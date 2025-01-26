# Basic Todo App

## Uruchomienie aplikacji lokalnie

1. Upewnij się, że masz Node.js zainstalowane na swoim systemie (wersja 14.0.0 lub wyższa)

```bash
node -v
```

2. Sklonuj repozytorium:

```bash
git clone https://github.com/wguzik/basic.git
```

> Możesz pobrać Node.js z [oficjalnego repozytorium](https://nodejs.org/en/download/).

3. Otwórz terminal i przejdź do katalogu projektu (ten katalog):

```bash
cd basictodo
```

4. Zainstaluj zależności:
   
```bash
npm install
```

5. Uruchom aplikację:
   
```bash
npm start
```

5. Otwórz przeglądarkę internetową i przejdź na:

```bash
http://localhost:3000
```

## Instalacja na maszynie wirtualnej Linux

1. Stwórz maszynę wirtualną na platformie Azure 

[Create a Linux virtual machine in the Azure portal](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal?tabs=ubuntu)

Wybierz Ubuntu 20.04 LTS.
Pobierz plik `.pem` z kluczem i otwórz zasób.

Postępuj zgodnie z instrukcją i zaloguj się przez ssh do maszyny wirtualnej.

Masz kłopot z połączeniem się przez ssh?
Wybierz opcję "Connect", a następnie "SSH using Azure CLI" i wybierz "Configure".


1. Zainstaluj wymagane pakiety:

```bash
sudo apt update
sudo apt install -y nodejs npm nginx
```

2. Sprawdź wersję Node.js:

```bash
node -v
```

   Jeśli wersja jest niższa niż 14.0.0, zaktualizuj Node.js:
   
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

3. Sklonuj repozytorium i zainstaluj zależności:

```bash
git clone https://github.com/wguzik/basic.git
cd basic/basictodo
npm install
```

4. Zbuduj aplikację:
   
```bash
npm run build
```

5. Uruchom aplikację:

Samo uruchomienie aplikacji w taki sposób, jak zostało to opisane w sekcji "Uruchomienie aplikacji lokalnie" nie zadziała. Musisz upewnić się, że aplikacja będzie działać jako usługa. Możesz to zrobić za pomocą `pm2`.

```bash
sudo npm install -g pm2
```

```bash
cd ~/basic/basictodo
```

```bash
pm2 start npm --name "todo" -- start
```

Upewnij się, że PM2 zostanie uruchomione przy starcie systemu (dzięki czemu aplikacja będzie działać po restarcie serwera).

```bash
pm2 startup
pm2 save
```

1. Skonfiguruj Nginx:

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

Wklej następujący kod:

```nginx
server {
    listen 80;
    server_name ADRES_IP_SERWERA; 

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

1. Włącz konfigurację i uruchom Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/basictodo /etc/nginx/sites-enabled/
sudo nginx -t
```

Jeżeli się nie udał, zweryfikuj konfigurację, a po udanym teście zrestartuj Nginx:

```bash
sudo systemctl restart nginx
```

2. Skonfiguruj firewall (opcjonalnie):

```bash
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

3.  Otwórz w przeglądarce adres IP serwera.

## Budowa i uruchomienie kontenera

Wykonaj ćwiczenie na tej samej maszynie wirtualnej!

1. Zainstaluj i skonfiguruj Docker:

```bash
sudo apt install docker.io
```   

```bash
sudo usermod -aG docker $USER
newgrp docker
```
Zweryfikuj działanie:

```bash
docker run hello-world
```

2. Przejdź do katalogu projektu (ten katalog):
   
```bash
cd basictodo
```

3. Zbuduj obraz za pomocą pliku `Dockerfile.simple`:

```bash
docker build -t basictodo:latest-simple -f Dockerfile.simple .
```

4. Zbuduj obraz za pomocą pliku `Dockerfile`:

```bash
docker build -t basictodo:latest -f Dockerfile .
```

5. Porównaj obrazy:

```bash
docker image ls 
```

6. Uruchom obraz lokalnie:

```bash
docker run -d --name basictodo -p 3001:3000 basictodo:latest
```

Sprawdź, czy działa:

```bash
docker ps
```

7. Zmień roboczo kod:

```bash
sed -i 's/Basic Todo App/Basic Todo App From Code/g' src/App.js
```

Odśwież aplikację i zauważ, że tytuł zmienił się na "Basic Todo App From Code".

Tymczasem chwilę wcześniej został zbudowany kontener, który ma stary kod.

8. Zaktualizuj konfigurację nginx, aby upublicznić nową wersję aplikacji pod nowym adresem: `/docker`

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

Zamień cały plik na następujący:
PODMIANKA!

```nginx
server {
    listen 80;
    server_name ADRES_IP_SERWERA;  

    # Stary, nadal dziaalajacy adres
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Nowy adres
    location /docker {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        
        rewrite ^/docker/(.*) /$1 break;
    }
}
```

```bash
sudo nginx -t
```

Jeżeli się nie udał, zweryfikuj konfigurację, a po udanym teście zrestartuj Nginx:

```bash
sudo systemctl restart nginx
```

## Opublikowanie obrazu

Przed opublikowaniem obrazu, musisz go oznaczyć adresem swojego rejestru. Jeśli używasz Docker Hub, będzie to twoje `Docker Hub username`.
Jeżeli używasz innego rejestru, będzie to adres tego rejestru, na przykład Azure Container Registry: `myregistry.azurecr.io`.

1. Otaguj obraz (zamień `<username>` z nazwą swojego registry (lub Docker Hub username)):

   ```bash
   docker tag basictodo:latest <username>/basictodo:latest
   ```

2. Zaloguj się do swojego registry:
   
   ```bash
   az acr login --name <registry-name>
   ```

lub 

   ```bash
   docker login
   ```

3. Wyślij obraz do registry:

   ```bash
   docker push <username>/basictodo:latest
   ```


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

2. Włącz konfigurację i uruchom Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/basictodo /etc/nginx/sites-enabled/
sudo nginx -t
```

Jeżeli się nie udał, zweryfikuj konfigurację, a po udanym teście zrestartuj Nginx:

```bash
sudo systemctl restart nginx
```

3. Skonfiguruj firewall (opcjonalnie):

```bash
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

4.  Otwórz przeglądarkę i wpisz adres IP serwera.

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

8. Zaktualizuj konfigurację `nginx`, aby zamienić wersję działającą z kodu na tę uruchomioną w kontenerze.

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

```nginx
server {
    listen 80;
    server_name ADRES_IP_SERWERA;  

    location / {
        proxy_pass http://localhost:3001; # zmien tylko port na którym działa kontener
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

0. Stwórz repozytorium w [Azure Container Registry](./basicacr)

> Wykonaj ćwiczenie z katalogu `basicacr` za pomocą Cloud Shell lub na swoim komputerze. Możesz na maszynie wirtualnej, aczkolwiek musisz doinstalować Terraform i Azure CLI.

1. Otaguj obraz (zamień `<acrName>` z nazwą swojego registry (lub Docker Hub username)):

```bash
docker tag basictodo:latest <acrName>/basictodo:latest
```

2. Zaloguj się do swojego registry:
   
```bash
az acr login --name <acrName>
```

lub gdy używasz Docker Hub:

```bash
docker login
```

3. Wyślij obraz do registry:

```bash
docker push <acrName>/basictodo:latest
```

4. Sprawdź, czy obraz jest dostępny w registry:

```bash
az acr repository list -n <acrName>
```

Otwórz przeglądarkę, znajdź Registry w Azure Portal i sprawdź, czy obraz jest dostępny.

## Wdrożenie w Azure App Service

1. Wdróż aplikację z katalogu [basicwebapp](./basicwebapp)

> Wykonaj ćwiczenie z katalogu `basicwebapp` za pomocą Cloud Shell lub na swoim komputerze. Możesz na maszynie wirtualnej, aczkolwiek musisz doinstalować Terraform i Azure CLI.
> Repozytorium masz już sklonowane, zmień katalog na `basicwebapp` i wykonaj kroki opisane w README.md.

2. Skonfiguruj Web App, aby miała dostęp do Container Registry

Masz dwie opcje:

> Obydwa ustawienia można wdrożyć za pomocą Terraform, natomiast w celach demonstracyjnych wykonaj je wedle sposobu poniżej.

### Opcja 1: Użycie poświadczeń administracyjnych ACR

```bash
# Pobierz dane uwierzytelniające z ACR
ACR_NAME="<nazwa-acr>"
IMAGE_NAME="basictodo:latest"
ACR_USERNAME=$(az acr credential show -n $ACR_NAME --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show -n $ACR_NAME --query "passwords[0].value" -o tsv)

# Skonfiguruj Web App
WEBAPP_NAME="<nazwa-webapp>"
RESOURCE_GROUP="<nazwa-resource-group>"

# Ustaw poświadczenia w konfiguracji Web App
az webapp config container set \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name "$ACR_NAME.azurecr.io/$IMAGE_NAME" \
    --docker-registry-server-url "https://$ACR_NAME.azurecr.io" \
    --docker-registry-server-user $ACR_USERNAME \
    --docker-registry-server-password $ACR_PASSWORD
```

### Opcja 2: Użycie tożsamości zarządzanej (zalecane)

1. Włącz tożsamość zarządzaną dla Web App:

```bash
# Włącz tożsamość zarządzaną
az webapp identity assign \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP
    
# Zapisz ID tożsamości
IDENTITY_ID=$(az webapp identity show \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query principalId \
    --output tsv)
```

2. Nadaj uprawnienia do ACR:

```bash
# Pobierz ID ACR
ACR_ID=$(az acr show \
    --name $ACR_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id \
    --output tsv)

# Nadaj rolę AcrPull
az role assignment create \
    --assignee $IDENTITY_ID \
    --scope $ACR_ID \
    --role AcrPull
```

3. Skonfiguruj Web App do użycia obrazu z ACR:

```bash
$ACR_NAME="<nazwa-acr>"
$IMAGE_NAME="basictodo:latest"
az webapp config container set \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name "$ACR_NAME.azurecr.io/$IMAGE_NAME" \
    --docker-registry-server-url "https://$ACR_NAME.azurecr.io"
```

4. Zrestartuj Web App:

```bash
az webapp restart --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP
```

> **Uwaga**: Opcja 2 (tożsamość zarządzana) jest bardziej bezpieczna, ponieważ nie wymaga przechowywania poświadczeń w konfiguracji aplikacji.

5. Sprawdź logi aplikacji w przypadku problemów:

```bash
az webapp log tail --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP
```

Po poprawnej konfiguracji, Web App powinna automatycznie pobrać i uruchomić obraz z ACR.

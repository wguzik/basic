# Basic Todo App

## Cel

Prześledź scieżkę od wdrożenia aplikacji w formie kopiowania plików do wdrożenia z wykorzystaniem kontenera.

Czas: 3h

## Wymagania

Aktywna subskrypcja w Azure.

Agent SSH.

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

Wybierz Ubuntu 22.04 LTS. Maszyna D2S_v3.
W "Select inbound ports" upewnij się, że masz zaznaczone `HTTP (80)` oraz `SSH (22)`.

Wybierz "Review + Create" i potwierdź "Create".

Pobierz plik `.pem` z kluczem i otwórz zasób.

Pobierz klucz i zaloguj się przez ssh do maszyny wirtualnej. Poczekaj kilka minut, aż maszyna się uruchomi.

Uruchom konsolę (PowerShell jeżeli to Windows):

```bash
ssh -i ~/Downloads/<nazwa klucza>.pem azureuser@<publiczny adres maszyny>
```

> Masz kłopot z połączeniem się przez ssh?
> Wybierz opcję "Connect", a następnie "SSH using Azure CLI" i wybierz "Configure".

> Shift+insert pozwala wkleić kod do terminala.

1. Zainstaluj wymagane pakiety:

```bash
sudo apt update
sudo apt install -y nodejs npm nginx
```

2. Sprawdź wersję Node.js:

```bash
node -v
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
pm2 start npm --name "todo" -- start
```

Upewnij się, że PM2 zostanie uruchomione przy starcie systemu (dzięki czemu aplikacja będzie działać po restarcie serwera).

```bash
pm2 startup
pm2 save
```

> Możesz w tym miejscu edytować Network Security Group i otwórzyć ruch na port 3000. Jeżeli aplikacja się uruchomiła, to powinna być dostępna.
> Aplikacje webowe zazwyczaj działają na portach 80 i 443, wobec czego chcemy tutaj zrobić przekierowanie.
> Dlaczego nie uruchomić aplikacji od razu na porcie 80? Ponieważ wtedy utrudnilibyśmy uruchamianie innych aplikacji, a na dodatek nasza aplikacja byłaby "goła" wystawiona na świat. Dzięki takim rozwiązaniom jak nginx można łatwiej wdrożyć reverse proxy oraz load balancing.

1. Skonfiguruj Nginx:

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

Wklej następujący kod, zamień `ADRES_IP_SERWERA` na faktyczny publiczny adres swojego serwera:

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
> Ctrl + X, Y, [Enter]

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

> Strona używa niezabezpieczonego protokołu, możesz dostać ostrzeżenie od przeglądarki.

## Budowa i uruchomienie kontenera

> Wykonaj ćwiczenie na tej samej maszynie wirtualnej!

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
cd ~/basic/basictodo
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

Tymczasem chwilę wcześniej został zbudowany kontener, który ma stary kod z nagłówkiem "Basic Todo App".

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
         ///
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

W tym momencie Aplikacja dla użytkownika jest udostępniana jako działający kontener.

## Opublikowanie obrazu

0. Zainstaluj oprogramowanie i zaloguj się do Azure:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

```bash
az login --device-login
```
Otwórz link, skopiuj kod i potwierdź logowanie.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform
```

2. Stwórz repozytorium w [Azure Container Registry](./basicacr)

> Wykonaj ćwiczenie z katalogu `basicacr` za pomocą Cloud Shell lub na swoim komputerze. Możesz na maszynie wirtualnej, aczkolwiek musisz doinstalować Terraform i Azure CLI.

2. Otaguj obraz (zamień `<acrName>` z nazwą swojego registry (lub Docker Hub username)):

```bash
docker tag basictodo:latest <acrName>.azurecr.io/basictodo:latest
```

3. Zaloguj się do swojego registry:
   
```bash
az acr login --name <acrName>
```

lub gdy używasz Docker Hub:

```bash
docker login
```

4. Wyślij obraz do registry:

```bash
docker push <acrName>.azurecr.io/basictodo:latest
```

5. Sprawdź, czy obraz jest dostępny w registry:

```bash
az acr repository list -n <acrName>
```

Otwórz przeglądarkę, znajdź Registry w Azure Portal i sprawdź, czy obraz jest dostępny.

## Wdrożenie w Azure App Service

1. Wdróż aplikację z katalogu [basicwebapp](./basicwebapp)

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

WEBAPP_NAME="<nazwa-webapp>"
RESOURCE_GROUP="<nazwa-resource-group>"

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
RESOURCE_GROUP_ACR="<nazwa-resource-group-acr>"

ACR_ID=$(az acr show \
    --name $ACR_NAME \
    --resource-group $RESOURCE_GROUP_ACR \
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

Upewnij się, że w "Deployment > Deployment Center" w sekcji "Authenticatin" jest wybrane "Managed Identity".

> **Uwaga**: Opcja 2 (tożsamość zarządzana) jest bardziej bezpieczna, ponieważ nie wymaga przechowywania poświadczeń w konfiguracji aplikacji.

5. Sprawdź logi aplikacji w przypadku problemów:

```bash
az webapp log tail --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP
```

Po poprawnej konfiguracji, Web App powinna automatycznie pobrać i uruchomić obraz z ACR.

## Usuń zasoby

Usuń zasoby, szczególnie Web App i Maszynę wirtualną.

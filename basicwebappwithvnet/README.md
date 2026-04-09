# Lab - Apka ToDo z siecią wirtualną

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Stworzenie web apki zintegrowanej z siecią wirtualną oraz storage account dostępnym wyłącznie przez prywatny endpoint.

Czas trwania: 45 minut

## Typy zasobów

`Resource group` - pudełko na zasoby w chmurze  
`Web App` - serwer aplikacji  
`Docker image` - spakowana aplikacja  
`Virtual Network` - izolowana sieć w chmurze  
`Subnet` - segment sieci wirtualnej  
`Storage Account` - magazyn danych (blob)  
`Private Endpoint` - prywatne połączenie do zasobu bez wychodzenia do internetu  
`Private DNS Zone` - rozwiązywanie nazw DNS dla prywatnych endpointów

### Krok 1 - Sklonuj repozytorium w Cloud Shell

  Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

  > Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

  ```bash
  git clone https://github.com/wguzik/basic.git

  cd basic/basicwebappwithvnet
  ```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

### Krok 2 - zweryfikuj plan

  ```bash
  terraform init
  terraform plan
  ```

### Krok 3 - Edytuj zmienne

  - wykonaj kopię pliku terraform.tfvars.example

  ```bash
  cp terraform.tfvars.example terraform.tfvars
  ```

  - podaj swoją subskrypcję
  
  ```bash
  subscription_id=$(az account show --query="id")
  sed -i "s/YourSubscriptionID/$subscription_id/g" terraform.tfvars
  ```

  - zmień custom_name

  ```bash
  sed -i 's/mywebapp/<twojeinicjaly>/' terraform.tfvars
  # sed -i 's/mywebapp/wg/' terraform.tfvars
  ```

### Krok 4 - Wdróż aplikację i odwiedź stronę

  ```bash
  terraform apply

  # terraform output pokaże Ci adres URL aplikacji
  ```

### Krok 5 - zmodifykuj obraz

  ```bash
  sed -i 's/nginx:latest/vhron\/basictodo:0.2.0/' terraform.tfvars
  ```

### Krok 6 - Wdróż zmiany

  ```bash
  terraform apply
  ```

Aplikacja nie załadowała się?
Odwiedź "Deployment Center" na poziomie Web App w Portalu Azure i zweryfikuj jak się nazywa obraz. Czy format jest właściwy?

---

## Wdrożenie aplikacji basicgallery

Aplikacja `basicgallery` to galeria obrazów pobieranych z Azure Blob Storage. Jej kod źródłowy znajduje się w katalogu `basicgallery/` w tym samym repozytorium.

### Krok A - Zbuduj aplikację

  ```bash
  cd ~/basic/basicgallery

  npm install
  npm run build
  npm install --omit=dev
  ```

### Krok B - Spakuj do ZIP

  ```bash
  zip -r ../app.zip build/ server.js node_modules/ package.json
  ```

### Krok C - Pobierz nazwę Web App z outputów Terraform

  ```bash
  cd ~/basic/basicwebappwithvnet

  WEBAPP_NAME=$(terraform output -raw webapp_name)
  RG=$(terraform output -raw rg_name)
  ```

### Krok D - Wdróż ZIP

  ```bash
  az webapp deploy \
    --resource-group $RG \
    --name $WEBAPP_NAME \
    --src-path ../app.zip \
    --type zip
  ```

### Krok E - Utwórz kontener i wgraj zdjęcia

  ```bash
  STORAGE_ACCOUNT=$(terraform output -raw storage_account_name)

  az storage container create \
    --name images \
    --account-name $STORAGE_ACCOUNT \
    --auth-mode login

  az storage blob upload \
    --account-name $STORAGE_ACCOUNT \
    --container-name images \
    --file <ścieżka/do/zdjęcia.jpg> \
    --name zdjecie.jpg \
    --auth-mode login
  ```

  > Storage account ma wyłączony dostęp publiczny. Jeśli powyższe polecenia zwrócą błąd autoryzacji sieciowej, tymczasowo włącz dostęp publiczny w portalu: Storage Account → Networking → Public network access → Enabled from all networks, wgraj pliki, następnie wyłącz.

---

### Krok -1 - Usuń zasoby

  ```bash
  terraform destroy
  ```

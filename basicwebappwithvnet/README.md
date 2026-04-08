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

### Krok -1 - Usuń zasoby

  ```bash
  terraform destroy
  ```

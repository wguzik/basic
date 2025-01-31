# Lab - Apka ToDo

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Stworzenie web apki i zmiana obrazu.

Czas trwania: 30 minut

## Typy zasobów

`Resource group` - pudełko na zasoby w chmurze  
`Web App` - serwer aplikacji  
`Docker image` - spakowana aplikacja

### Krok 1 - Sklonuj repozytorium w Cloud Shell

  Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

  > Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

  ```bash
  git clone https://github.com/wguzik/basic.git

  cd basic/basicwebapp
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

  - zmień custom_name

  ```bash
   sed -i 's/mywebapp/<twojeinicjaly>/' terraform.tfvars
   # sed -i 's/mywebapp/wg/' terraform.tfvars
  ```

### Krok 4 - Wdróż aplikację i odwiedź stronę

  ```bash
  terraform apply

  # terraform ouput pokaże Ci adres URL aplikacji
  ```

### Krok 5 - zmodifykuj obraz

  ```
  sed -i 's/nginx:latest/vhron\/basictodo:0.2.0/' terraform.tfvars
  ```

### Krok 4 - Wdróż zmiany

  ```bash
  terraform apply
  ```

Aplikacja nie załadowała się?
Odwiedź "Deployment Center" na poziomie Web App w Portalu Azure i zweryfikuj jak się nazywa obraz. Czy format jest właściwy?

### Krok -1 - Usuń zasoby

  ```bash
  terraform destroy
  ```

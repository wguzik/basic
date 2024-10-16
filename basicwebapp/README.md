# Lab - Apka to do

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

  cd basicwebapp
  ```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

### Krok 2 - zweryfikuj plan

  ```bash
  terraform init
  terraform plan
  ```

### Krok 3 - Edytuj zmienne

  - uruchom edytor

  ```bash
  code terraform.tfvars
  ```

  - zmień wartość zmiennej `custom_name` na `<inicjały>`
  - zapisz i wyjdź z edytora

### Krok 4 - Wdróż aplikację i odwiedź ją

  ```bash
  terraform apply

  # terraform ouput pokaże Ci adres URL aplikacji
  ```

### Krok 5 - zmodifykuj obraz

  - uruchom edytor
  ```
    code terraform.tfvars
  ```
  - zmień wartość zmiennej `docker_image` na `vhron/basictodo:0.2.0`
  - zapisz i wyjdź z edytora

### Krok 4 - Wdróż zmiany

  ```bash
  terraform apply
  ```

### Krok -1 - Usuń zasoby

  ```bash
  terraform destroy
  ```

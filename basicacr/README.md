# Lab - Apka ToDo

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Stworzenie Azure Container Registry.

Azure Container Registry to usługa Azure, która umożliwia przechowywanie i zarządzanie obrazami kontenerów.

Dowiedz się więcej: [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-overview).

Czas trwania: 30 minut

## Instalacja Azure Container Registry za pomocą Terraform

1. Sklonuj to repozytorium i wejdź do katalogu `basicacr`:

```bash
https://github.com/wguzik/basic.git

```
cd basic/basicacr
```

2. Przygotuj plik `terraform.tfvars` swoimi wartościami:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edytuj plik `terraform.tfvars` i wprowadź własną nazwę projektu:

```bash
project_name    = "mrt" #inicjały
```

Edytuj plik `terraform.tfvars` i zastąp `YourSubscriptionID` swoim ID subskrypcji:

```bash
subscription_id=$(az account show --query="id")
sed -i "s/YourSubscriptionID/$subscription_id/g" terraform.tfvars
```

3. Zainicjuj Terraform, zweryfikuj konfigurację:

```bash
terraform init
terraform validate
terraform plan
```

4. Wdróż konfigurację:

```bash
terraform apply
```

Po potwierdzeniu, Terraform utworzy:
- Grupę zasobów
- Azure Container Registry (ACR)
- Key Vault z zapisanymi poświadczeniami do ACR

5. Zaloguj się do utworzonego ACR:

```bash
az acr login --name <nazwa-acr>
```

6. Pobierz poświadczenia do ACR:

```bash
az acr credential show --name <nazwa-acr>
```

```bash
az keyvault secret show --vault-name $(terraform output key_vault_name) --name $(terraform output acr_password) --query value -o tsv
az keyvault secret show --vault-name $(terraform output key_vault_name) --name $(terraform output acr_username) --query value -o tsv
```

7. Po zakończeniu pracy możesz usunąć zasoby:

```bash
terraform destroy
```

> **Uwaga**: Nazwa ACR musi być globalnie unikalna i zawierać tylko małe litery oraz cyfry.
> Poświadczenia do ACR są automatycznie zapisywane w Key Vault dla bezpieczeństwa.

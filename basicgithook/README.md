# Laboratorium - Pre-hook commit do formatowania plików Terraform


## Cel

Wykorzystanie pre-hook commit do formatowania plików Terraform przed commitowaniem.

## Wymagania

- Aktywna subskrypcja Azure i dostęp do portalu
- Zainstalowany Terraform
- Zainstalowane Azure CLI
- Lub wszystko w Cloud Shell

Czas: 30 minut


## Instrukcje

### Krok 1 - Utwórz Strukturę Projektu


### Krok 2 - Przygotuj Pliki


### Krok 3 - Inicjalizacja i Wdrożenie

```bash
terraform init
terraform plan
terraform apply
```

### Krok 4 - Stwórz pre-commit hook

```bash
mkdir -p .git/hooks
touch .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

```bash
#!/bin/bash

# Get all staged .tf files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.tf$' || true)

if [ -n "$files" ]; then
    echo "Formatting Terraform files..."
    terraform fmt -recursive
    
    # Add the formatted files back to staging
    for file in $files; do
        if [ -f "$file" ]; then
            git add "$file"
        fi
    done
fi

exit 0
```






### Krok 5 - Sprzątanie

Po zakończeniu eksperymentów, usuń zasoby:

```bash
terraform destroy
```




## Uwagi

- Nazwy kont magazynu muszą być globalnie unikalne i zawierać tylko małe litery i cyfry
- Upewnij się, że jesteś zalogowany do Azure CLI przed uruchomieniem poleceń Terraform
- Blok `depends_on` zapewnia, że grupa zasobów zostanie utworzona przed kontem magazynu
- Domyślna lokalizacja to "westeurope", możesz ją zmienić w pliku terraform.tfvars

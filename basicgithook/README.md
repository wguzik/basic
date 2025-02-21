# Laboratorium - Pre-hook commit do formatowania plików Terraform


## Cel

Wykorzystanie pre-hook commit do formatowania plików Terraform przed commitowaniem.

## Wymagania

- Aktywna subskrypcja Azure i dostęp do portalu
- Cloud Shell

Czas: 30 minut

## Instrukcje

### Krok 1 - Sklonuj repozytorium

```bash
git clone https://github.com/wguzik/basic.git
```

```bash
cd basic/basicgithook
```

### Krok 2 -  Podejrzyj pliki

```bash
ls -la
```

```bash
cat main.tf
```

Zwróć uwagę na chaotyczne formatowanie plików.

### Krok 3 - Stwórz pre-commit hook

```bash


```bash
mkdir -p ~/basic/.git/hooks
touch ~/basic/.git/hooks/pre-commit
chmod +x ~/basic/.git/hooks/pre-commit
```

```bash
vi .git/hooks/pre-commit
```

Wklej zawartość:

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

zapisz:

```bash
[ESC]
:wq
[ENTER]
```

### Krok 4 - Zweryfikuj działanie pre-commit hooka

```bash
vi main.tf
```
(dodaj lub usuń wcięcia)

zapisz:

```bash
[ESC]
:wq
[ENTER]
```

```bash
git add .
git commit -m "Formatowanie plików Terraform"
```

Zwróć uwagę na to ile plików zostało poprawionych w ramach commitu:

```bash
git log --name-only
```

Zwróć uwagę na to, że część plików została sformatowana, ale nie zostały scommitowane:

```bash
git status
```

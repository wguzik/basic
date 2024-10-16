# Lab - Podstawy git i GitHub

## Wymagania

- Aktywna subskrypcja w Azure i dostęp do portalu.  
- Konto GitHub.

## Wstęp

### Cel

Podstawy git i GitHub.

Czas trwania: 30 minut

## Instrukcje

### Krok 1 - Uruchom Cloud Shell i stwórz katalog

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

> Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
mkdir hellogit
cd hellogit
```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

### Krok 2 - Zainicjalizuj repozytorium

```bash
git init
git status
```

### Krok 3 - Stwórz plik README.md, dodaj do stage

```bash
touch README.md
echo "# This is readme, hello Git!" > README.md
git status
git add README.md
git status
```

### Krok 4 - Wykonaj commit

```bash
git commit -m "Initial commit"
# błędy?
# skonfiguruj swoje imię i nazwisko
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git status
git commit -m "Initial commit"
```

### Krok 5 - Podejrzyj historię commitów

```bash
git log
# ładniejszy format
git log --pretty=oneline
```

### Krok 6 - Dodaj nowe repozytorium na GitHub

- Otwórz https://github.com i wybierz "New" aby dodać nowe repozytorium.
- Nadaj mu nazwę "hellogit" (taką samą jak katalogowi).

### Krok 7 - Zaloguj się do GitHub

```bash
gh auth login
# przeklikujesz i otwierasz link w przeglądarce
# https://github.com/login/device
# wklej kod, autoryzuj GH i wróć do Cloud Shell
```

### Krok 8 - Połącz lokalne repozytorium z GitHub

```bash
git remote add origin https://github.com/<TwojeKonto>/hellogit.git
# zweryfikuj
git remote -v
# push
git push
git push --set-upstream origin master
```

### Krok 9 - Stwórz nowy branch

```bash
git checkout feature-detailed-readme
# git branch feature-detailed-readme żeby stworzyć branch, ale się nie przełączyć
git checkout -h
git checkout -b "feature-detailed-readme"
git status
```

### Krok 10 - Zmodyfikuj plik README.md

```bash
code .
# wybierz plik README.md i zmień jego treść
# CTRL+S, CTRL+Q aby zapisać i wyjść
git status
git add README.md
# git add . aby dodać wszystkie zmiany
git commit -m "Detailed description of README.md"
git push
git push --set-upstream origin feature-detailed-readme
```

### Krok 11 - Pull request

- Otwórz przeglądarkę i przejdź do swojego repozytorium na GitHub.
- Wybierz branch "feature-detailed-readme" i stwórz pull request.
- Wybierz zakładkę "Files"
- Wróć do zakładki "Conversation"
- Skomentuj pull request.
- Wybierz: "Merge pull request", "Confirm merge", "Delete branch"

# Basic Todo App

## Uruchomienie aplikacji lokalnie

1. Upewnij się, że masz Node.js zainstalowane na swoim systemie (wersja 14.0.0 lub wyższa)

   ```bash
   node -v
   ```

> Możesz pobrać Node.js z [oficjalnego repozytorium](https://nodejs.org/en/download/).

2. Otwórz terminal i przejdź do katalogu projektu (ten katalog):

   ```bash
   cd basictodo
   ```

3. Zainstaluj zależności:
   
   ```bash
   npm install
   ```

4. Uruchom aplikację:
   
   ```bash
   npm start
   ```

5. Otwórz przeglądarkę internetową i przejdź na:

   ```bash
   http://localhost:3000
   ```

## Budowa i uruchomienie kontenera

1. Upewnij się, że masz zainstalowany Docker (lub inny system do budowania obrazów kontenerów):

   ```bash
   docker --version
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

## Opublikowanie obrazu

Przed opublikowaniem obrazu, musisz go oznaczyć adresem swojego rejestru. Jeśli używasz Docker Hub, będzie to twoje `Docker Hub username`.
Jeżeli używasz innego rejestru, będzie to adres tego rejestru, na przykład Azure Container Registry: `myregistry.azurecr.io`.

1. Tag the image (replace `<username>` with your Docker Hub username or your private registry address):
   ```
   docker tag basictodo:latest <username>/basictodo:latest
   ```

2. Log in to your Docker registry:
   ```
   docker login
   ```
   Enter your credentials when prompted.

3. Push the image to the registry:
   ```
   docker push <username>/basictodo:latest
   ```

## Additional Notes

- If you're using a private registry other than Docker Hub, you may need to adjust the login command and include the registry URL in your image tag.
- You can add a specific version tag instead of or in addition to `latest`, e.g., `basictodo:v1.0.0`.
- Always ensure you have the necessary permissions to push to the repository you're targeting.

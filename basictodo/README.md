# Build and Push Docker Image

## Build the Docker Image

1. Navigate to the directory containing the Dockerfile (this one)
2. Build the Docker image:
   ```
   docker build -t basictodo:latest .
   ```
   This command builds the image and tags it as `basictodo:latest`.

## Push the Docker Image

Before pushing, you need to tag the image with your Docker registry's address. If you're using Docker Hub, it would be your Docker Hub username.

3. Tag the image (replace `<username>` with your Docker Hub username or your private registry address):
   ```
   docker tag basictodo:latest <username>/basictodo:latest
   ```

4. Log in to your Docker registry:
   ```
   docker login
   ```
   Enter your credentials when prompted.

5. Push the image to the registry:
   ```
   docker push <username>/basictodo:latest
   ```

## Additional Notes

- If you're using a private registry other than Docker Hub, you may need to adjust the login command and include the registry URL in your image tag.
- You can add a specific version tag instead of or in addition to `latest`, e.g., `basictodo:v1.0.0`.
- Always ensure you have the necessary permissions to push to the repository you're targeting.

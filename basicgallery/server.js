const express = require('express');
const path = require('path');
const { BlobServiceClient } = require('@azure/storage-blob');
const { DefaultAzureCredential } = require('@azure/identity');

const app = express();
const PORT = process.env.PORT || 3000;
const STORAGE_ACCOUNT_NAME = process.env.STORAGE_ACCOUNT_NAME;
const CONTAINER_NAME = 'images';
const IMAGE_EXTENSIONS = /\.(jpg|jpeg|png|gif|webp|bmp|svg)$/i;

function getBlobServiceClient() {
  if (!STORAGE_ACCOUNT_NAME) {
    throw new Error('STORAGE_ACCOUNT_NAME environment variable is not set');
  }
  const credential = new DefaultAzureCredential();
  const url = `https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net`;
  return new BlobServiceClient(url, credential);
}

app.get('/api/images', async (req, res) => {
  try {
    const client = getBlobServiceClient();
    const containerClient = client.getContainerClient(CONTAINER_NAME);
    const images = [];
    for await (const blob of containerClient.listBlobsFlat()) {
      if (IMAGE_EXTENSIONS.test(blob.name)) {
        images.push(blob.name);
      }
    }
    res.json({ images });
  } catch (err) {
    console.error('Failed to list images:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/image/*', async (req, res) => {
  const blobName = req.params[0];
  try {
    const client = getBlobServiceClient();
    const containerClient = client.getContainerClient(CONTAINER_NAME);
    const blobClient = containerClient.getBlobClient(blobName);
    const download = await blobClient.download();
    res.setHeader('Content-Type', download.contentType || 'application/octet-stream');
    res.setHeader('Cache-Control', 'public, max-age=3600');
    download.readableStreamBody.pipe(res);
  } catch (err) {
    console.error(`Failed to fetch image ${blobName}:`, err.message);
    res.status(500).json({ error: err.message });
  }
});

app.use(express.static(path.join(__dirname, 'build')));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Storage account: ${STORAGE_ACCOUNT_NAME || '(not set)'}`);
});

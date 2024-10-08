const express = require('express');
const bodyParser = require('body-parser');
const libraryRoutes = require('./routes/library');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

app.use('/api/library', libraryRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
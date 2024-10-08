const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;
const location = process.env.LOCATION || 'Unknown';

// Set the view engine to EJS
app.set('view engine', 'ejs');

// Set the directory for the views
app.set('views', path.join(__dirname, 'views'));

app.use(express.static('src/public'));

app.get('/', (req, res) => {
  res.render('pages/index', { location: location, active: 'main' });
});

app.get('/contact', (req, res) => {
  res.render('pages/contact', { location: location, active: 'contact' });
});

app.get('/library', (req, res) => {
  const favoriteBooks = [
    { title: "1984", author: "George Orwell" },
    { title: "To Kill a Mockingbird", author: "Harper Lee" },
    { title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams" }
  ];
  res.render('pages/library', { location: location, active: 'library', books: favoriteBooks });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
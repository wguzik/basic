const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getBookById = async (req, res) => {
  try {
    const { id } = req.params;
    const book = await prisma.library.findUnique({
      where: { id: parseInt(id) },
    });

    if (!book) {
      return res.status(404).json({ message: 'Book not found' });
    }

    res.json(book);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching book', error: error.message });
  }
};

exports.createBook = async (req, res) => {
  try {
    const { author, title, year } = req.body;
    const newBook = await prisma.library.create({
      data: { author, title, year },
    });

    res.status(201).json(newBook);
  } catch (error) {
    res.status(500).json({ message: 'Error creating book', error: error.message });
  }
};
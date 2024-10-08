const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const books = [
    {
      title: "To Kill a Mockingbird",
      author: "Harper Lee",
      publicationYear: 1960,
      genre: "Fiction",
      description: "A novel about racial injustice in a small Southern town",
    },
    {
      title: "1984",
      author: "George Orwell",
      publicationYear: 1949,
      genre: "Science Fiction",
      description: "A dystopian novel set in a totalitarian society",
    },
    {
      title: "Pride and Prejudice",
      author: "Jane Austen",
      publicationYear: 1813,
      genre: "Romance",
      description: "A novel about love and marriage in 19th century England",
    },
    {
      title: "The Hitchhiker's Guide to the Galaxy",
      author: "Douglas Adams",
      publicationYear: 1979,
      genre: "Science Fiction",
      description: "A humorous science fiction comedy series",
    },
    {
      title: "The Catcher in the Rye",
      author: "J.D. Salinger",
      publicationYear: 1951,
      genre: "Fiction",
      description: "A novel about the loss of innocence and the search for meaning",
    },
  ];

  for (const book of books) {
    await prisma.book.create({
      data: book,
    });
  }

  console.log('Seed data inserted successfully.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

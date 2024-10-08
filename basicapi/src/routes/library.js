const express = require('express');
const router = express.Router();
const libraryController = require('../controllers/libraryController');

router.get('/:id', libraryController.getBookById);
router.post('/', libraryController.createBook);

module.exports = router;

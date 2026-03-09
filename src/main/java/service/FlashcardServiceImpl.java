package service;

import dao.FlashcardDAO;
import model.Flashcard;
import model.FlashcardDeck;

import java.util.List;

public class FlashcardServiceImpl implements FlashcardService {

    private final FlashcardDAO flashcardDAO = new FlashcardDAO();

    @Override
    public List<FlashcardDeck> getUserDecks(int userId) {
        return flashcardDAO.getUserDecks(userId);
    }

    @Override
    public List<FlashcardDeck> getPublicDecks() {
        return flashcardDAO.getPublicDecks();
    }

    @Override
    public FlashcardDeck getDeckById(int deckId) {
        return flashcardDAO.getDeckById(deckId);
    }

    @Override
    public int createDeck(int userId, String name, String description, Integer courseId, boolean isPublic) {
        if (name == null || name.trim().isEmpty()) {
            throw new ValidationException("Deck name is required");
        }
        return flashcardDAO.createDeck(userId, name.trim(), description, courseId, isPublic);
    }

    @Override
    public boolean deleteDeck(int deckId, int userId) {
        FlashcardDeck deck = flashcardDAO.getDeckById(deckId);
        if (deck == null || deck.getUserID() != userId)
            return false;
        return flashcardDAO.deleteDeck(deckId);
    }

    @Override
    public List<Flashcard> getCardsByDeck(int deckId) {
        return flashcardDAO.getCardsByDeck(deckId);
    }

    @Override
    public boolean addCard(int deckId, String front, String back, int order) {
        if (front == null || front.trim().isEmpty() || back == null || back.trim().isEmpty()) {
            throw new ValidationException("Both front and back content are required");
        }
        return flashcardDAO.addCard(deckId, front.trim(), back.trim(), order);
    }

    @Override
    public boolean deleteCard(int cardId, int userId) {
        return flashcardDAO.deleteCard(cardId, userId);
    }

    @Override
    public List<Flashcard> getCardsForReview(int userId, int deckId) {
        return flashcardDAO.getCardsForReview(userId, deckId);
    }

    @Override
    public boolean recordReview(int userId, int cardId, int difficulty) {
        return flashcardDAO.recordReview(userId, cardId, difficulty);
    }
}

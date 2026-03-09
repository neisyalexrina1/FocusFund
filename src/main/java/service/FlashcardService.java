package service;

import model.Flashcard;
import model.FlashcardDeck;

import java.util.List;

public interface FlashcardService {
    List<FlashcardDeck> getUserDecks(int userId);

    List<FlashcardDeck> getPublicDecks();

    FlashcardDeck getDeckById(int deckId);

    int createDeck(int userId, String name, String description, Integer courseId, boolean isPublic);

    boolean deleteDeck(int deckId, int userId);

    List<Flashcard> getCardsByDeck(int deckId);

    boolean addCard(int deckId, String front, String back, int order);

    boolean deleteCard(int cardId, int userId);

    List<Flashcard> getCardsForReview(int userId, int deckId);

    boolean recordReview(int userId, int cardId, int difficulty);
}

package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Flashcard;
import model.FlashcardDeck;
import model.UserFlashcardProgress;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class FlashcardDAO extends BaseDAO {

    // ===== Deck operations =====

    public List<FlashcardDeck> getUserDecks(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<FlashcardDeck> q = em.createQuery(
                    "SELECT d FROM FlashcardDeck d WHERE d.userID = :userId ORDER BY d.createdDate DESC",
                    FlashcardDeck.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<FlashcardDeck> getPublicDecks() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT d FROM FlashcardDeck d WHERE d.isPublic = true ORDER BY d.createdDate DESC",
                    FlashcardDeck.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public FlashcardDeck getDeckById(int deckId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(FlashcardDeck.class, deckId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public int createDeck(int userId, String name, String description, Integer courseId, boolean isPublic) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            FlashcardDeck deck = new FlashcardDeck();
            deck.setUserID(userId);
            deck.setDeckName(name);
            deck.setDescription(description);
            deck.setCourseID(courseId);
            deck.setIsPublic(isPublic);
            em.persist(deck);
            tx.commit();
            return deck.getDeckID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    public boolean deleteDeck(int deckId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            FlashcardDeck deck = em.find(FlashcardDeck.class, deckId);
            if (deck == null)
                return false;

            // Delete user progress for cards in this deck
            em.createQuery(
                    "DELETE FROM UserFlashcardProgress p WHERE p.cardID IN (SELECT f.cardID FROM Flashcard f WHERE f.deckID = :deckId)")
                    .setParameter("deckId", deckId)
                    .executeUpdate();

            // Explicitly delete cards so we don't rely only on DB cascades
            em.createQuery("DELETE FROM Flashcard f WHERE f.deckID = :deckId")
                    .setParameter("deckId", deckId)
                    .executeUpdate();

            em.remove(deck);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // ===== Card operations =====

    public List<Flashcard> getCardsByDeck(int deckId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Flashcard> q = em.createQuery(
                    "SELECT f FROM Flashcard f WHERE f.deckID = :deckId ORDER BY f.cardOrder",
                    Flashcard.class);
            q.setParameter("deckId", deckId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean addCard(int deckId, String front, String back, int order) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Flashcard card = new Flashcard();
            card.setDeckID(deckId);
            card.setFrontContent(front);
            card.setBackContent(back);
            card.setCardOrder(order);
            em.persist(card);

            // Update card count
            FlashcardDeck deck = em.find(FlashcardDeck.class, deckId);
            if (deck != null) {
                deck.setCardCount(deck.getCardCount() + 1);
                em.merge(deck);
            }

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean deleteCard(int cardId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Flashcard card = em.find(Flashcard.class, cardId);
            if (card == null)
                return false;

            int deckId = card.getDeckID();

            // Verify ownership: check the deck belongs to this user
            FlashcardDeck deck = em.find(FlashcardDeck.class, deckId);
            if (deck == null || deck.getUserID() != userId) {
                tx.rollback();
                return false;
            }

            // Delete user progress before removing the card
            em.createQuery("DELETE FROM UserFlashcardProgress p WHERE p.cardID = :cardId")
                    .setParameter("cardId", cardId)
                    .executeUpdate();

            em.remove(card);

            if (deck.getCardCount() > 0) {
                deck.setCardCount(deck.getCardCount() - 1);
                em.merge(deck);
            }

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // ===== Spaced repetition =====

    public List<Flashcard> getCardsForReview(int userId, int deckId) {
        EntityManager em = getEntityManager();
        try {
            // Cards due for review or never reviewed
            TypedQuery<Flashcard> q = em.createQuery(
                    "SELECT f FROM Flashcard f WHERE f.deckID = :deckId AND " +
                            "(f.cardID NOT IN (SELECT p.cardID FROM UserFlashcardProgress p WHERE p.userID = :userId) "
                            +
                            "OR f.cardID IN (SELECT p.cardID FROM UserFlashcardProgress p WHERE p.userID = :userId AND p.nextReviewDate <= :now))"
                            +
                            " ORDER BY f.cardOrder",
                    Flashcard.class);
            q.setParameter("deckId", deckId);
            q.setParameter("userId", userId);
            q.setParameter("now", new Date());
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean recordReview(int userId, int cardId, int difficulty) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<UserFlashcardProgress> q = em.createQuery(
                    "SELECT p FROM UserFlashcardProgress p WHERE p.userID = :userId AND p.cardID = :cardId",
                    UserFlashcardProgress.class);
            q.setParameter("userId", userId);
            q.setParameter("cardId", cardId);
            List<UserFlashcardProgress> results = q.getResultList();

            UserFlashcardProgress progress;
            if (results.isEmpty()) {
                progress = new UserFlashcardProgress();
                progress.setUserID(userId);
                progress.setCardID(cardId);
                progress.setDifficulty(difficulty);
                progress.setReviewCount(1);
                progress.setLastReviewDate(new Date());
                progress.setNextReviewDate(calculateNextReview(difficulty, 1));
                em.persist(progress);
            } else {
                progress = results.get(0);
                progress.setDifficulty(difficulty);
                progress.setReviewCount(progress.getReviewCount() + 1);
                progress.setLastReviewDate(new Date());
                progress.setNextReviewDate(calculateNextReview(difficulty, progress.getReviewCount()));
                em.merge(progress);
            }

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Simple spaced repetition: interval depends on difficulty and review count
     * Easy: 4 days * reviewCount
     * Medium: 2 days * reviewCount
     * Hard: 1 day
     */
    private Date calculateNextReview(int difficulty, int reviewCount) {
        Calendar cal = Calendar.getInstance();
        int days;
        if (difficulty == 1) {
            days = 4 * reviewCount; // easy
        } else if (difficulty == 2) {
            days = 2 * reviewCount; // medium
        } else {
            days = 1; // hard or new
        }
        cal.add(Calendar.DAY_OF_YEAR, days);
        return cal.getTime();
    }
}

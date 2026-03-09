package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserFlashcardProgress", uniqueConstraints = @UniqueConstraint(columnNames = { "UserID", "CardID" }))
public class UserFlashcardProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ProgressID")
    private int progressID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "CardID", nullable = false)
    private int cardID;

    @Column(name = "Difficulty")
    private int difficulty; // 0=new, 1=easy, 2=medium, 3=hard

    @Column(name = "NextReviewDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date nextReviewDate;

    @Column(name = "ReviewCount")
    private int reviewCount;

    @Column(name = "LastReviewDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastReviewDate;

    public UserFlashcardProgress() {
        this.difficulty = 0;
        this.reviewCount = 0;
    }

    // Getters and Setters
    public int getProgressID() {
        return progressID;
    }

    public void setProgressID(int progressID) {
        this.progressID = progressID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getCardID() {
        return cardID;
    }

    public void setCardID(int cardID) {
        this.cardID = cardID;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public Date getNextReviewDate() {
        return nextReviewDate;
    }

    public void setNextReviewDate(Date nextReviewDate) {
        this.nextReviewDate = nextReviewDate;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public Date getLastReviewDate() {
        return lastReviewDate;
    }

    public void setLastReviewDate(Date lastReviewDate) {
        this.lastReviewDate = lastReviewDate;
    }
}

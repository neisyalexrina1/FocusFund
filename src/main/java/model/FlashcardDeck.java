package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "FlashcardDecks")
public class FlashcardDeck {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DeckID")
    private int deckID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "DeckName", nullable = false, length = 100)
    private String deckName;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "CourseID")
    private Integer courseID;

    @Column(name = "IsPublic")
    private boolean isPublic;

    @Column(name = "CardCount")
    private int cardCount;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public FlashcardDeck() {
        this.isPublic = false;
        this.cardCount = 0;
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getDeckID() {
        return deckID;
    }

    public void setDeckID(int deckID) {
        this.deckID = deckID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getDeckName() {
        return deckName;
    }

    public void setDeckName(String deckName) {
        this.deckName = deckName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCourseID() {
        return courseID;
    }

    public void setCourseID(Integer courseID) {
        this.courseID = courseID;
    }

    public boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public int getCardCount() {
        return cardCount;
    }

    public void setCardCount(int cardCount) {
        this.cardCount = cardCount;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}

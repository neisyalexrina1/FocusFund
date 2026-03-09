package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Flashcards")
public class Flashcard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CardID")
    private int cardID;

    @Column(name = "DeckID", nullable = false)
    private int deckID;

    @Column(name = "FrontContent", nullable = false, length = 1000)
    private String frontContent;

    @Column(name = "BackContent", nullable = false, length = 1000)
    private String backContent;

    @Column(name = "CardOrder")
    private int cardOrder;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public Flashcard() {
        this.cardOrder = 0;
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getCardID() {
        return cardID;
    }

    public void setCardID(int cardID) {
        this.cardID = cardID;
    }

    public int getDeckID() {
        return deckID;
    }

    public void setDeckID(int deckID) {
        this.deckID = deckID;
    }

    public String getFrontContent() {
        return frontContent;
    }

    public void setFrontContent(String frontContent) {
        this.frontContent = frontContent;
    }

    public String getBackContent() {
        return backContent;
    }

    public void setBackContent(String backContent) {
        this.backContent = backContent;
    }

    public int getCardOrder() {
        return cardOrder;
    }

    public void setCardOrder(int cardOrder) {
        this.cardOrder = cardOrder;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}

package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "FocusFundTransactions")
public class FocusFundTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TransactionID")
    private int transactionID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "TransactionType", nullable = false, length = 30)
    private String transactionType;

    @Column(name = "Amount", nullable = false)
    private double amount;

    @Column(name = "BalanceAfter")
    private double balanceAfter;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "ContractID")
    private Integer contractID;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public FocusFundTransaction() {
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(double balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getContractID() {
        return contractID;
    }

    public void setContractID(Integer contractID) {
        this.contractID = contractID;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}

package model;

import jakarta.persistence.*;

@Entity
@Table(name = "FocusFundPool")
public class FocusFundPool {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PoolID")
    private int poolID;

    @Column(name = "MonthYear", unique = true, nullable = false, length = 7)
    private String monthYear;

    @Column(name = "LeaderboardPool")
    private double leaderboardPool;

    @Column(name = "RevenuePool")
    private double revenuePool;

    @Column(name = "VipBonusPool")
    private double vipBonusPool;

    @Column(name = "TotalPenalties")
    private double totalPenalties;

    @Column(name = "Distributed")
    private boolean distributed;

    public FocusFundPool() {
        this.leaderboardPool = 0;
        this.revenuePool = 0;
        this.vipBonusPool = 0;
        this.totalPenalties = 0;
        this.distributed = false;
    }

    // Getters and Setters
    public int getPoolID() {
        return poolID;
    }

    public void setPoolID(int poolID) {
        this.poolID = poolID;
    }

    public String getMonthYear() {
        return monthYear;
    }

    public void setMonthYear(String monthYear) {
        this.monthYear = monthYear;
    }

    public double getLeaderboardPool() {
        return leaderboardPool;
    }

    public void setLeaderboardPool(double leaderboardPool) {
        this.leaderboardPool = leaderboardPool;
    }

    public double getRevenuePool() {
        return revenuePool;
    }

    public void setRevenuePool(double revenuePool) {
        this.revenuePool = revenuePool;
    }

    public double getVipBonusPool() {
        return vipBonusPool;
    }

    public void setVipBonusPool(double vipBonusPool) {
        this.vipBonusPool = vipBonusPool;
    }

    public double getTotalPenalties() {
        return totalPenalties;
    }

    public void setTotalPenalties(double totalPenalties) {
        this.totalPenalties = totalPenalties;
    }

    public boolean isDistributed() {
        return distributed;
    }

    public void setDistributed(boolean distributed) {
        this.distributed = distributed;
    }
}

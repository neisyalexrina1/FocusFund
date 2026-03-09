package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserOnboarding")
public class UserOnboarding {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OnboardingID")
    private int onboardingID;

    @Column(name = "UserID", unique = true, nullable = false)
    private int userID;

    @Column(name = "Step1_ChooseSubject")
    private boolean step1ChooseSubject;

    @Column(name = "Step2_ReviewFlashcard")
    private boolean step2ReviewFlashcard;

    @Column(name = "Step3_StartMicroSession")
    private boolean step3StartMicroSession;

    @Column(name = "Step4_CompletePomodoro")
    private boolean step4CompletePomodoro;

    @Column(name = "Step5_PostStatus")
    private boolean step5PostStatus;

    @Column(name = "IsCompleted")
    private boolean isCompleted;

    @Column(name = "CompletedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    public UserOnboarding() {
    }

    // Getters and Setters
    public int getOnboardingID() {
        return onboardingID;
    }

    public void setOnboardingID(int onboardingID) {
        this.onboardingID = onboardingID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public boolean isStep1ChooseSubject() {
        return step1ChooseSubject;
    }

    public void setStep1ChooseSubject(boolean v) {
        this.step1ChooseSubject = v;
    }

    public boolean isStep2ReviewFlashcard() {
        return step2ReviewFlashcard;
    }

    public void setStep2ReviewFlashcard(boolean v) {
        this.step2ReviewFlashcard = v;
    }

    public boolean isStep3StartMicroSession() {
        return step3StartMicroSession;
    }

    public void setStep3StartMicroSession(boolean v) {
        this.step3StartMicroSession = v;
    }

    public boolean isStep4CompletePomodoro() {
        return step4CompletePomodoro;
    }

    public void setStep4CompletePomodoro(boolean v) {
        this.step4CompletePomodoro = v;
    }

    public boolean isStep5PostStatus() {
        return step5PostStatus;
    }

    public void setStep5PostStatus(boolean v) {
        this.step5PostStatus = v;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Date completedDate) {
        this.completedDate = completedDate;
    }

    public int getCompletedSteps() {
        int count = 0;
        if (step1ChooseSubject)
            count++;
        if (step2ReviewFlashcard)
            count++;
        if (step3StartMicroSession)
            count++;
        if (step4CompletePomodoro)
            count++;
        if (step5PostStatus)
            count++;
        return count;
    }
}

package service;

import model.Challenge;
import model.UserChallenge;

import java.util.List;

public interface ChallengeService {
    List<Challenge> getActiveChallenges();

    Challenge getChallengeById(int challengeId);

    List<UserChallenge> getUserChallenges(int userId);

    List<UserChallenge> getActiveUserChallenges(int userId);

    boolean joinChallenge(int userId, int challengeId);

    boolean updateProgress(int userChallengeId, int daysCompleted, int userId);

    boolean abandonChallenge(int userChallengeId, int userId);
}

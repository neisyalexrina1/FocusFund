package service;

import dao.ChallengeDAO;
import model.Challenge;
import model.UserChallenge;

import java.util.List;

public class ChallengeServiceImpl implements ChallengeService {

    private final ChallengeDAO challengeDAO = new ChallengeDAO();

    @Override
    public List<Challenge> getActiveChallenges() {
        return challengeDAO.getActiveChallenges();
    }

    @Override
    public Challenge getChallengeById(int challengeId) {
        return challengeDAO.getChallengeById(challengeId);
    }

    @Override
    public List<UserChallenge> getUserChallenges(int userId) {
        return challengeDAO.getUserChallenges(userId);
    }

    @Override
    public List<UserChallenge> getActiveUserChallenges(int userId) {
        return challengeDAO.getActiveUserChallenges(userId);
    }

    @Override
    public boolean joinChallenge(int userId, int challengeId) {
        return challengeDAO.joinChallenge(userId, challengeId);
    }

    @Override
    public boolean updateProgress(int userChallengeId, int daysCompleted, int userId) {
        return challengeDAO.updateProgress(userChallengeId, daysCompleted, userId);
    }

    @Override
    public boolean abandonChallenge(int userChallengeId, int userId) {
        return challengeDAO.abandonChallenge(userChallengeId, userId);
    }
}

package service;

import dao.UserGamificationDAO;
import dao.VipDAO;
import model.UserGamification;
import model.UserVipStatus;
import model.VipTier;

import java.util.List;

public class VipServiceImpl implements VipService {

    private final VipDAO vipDAO = new VipDAO();
    private final UserGamificationDAO gamificationDAO = new UserGamificationDAO();

    @Override
    public List<VipTier> getAllTiers() {
        return vipDAO.getAllTiers();
    }

    @Override
    public VipTier getTierById(int tierId) {
        return vipDAO.getTierById(tierId);
    }

    @Override
    public UserVipStatus getUserVipStatus(int userId) {
        return vipDAO.getUserVipStatus(userId);
    }

    @Override
    public boolean purchaseVip(int userId, int tierId) {
        VipTier tier = vipDAO.getTierById(tierId);
        if (tier == null)
            return false;

        // Check if user has enough coins
        UserGamification gData = gamificationDAO.getOrCreate(userId);
        if (gData.getFocusCoins() < tier.getCoinCost()) {
            throw new ValidationException("Not enough Focus Coins! Need " + tier.getCoinCost()
                    + " coins, you have " + gData.getFocusCoins() + " coins.");
        }

        // Spend coins and purchase VIP
        boolean spent = gamificationDAO.spendCoins(userId, tier.getCoinCost());
        if (!spent)
            return false;

        return vipDAO.purchaseVip(userId, tierId);
    }

    @Override
    public boolean hasFeature(int userId, String featureName) {
        UserVipStatus vip = vipDAO.getUserVipStatus(userId);
        if (vip == null || vip.getVipTier() == null)
            return false;
        String features = vip.getVipTier().getFeatures();
        return features != null && features.contains(featureName);
    }
}

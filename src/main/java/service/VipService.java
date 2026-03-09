package service;

import model.VipTier;
import model.UserVipStatus;

import java.util.List;

public interface VipService {
    List<VipTier> getAllTiers();

    VipTier getTierById(int tierId);

    UserVipStatus getUserVipStatus(int userId);

    boolean purchaseVip(int userId, int tierId);

    boolean hasFeature(int userId, String featureName);
}

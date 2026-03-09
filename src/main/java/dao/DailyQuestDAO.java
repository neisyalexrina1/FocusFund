package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.DailyQuestTemplate;
import model.UserDailyQuest;

import java.text.SimpleDateFormat;
import java.util.*;

public class DailyQuestDAO extends BaseDAO {

    private Date today() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }

    /**
     * Get all active quest templates
     */
    public List<DailyQuestTemplate> getActiveTemplates() {
        EntityManager em = getEntityManager();
        try {
            return em
                    .createQuery("SELECT t FROM DailyQuestTemplate t WHERE t.isActive = true", DailyQuestTemplate.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Get today's quests for a user, auto-assigning if not yet assigned
     */
    public List<UserDailyQuest> getTodayQuests(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Date today = today();

            // Check if already assigned
            TypedQuery<UserDailyQuest> q = em.createQuery(
                    "SELECT uq FROM UserDailyQuest uq WHERE uq.userID = :userId AND uq.questDate = :today",
                    UserDailyQuest.class);
            q.setParameter("userId", userId);
            q.setParameter("today", today);
            List<UserDailyQuest> existing = q.getResultList();

            if (!existing.isEmpty()) {
                // Enrich with template info
                for (UserDailyQuest uq : existing) {
                    DailyQuestTemplate t = em.find(DailyQuestTemplate.class, uq.getTemplateID());
                    if (t != null) {
                        uq.setQuestName(t.getQuestName());
                        uq.setQuestIcon(t.getQuestIcon());
                        uq.setDescription(t.getDescription());
                        uq.setQuestType(t.getQuestType());
                    }
                }
                return existing;
            }

            // Auto-assign: pick 3 random quests (1 easy, 1 easy, 1 medium)
            tx.begin();
            List<DailyQuestTemplate> all = getActiveTemplates();
            List<DailyQuestTemplate> easy = new ArrayList<>();
            List<DailyQuestTemplate> medium = new ArrayList<>();
            for (DailyQuestTemplate t : all) {
                if ("easy".equals(t.getDifficulty()))
                    easy.add(t);
                else if ("medium".equals(t.getDifficulty()))
                    medium.add(t);
            }

            Collections.shuffle(easy);
            Collections.shuffle(medium);

            List<DailyQuestTemplate> selected = new ArrayList<>();
            if (easy.size() >= 2) {
                selected.add(easy.get(0));
                selected.add(easy.get(1));
            } else {
                selected.addAll(easy);
            }
            if (!medium.isEmpty()) {
                selected.add(medium.get(0));
            }

            List<UserDailyQuest> result = new ArrayList<>();
            for (DailyQuestTemplate t : selected) {
                UserDailyQuest uq = new UserDailyQuest();
                uq.setUserID(userId);
                uq.setTemplateID(t.getTemplateID());
                uq.setQuestDate(today);
                uq.setTargetValue(t.getTargetValue());
                uq.setCoinReward(t.getCoinReward());
                uq.setExpReward(t.getExpReward());
                em.persist(uq);

                // Set transient display fields
                uq.setQuestName(t.getQuestName());
                uq.setQuestIcon(t.getQuestIcon());
                uq.setDescription(t.getDescription());
                uq.setQuestType(t.getQuestType());
                result.add(uq);
            }

            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Update quest progress. Returns true if quest was just completed.
     */
    public boolean updateProgress(int userQuestId, int progressToAdd) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserDailyQuest uq = em.find(UserDailyQuest.class, userQuestId);
            if (uq == null || !"active".equals(uq.getStatus()))
                return false;

            uq.setCurrentProgress(uq.getCurrentProgress() + progressToAdd);

            if (uq.getCurrentProgress() >= uq.getTargetValue()) {
                uq.setStatus("completed");
                uq.setCompletedDate(new Date());
                em.merge(uq);
                tx.commit();
                return true;
            }

            em.merge(uq);
            tx.commit();
            return false;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Auto-progress quests by type (called when events happen)
     * Returns list of completed quest IDs
     */
    public List<Integer> progressByType(int userId, String questType, int amount) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        List<Integer> completedIds = new ArrayList<>();
        try {
            tx.begin();
            Date today = today();

            // Get template IDs for this type
            List<DailyQuestTemplate> templates = em.createQuery(
                    "SELECT t FROM DailyQuestTemplate t WHERE t.questType = :type AND t.isActive = true",
                    DailyQuestTemplate.class)
                    .setParameter("type", questType)
                    .getResultList();

            Set<Integer> templateIds = new HashSet<>();
            for (DailyQuestTemplate t : templates) {
                templateIds.add(t.getTemplateID());
            }

            if (templateIds.isEmpty()) {
                tx.commit();
                return completedIds;
            }

            // Find user's active quests of this type today
            List<UserDailyQuest> quests = em.createQuery(
                    "SELECT uq FROM UserDailyQuest uq WHERE uq.userID = :userId AND uq.questDate = :today AND uq.status = 'active'",
                    UserDailyQuest.class)
                    .setParameter("userId", userId)
                    .setParameter("today", today)
                    .getResultList();

            for (UserDailyQuest uq : quests) {
                if (!templateIds.contains(uq.getTemplateID()))
                    continue;

                uq.setCurrentProgress(uq.getCurrentProgress() + amount);
                if (uq.getCurrentProgress() >= uq.getTargetValue()) {
                    uq.setStatus("completed");
                    uq.setCompletedDate(new Date());
                    completedIds.add(uq.getUserQuestID());
                }
                em.merge(uq);
            }

            tx.commit();
            return completedIds;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return completedIds;
        } finally {
            em.close();
        }
    }

    /**
     * Count completed quests today
     */
    public int getCompletedCountToday(int userId) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(uq) FROM UserDailyQuest uq WHERE uq.userID = :userId AND uq.questDate = :today AND uq.status = 'completed'",
                    Long.class)
                    .setParameter("userId", userId)
                    .setParameter("today", today())
                    .getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }
}

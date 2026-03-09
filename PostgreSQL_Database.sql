-- =============================================
-- FocusFund Database Setup Script
-- PostgreSQL / Supabase
-- =============================================

-- =============================================
-- 1. CORE TABLES
-- =============================================

CREATE TABLE IF NOT EXISTS Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(255),
    Email VARCHAR(255),
    Bio VARCHAR(255),
    Location VARCHAR(255),
    Website VARCHAR(255),
    WebsiteName VARCHAR(255),
    ProfileImage VARCHAR(255),
    BannerImage VARCHAR(255),
    Role VARCHAR(255) DEFAULT 'user',
    Balance DOUBLE PRECISION DEFAULT 0,
    IsActive BOOLEAN NOT NULL DEFAULT true,
    LastLogin TIMESTAMP,
    RememberToken VARCHAR(255),
    OtpCode VARCHAR(255),
    OtpExpiry TIMESTAMP,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Courses (
    CourseID SERIAL PRIMARY KEY,
    CourseName VARCHAR(255) NOT NULL,
    Icon VARCHAR(255),
    Description VARCHAR(255),
    DetailDescription VARCHAR(255),
    Duration VARCHAR(255),
    TopicCount INT DEFAULT 0,
    LearnerCount INT DEFAULT 0,
    CreatedBy INT NULL,
    IsPublic BOOLEAN DEFAULT true,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS StudyRooms (
    RoomID SERIAL PRIMARY KEY,
    RoomName VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    RoomType VARCHAR(255) DEFAULT 'public',
    PomodoroSetting VARCHAR(255) DEFAULT '25-5',
    MaxParticipants INT DEFAULT 15,
    CurrentParticipants INT DEFAULT 0,
    CreatedBy INT,
    Status VARCHAR(255) DEFAULT 'OPEN',
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS StudySessions (
    SessionID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    RoomID INT,
    StartTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndTime TIMESTAMP,
    FocusMinutes INT DEFAULT 0,
    PomodorosCompleted INT DEFAULT 0,
    Goal VARCHAR(255),
    Status VARCHAR(255) DEFAULT 'active',
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID)
);

CREATE TABLE IF NOT EXISTS Posts (
    PostID SERIAL PRIMARY KEY,
    UserID INT,
    Content VARCHAR(255),
    ImageURL VARCHAR(255),
    LikeCount INT DEFAULT 0,
    CommentCount INT DEFAULT 0,
    ShareCount INT DEFAULT 0,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Comments (
    CommentID SERIAL PRIMARY KEY,
    PostID INT NOT NULL,
    UserID INT,
    Content VARCHAR(255),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);

-- =============================================
-- 2. STUDY ROOM EXTENSIONS
-- =============================================

CREATE TABLE IF NOT EXISTS RoomMembers (
    MemberID SERIAL PRIMARY KEY,
    RoomID INT NOT NULL,
    UserID INT,
    Role VARCHAR(255) DEFAULT 'member',
    JoinedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL,
    CONSTRAINT UQ_RoomMembers_RoomUser UNIQUE (RoomID, UserID)
);

CREATE TABLE IF NOT EXISTS RoomMessages (
    MessageID SERIAL PRIMARY KEY,
    RoomID INT NOT NULL,
    UserID INT,
    DisplayName VARCHAR(255),
    Content VARCHAR(255) NOT NULL,
    SentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS IX_RoomMessages_RoomID ON RoomMessages(RoomID, SentAt DESC);

-- =============================================
-- 3. GAMIFICATION TABLES
-- =============================================

CREATE TABLE IF NOT EXISTS UserGamification (
    GamificationID SERIAL PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    FocusCoins INT DEFAULT 0,
    TotalExp INT DEFAULT 0,
    CurrentRank VARCHAR(255) DEFAULT 'Unranked',
    TotalStudyMinutes INT DEFAULT 0,
    LastCoinEarnedDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DailyStreaks (
    StreakID SERIAL PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    CurrentStreak INT DEFAULT 0,
    LongestStreak INT DEFAULT 0,
    LastStudyDate DATE,
    StreakStartDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- =============================================
-- 4. BADGES & ACHIEVEMENTS
-- =============================================

CREATE TABLE IF NOT EXISTS Badges (
    BadgeID SERIAL PRIMARY KEY,
    BadgeName VARCHAR(255) NOT NULL,
    BadgeIcon VARCHAR(255),
    Description VARCHAR(255),
    BadgeType VARCHAR(255),
    RequirementType VARCHAR(255),
    RequirementValue INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS UserBadges (
    UserBadgeID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    BadgeID INT NOT NULL,
    EarnedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BadgeID) REFERENCES Badges(BadgeID),
    CONSTRAINT UQ_UserBadges UNIQUE (UserID, BadgeID)
);

-- =============================================
-- 5. CHALLENGES
-- =============================================

CREATE TABLE IF NOT EXISTS Challenges (
    ChallengeID SERIAL PRIMARY KEY,
    ChallengeName VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    ChallengeType VARCHAR(255),
    DurationDays INT NOT NULL,
    TargetMinutesPerDay INT DEFAULT 25,
    CoinReward INT DEFAULT 20,
    ExpReward INT DEFAULT 50,
    BadgeRewardID INT,
    IsActive BOOLEAN DEFAULT true,
    FOREIGN KEY (BadgeRewardID) REFERENCES Badges(BadgeID)
);

CREATE TABLE IF NOT EXISTS UserChallenges (
    UserChallengeID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    ChallengeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    DaysCompleted INT DEFAULT 0,
    Status VARCHAR(255) DEFAULT 'active',
    CompletedDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ChallengeID) REFERENCES Challenges(ChallengeID)
);

-- =============================================
-- 6. MYSTERY REWARDS
-- =============================================

CREATE TABLE IF NOT EXISTS Rewards (
    RewardID SERIAL PRIMARY KEY,
    RewardType VARCHAR(255) NOT NULL,
    Content VARCHAR(255) NOT NULL,
    BonusCoins INT DEFAULT 0,
    Rarity VARCHAR(255) DEFAULT 'common',
    IsActive BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS UserRewards (
    UserRewardID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    RewardID INT NOT NULL,
    SessionID INT,
    ReceivedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RewardID) REFERENCES Rewards(RewardID),
    FOREIGN KEY (SessionID) REFERENCES StudySessions(SessionID)
);

-- =============================================
-- 7. FLASHCARDS
-- =============================================

CREATE TABLE IF NOT EXISTS FlashcardDecks (
    DeckID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    DeckName VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    CourseID INT,
    IsPublic BOOLEAN DEFAULT false,
    CardCount INT DEFAULT 0,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE IF NOT EXISTS Flashcards (
    CardID SERIAL PRIMARY KEY,
    DeckID INT NOT NULL,
    FrontContent VARCHAR(255) NOT NULL,
    BackContent VARCHAR(255) NOT NULL,
    CardOrder INT DEFAULT 0,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DeckID) REFERENCES FlashcardDecks(DeckID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS UserFlashcardProgress (
    ProgressID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    CardID INT NOT NULL,
    Difficulty INT DEFAULT 0,
    NextReviewDate TIMESTAMP,
    ReviewCount INT DEFAULT 0,
    LastReviewDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CardID) REFERENCES Flashcards(CardID),
    CONSTRAINT UQ_UserFlashcard UNIQUE (UserID, CardID)
);

-- =============================================
-- 8. MINDMAPS
-- =============================================

CREATE TABLE IF NOT EXISTS Mindmaps (
    MindmapID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    CourseID INT,
    IsPublic BOOLEAN DEFAULT false,
    LikeCount INT DEFAULT 0,
    UseCount INT DEFAULT 0,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE IF NOT EXISTS MindmapNodes (
    NodeID SERIAL PRIMARY KEY,
    MindmapID INT NOT NULL,
    ParentNodeID INT,
    NodeText VARCHAR(255) NOT NULL,
    NodeColor VARCHAR(255),
    NodeIcon VARCHAR(255),
    PositionX DOUBLE PRECISION DEFAULT 0,
    PositionY DOUBLE PRECISION DEFAULT 0,
    NodeOrder INT DEFAULT 0,
    FOREIGN KEY (MindmapID) REFERENCES Mindmaps(MindmapID) ON DELETE CASCADE,
    FOREIGN KEY (ParentNodeID) REFERENCES MindmapNodes(NodeID)
);

-- =============================================
-- 9. SOCIAL FEATURES
-- =============================================

CREATE TABLE IF NOT EXISTS PostLikes (
    LikeID SERIAL PRIMARY KEY,
    PostID INT NOT NULL,
    UserID INT NOT NULL,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT UQ_PostLikes UNIQUE (PostID, UserID)
);

CREATE TABLE IF NOT EXISTS Follows (
    FollowID SERIAL PRIMARY KEY,
    FollowerID INT NOT NULL,
    FollowingID INT NOT NULL,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FollowerID) REFERENCES Users(UserID),
    FOREIGN KEY (FollowingID) REFERENCES Users(UserID),
    CONSTRAINT UQ_Follows UNIQUE (FollowerID, FollowingID),
    CONSTRAINT CK_NoSelfFollow CHECK (FollowerID <> FollowingID)
);

-- =============================================
-- 10. VIP TIERS
-- =============================================

CREATE TABLE IF NOT EXISTS VipTiers (
    TierID SERIAL PRIMARY KEY,
    TierName VARCHAR(255) NOT NULL,
    TierIcon VARCHAR(255),
    CoinCost INT NOT NULL,
    Description VARCHAR(255),
    Features VARCHAR(255),
    TierOrder INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS UserVipStatus (
    UserVipID SERIAL PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    TierID INT NOT NULL,
    PurchasedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TierID) REFERENCES VipTiers(TierID)
);

-- =============================================
-- 11. LEADERBOARD
-- =============================================

CREATE TABLE IF NOT EXISTS LeaderboardMonthly (
    LeaderboardID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    MonthYear VARCHAR(255) NOT NULL,
    TotalCoinsEarned INT DEFAULT 0,
    TotalStudyMinutes INT DEFAULT 0,
    Ranking INT,
    PrizeAmount DOUBLE PRECISION DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT UQ_Leaderboard UNIQUE (UserID, MonthYear)
);

CREATE INDEX IF NOT EXISTS IX_Leaderboard_Month ON LeaderboardMonthly(MonthYear, TotalCoinsEarned DESC);

-- =============================================
-- 12. FOCUSFUND MODE TABLES
-- =============================================

CREATE TABLE IF NOT EXISTS FocusFundContracts (
    ContractID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    StakeAmount DOUBLE PRECISION NOT NULL,
    PenaltyPercent INT DEFAULT 10,
    GoalType VARCHAR(255) DEFAULT 'session',
    GoalValue INT DEFAULT 25,
    DurationDays INT DEFAULT 1,
    StartDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndDate TIMESTAMP,
    DaysCompleted INT DEFAULT 0,
    Status VARCHAR(255) DEFAULT 'active',
    CompletedDate TIMESTAMP,
    BonusEarned DOUBLE PRECISION DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FocusFundTransactions (
    TransactionID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    TransactionType VARCHAR(255) NOT NULL,
    Amount DOUBLE PRECISION NOT NULL,
    BalanceAfter DOUBLE PRECISION DEFAULT 0,
    Description VARCHAR(255),
    ContractID INT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ContractID) REFERENCES FocusFundContracts(ContractID)
);

CREATE INDEX IF NOT EXISTS IX_Transactions_User ON FocusFundTransactions(UserID, CreatedDate DESC);

CREATE TABLE IF NOT EXISTS FocusFundPool (
    PoolID SERIAL PRIMARY KEY,
    MonthYear VARCHAR(255) NOT NULL UNIQUE,
    LeaderboardPool DOUBLE PRECISION DEFAULT 0,
    RevenuePool DOUBLE PRECISION DEFAULT 0,
    VipBonusPool DOUBLE PRECISION DEFAULT 0,
    TotalPenalties DOUBLE PRECISION DEFAULT 0,
    Distributed BOOLEAN DEFAULT false
);

CREATE INDEX IF NOT EXISTS IX_Contracts_User_Status ON FocusFundContracts(UserID, Status);
CREATE INDEX IF NOT EXISTS IX_Pool_Month ON FocusFundPool(MonthYear);

-- =============================================
-- 13. ENGAGEMENT FEATURES
-- =============================================

CREATE TABLE IF NOT EXISTS DailyQuestTemplates (
    TemplateID SERIAL PRIMARY KEY,
    QuestName VARCHAR(255) NOT NULL,
    QuestIcon VARCHAR(255),
    Description VARCHAR(255),
    QuestType VARCHAR(255) NOT NULL,
    TargetValue INT DEFAULT 1,
    CoinReward INT DEFAULT 2,
    ExpReward INT DEFAULT 10,
    Difficulty VARCHAR(255) DEFAULT 'easy',
    IsActive BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS UserDailyQuests (
    UserQuestID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    TemplateID INT NOT NULL,
    QuestDate DATE NOT NULL,
    CurrentProgress INT DEFAULT 0,
    TargetValue INT DEFAULT 1,
    Status VARCHAR(255) DEFAULT 'active',
    CompletedDate TIMESTAMP,
    CoinReward INT DEFAULT 2,
    ExpReward INT DEFAULT 10,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TemplateID) REFERENCES DailyQuestTemplates(TemplateID),
    CONSTRAINT UQ_UserDailyQuest UNIQUE (UserID, TemplateID, QuestDate)
);

CREATE INDEX IF NOT EXISTS IX_UserDailyQuests_Date ON UserDailyQuests(UserID, QuestDate, Status);

CREATE TABLE IF NOT EXISTS MicroSessions (
    MicroSessionID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    InitialDuration INT DEFAULT 1,
    ActualDuration INT DEFAULT 0,
    Escalations INT DEFAULT 0,
    StartTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndTime TIMESTAMP,
    Status VARCHAR(255) DEFAULT 'active',
    ConvertedToPomodoro BOOLEAN DEFAULT false,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS StudyBuddies (
    BuddyPairID SERIAL PRIMARY KEY,
    User1ID INT NOT NULL,
    User2ID INT NOT NULL,
    Status VARCHAR(255) DEFAULT 'active',
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalSessionsTogether INT DEFAULT 0,
    FOREIGN KEY (User1ID) REFERENCES Users(UserID),
    FOREIGN KEY (User2ID) REFERENCES Users(UserID),
    CONSTRAINT UQ_BuddyPair UNIQUE (User1ID, User2ID),
    CONSTRAINT CK_NoBuddySelf CHECK (User1ID <> User2ID)
);

CREATE TABLE IF NOT EXISTS BuddyActivity (
    ActivityID SERIAL PRIMARY KEY,
    BuddyPairID INT NOT NULL,
    UserID INT NOT NULL,
    ActivityType VARCHAR(255) NOT NULL,
    Message VARCHAR(255),
    IsRead BOOLEAN DEFAULT false,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BuddyPairID) REFERENCES StudyBuddies(BuddyPairID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE INDEX IF NOT EXISTS IX_BuddyActivity_Pair ON BuddyActivity(BuddyPairID, CreatedDate DESC);

CREATE TABLE IF NOT EXISTS StreakAlerts (
    AlertID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    AlertType VARCHAR(255) NOT NULL,
    Message VARCHAR(255),
    IsRead BOOLEAN DEFAULT false,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS UserOnboarding (
    OnboardingID SERIAL PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Step1_ChooseSubject BOOLEAN DEFAULT false,
    Step2_ReviewFlashcard BOOLEAN DEFAULT false,
    Step3_StartMicroSession BOOLEAN DEFAULT false,
    Step4_CompletePomodoro BOOLEAN DEFAULT false,
    Step5_PostStatus BOOLEAN DEFAULT false,
    IsCompleted BOOLEAN DEFAULT false,
    CompletedDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- =============================================
-- 14. NOTIFICATIONS
-- =============================================

CREATE TABLE IF NOT EXISTS Notifications (
    NotificationID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Icon VARCHAR(255),
    Title VARCHAR(255) NOT NULL,
    Message VARCHAR(255),
    ActionUrl VARCHAR(255),
    IsRead BOOLEAN DEFAULT false,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_Notifications_User ON Notifications(UserID, IsRead, CreatedDate DESC);

-- =============================================
-- 15. AI CHAT HISTORY
-- =============================================

CREATE TABLE IF NOT EXISTS AIChatSessions (
    SessionID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Title VARCHAR(255) DEFAULT 'New Chat',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_AIChatSessions_User ON AIChatSessions(UserID, UpdatedAt DESC);

CREATE TABLE IF NOT EXISTS AIChatMessages (
    MessageID SERIAL PRIMARY KEY,
    SessionID INT NOT NULL,
    Role VARCHAR(255) NOT NULL,
    Content TEXT,
    Mode VARCHAR(255) DEFAULT 'normal',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SessionID) REFERENCES AIChatSessions(SessionID) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_AIChatMessages_Session ON AIChatMessages(SessionID, CreatedAt ASC);

-- =============================================
-- 16. COURSE PROGRESS
-- =============================================

CREATE TABLE IF NOT EXISTS UserCourseProgress (
    ProgressID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    CompletedLessons INT DEFAULT 0,
    TotalLessons INT DEFAULT 1,
    ProgressPercent DOUBLE PRECISION GENERATED ALWAYS AS (
        CAST(CompletedLessons AS DOUBLE PRECISION) / NULLIF(TotalLessons, 0) * 100
    ) STORED,
    Status VARCHAR(255) DEFAULT 'in_progress',
    StartedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CompletedDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    UNIQUE(UserID, CourseID)
);

-- =============================================
-- 17. EMAIL NOTIFICATIONS LOG
-- =============================================

CREATE TABLE IF NOT EXISTS EmailNotifications (
    NotificationID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Subject VARCHAR(255),
    SentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(255) DEFAULT 'sent',
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);



-- =============================================
-- SAMPLE DATA
-- =============================================

INSERT INTO Users (Username, PasswordHash, FullName, Email, Bio, Location, Role) VALUES ('admin', 'admin123', 'Admin FocusFund', 'admin@focusfund.com', 'Platform administrator', 'Vietnam', 'admin'),
('johndoe', 'password123', 'John Doe', 'john@email.com', 'Passionate learner. Focus enthusiast.', 'Vietnam', 'user'),
('sarahm', 'password123', 'Sarah Mitchell', 'sarah@email.com', 'Math lover. Calculus explorer.', 'United States', 'user'),
('jamesk', 'password123', 'James Kim', 'james@email.com', 'Physics and programming enthusiast.', 'South Korea', 'user') ON CONFLICT DO NOTHING;

INSERT INTO Courses (CourseName, Icon, Description, DetailDescription, Duration, TopicCount, LearnerCount) VALUES ('Calculus I', '&#8747 ON CONFLICT DO NOTHING;', 'Limits, derivatives, integrals and their applications', 'Master the fundamentals of calculus with our structured 8-week roadmap', '8 Weeks', 12, 234),
('Physics 101', '&#x26DB;', 'Mechanics, thermodynamics, and wave motion', 'Comprehensive introduction to classical physics concepts', '10 Weeks', 15, 189),
('Python Programming', '{ }', 'From basics to data structures and algorithms', 'Learn Python from scratch with hands-on projects', '12 Weeks', 20, 567),
('Microeconomics', '&#x1F4CA;', 'Supply, demand, market structures, and consumer theory', 'Understanding economic principles for real-world applications', '8 Weeks', 10, 145),
('General Chemistry', '&#x1F9EA;', 'Atomic structure, bonding, reactions, and stoichiometry', 'Foundation course for chemistry majors', '10 Weeks', 14, 198),
('Statistics', '&#x1F4C8;', 'Probability, distributions, hypothesis testing', 'Essential statistics for data-driven decisions', '6 Weeks', 8, 312);

INSERT INTO StudyRooms (RoomName, Description, RoomType, PomodoroSetting, MaxParticipants, CurrentParticipants, CreatedBy) VALUES ('Deep Focus Zone', 'No distractions. Maximum concentration.', 'private', '25-5', 12, 8, 2),
('Calculus Study Group', 'Working through Week 2 derivatives together', 'public', '50-10', 20, 15, 3),
('Night Owl Coders', 'Late night programming sessions', 'silent', '90-20', 8, 3, 4) ON CONFLICT DO NOTHING;

INSERT INTO Posts (UserID, Content, LikeCount, CommentCount) VALUES (2, 'Just completed my 7-day study streak! Feeling more productive than ever.', 12, 3),
(2, 'Finally mastered the chain rule in Calculus! The AI assistant really helped break it down.', 24, 4) ON CONFLICT DO NOTHING;

INSERT INTO Comments (PostID, UserID, Content) VALUES (1, 3, 'Amazing! Keep it up!'),
(1, 4, 'Inspiring! I need to start my streak too.'),
(2, 3, 'The chain rule clicked for me too after using the AI helper!') ON CONFLICT DO NOTHING;

INSERT INTO Badges (BadgeName, BadgeIcon, Description, BadgeType, RequirementType, RequirementValue) VALUES ('First Steps', '🌱', 'Complete your first study session', 'special', 'total_sessions', 1),
('Early Bird', '🐦', 'Study before 7 AM', 'special', 'special', 0),
('Night Owl', '🦉', 'Study after 11 PM', 'special', 'special', 0),
('3-Day Streak', '🔥', 'Maintain a 3-day study streak', 'streak', 'streak_days', 3),
('7-Day Warrior', '⚔️', 'Maintain a 7-day study streak', 'streak', 'streak_days', 7),
('30-Day Legend', '🏆', 'Maintain a 30-day study streak', 'streak', 'streak_days', 30),
('Bronze Scholar', '🥉', 'Reach Bronze rank (10 hours)', 'study_hours', 'total_hours', 10),
('Silver Scholar', '🥈', 'Reach Silver rank (50 hours)', 'study_hours', 'total_hours', 50),
('Gold Scholar', '🥇', 'Reach Gold rank (100 hours)', 'study_hours', 'total_hours', 100),
('Coin Collector', '💰', 'Earn 100 Focus Coins', 'special', 'coins_earned', 100),
('Social Butterfly', '🦋', 'Get 10 likes on your posts', 'social', 'likes_received', 10),
('Flashcard Master', '📚', 'Review 100 flashcards', 'special', 'flashcards_reviewed', 100) ON CONFLICT DO NOTHING;

INSERT INTO Challenges (ChallengeName, Description, ChallengeType, DurationDays, TargetMinutesPerDay, CoinReward, ExpReward) VALUES ('7-Day Focus Sprint', 'Study at least 25 minutes every day for 7 days straight!', '7day', 7, 25, 25, 70),
('30-Day Marathon', 'Commit to 25 minutes of focused study every day for a whole month!', '30day', 30, 25, 100, 300),
('Weekend Warrior', 'Study 50 minutes each day this weekend!', 'custom', 2, 50, 15, 30),
('Early Riser Week', 'Complete a study session before 8 AM for 7 days!', '7day', 7, 25, 30, 80),
('Deep Focus Challenge', 'Complete 5 Pomodoro sessions (25 min each) in one day!', 'custom', 1, 125, 20, 50) ON CONFLICT DO NOTHING;

INSERT INTO Rewards (RewardType, Content, BonusCoins, Rarity) VALUES ('quote', 'Hey! The focus you''re putting in right now is about to pay off. In exactly 30 days, you will have unlocked a powerful new skill!', 0, 'common'),
('quote', '"A drop of water wears through rock, not by force, but by persistence." — You are doing exactly that!', 0, 'common'),
('quote', 'Every study session is a brick. Today you just laid another one on the road to success!', 0, 'common'),
('quote', 'Your knowledge portfolio is growing with compound interest. Don''t stop — your future self will thank you!', 0, 'common'),
('quote', 'You just outperformed 80% of people who gave up today. Thank you for staying!', 0, 'common'),
('prediction', '🔮 Message from the future: In 30 days you won''t just remember this material — you''ll be able to teach it to others!', 0, 'rare'),
('prediction', '🔮 A wise traveler from ahead sends word: The knowledge you just studied will appear on your next exam!', 0, 'rare'),
('prediction', '🔮 In 14 days, you will look back and wonder: "How did I get so good?" — Just trust the process!', 0, 'rare'),
('fun_fact', '💡 Did you know? Your brain burns 20% of your body''s energy despite only weighing 2% of your body weight. You just burned some serious brain calories!', 0, 'common'),
('fun_fact', '💡 Research shows: Spaced repetition improves long-term retention by 200% compared to re-reading. Try flashcards!', 0, 'common'),
('fun_fact', '💡 The Pomodoro Technique was invented by Francesco Cirillo in 1980 using a tomato-shaped kitchen timer!', 0, 'common'),
('bonus_coins', '🎉 JACKPOT! You received 3 bonus Focus Coins! Today is your lucky day!', 3, 'epic'),
('bonus_coins', '✨ Bonus! +2 Focus Coins for your dedication!', 2, 'rare'),
('bonus_coins', '🌟 +1 Focus Coin! Keep up the great work!', 1, 'common') ON CONFLICT DO NOTHING;

INSERT INTO VipTiers (TierName, TierIcon, CoinCost, Description, Features, TierOrder) VALUES ('VIP Bronze', '🥉', 50, 'Unlock basic premium features', '["enhanced_ai","custom_themes"]', 1),
('VIP Silver', '🥈', 150, 'Access to expanded resources', '["enhanced_ai","custom_themes","document_library","priority_rooms"]', 2),
('VIP Gold', '🥇', 300, 'Full premium experience', '["enhanced_ai","custom_themes","document_library","priority_rooms","exclusive_badges","advanced_analytics"]', 3),
('VIP Diamond', '💎', 500, 'Ultimate learner package', '["all_features","mentor_access","exclusive_challenges","custom_badges"]', 4) ON CONFLICT DO NOTHING;

INSERT INTO DailyQuestTemplates (QuestName, QuestIcon, Description, QuestType, TargetValue, CoinReward, ExpReward, Difficulty) VALUES ('🎯 Complete 1 Pomodoro', '🎯', 'Complete at least 1 Pomodoro session (25 minutes)', 'pomodoro', 1, 3, 15, 'easy'),
('📚 Review 5 Flashcards', '📚', 'Review any 5 flashcards', 'flashcard', 5, 2, 10, 'easy'),
('✍️ Share Your Journey', '✍️', 'Post 1 update about your study session today', 'post', 1, 2, 5, 'easy'),
('⚡ 1-Minute Micro Session', '⚡', 'Start with "Just 1 Minute" and see how far you go!', 'micro_session', 1, 1, 5, 'easy'),
('🔥 Keep Your Streak', '🔥', 'Log in and study at least 1 minute today', 'streak', 1, 2, 10, 'easy'),
('💪 Pomodoro Marathon', '💪', 'Complete 3 Pomodoro sessions in a day', 'pomodoro', 3, 8, 30, 'medium'),
('🧠 Flashcard Master', '🧠', 'Review 20 flashcards', 'flashcard', 20, 5, 20, 'medium'),
('⏰ 60-Minute Focus', '⏰', 'Accumulate 60 total minutes of study in one day', 'pomodoro', 60, 10, 40, 'hard') ON CONFLICT DO NOTHING;

-- Initialize gamification & streak for sample users
INSERT INTO UserGamification (UserID, FocusCoins, TotalExp, CurrentRank, TotalStudyMinutes)
SELECT UserID, 0, 0, 'Unranked', 0 FROM Users
WHERE UserID NOT IN (SELECT UserID FROM UserGamification);

INSERT INTO DailyStreaks (UserID, CurrentStreak, LongestStreak)
SELECT UserID, 0, 0 FROM Users
WHERE UserID NOT IN (SELECT UserID FROM DailyStreaks);

-- Seed RoomMembers for existing sample rooms
INSERT INTO RoomMembers (RoomID, UserID, Role)
SELECT RoomID, CreatedBy, 'host' FROM StudyRooms WHERE CreatedBy IS NOT NULL
ON CONFLICT DO NOTHING;

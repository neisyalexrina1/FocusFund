-- =============================================
-- FocusFund Database Setup Script
-- SQL Server
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FocusFundDB')
BEGIN
    CREATE DATABASE FocusFundDB;
END
GO

USE FocusFundDB;
GO

-- =============================================
-- 1. CORE TABLES
-- =============================================

-- Table: Users
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Bio NVARCHAR(500),
    Location NVARCHAR(100),
    Website NVARCHAR(255),
    WebsiteName NVARCHAR(100),
    ProfileImage NVARCHAR(500),
    BannerImage NVARCHAR(500),
    Role NVARCHAR(20) DEFAULT 'user',
    Balance FLOAT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Table: Courses
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    Icon NVARCHAR(10),
    Description NVARCHAR(500),
    DetailDescription NVARCHAR(1000),
    Duration NVARCHAR(50),
    TopicCount INT DEFAULT 0,
    LearnerCount INT DEFAULT 0
);

-- Table: StudyRooms
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='StudyRooms' AND xtype='U')
CREATE TABLE StudyRooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    RoomName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    RoomType NVARCHAR(20) DEFAULT 'public',
    PomodoroSetting NVARCHAR(10) DEFAULT '25-5',
    MaxParticipants INT DEFAULT 15,
    CurrentParticipants INT DEFAULT 0,
    CreatedBy INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Table: StudySessions
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='StudySessions' AND xtype='U')
CREATE TABLE StudySessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    RoomID INT,
    StartTime DATETIME DEFAULT GETDATE(),
    EndTime DATETIME,
    FocusMinutes INT DEFAULT 0,
    PomodorosCompleted INT DEFAULT 0,
    Goal NVARCHAR(500),
    Status NVARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID)
);

-- Table: Posts
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Posts' AND xtype='U')
CREATE TABLE Posts (
    PostID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Content NVARCHAR(2000),
    ImageURL NVARCHAR(500),
    LikeCount INT DEFAULT 0,
    CommentCount INT DEFAULT 0,
    ShareCount INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: Comments
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Comments' AND xtype='U')
CREATE TABLE Comments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    PostID INT NOT NULL,
    UserID INT NOT NULL,
    Content NVARCHAR(1000),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Sample Users
INSERT INTO Users (Username, PasswordHash, FullName, Email, Bio, Location, Role) VALUES
('admin', 'admin123', 'Admin FocusFund', 'admin@focusfund.com', 'Platform administrator', 'Vietnam', 'admin'),
('johndoe', 'password123', 'John Doe', 'john@email.com', 'Passionate learner. Focus enthusiast.', 'Vietnam', 'user'),
('sarahm', 'password123', 'Sarah Mitchell', 'sarah@email.com', 'Math lover. Calculus explorer.', 'United States', 'user'),
('jamesk', 'password123', 'James Kim', 'james@email.com', 'Physics and programming enthusiast.', 'South Korea', 'user');

-- Sample Courses
INSERT INTO Courses (CourseName, Icon, Description, DetailDescription, Duration, TopicCount, LearnerCount) VALUES
(N'Calculus I', N'&#8747;', N'Limits, derivatives, integrals and their applications', N'Master the fundamentals of calculus with our structured 8-week roadmap', N'8 Weeks', 12, 234),
(N'Physics 101', N'&#x26DB;', N'Mechanics, thermodynamics, and wave motion', N'Comprehensive introduction to classical physics concepts', N'10 Weeks', 15, 189),
(N'Python Programming', N'{ }', N'From basics to data structures and algorithms', N'Learn Python from scratch with hands-on projects', N'12 Weeks', 20, 567),
(N'Microeconomics', N'&#x1F4CA;', N'Supply, demand, market structures, and consumer theory', N'Understanding economic principles for real-world applications', N'8 Weeks', 10, 145),
(N'General Chemistry', N'&#x1F9EA;', N'Atomic structure, bonding, reactions, and stoichiometry', N'Foundation course for chemistry majors', N'10 Weeks', 14, 198),
(N'Statistics', N'&#x1F4C8;', N'Probability, distributions, hypothesis testing', N'Essential statistics for data-driven decisions', N'6 Weeks', 8, 312);

-- Sample StudyRooms
INSERT INTO StudyRooms (RoomName, Description, RoomType, PomodoroSetting, MaxParticipants, CurrentParticipants, CreatedBy) VALUES
(N'Deep Focus Zone', N'No distractions. Maximum concentration.', 'private', '25-5', 12, 8, 2),
(N'Calculus Study Group', N'Working through Week 2 derivatives together', 'public', '50-10', 20, 15, 3),
(N'Night Owl Coders', N'Late night programming sessions', 'silent', '90-20', 8, 3, 4);

-- Sample Posts
INSERT INTO Posts (UserID, Content, LikeCount, CommentCount) VALUES
(2, N'Just completed my 7-day study streak! Feeling more productive than ever.', 12, 3),
(2, N'Finally mastered the chain rule in Calculus! The AI assistant really helped break it down.', 24, 4);

-- Sample Comments
INSERT INTO Comments (PostID, UserID, Content) VALUES
(1, 3, N'Amazing! Keep it up!'),
(1, 4, N'Inspiring! I need to start my streak too.'),
(2, 3, N'The chain rule clicked for me too after using the AI helper!');

GO

-- =============================================
-- 2. STUDY ROOM EXTENSIONS
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StudyRooms') AND name = 'Status')
BEGIN
    ALTER TABLE StudyRooms ADD Status NVARCHAR(10) DEFAULT 'OPEN';
END
GO

-- Set default status for existing rooms
UPDATE StudyRooms SET Status = 'OPEN' WHERE Status IS NULL;
GO

-- Table: RoomMembers
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RoomMembers' AND xtype='U')
CREATE TABLE RoomMembers (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    RoomID INT NOT NULL,
    UserID INT NOT NULL,
    Role NVARCHAR(10) DEFAULT 'member',      -- 'host' or 'member'
    JoinedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT UQ_RoomMembers_RoomUser UNIQUE (RoomID, UserID)
);
GO

-- Seed RoomMembers for existing sample rooms (creators as hosts)
IF NOT EXISTS (SELECT 1 FROM RoomMembers)
BEGIN
    INSERT INTO RoomMembers (RoomID, UserID, Role)
    SELECT RoomID, CreatedBy, 'host'
    FROM StudyRooms
    WHERE CreatedBy IS NOT NULL;
END
GO

-- Table: RoomMessages
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RoomMessages')
BEGIN
    CREATE TABLE RoomMessages (
        MessageID INT IDENTITY(1,1) PRIMARY KEY,
        RoomID INT NOT NULL,
        UserID INT NOT NULL,
        DisplayName NVARCHAR(100),
        Content NVARCHAR(500) NOT NULL,
        SentAt DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (RoomID) REFERENCES StudyRooms(RoomID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
    CREATE INDEX IX_RoomMessages_RoomID ON RoomMessages(RoomID, SentAt DESC);
END
GO

-- =============================================
-- 3. GAMIFICATION TABLES
-- =============================================

-- Table: UserGamification (Focus Coins, EXP, Rank)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserGamification' AND xtype='U')
CREATE TABLE UserGamification (
    GamificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    FocusCoins INT DEFAULT 0,
    TotalExp INT DEFAULT 0,
    CurrentRank NVARCHAR(20) DEFAULT 'Unranked',
    TotalStudyMinutes INT DEFAULT 0,
    LastCoinEarnedDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Table: DailyStreaks (consecutive study days)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DailyStreaks' AND xtype='U')
CREATE TABLE DailyStreaks (
    StreakID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    CurrentStreak INT DEFAULT 0,
    LongestStreak INT DEFAULT 0,
    LastStudyDate DATE,
    StreakStartDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- =============================================
-- 4. BADGES & ACHIEVEMENTS
-- =============================================

-- Table: Badges (badge catalog)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Badges' AND xtype='U')
CREATE TABLE Badges (
    BadgeID INT IDENTITY(1,1) PRIMARY KEY,
    BadgeName NVARCHAR(100) NOT NULL,
    BadgeIcon NVARCHAR(10),
    Description NVARCHAR(500),
    BadgeType NVARCHAR(30),         -- 'streak', 'study_hours', 'challenge', 'social', 'special'
    RequirementType NVARCHAR(50),   -- 'streak_days', 'total_hours', 'challenges_completed', 'coins_earned'
    RequirementValue INT DEFAULT 0
);
GO

-- Table: UserBadges (unlocked badges)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserBadges' AND xtype='U')
CREATE TABLE UserBadges (
    UserBadgeID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    BadgeID INT NOT NULL,
    EarnedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BadgeID) REFERENCES Badges(BadgeID),
    CONSTRAINT UQ_UserBadges UNIQUE (UserID, BadgeID)
);
GO

-- =============================================
-- 5. CHALLENGES
-- =============================================

-- Table: Challenges (7-day / 30-day challenges)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Challenges' AND xtype='U')
CREATE TABLE Challenges (
    ChallengeID INT IDENTITY(1,1) PRIMARY KEY,
    ChallengeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    ChallengeType NVARCHAR(20),     -- '7day', '30day', 'custom'
    DurationDays INT NOT NULL,
    TargetMinutesPerDay INT DEFAULT 25,
    CoinReward INT DEFAULT 20,
    ExpReward INT DEFAULT 50,
    BadgeRewardID INT,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (BadgeRewardID) REFERENCES Badges(BadgeID)
);
GO

-- Table: UserChallenges (challenge progress)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserChallenges' AND xtype='U')
CREATE TABLE UserChallenges (
    UserChallengeID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ChallengeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    DaysCompleted INT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'active',  -- 'active', 'completed', 'failed', 'abandoned'
    CompletedDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ChallengeID) REFERENCES Challenges(ChallengeID)
);
GO

-- =============================================
-- 6. MYSTERY REWARDS
-- =============================================

-- Table: Rewards (mystery reward pool)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Rewards' AND xtype='U')
CREATE TABLE Rewards (
    RewardID INT IDENTITY(1,1) PRIMARY KEY,
    RewardType NVARCHAR(30) NOT NULL,   -- 'quote', 'prediction', 'fun_fact', 'bonus_coins'
    Content NVARCHAR(1000) NOT NULL,
    BonusCoins INT DEFAULT 0,
    Rarity NVARCHAR(20) DEFAULT 'common',  -- 'common', 'rare', 'epic', 'legendary'
    IsActive BIT DEFAULT 1
);
GO

-- Table: UserRewards (received rewards)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserRewards' AND xtype='U')
CREATE TABLE UserRewards (
    UserRewardID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    RewardID INT NOT NULL,
    SessionID INT,
    ReceivedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RewardID) REFERENCES Rewards(RewardID),
    FOREIGN KEY (SessionID) REFERENCES StudySessions(SessionID)
);
GO

-- =============================================
-- 7. FLASHCARDS
-- =============================================

-- Table: FlashcardDecks
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FlashcardDecks' AND xtype='U')
CREATE TABLE FlashcardDecks (
    DeckID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    DeckName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CourseID INT,
    IsPublic BIT DEFAULT 0,
    CardCount INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Table: Flashcards
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Flashcards' AND xtype='U')
CREATE TABLE Flashcards (
    CardID INT IDENTITY(1,1) PRIMARY KEY,
    DeckID INT NOT NULL,
    FrontContent NVARCHAR(1000) NOT NULL,
    BackContent NVARCHAR(1000) NOT NULL,
    CardOrder INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DeckID) REFERENCES FlashcardDecks(DeckID) ON DELETE CASCADE
);
GO

-- Table: UserFlashcardProgress (spaced repetition)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserFlashcardProgress' AND xtype='U')
CREATE TABLE UserFlashcardProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CardID INT NOT NULL,
    Difficulty INT DEFAULT 0,           -- 0=new, 1=easy, 2=medium, 3=hard
    NextReviewDate DATETIME,
    ReviewCount INT DEFAULT 0,
    LastReviewDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CardID) REFERENCES Flashcards(CardID),
    CONSTRAINT UQ_UserFlashcard UNIQUE (UserID, CardID)
);
GO

-- =============================================
-- 8. MINDMAPS
-- =============================================

-- Table: Mindmaps
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Mindmaps' AND xtype='U')
CREATE TABLE Mindmaps (
    MindmapID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    CourseID INT,
    IsPublic BIT DEFAULT 0,
    LikeCount INT DEFAULT 0,
    UseCount INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Table: MindmapNodes (tree structure)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='MindmapNodes' AND xtype='U')
CREATE TABLE MindmapNodes (
    NodeID INT IDENTITY(1,1) PRIMARY KEY,
    MindmapID INT NOT NULL,
    ParentNodeID INT,
    NodeText NVARCHAR(500) NOT NULL,
    NodeColor NVARCHAR(20),
    NodeIcon NVARCHAR(10),
    PositionX FLOAT DEFAULT 0,
    PositionY FLOAT DEFAULT 0,
    NodeOrder INT DEFAULT 0,
    FOREIGN KEY (MindmapID) REFERENCES Mindmaps(MindmapID) ON DELETE CASCADE,
    FOREIGN KEY (ParentNodeID) REFERENCES MindmapNodes(NodeID)
);
GO

-- =============================================
-- 9. SOCIAL FEATURES
-- =============================================

-- Table: PostLikes (like/unlike toggle)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PostLikes' AND xtype='U')
CREATE TABLE PostLikes (
    LikeID INT IDENTITY(1,1) PRIMARY KEY,
    PostID INT NOT NULL,
    UserID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT UQ_PostLikes UNIQUE (PostID, UserID)
);
GO

-- Table: Follows (follow/unfollow)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Follows' AND xtype='U')
CREATE TABLE Follows (
    FollowID INT IDENTITY(1,1) PRIMARY KEY,
    FollowerID INT NOT NULL,
    FollowingID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (FollowerID) REFERENCES Users(UserID),
    FOREIGN KEY (FollowingID) REFERENCES Users(UserID),
    CONSTRAINT UQ_Follows UNIQUE (FollowerID, FollowingID),
    CONSTRAINT CK_NoSelfFollow CHECK (FollowerID <> FollowingID)
);
GO

-- =============================================
-- 10. VIP TIERS
-- =============================================

-- Table: VipTiers
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='VipTiers' AND xtype='U')
CREATE TABLE VipTiers (
    TierID INT IDENTITY(1,1) PRIMARY KEY,
    TierName NVARCHAR(50) NOT NULL,
    TierIcon NVARCHAR(10),
    CoinCost INT NOT NULL,
    Description NVARCHAR(500),
    Features NVARCHAR(1000),      -- JSON string of unlocked features
    TierOrder INT DEFAULT 0
);
GO

-- Table: UserVipStatus
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserVipStatus' AND xtype='U')
CREATE TABLE UserVipStatus (
    UserVipID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    TierID INT NOT NULL,
    PurchasedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TierID) REFERENCES VipTiers(TierID)
);
GO

-- =============================================
-- 11. LEADERBOARD
-- =============================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LeaderboardMonthly' AND xtype='U')
CREATE TABLE LeaderboardMonthly (
    LeaderboardID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    MonthYear NVARCHAR(7) NOT NULL,    -- format: '2026-03'
    TotalCoinsEarned INT DEFAULT 0,
    TotalStudyMinutes INT DEFAULT 0,
    Ranking INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT UQ_Leaderboard UNIQUE (UserID, MonthYear)
);
GO

CREATE INDEX IX_Leaderboard_Month ON LeaderboardMonthly(MonthYear, TotalCoinsEarned DESC);
GO

-- =============================================
-- SAMPLE DATA: BADGES, CHALLENGES, REWARDS, VIP
-- =============================================

-- Sample Badges
INSERT INTO Badges (BadgeName, BadgeIcon, Description, BadgeType, RequirementType, RequirementValue) VALUES
(N'First Steps', N'🌱', N'Complete your first study session', 'special', 'total_sessions', 1),
(N'Early Bird', N'🐦', N'Study before 7 AM', 'special', 'special', 0),
(N'Night Owl', N'🦉', N'Study after 11 PM', 'special', 'special', 0),
(N'3-Day Streak', N'🔥', N'Maintain a 3-day study streak', 'streak', 'streak_days', 3),
(N'7-Day Warrior', N'⚔️', N'Maintain a 7-day study streak', 'streak', 'streak_days', 7),
(N'30-Day Legend', N'🏆', N'Maintain a 30-day study streak', 'streak', 'streak_days', 30),
(N'Bronze Scholar', N'🥉', N'Reach Bronze rank (10 hours)', 'study_hours', 'total_hours', 10),
(N'Silver Scholar', N'🥈', N'Reach Silver rank (50 hours)', 'study_hours', 'total_hours', 50),
(N'Gold Scholar', N'🥇', N'Reach Gold rank (100 hours)', 'study_hours', 'total_hours', 100),
(N'Coin Collector', N'💰', N'Earn 100 Focus Coins', 'special', 'coins_earned', 100),
(N'Social Butterfly', N'🦋', N'Get 10 likes on your posts', 'social', 'likes_received', 10),
(N'Flashcard Master', N'📚', N'Review 100 flashcards', 'special', 'flashcards_reviewed', 100);
GO

-- Sample Challenges
INSERT INTO Challenges (ChallengeName, Description, ChallengeType, DurationDays, TargetMinutesPerDay, CoinReward, ExpReward) VALUES
(N'7-Day Focus Sprint', N'Study at least 25 minutes every day for 7 days straight!', '7day', 7, 25, 25, 70),
(N'30-Day Marathon', N'Commit to 25 minutes of focused study every day for a whole month!', '30day', 30, 25, 100, 300),
(N'Weekend Warrior', N'Study 50 minutes each day this weekend!', 'custom', 2, 50, 15, 30),
(N'Early Riser Week', N'Complete a study session before 8 AM for 7 days!', '7day', 7, 25, 30, 80),
(N'Deep Focus Challenge', N'Complete 5 Pomodoro sessions (25 min each) in one day!', 'custom', 1, 125, 20, 50);
GO

-- Sample Rewards (Mystery Box content)
INSERT INTO Rewards (RewardType, Content, BonusCoins, Rarity) VALUES
-- Motivational Quotes
('quote', N'Hey! The focus you''re putting in right now is about to pay off. In exactly 30 days, you will have unlocked a powerful new skill!', 0, 'common'),
('quote', N'"A drop of water wears through rock, not by force, but by persistence." — You are doing exactly that!', 0, 'common'),
('quote', N'Every study session is a brick. Today you just laid another one on the road to success!', 0, 'common'),
('quote', N'Your knowledge portfolio is growing with compound interest. Don''t stop — your future self will thank you!', 0, 'common'),
('quote', N'You just outperformed 80% of people who gave up today. Thank you for staying!', 0, 'common'),
-- Future Predictions
('prediction', N'🔮 Message from the future: In 30 days you won''t just remember this material — you''ll be able to teach it to others!', 0, 'rare'),
('prediction', N'🔮 A wise traveler from ahead sends word: The knowledge you just studied will appear on your next exam!', 0, 'rare'),
('prediction', N'🔮 In 14 days, you will look back and wonder: "How did I get so good?" — Just trust the process!', 0, 'rare'),
-- Fun Facts
('fun_fact', N'💡 Did you know? Your brain burns 20% of your body''s energy despite only weighing 2% of your body weight. You just burned some serious brain calories!', 0, 'common'),
('fun_fact', N'💡 Research shows: Spaced repetition improves long-term retention by 200% compared to re-reading. Try flashcards!', 0, 'common'),
('fun_fact', N'💡 The Pomodoro Technique was invented by Francesco Cirillo in 1980 using a tomato-shaped kitchen timer!', 0, 'common'),
-- Bonus Coins
('bonus_coins', N'🎉 JACKPOT! You received 3 bonus Focus Coins! Today is your lucky day!', 3, 'epic'),
('bonus_coins', N'✨ Bonus! +2 Focus Coins for your dedication!', 2, 'rare'),
('bonus_coins', N'🌟 +1 Focus Coin! Keep up the great work!', 1, 'common');
GO

-- Sample VIP Tiers
INSERT INTO VipTiers (TierName, TierIcon, CoinCost, Description, Features, TierOrder) VALUES
(N'VIP Bronze', N'🥉', 50, N'Unlock basic premium features', N'["enhanced_ai","custom_themes"]', 1),
(N'VIP Silver', N'🥈', 150, N'Access to expanded resources', N'["enhanced_ai","custom_themes","document_library","priority_rooms"]', 2),
(N'VIP Gold', N'🥇', 300, N'Full premium experience', N'["enhanced_ai","custom_themes","document_library","priority_rooms","exclusive_badges","advanced_analytics"]', 3),
(N'VIP Diamond', N'💎', 500, N'Ultimate learner package', N'["all_features","mentor_access","exclusive_challenges","custom_badges"]', 4);
GO

-- Initialize gamification for existing users
INSERT INTO UserGamification (UserID, FocusCoins, TotalExp, CurrentRank, TotalStudyMinutes)
SELECT UserID, 0, 0, 'Unranked', 0
FROM Users
WHERE UserID NOT IN (SELECT UserID FROM UserGamification);
GO

-- Initialize streaks for existing users
INSERT INTO DailyStreaks (UserID, CurrentStreak, LongestStreak)
SELECT UserID, 0, 0
FROM Users
WHERE UserID NOT IN (SELECT UserID FROM DailyStreaks);
GO

-- =============================================
-- 12. FOCUSFUND MODE TABLES
-- =============================================

-- Table: FocusFundContracts
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FocusFundContracts' AND xtype='U')
CREATE TABLE FocusFundContracts (
    ContractID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    StakeAmount FLOAT NOT NULL,
    PenaltyPercent INT DEFAULT 10,
    GoalType NVARCHAR(20) DEFAULT 'session',   -- 'session','daily','weekly'
    GoalValue INT DEFAULT 25,                   -- target minutes per day
    DurationDays INT DEFAULT 1,                 -- 1=single session, 7=week, 30=month
    StartDate DATETIME DEFAULT GETDATE(),
    EndDate DATETIME,
    DaysCompleted INT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'active',       -- active/completed/failed/cancelled
    CompletedDate DATETIME,
    BonusEarned FLOAT DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Table: FocusFundTransactions (audit trail)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FocusFundTransactions' AND xtype='U')
CREATE TABLE FocusFundTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TransactionType NVARCHAR(30) NOT NULL,      -- deposit/withdraw/penalty/stake/refund/coin_exchange/leaderboard_prize/bonus
    Amount FLOAT NOT NULL,
    BalanceAfter FLOAT DEFAULT 0,
    Description NVARCHAR(500),
    ContractID INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ContractID) REFERENCES FocusFundContracts(ContractID)
);
GO

CREATE INDEX IX_Transactions_User ON FocusFundTransactions(UserID, CreatedDate DESC);
GO

-- Table: FocusFundPool (monthly reward pool)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FocusFundPool' AND xtype='U')
CREATE TABLE FocusFundPool (
    PoolID INT IDENTITY(1,1) PRIMARY KEY,
    MonthYear NVARCHAR(7) NOT NULL UNIQUE,
    LeaderboardPool FLOAT DEFAULT 0,    -- 50% of penalties
    RevenuePool FLOAT DEFAULT 0,        -- 30% of penalties
    VipBonusPool FLOAT DEFAULT 0,       -- 20% of penalties
    TotalPenalties FLOAT DEFAULT 0,
    [Distributed] BIT DEFAULT 0
);
GO

-- Add PrizeAmount to LeaderboardMonthly
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('LeaderboardMonthly') AND name = 'PrizeAmount')
BEGIN
    ALTER TABLE LeaderboardMonthly ADD PrizeAmount FLOAT DEFAULT 0;
END
GO

CREATE INDEX IX_Contracts_User_Status ON FocusFundContracts(UserID, Status);
GO

CREATE INDEX IX_Pool_Month ON FocusFundPool(MonthYear);
GO

-- =============================================
-- 13. ENGAGEMENT FEATURES
-- =============================================

-- Table: DailyQuestTemplates (admin-defined quest catalog)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DailyQuestTemplates' AND xtype='U')
CREATE TABLE DailyQuestTemplates (
    TemplateID INT IDENTITY(1,1) PRIMARY KEY,
    QuestName NVARCHAR(200) NOT NULL,
    QuestIcon NVARCHAR(10),
    Description NVARCHAR(500),
    QuestType NVARCHAR(30) NOT NULL,    -- 'pomodoro','flashcard','post','streak','login','micro_session'
    TargetValue INT DEFAULT 1,           -- e.g., 1 pomodoro, 5 flashcards
    CoinReward INT DEFAULT 2,
    ExpReward INT DEFAULT 10,
    Difficulty NVARCHAR(10) DEFAULT 'easy',  -- easy/medium/hard
    IsActive BIT DEFAULT 1
);
GO

-- Table: UserDailyQuests (auto-assigned each day)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserDailyQuests' AND xtype='U')
CREATE TABLE UserDailyQuests (
    UserQuestID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TemplateID INT NOT NULL,
    QuestDate DATE NOT NULL,
    CurrentProgress INT DEFAULT 0,
    TargetValue INT DEFAULT 1,
    Status NVARCHAR(20) DEFAULT 'active', -- active/completed/expired
    CompletedDate DATETIME,
    CoinReward INT DEFAULT 2,
    ExpReward INT DEFAULT 10,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TemplateID) REFERENCES DailyQuestTemplates(TemplateID),
    CONSTRAINT UQ_UserDailyQuest UNIQUE (UserID, TemplateID, QuestDate)
);
GO

CREATE INDEX IX_UserDailyQuests_Date ON UserDailyQuests(UserID, QuestDate, Status);
GO

-- Table: MicroSessions ("Just 1 Minute" escalation)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='MicroSessions' AND xtype='U')
CREATE TABLE MicroSessions (
    MicroSessionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    InitialDuration INT DEFAULT 1,       -- started with 1 min
    ActualDuration INT DEFAULT 0,        -- actual minutes studied
    Escalations INT DEFAULT 0,           -- how many times user chose to continue
    StartTime DATETIME DEFAULT GETDATE(),
    EndTime DATETIME,
    Status NVARCHAR(20) DEFAULT 'active', -- active/completed/abandoned
    ConvertedToPomodoro BIT DEFAULT 0,    -- did user go full pomodoro?
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Table: StudyBuddies (1-on-1 accountability)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='StudyBuddies' AND xtype='U')
CREATE TABLE StudyBuddies (
    BuddyPairID INT IDENTITY(1,1) PRIMARY KEY,
    User1ID INT NOT NULL,
    User2ID INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'active',  -- active/ended
    CreatedDate DATETIME DEFAULT GETDATE(),
    TotalSessionsTogether INT DEFAULT 0,
    FOREIGN KEY (User1ID) REFERENCES Users(UserID),
    FOREIGN KEY (User2ID) REFERENCES Users(UserID),
    CONSTRAINT UQ_BuddyPair UNIQUE (User1ID, User2ID),
    CONSTRAINT CK_NoBuddySelf CHECK (User1ID <> User2ID)
);
GO

-- Table: BuddyActivity (when buddy studies, notify partner)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BuddyActivity' AND xtype='U')
CREATE TABLE BuddyActivity (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    BuddyPairID INT NOT NULL,
    UserID INT NOT NULL,               -- who did the activity
    ActivityType NVARCHAR(30) NOT NULL, -- 'session_start','session_complete','quest_done','streak_kept'
    Message NVARCHAR(500),
    IsRead BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BuddyPairID) REFERENCES StudyBuddies(BuddyPairID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

CREATE INDEX IX_BuddyActivity_Pair ON BuddyActivity(BuddyPairID, CreatedDate DESC);
GO

-- Table: StreakAlerts (countdown notifications)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='StreakAlerts' AND xtype='U')
CREATE TABLE StreakAlerts (
    AlertID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    AlertType NVARCHAR(30) NOT NULL,     -- 'streak_at_risk','streak_lost','streak_milestone'
    Message NVARCHAR(500),
    IsRead BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Table: UserOnboarding (tiny habits / step-by-step)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserOnboarding' AND xtype='U')
CREATE TABLE UserOnboarding (
    OnboardingID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Step1_ChooseSubject BIT DEFAULT 0,
    Step2_ReviewFlashcard BIT DEFAULT 0,
    Step3_StartMicroSession BIT DEFAULT 0,
    Step4_CompletePomodoro BIT DEFAULT 0,
    Step5_PostStatus BIT DEFAULT 0,
    IsCompleted BIT DEFAULT 0,
    CompletedDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Sample Daily Quest Templates
INSERT INTO DailyQuestTemplates (QuestName, QuestIcon, Description, QuestType, TargetValue, CoinReward, ExpReward, Difficulty) VALUES
(N'🎯 Complete 1 Pomodoro', N'🎯', N'Complete at least 1 Pomodoro session (25 minutes)', 'pomodoro', 1, 3, 15, 'easy'),
(N'📚 Review 5 Flashcards', N'📚', N'Review any 5 flashcards', 'flashcard', 5, 2, 10, 'easy'),
(N'✍️ Share Your Journey', N'✍️', N'Post 1 update about your study session today', 'post', 1, 2, 5, 'easy'),
(N'⚡ 1-Minute Micro Session', N'⚡', N'Start with "Just 1 Minute" and see how far you go!', 'micro_session', 1, 1, 5, 'easy'),
(N'🔥 Keep Your Streak', N'🔥', N'Log in and study at least 1 minute today', 'streak', 1, 2, 10, 'easy'),
(N'💪 Pomodoro Marathon', N'💪', N'Complete 3 Pomodoro sessions in a day', 'pomodoro', 3, 8, 30, 'medium'),
(N'🧠 Flashcard Master', N'🧠', N'Review 20 flashcards', 'flashcard', 20, 5, 20, 'medium'),
(N'⏰ 60-Minute Focus', N'⏰', N'Accumulate 60 total minutes of study in one day', 'pomodoro', 60, 10, 40, 'hard');
GO

-- =============================================
-- 14. NOTIFICATIONS
-- =============================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Type NVARCHAR(30) NOT NULL,       -- 'streak','badge','like','follow','quest','buddy','leaderboard','system'
    Icon NVARCHAR(10),
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(500),
    ActionUrl NVARCHAR(300),          -- where to go when clicked
    IsRead BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

CREATE INDEX IX_Notifications_User ON Notifications(UserID, IsRead, CreatedDate DESC);
GO

-- =============================================
-- 15. COURSE OWNERSHIP
-- =============================================

-- Add ownership columns to Courses
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Courses') AND name = 'CreatedBy')
    ALTER TABLE Courses ADD CreatedBy INT NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Courses') AND name = 'IsPublic')
    ALTER TABLE Courses ADD IsPublic BIT DEFAULT 1;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Courses') AND name = 'CreatedDate')
    ALTER TABLE Courses ADD CreatedDate DATETIME DEFAULT GETDATE();
GO

-- Add FK for CreatedBy
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Courses_CreatedBy')
    ALTER TABLE Courses ADD CONSTRAINT FK_Courses_CreatedBy
        FOREIGN KEY (CreatedBy) REFERENCES Users(UserID) ON DELETE SET NULL;
GO

CREATE INDEX IX_Courses_CreatedBy ON Courses(CreatedBy);
GO

-- Set defaults for existing rows
UPDATE Courses SET IsPublic = 1, CreatedDate = GETDATE() WHERE CreatedDate IS NULL;
GO

-- =============================================
-- 16. AI CHAT HISTORY
-- =============================================

-- Table: AIChatSessions (conversation sessions per user)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AIChatSessions' AND xtype='U')
CREATE TABLE AIChatSessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) DEFAULT N'New Chat',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

CREATE INDEX IX_AIChatSessions_User ON AIChatSessions(UserID, UpdatedAt DESC);
GO

-- Table: AIChatMessages (individual messages within a session)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AIChatMessages' AND xtype='U')
CREATE TABLE AIChatMessages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    SessionID INT NOT NULL,
    Role VARCHAR(20) NOT NULL,              -- 'user' or 'assistant'
    Content NVARCHAR(MAX),                  -- supports long AI responses
    Mode VARCHAR(30) DEFAULT 'normal',      -- 'normal', 'thinking', 'research', 'image'
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SessionID) REFERENCES AIChatSessions(SessionID) ON DELETE CASCADE
);
GO

CREATE INDEX IX_AIChatMessages_Session ON AIChatMessages(SessionID, CreatedAt ASC);
GO

-- ============================================================
-- Table: UserCourseProgress
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserCourseProgress' AND xtype='U')
CREATE TABLE UserCourseProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    CompletedLessons INT DEFAULT 0,
    TotalLessons INT DEFAULT 1,
    ProgressPercent AS (CAST(CompletedLessons AS FLOAT) / NULLIF(TotalLessons, 0) * 100) PERSISTED,
    Status NVARCHAR(20) DEFAULT 'in_progress',   -- 'in_progress', 'completed'
    StartedDate DATETIME DEFAULT GETDATE(),
    CompletedDate DATETIME NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    UNIQUE(UserID, CourseID)
);
GO

-- ============================================================
-- Table: EmailNotifications
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='EmailNotifications' AND xtype='U')
CREATE TABLE EmailNotifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Type NVARCHAR(50) NOT NULL,             -- 'streak_warning', 'challenge_complete', 'buddy_nudge'
    Subject NVARCHAR(255),
    SentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'sent',     -- 'sent', 'failed'
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO



-- =============================================
-- 16. CASCADING DELETES FOR USERS
-- =============================================
-- Automatically scans and applies ON DELETE CASCADE to all
-- UserID foreign keys, EXCEPT for community-driven content
-- (Posts, Comments, StudyRooms) which are set to SET NULL.
-- =========================================================

DECLARE @TableName NVARCHAR(256);
DECLARE @FKName NVARCHAR(256);
DECLARE @ColumnName NVARCHAR(256);

-- 1. Apply ON DELETE CASCADE to personal user data tables
DECLARE fk_cursor CURSOR FOR
SELECT t.name AS TableName, fk.name AS FKName, c.name AS ColumnName
FROM sys.foreign_keys fk
INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
WHERE fk.referenced_object_id = OBJECT_ID('Users')    
  AND fk.delete_referential_action = 0            
  AND t.name NOT IN ('Posts', 'Comments', 'RoomMessages', 'StudyRooms', 'RoomMembers', 'Courses');

OPEN fk_cursor;
FETCH NEXT FROM fk_cursor INTO @TableName, @FKName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @DropSQL NVARCHAR(MAX) = 'ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @FKName + '];';
    DECLARE @AddSQL NVARCHAR(MAX) = 'ALTER TABLE [' + @TableName + '] ADD CONSTRAINT [' + @FKName + '_Cascade] FOREIGN KEY ([' + @ColumnName + ']) REFERENCES [Users]([UserID]) ON DELETE CASCADE;';
    
    BEGIN TRY
        EXEC sp_executesql @DropSQL;
        EXEC sp_executesql @AddSQL;
    END TRY
    BEGIN CATCH END CATCH

    FETCH NEXT FROM fk_cursor INTO @TableName, @FKName, @ColumnName;
END
CLOSE fk_cursor;
DEALLOCATE fk_cursor;


-- 2. Apply ON DELETE SET NULL to community data tables
-- This ensures user-generated content remains visible anonymously
-- We must dynamically find and drop the auto-generated constraint names first.

DECLARE @DropCmd NVARCHAR(MAX);

-- For Posts
SELECT @DropCmd = 'ALTER TABLE Posts DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('Posts') AND referenced_object_id = OBJECT_ID('Users');
IF @DropCmd IS NOT NULL EXEC(@DropCmd);

ALTER TABLE Posts ALTER COLUMN UserID INT NULL;
ALTER TABLE Posts ADD CONSTRAINT FK_Posts_UserID_SetNull FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL;

-- For Comments
SET @DropCmd = NULL;
SELECT @DropCmd = 'ALTER TABLE Comments DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('Comments') AND referenced_object_id = OBJECT_ID('Users');
IF @DropCmd IS NOT NULL EXEC(@DropCmd);

ALTER TABLE Comments ALTER COLUMN UserID INT NULL;
ALTER TABLE Comments ADD CONSTRAINT FK_Comments_UserID_SetNull FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL;

-- For RoomMessages
SET @DropCmd = NULL;
SELECT @DropCmd = 'ALTER TABLE RoomMessages DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('RoomMessages') AND referenced_object_id = OBJECT_ID('Users');
IF @DropCmd IS NOT NULL EXEC(@DropCmd);

ALTER TABLE RoomMessages ALTER COLUMN UserID INT NULL;
ALTER TABLE RoomMessages ADD CONSTRAINT FK_RoomMessages_UserID_SetNull FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL;

-- For StudyRooms
SET @DropCmd = NULL;
SELECT @DropCmd = 'ALTER TABLE StudyRooms DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('StudyRooms') AND referenced_object_id = OBJECT_ID('Users');
IF @DropCmd IS NOT NULL EXEC(@DropCmd);

ALTER TABLE StudyRooms ALTER COLUMN CreatedBy INT NULL;
ALTER TABLE StudyRooms ADD CONSTRAINT FK_StudyRooms_CreatedBy_SetNull FOREIGN KEY (CreatedBy) REFERENCES Users(UserID) ON DELETE SET NULL;

-- For RoomMembers
SET @DropCmd = NULL;
SELECT @DropCmd = 'ALTER TABLE RoomMembers DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('RoomMembers') AND referenced_object_id = OBJECT_ID('Users');
IF @DropCmd IS NOT NULL EXEC(@DropCmd);

ALTER TABLE RoomMembers ALTER COLUMN UserID INT NULL;
ALTER TABLE RoomMembers ADD CONSTRAINT FK_RoomMembers_UserID_SetNull FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL;
GO

-- =============================================
-- AUTH COLUMNS (for OTP & Session features)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'IsActive')
    ALTER TABLE Users ADD IsActive BIT NOT NULL DEFAULT 1;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'LastLogin')
    ALTER TABLE Users ADD LastLogin DATETIME;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'RememberToken')
    ALTER TABLE Users ADD RememberToken NVARCHAR(255);
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'OtpCode')
    ALTER TABLE Users ADD OtpCode NVARCHAR(10);
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'OtpExpiry')
    ALTER TABLE Users ADD OtpExpiry DATETIME;
GO

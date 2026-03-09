package service;

import dao.UserDAO;
import model.User;
import java.util.List;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAO();
    }

    @Override
    public User login(String username, String password) {
        if (username == null || password == null)
            return null;
        return userDAO.login(username.toLowerCase(), password);
    }

    @Override
    public boolean register(String username, String password, String fullName, String email) {
        if (username == null || username.trim().isEmpty()) {
            throw new ValidationException("Username cannot be empty");
        }

        username = username.toLowerCase();

        if (password == null || password.trim().isEmpty() || password.length() < 8) {
            throw new ValidationException("Password must be at least 8 characters");
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            throw new ValidationException("Valid email is required");
        }
        if (userDAO.findByUsername(username) != null) {
            throw new ValidationException("Username already exists");
        }
        if (userDAO.findByEmail(email) != null) {
            throw new ValidationException("Email already registered");
        }
        return userDAO.register(username, password, fullName, email);
    }

    @Override
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    @Override
    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    @Override
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public boolean updateProfile(int userId, String fullName, String username, String email,
            String bio, String location, String website, String websiteName) {
        return userDAO.updateProfile(userId, fullName, username, email, bio, location, website, websiteName);
    }

    @Override
    public boolean updatePassword(int userId, String newPassword) {
        if (newPassword == null || newPassword.length() < 4) {
            throw new ValidationException("Password must be at least 4 characters");
        }
        return userDAO.updatePassword(userId, newPassword);
    }

    @Override
    public boolean updateProfileImage(int userId, String imageUrl) {
        return userDAO.updateProfileImage(userId, imageUrl);
    }

    @Override
    public boolean updateBalance(int userId, double amount) {
        return userDAO.updateBalance(userId, amount);
    }

    @Override
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }
}

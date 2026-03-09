package service;

import model.User;
import java.util.List;

public interface UserService {
    User login(String username, String password);

    boolean register(String username, String password, String fullName, String email);

    User getUserById(int userId);

    User findByUsername(String username);

    User findByEmail(String email);

    List<User> getAllUsers();

    boolean updateProfile(int userId, String fullName, String username, String email,
            String bio, String location, String website, String websiteName);

    boolean updatePassword(int userId, String newPassword);

    boolean updateProfileImage(int userId, String imageUrl);

    boolean updateBalance(int userId, double amount);

    boolean deleteUser(int userId);
}

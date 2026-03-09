package service;

import dao.PostDAO;
import model.Post;
import java.util.List;

public class PostServiceImpl implements PostService {

    private final PostDAO postDAO;

    public PostServiceImpl() {
        this.postDAO = new PostDAO();
    }

    @Override
    public boolean createPost(int userId, String content, String imageURL) {
        if (content == null || content.trim().isEmpty()) {
            throw new ValidationException("Post content cannot be empty");
        }
        return postDAO.createPost(userId, content, imageURL);
    }

    @Override
    public List<Post> getAllPosts() {
        return postDAO.getAllPosts();
    }

    @Override
    public List<Post> getPostsByUser(int userId) {
        return postDAO.getPostsByUser(userId);
    }

    @Override
    public Post getPostById(int postId) {
        return postDAO.getPostById(postId);
    }

    @Override
    public boolean updateLikeCount(int postId, int increment) {
        return postDAO.updateLikeCount(postId, increment);
    }

    @Override
    public boolean toggleLike(int postId, int userId) {
        return postDAO.toggleLike(postId, userId);
    }
}

package service;

import model.Post;
import java.util.List;

public interface PostService {
    boolean createPost(int userId, String content, String imageURL);

    List<Post> getAllPosts();

    List<Post> getPostsByUser(int userId);

    Post getPostById(int postId);

    boolean updateLikeCount(int postId, int increment);

    boolean toggleLike(int postId, int userId);
}

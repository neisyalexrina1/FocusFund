package service;

import model.Comment;
import java.util.List;

public interface CommentService {
    boolean createComment(int postId, int userId, String content);

    List<Comment> getCommentsByPost(int postId);
}

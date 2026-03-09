package service;

import dao.CommentDAO;
import dao.PostDAO;
import model.Comment;
import java.util.List;

public class CommentServiceImpl implements CommentService {

    private final CommentDAO commentDAO;
    private final PostDAO postDAO;

    public CommentServiceImpl() {
        this.commentDAO = new CommentDAO();
        this.postDAO = new PostDAO();
    }

    @Override
    public boolean createComment(int postId, int userId, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new ValidationException("Comment cannot be empty");
        }
        boolean created = commentDAO.createComment(postId, userId, content);
        if (created) {
            postDAO.incrementCommentCount(postId);
        }
        return created;
    }

    @Override
    public List<Comment> getCommentsByPost(int postId) {
        return commentDAO.getCommentsByPost(postId);
    }
}

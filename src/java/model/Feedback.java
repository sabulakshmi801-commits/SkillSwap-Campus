package model;

public class Feedback {
    private int    feedbackId;
    private int    sessionId;
    private int    reviewerId;
    private int    revieweeId;
    private int    rating;
    private String comments;
    private String createdAt;
    private String reviewerName;
    private String reviewerPhoto;

    public Feedback() {}

    public int    getFeedbackId()      { return feedbackId; }
    public void   setFeedbackId(int v) { feedbackId = v; }

    public int    getSessionId()      { return sessionId; }
    public void   setSessionId(int v) { sessionId = v; }

    public int    getReviewerId()     { return reviewerId; }
    public void   setReviewerId(int v){ reviewerId = v; }

    public int    getRevieweeId()     { return revieweeId; }
    public void   setRevieweeId(int v){ revieweeId = v; }

    public int    getRating()     { return rating; }
    public void   setRating(int v){ rating = v; }

    public String getComments()        { return comments; }
    public void   setComments(String v){ comments = v; }

    public String getCreatedAt()        { return createdAt; }
    public void   setCreatedAt(String v){ createdAt = v; }

    public String getReviewerName()        { return reviewerName; }
    public void   setReviewerName(String v){ reviewerName = v; }

    public String getReviewerPhoto()        { return reviewerPhoto; }
    public void   setReviewerPhoto(String v){ reviewerPhoto = v; }
}

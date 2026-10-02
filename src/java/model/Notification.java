package model;

public class Notification {
    private int    notificationId;
    private int    userId;
    private String title;
    private String message;
    private String type;
    private int    referenceId;
    private boolean isRead;
    private String createdAt;

    public Notification() {}

    public int    getNotificationId()      { return notificationId; }
    public void   setNotificationId(int v) { notificationId = v; }

    public int    getUserId()     { return userId; }
    public void   setUserId(int v){ userId = v; }

    public String getTitle()        { return title; }
    public void   setTitle(String v){ title = v; }

    public String getMessage()        { return message; }
    public void   setMessage(String v){ message = v; }

    public String getType()        { return type; }
    public void   setType(String v){ type = v; }

    public int    getReferenceId()      { return referenceId; }
    public void   setReferenceId(int v) { referenceId = v; }

    public boolean isRead()          { return isRead; }
    public void    setRead(boolean v){ isRead = v; }

    public String getCreatedAt()        { return createdAt; }
    public void   setCreatedAt(String v){ createdAt = v; }
}

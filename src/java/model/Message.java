package model;

public class Message {
    private int    messageId;
    private int    senderId;
    private int    receiverId;
    private String message;
    private boolean isRead;
    private String sentTime;
    private String senderName;
    private String receiverName;
    private String senderPhoto;

    public Message() {}

    public int    getMessageId()      { return messageId; }
    public void   setMessageId(int v) { messageId = v; }

    public int    getSenderId()       { return senderId; }
    public void   setSenderId(int v)  { senderId = v; }

    public int    getReceiverId()     { return receiverId; }
    public void   setReceiverId(int v){ receiverId = v; }

    public String getMessage()        { return message; }
    public void   setMessage(String v){ message = v; }

    public boolean isRead()          { return isRead; }
    public void    setRead(boolean v){ isRead = v; }

    public String getSentTime()        { return sentTime; }
    public void   setSentTime(String v){ sentTime = v; }

    public String getSenderName()        { return senderName; }
    public void   setSenderName(String v){ senderName = v; }

    public String getReceiverName()        { return receiverName; }
    public void   setReceiverName(String v){ receiverName = v; }

    public String getSenderPhoto()        { return senderPhoto; }
    public void   setSenderPhoto(String v){ senderPhoto = v; }
}

package model;

public class LearningSession {
    private int    sessionId;
    private int    mentorId;
    private int    learnerId;
    private int    skillId;
    private String skillName;
    private String sessionDate;
    private String sessionTime;
    private String sessionType;
    private String sessionMode;
    private String status;
    private String notes;
    private String createdAt;
    // joined
    private String mentorName;
    private String learnerName;
    private String mentorPhoto;
    private String learnerPhoto;

    public LearningSession() {}

    public int    getSessionId()      { return sessionId; }
    public void   setSessionId(int v) { sessionId = v; }

    public int    getMentorId()       { return mentorId; }
    public void   setMentorId(int v)  { mentorId = v; }

    public int    getLearnerId()      { return learnerId; }
    public void   setLearnerId(int v) { learnerId = v; }

    public int    getSkillId()        { return skillId; }
    public void   setSkillId(int v)   { skillId = v; }

    public String getSkillName()        { return skillName; }
    public void   setSkillName(String v){ skillName = v; }

    public String getSessionDate()        { return sessionDate; }
    public void   setSessionDate(String v){ sessionDate = v; }

    public String getSessionTime()        { return sessionTime; }
    public void   setSessionTime(String v){ sessionTime = v; }

    public String getSessionType()        { return sessionType; }
    public void   setSessionType(String v){ sessionType = v; }

    public String getSessionMode()        { return sessionMode; }
    public void   setSessionMode(String v){ sessionMode = v; }

    public String getStatus()        { return status; }
    public void   setStatus(String v){ status = v; }

    public String getNotes()        { return notes; }
    public void   setNotes(String v){ notes = v; }

    public String getCreatedAt()        { return createdAt; }
    public void   setCreatedAt(String v){ createdAt = v; }

    public String getMentorName()        { return mentorName; }
    public void   setMentorName(String v){ mentorName = v; }

    public String getLearnerName()        { return learnerName; }
    public void   setLearnerName(String v){ learnerName = v; }

    public String getMentorPhoto()        { return mentorPhoto; }
    public void   setMentorPhoto(String v){ mentorPhoto = v; }

    public String getLearnerPhoto()        { return learnerPhoto; }
    public void   setLearnerPhoto(String v){ learnerPhoto = v; }
}

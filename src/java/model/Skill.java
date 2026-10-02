package model;

public class Skill {
    private int    skillId;
    private int    userId;
    private String skillName;
    private String category;
    private String description;
    private String experienceLevel;
    private String availability;
    private boolean isActive;
    // joined fields
    private String userName;
    private String userDepartment;
    private String profilePhoto;
    private double avgRating;

    public Skill() {}

    public int    getSkillId()        { return skillId; }
    public void   setSkillId(int v)   { skillId = v; }

    public int    getUserId()         { return userId; }
    public void   setUserId(int v)    { userId = v; }

    public String getSkillName()        { return skillName; }
    public void   setSkillName(String v){ skillName = v; }

    public String getCategory()        { return category; }
    public void   setCategory(String v){ category = v; }

    public String getDescription()        { return description; }
    public void   setDescription(String v){ description = v; }

    public String getExperienceLevel()        { return experienceLevel; }
    public void   setExperienceLevel(String v){ experienceLevel = v; }

    public String getAvailability()        { return availability; }
    public void   setAvailability(String v){ availability = v; }

    public boolean isActive()          { return isActive; }
    public void    setActive(boolean v){ isActive = v; }

    public String getUserName()        { return userName; }
    public void   setUserName(String v){ userName = v; }

    public String getUserDepartment()        { return userDepartment; }
    public void   setUserDepartment(String v){ userDepartment = v; }

    public String getProfilePhoto()        { return profilePhoto; }
    public void   setProfilePhoto(String v){ profilePhoto = v; }

    public double getAvgRating()        { return avgRating; }
    public void   setAvgRating(double v){ avgRating = v; }
}

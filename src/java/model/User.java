package model;

public class User {
    private int    userId;
    private String name;
    private String email;
    private String password;
    private String role;
    private String department;
    private String bio;
    private String profilePhoto;
    private double avgRating;
    private int    totalSessions;
    private boolean isActive;

    public User() {}

    public int    getUserId()       { return userId; }
    public void   setUserId(int v)  { userId = v; }

    public String getName()         { return name; }
    public void   setName(String v) { name = v; }

    public String getEmail()           { return email; }
    public void   setEmail(String v)   { email = v; }

    public String getPassword()        { return password; }
    public void   setPassword(String v){ password = v; }

    public String getRole()            { return role; }
    public void   setRole(String v)    { role = v; }

    public String getDepartment()        { return department; }
    public void   setDepartment(String v){ department = v; }

    public String getBio()         { return bio; }
    public void   setBio(String v) { bio = v; }

    public String getProfilePhoto()        { return profilePhoto; }
    public void   setProfilePhoto(String v){ profilePhoto = v; }

    public double getAvgRating()       { return avgRating; }
    public void   setAvgRating(double v){ avgRating = v; }

    public int  getTotalSessions()      { return totalSessions; }
    public void setTotalSessions(int v) { totalSessions = v; }

    public boolean isActive()          { return isActive; }
    public void    setActive(boolean v){ isActive = v; }
}

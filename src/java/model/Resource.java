package model;

public class Resource {
    private int    resourceId;
    private int    userId;
    private int    skillId;
    private String title;
    private String fileName;
    private String fileType;
    private long   fileSize;
    private String filePath;
    private String description;
    private String category;
    private int    downloadCount;
    private String uploadDate;
    private String uploaderName;

    public Resource() {}

    public int    getResourceId()      { return resourceId; }
    public void   setResourceId(int v) { resourceId = v; }

    public int    getUserId()     { return userId; }
    public void   setUserId(int v){ userId = v; }

    public int    getSkillId()     { return skillId; }
    public void   setSkillId(int v){ skillId = v; }

    public String getTitle()        { return title; }
    public void   setTitle(String v){ title = v; }

    public String getFileName()        { return fileName; }
    public void   setFileName(String v){ fileName = v; }

    public String getFileType()        { return fileType; }
    public void   setFileType(String v){ fileType = v; }

    public long   getFileSize()       { return fileSize; }
    public void   setFileSize(long v) { fileSize = v; }

    public String getFilePath()        { return filePath; }
    public void   setFilePath(String v){ filePath = v; }

    public String getDescription()        { return description; }
    public void   setDescription(String v){ description = v; }

    public String getCategory()        { return category; }
    public void   setCategory(String v){ category = v; }

    public int    getDownloadCount()      { return downloadCount; }
    public void   setDownloadCount(int v) { downloadCount = v; }

    public String getUploadDate()        { return uploadDate; }
    public void   setUploadDate(String v){ uploadDate = v; }

    public String getUploaderName()        { return uploaderName; }
    public void   setUploaderName(String v){ uploaderName = v; }
}

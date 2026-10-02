package utility;

/**
 * Builds consistent profile photo URLs for JSP pages (explore, chat, profile, etc.).
 */
public class PhotoUtil {

    private PhotoUtil() {}

    public static boolean hasPhoto(String profilePhoto) {
        return profilePhoto != null && !profilePhoto.trim().isEmpty()
                && !"default.png".equalsIgnoreCase(profilePhoto.trim());
    }

    public static String getPhotoUrl(String contextPath, String profilePhoto) {
        if (!hasPhoto(profilePhoto)) return null;
        String p = profilePhoto.replace('\\', '/').trim();
        while (p.startsWith("uploads/")) {
            p = p.substring("uploads/".length());
        }
        return contextPath + "/uploads/" + p;
    }
}

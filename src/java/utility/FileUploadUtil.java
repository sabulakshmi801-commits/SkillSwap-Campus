package utility;

import javax.servlet.ServletContext;
import java.io.File;

/**
 * Stores uploads outside the exploded WAR so files survive redeploy and Tomcat restarts.
 * Default: {catalina.base}/skillswap_uploads
 */
public class FileUploadUtil {

    private FileUploadUtil() {}

    public static File getUploadRoot(ServletContext ctx) {
        String configured = ctx.getInitParameter("uploadBaseDir");
        if (configured != null && !configured.trim().isEmpty()) {
            File dir = new File(configured.trim());
            if (!dir.exists()) dir.mkdirs();
            return dir;
        }
        String catalina = System.getProperty("catalina.base");
        File root = (catalina != null)
                ? new File(catalina, "skillswap_uploads")
                : new File(ctx.getRealPath("/"), "uploads");
        if (!root.exists()) root.mkdirs();
        return root;
    }

    public static File resolveStoredFile(ServletContext ctx, String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) return null;
        String clean = relativePath.replace('\\', '/').trim();
        if (clean.contains("..")) return null;

        File root = getUploadRoot(ctx).getAbsoluteFile();
        File target = new File(root, clean);
        try {
            if (!target.getCanonicalFile().toPath().startsWith(root.getCanonicalFile().toPath())) {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
        if (target.isFile()) return target;

        String webRoot = ctx.getRealPath("/");
        if (webRoot != null) {
            File legacy = new File(webRoot, "uploads" + File.separator + clean.replace('/', File.separatorChar));
            if (legacy.isFile()) return legacy;
        }
        return null;
    }
}

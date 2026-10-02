package utility;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;
import java.io.InputStream;
import java.util.Properties;

/**
 * Sends verification emails via SMTP.
 * Configure web/WEB-INF/email.properties (see email.properties.example).
 */
public class EmailUtil {

    private EmailUtil() {}

    private static Properties loadConfig(ServletContext ctx) {
        Properties p = new Properties();
        try (InputStream in = ctx.getResourceAsStream("/WEB-INF/email.properties")) {
            if (in != null) p.load(in);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    public static boolean isConfigured(ServletContext ctx) {
        Properties cfg = loadConfig(ctx);
        String host = cfg.getProperty("mail.smtp.host", "").trim();
        String user = cfg.getProperty("mail.smtp.user", "").trim();
        String pass = cfg.getProperty("mail.smtp.password", "").trim();
        return !host.isEmpty() && !user.isEmpty() && !pass.isEmpty()
                && !user.contains("your-email") && !pass.contains("your-app");
    }

    public static boolean send(ServletContext ctx, String to, String subject, String body) {
        if (to == null || to.trim().isEmpty()) return false;

        Properties cfg = loadConfig(ctx);
        String host = cfg.getProperty("mail.smtp.host", "").trim();
        String user = cfg.getProperty("mail.smtp.user", "").trim();
        String pass = cfg.getProperty("mail.smtp.password", "").trim();
        String from = cfg.getProperty("mail.from", user).trim();
        String port = cfg.getProperty("mail.smtp.port", "587").trim();
        String tls  = cfg.getProperty("mail.smtp.starttls.enable", "true").trim();

        if (!isConfigured(ctx)) {
            System.err.println("[EmailUtil] Missing or incomplete WEB-INF/email.properties");
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.starttls.enable", tls);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, pass);
                }
            });

            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "SkillSwap Campus"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to.trim()));
            msg.setSubject(subject, "UTF-8");
            msg.setText(body, "UTF-8");

            Transport.send(msg);
            System.out.println("[EmailUtil] Sent \"" + subject + "\" to " + to);
            return true;
        } catch (Exception e) {
            System.err.println("[EmailUtil] Failed to send to " + to + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static String maskEmail(String email) {
        if (email == null || !email.contains("@")) return "your registered email";
        int at = email.indexOf('@');
        String local = email.substring(0, at);
        String domain = email.substring(at);
        if (local.length() <= 2) return "**" + domain;
        return local.charAt(0) + "***" + local.charAt(local.length() - 1) + domain;
    }
}

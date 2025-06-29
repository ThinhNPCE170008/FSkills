package util;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class Iconstant {

    public static final String GOOGLE_CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");

    public static final String GOOGLE_CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");

    // public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/FSkills/login";
    public static final String GOOGLE_REDIRECT_URI = "https://fskills.onrender.com/login";

    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
}

package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import model.User;
import model.UserGoogle;
import util.GoogleLogin;
import util.RoleRedirect;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
@WebServlet(name = "Login", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String code = request.getParameter("code");

        if (code != null) {
            GoogleLogin googleLogin = new GoogleLogin();
            String accessToken = googleLogin.getToken(code);

            UserGoogle userGoogle = googleLogin.getUserInfo(accessToken);

            UserDAO dao = new UserDAO();
            User user = dao.findByGoogleID(userGoogle.getId());

            if (user == null) {
                user = dao.findByEmail(userGoogle.getEmail());
                if (user == null) {
                    dao.insertGoogle(userGoogle);
                    user = dao.findByGoogleID(userGoogle.getId()); // Lấy lại user đã insert để lưu vào session
                } else {
                    user.setGoogleID(userGoogle.getId());
                    dao.updateGoogleID(user);
                }
            }

            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole().toString());
            RoleRedirect.redirect(user, response);
        } else {
            String token = null;
            String usernameCookieSaved = "";
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("REMEMBER_TOKEN")) {
                        token = cookie.getValue();
                    }
                    if (cookie.getName().equals("COOKIE_INPUT")) {
                        usernameCookieSaved = cookie.getValue();
                    }
                }
            }

            if (token != null) {
                try {
                    UserDAO dao = new UserDAO();
                    User user = dao.findByToken(token);
                    if (user != null) {
                        session.setAttribute("user", user);
                        session.setAttribute("role", user.getRole().toString());
                        RoleRedirect.redirect(user, response);
                        return;
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }

//            String turnstileSiteKey = "0x4AAAAAABgts3i36HFv5My10x4AAAAAABgts3i36HFv5My1";
//            request.setAttribute("turnstileSiteKey", turnstileSiteKey);

            request.setAttribute("usernameCookieSaved", usernameCookieSaved);
//            request.setAttribute("turnstileSiteKey", turnstileSiteKey);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String turnstileToken = request.getParameter("cf-turnstile-response");
        if (turnstileToken == null || turnstileToken.isEmpty()) {
            request.setAttribute("err", "Login failed: Captcha verification failed!!!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String secretKey = "0x4AAAAAABgts4-8Q8nhLD8g5wGXEaXXDT4";
//        String secretKey = System.getenv("CLOUDFLARE_SECRET_KEY");
        URL url = new URL("https://challenges.cloudflare.com/turnstile/v0/siteverify");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String postData = "secret=" + URLEncoder.encode(secretKey, "UTF-8")
                + "&response=" + URLEncoder.encode(turnstileToken, "UTF-8");

        try ( OutputStream os = conn.getOutputStream()) {
            os.write(postData.getBytes());
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        StringBuilder responseStr = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            responseStr.append(inputLine);
        }
        in.close();

        JsonObject json = JsonParser.parseString(responseStr.toString()).getAsJsonObject();

        boolean success = json.get("success").getAsBoolean();
        if (!success) {
            String errorMsg = "Captcha verification failed!!!";
            if (json.has("error-codes")) {
                errorMsg += " Error codes: " + json.get("error-codes").toString();
            }
            request.setAttribute("err", "Login failed: " + errorMsg);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (request.getMethod().equalsIgnoreCase("POST")) {
            UserDAO dao = new UserDAO();
            HttpSession session = request.getSession();

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe");

            User user = dao.verifyMD5(username, password);

            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole().toString());

                if ("on".equalsIgnoreCase(rememberMe)) {
                    try {
                        String token = UUID.randomUUID().toString();
                        Timestamp expiryDate = Timestamp.from(Instant.now().plus(30, ChronoUnit.DAYS));
                        dao.saveToken(user.getUserId(), token, expiryDate);

                        Cookie tokenCookie = new Cookie("REMEMBER_TOKEN", token);
                        tokenCookie.setMaxAge(30 * 24 * 60 * 60); // 30 ngày
                        tokenCookie.setPath("/");
                        tokenCookie.setHttpOnly(true);
                        tokenCookie.setSecure(true);
                        response.addCookie(tokenCookie);

                        Cookie usernameCookie = new Cookie("COOKIE_INPUT", username);
                        usernameCookie.setMaxAge(30 * 24 * 60 * 60);
                        usernameCookie.setPath("/");
                        usernameCookie.setHttpOnly(true);
                        usernameCookie.setSecure(true);
                        response.addCookie(usernameCookie);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }

                RoleRedirect.redirect(user, response);
            } else {
                request.setAttribute("err", "Login failed: The user or password are wrong!!!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

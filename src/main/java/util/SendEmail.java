package util;

import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

/**
 *
 * @author NgoThinh1902
 */
public class SendEmail {

    public boolean sendEmailNormal(String toEmail, String message, String title) {
        Email from = new Email("noreply@fskills.website");
        Email to = new Email(toEmail);

        Content content = new Content("text/html", message);
        Mail email = new Mail(from, title, to, content);

        SendGrid sg = new SendGrid(System.getenv("SENDGRID_API_KEY"));

        Request req = new Request();

        try {
            req.setMethod(Method.POST);
            req.setEndpoint("mail/send");
            req.setBody(email.build());

            Response res = sg.api(req);

            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean sendByEmail(String toEmail, String message, String title) {
        Email from = new Email("noreply@fskills.website");
        Email to = new Email(toEmail);

        Content content = new Content("text/html", message);
        Mail email = new Mail(from, title, to, content);

        SendGrid sg = new SendGrid(System.getenv("SENDGRID_API_KEY"));

        Request req = new Request();

        try {
            req.setMethod(Method.POST);
            req.setEndpoint("mail/send");
            req.setBody(email.build());

            Response res = sg.api(req);

            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mail;

namespace WatchUs.Common.Utility
{
    public class EmailHelper
    {
        public void sendEmailViaWebApi(string subject, string body, string sender)
        {
            //string subject = subject;
            //string body = "Email body";
            string FromMail = "postmaster@redtopdev.com";
            string emailTo = "redtop.feedbacks@gmail.com";
            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
            SmtpClient SmtpServer = new SmtpClient("mail.redtopdev.com");
            mail.From = new MailAddress(FromMail);
            mail.To.Add(emailTo);
            mail.Subject = "Received feedback from " + sender + ". Category: " + subject;
            mail.Body = body;
            SmtpServer.Port = 8889; // 25;
            SmtpServer.Credentials = new System.Net.NetworkCredential("postmaster@redtopdev.com", "Password1");
            SmtpServer.EnableSsl = false;
            SmtpServer.Send(mail);
        }
    }
}

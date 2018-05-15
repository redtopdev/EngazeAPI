using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Specialized;
using System.Web;
using WatchUs.Model;


namespace WatchUs.Common.Utility
{
    public class SMSHelper
    {
        public static string getEventInviteMessage(string eventName, string hostName)
        {
            string messageText = ConfigurationManager.AppSettings["EventSMSFormat"].ToString();
            messageText = messageText.Replace("$eventName$", eventName).Replace("$hostName$", hostName);
            return messageText;
        }

        public static Boolean sendSMS_Deprecated(string senderID, string recipientNumber, string messageText)
        {
            try
            {
                Boolean smsGatewayEnabled = Boolean.Parse(ConfigurationManager.AppSettings["SMSGatewayEnabled"].ToString()); 

                //string strUrl = "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shyamsk1983@hotmail.com:india123&senderID=" + senderID + "&receipientno=" + recipientNumber + "&msgtxt=" + messageText + "&state=4";
                if (!smsGatewayEnabled)
                {
                    return true;
                }

                string strUrl = ConfigurationManager.AppSettings["MVayooSMSApiUrl"];
                strUrl = strUrl.Replace("$senderID$", senderID).Replace("$recipientNumber$", recipientNumber).Replace("$messageText$", messageText);

                WebRequest request = HttpWebRequest.Create(strUrl);
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                Stream s = (Stream)response.GetResponseStream();
                StreamReader readStream = new StreamReader(s);
                string dataString = readStream.ReadToEnd();
                response.Close();
                s.Close();
                readStream.Close();

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

   

        public static MethodResult sendSMSGeneric(string countryCode, string contactNumber, int MessageTye, string OTP, string hostname, string eventName)
        { 
            switch(MessageTye)
            {
                case 0:
                    return sendSMSEventInviteViaTextLocal(countryCode, contactNumber, hostname, eventName);

                case 1:
                    return sendSMSOTPViaTextLocal(countryCode, contactNumber, OTP);

                default :
                    return new MethodResult() { Status=false,Message="Unknown SMS Category."};

            }
        }

        public static MethodResult sendSMSEventInviteViaTextLocal(string countryCode, string contactNumber, string hostname, string eventName)
        {
            Boolean smsInviteEnabled = Boolean.Parse(ConfigurationManager.AppSettings["SMSInviteEnabled"].ToString());
            MethodResult mr = new MethodResult();

            if (!smsInviteEnabled)
            {
                mr.Status = false;
                mr.Message = "Sms Invite is Disabled in Web API.";
                return mr;
            }
            String textLocalMessage = ConfigurationManager.AppSettings["TextLocalSMSEventInviteTemplate1"].ToString();
            if (hostname.Length > 20)
            {
                hostname = hostname.Substring(0, 20);
            }
            textLocalMessage = textLocalMessage.Replace("$hostName$", hostname);
            textLocalMessage = textLocalMessage.Replace("$eventName$", eventName);
            return sendSMSViaTextLocalGeneric(countryCode, contactNumber, textLocalMessage);
        }

        public static MethodResult sendSMSOTPViaTextLocal(string countryCode, string contactNumber, string message)
        {

            String textLocalMessage = ConfigurationManager.AppSettings["TextLocalOtpMessageTemplate1"].ToString();
            textLocalMessage = textLocalMessage.Replace("$OtpText$", message);
            return sendSMSViaTextLocalGeneric(countryCode, contactNumber, textLocalMessage);

            //Boolean smsGatewayEnabled = Boolean.Parse(ConfigurationManager.AppSettings["SMSGatewayEnabled"].ToString());
            //String countryCodesAllowedForSMS = ConfigurationManager.AppSettings["CountryCodesAllowedForSMS"].ToString();

            //MethodResult mr = new MethodResult();



            //if (!smsGatewayEnabled)
            //{
            //    mr.Status = false;
            //    mr.Message = "Sms Gateway is Disabled in Web API.";
            //    return mr;
            //}


            //if (countryCode.Contains("+"))
            //{
            //    countryCode = countryCode.Substring(1);
            //}
            //if (countryCodesAllowedForSMS.ToUpper().CompareTo("ALL") != 0)
            //{
            //    List<string> listCountryCodesAllowedForSMS = countryCodesAllowedForSMS.Split(",".ToCharArray()).ToList();
            //    if (!listCountryCodesAllowedForSMS.Contains(countryCode))
            //    {
            //        mr.Status = false;
            //        mr.Message = "Sms Gateway is not allowed for this country code " + countryCode;
            //        return mr;
            //    }                
            //}
            //contactNumber = countryCode + contactNumber;


            
            //String textLocalApiUrl = ConfigurationManager.AppSettings["TextLocalApiUrl"].ToString(); //"http://api.textlocal.in/send/";
            //String textLocalUsername = ConfigurationManager.AppSettings["TextLocalUsername"].ToString(); 
            //String textLocalHash = ConfigurationManager.AppSettings["TextLocalHash"].ToString(); 
            //String textLocalSender = ConfigurationManager.AppSettings["TextLocalSender"].ToString();
            //String textLocalTestFlag = ConfigurationManager.AppSettings["TextLocalTestFlag"].ToString();
            //String inviteSMSMessage = ConfigurationManager.AppSettings["InviteSMSFormat"].ToString();
            //String textLocalOtpMessageTemplate1 = ConfigurationManager.AppSettings["TextLocalOtpMessageTemplate1"].ToString();

            //textLocalOtpMessageTemplate1 = textLocalOtpMessageTemplate1.Replace("$OtpText$", message);
            //textLocalOtpMessageTemplate1 = HttpUtility.UrlEncode(textLocalOtpMessageTemplate1);

            ////String message = HttpUtility.UrlEncode(inviteSMSMessage.Replace("$senderName$",senderName)); //"Hi there. " + senderName+ " has invited you to try Coordify. Did you know that Coordify lets you locate friends on map in realtime, helping better coordinate events. Visit link to download.");
            //using (var wb = new WebClient())
            //{
            //    byte[] response = wb.UploadValues(textLocalApiUrl, new NameValueCollection()
            //    {
            //    {"username" , textLocalUsername},
            //    {"hash" , textLocalHash},
            //    {"numbers" , contactNumber},
            //    {"message" , textLocalOtpMessageTemplate1},
            //    {"sender" , textLocalSender},
            //    {"test" , textLocalTestFlag}
            //    });
            //    string result = System.Text.Encoding.UTF8.GetString(response);
            //    var res = Serializer.DeserializeFromJson<TextLocalApiResult>(result);


                
            //    if (res.status.ToLower().CompareTo("failure") == 0)
            //    {
            //        mr.Status = false;
            //        mr.Message = res.errors[0].message;
            //    }
            //    else
            //    {
            //        mr.Status = true;
            //    }

            //    return mr;
            //}

        }


        public static MethodResult sendSMSViaTextLocalGeneric(string countryCode, string contactNumber, string textLocalMessage)
        {
            Boolean smsGatewayEnabled = Boolean.Parse(ConfigurationManager.AppSettings["SMSGatewayEnabled"].ToString());
            String countryCodesAllowedForSMS = ConfigurationManager.AppSettings["CountryCodesAllowedForSMS"].ToString();

            MethodResult mr = new MethodResult();



            if (!smsGatewayEnabled)
            {
                mr.Status = false;
                mr.Message = "Sms Gateway is Disabled in Web API.";
                return mr;
            }


            if (countryCode.Contains("+"))
            {
                countryCode = countryCode.Substring(1);
            }
            if (countryCodesAllowedForSMS.ToUpper().CompareTo("ALL") != 0)
            {
                List<string> listCountryCodesAllowedForSMS = countryCodesAllowedForSMS.Split(",".ToCharArray()).ToList();
                if (!listCountryCodesAllowedForSMS.Contains(countryCode))
                {
                    mr.Status = false;
                    mr.Message = "Sms Gateway is not allowed for this country code " + countryCode;
                    return mr;
                }
            }
            contactNumber = countryCode + contactNumber;



            String textLocalApiUrl = ConfigurationManager.AppSettings["TextLocalApiUrl"].ToString(); //"http://api.textlocal.in/send/";
            String textLocalUsername = ConfigurationManager.AppSettings["TextLocalUsername"].ToString();
            String textLocalHash = ConfigurationManager.AppSettings["TextLocalHash"].ToString();
            String textLocalSender = ConfigurationManager.AppSettings["TextLocalSender"].ToString();
            String textLocalTestFlag = ConfigurationManager.AppSettings["TextLocalTestFlag"].ToString();
            String inviteSMSMessage = ConfigurationManager.AppSettings["InviteSMSFormat"].ToString();
            //String textLocalOtpMessageTemplate1 = ConfigurationManager.AppSettings["TextLocalOtpMessageTemplate1"].ToString();

            //textLocalOtpMessageTemplate1 = textLocalOtpMessageTemplate1.Replace("$OtpText$", message);
            String textLocalMessageEncoded = HttpUtility.UrlEncode(textLocalMessage);

            //String message = HttpUtility.UrlEncode(inviteSMSMessage.Replace("$senderName$",senderName)); //"Hi there. " + senderName+ " has invited you to try Coordify. Did you know that Coordify lets you locate friends on map in realtime, helping better coordinate events. Visit link to download.");
            using (var wb = new WebClient())
            {
                byte[] response = wb.UploadValues(textLocalApiUrl, new NameValueCollection()
                {
                {"username" , textLocalUsername},
                {"hash" , textLocalHash},
                {"numbers" , contactNumber},
                {"message" , textLocalMessageEncoded},
                {"sender" , textLocalSender},
                {"test" , textLocalTestFlag}
                });
                string result = System.Text.Encoding.UTF8.GetString(response);
                var res = Serializer.DeserializeFromJson<TextLocalApiResult>(result);



                if (res.status.ToLower().CompareTo("failure") == 0)
                {
                    mr.Status = false;
                    mr.Message = res.errors[0].message;
                }
                else
                {
                    mr.Status = true;
                }

                return mr;
            }

        }

    }
}

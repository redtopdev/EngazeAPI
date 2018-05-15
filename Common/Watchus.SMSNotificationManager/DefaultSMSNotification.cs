using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Interface.SMSNotification;
using WatchUs.Common.Utility;
using WatchUs.Model;

namespace Watchus.SMSNotificationManager
{
    public class DefaultSMSNotification : ISMSNotificationManager
    {

        public int sendEventInviteSMSToMultipleContacts(List<string> contactNumbers, string eventName, string hostName)
        {
            //test code
            if (contactNumbers.Count == 0)
            {
                contactNumbers.Add("919611633226");
            }
            try
            {
                foreach( string contactNumber in contactNumbers)
                {
                    //SMSHelper.sendSMS("Watchus", contactNumber, SMSHelper.getEventInviteMessage(eventName, hostName));
                    //SMSHelper.sendSMSInvite(contactNumber, hostName);
                }

                return 1;
            }
            catch (Exception)
            {
                return 0;
            }

        }

        public MethodResult sendSMSGenericAsync(string countryCode, string mobileNumber, int messageType, string otp, string hostname, string eventName)
        {
            try
            {
                //SMSHelper.sendSMS("Watchus", contactNumber, SMSHelper.getEventInviteMessage(eventName, hostName));
                new SMSNotificationTaskManager(new SMSNotificationContainer() { CountryCode = countryCode, MobileNumber = mobileNumber, MessageType = messageType, OTP = otp , HostName = hostname, EventName = eventName}).Enqueue();
                return new MethodResult() { Status = true, Message="SMS queued."};
                //return SMSHelper.sendSMSOTPViaTextLocal(CountryCode, MobileNumber, OTP);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public MethodResult sendSMSGeneric(string countryCode, string mobileNumber, int messageType, string otp, string hostname, string eventName)
        {
            try
            {
                return SMSHelper.sendSMSGeneric(countryCode, mobileNumber, messageType, otp, hostname, eventName);
            }
            catch (Exception)
            {
                throw;
            }
        }


        public Boolean sendEventInviteSMSToMultipleContactsAsync(List<EventParticipant> participants, string eventName, string hostName)
        {            
            //test code
            if (participants.Count <= 0)
            {
                return true;
            }
            try
            {
                foreach (EventParticipant ep in participants)
                {
                    new SMSNotificationTaskManager(new SMSNotificationContainer() { CountryCode = ep.CountryCode, MobileNumber = ep.MobileNumber, MessageType = 0, OTP = "", HostName = hostName, EventName = eventName }).Enqueue();                                        
                    //SMSHelper.sendSMS("Watchus", contactNumber, SMSHelper.getEventInviteMessage(eventName, hostName));
                    //SMSHelper.sendSMSEventInviteViaTextLocal(ep.CountryCode, ep.MobileNumber, hostName, eventName);
                }

                return true;
            }
            catch (Exception)
            {
                throw;                
            }
        }


        }

    }


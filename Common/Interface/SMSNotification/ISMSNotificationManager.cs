using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.SMSNotification
{
    public interface ISMSNotificationManager
    {
        int sendEventInviteSMSToMultipleContacts(List<string> contactNumbers, string eventName, string hostName);
        Boolean sendEventInviteSMSToMultipleContactsAsync(List<EventParticipant> participants, string eventName, string hostName);
        MethodResult sendSMSGenericAsync(string countryCode, string contactNumber, int messageType, string otp, string hostname, string eventName);
        MethodResult sendSMSGeneric(string countryCode, string contactNumber, int messageType, string otp, string hostname, string eventName);
    }
}

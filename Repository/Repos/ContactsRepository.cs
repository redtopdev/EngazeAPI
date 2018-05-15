using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Watchus.NotificationManager;
using Watchus.SMSNotificationManager;
using WatchUs.Common.Utility;
using WatchUs.Interface.PushNotification;
using WatchUs.Interface.Repository;
using WatchUs.Interface.SMSNotification;
using WatchUs.Model;

namespace WatchUs.Repository
{
    public class ContactsRepository : Repository, IContactsRepository
    {
        List<CountryCode> countryCodes;
        INotificationManager pushNotifier;

        #region .ctor
        /// <summary>
        /// release version repository
        /// </summary>
        /// <param name="context">the context</param>
        public ContactsRepository(WatchUsEntities context)
            : base(context)
        {
            this.countryCodes = GetCountryCodes();
        }

        #endregion

        public List<PhoneContact> GetRegisteredUsers(ContactsRequest contactsRequest)
        {
            /*if (contactsRequest.RequestorId.ToUpper() == "EBCEEBA3-A557-476D-BA21-61AFF9D73B15")
            { 
            UserAccountRepository uac = new UserAccountRepository(this.Context);
            uac.SaveFeedback(new UserFeedback() {Feedback = string.Join(",",contactsRequest.ContactList.ToArray()),UserEmailId="ajaycm90",CreatedOn=DateTime.UtcNow, FeedbackCategory="Debug",RequestorId=new Guid(contactsRequest.RequestorId )}
            );
            }*/
            List<PhoneContact> registeredContactList = new List<PhoneContact>();

            var resCode = Context.GetUserCountryCode(new Guid(contactsRequest.RequestorId));
            string initiatorCountryCode = resCode.FirstOrDefault().ToString();

            contactsRequest.ContactListFormatted = contactsRequest.ContactList.Select(c =>
            {
                return PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, new PhoneContact() { MobileNumber = c, MobileNumberStoredInRequestorPhone = c }, this.countryCodes);
            }).ToList();

            contactsRequest.ContactList.Clear();
            string req = Serializer.Serialize(contactsRequest);
            var res = Context.GetRegisteredContacts(req).FirstOrDefault();

            if(!string.IsNullOrEmpty(res))
            {
                registeredContactList = Serializer.DeserializeFromXml<List<PhoneContact>>(res.ToString()).ToList();
                registeredContactList = registeredContactList.Where(x => x.UserId.ToString().ToLower() != contactsRequest.RequestorId.ToString().ToLower() ).ToList(); 
            }

            return registeredContactList;
        }

        public String GetGcmClientIdOfUser(String userId)
        {
            return Context.GetUserGcmClientId(new Guid(userId)).FirstOrDefault().ToString(); 
            //Context.ws_UserProfile.Where(c => c.UserId.ToString().ToLower() == userId.ToLower()).Select(x => x.GCMClientId).ToString();
        }

        public String GetGcmClientIdForMobile(GcmClientIdRequest gcmClientIdRequest)
        {
            return Context.GetGcmClientIdForMobile(Serializer.Serialize(gcmClientIdRequest)).FirstOrDefault().ToString();
            //Context.ws_UserProfile.Where(c => c.UserId.ToString().ToLower() == userId.ToLower()).Select(x => x.GCMClientId).ToString();
        }

        public MethodResult InviteContact(ContactsRequest contactRequest)
        {
            this.countryCodes = GetCountryCodes();
            String contactNumber = contactRequest.ContactNumberForInvite;
            var resCode = Context.GetUserCountryCode(new Guid(contactRequest.RequestorId));
            string initiatorCountryCode = resCode.FirstOrDefault().ToString();

            EventParticipant ep = PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, new EventParticipant() { MobileNumber = contactNumber, MobileNumberStoredInRequestorPhone = contactNumber }, this.countryCodes);


            return SMSHelper.sendSMSGeneric(ep.CountryCode, ep.MobileNumber, 0, "", contactRequest.RequestorName, "");     
        }

        public MethodResult SendSMSOTP(ContactsRequest contactRequest)
        {
            String countryCode = contactRequest.CountryCodeForSMS;
            String contactNumber = contactRequest.ContactNumberForSMS;
            String message = contactRequest.MessageForSMS;

            ISMSNotificationManager smsManager = new DefaultSMSNotification();
            //return SMSHelper.sendSMSOTPViaTextLocal(countryCode, contactNumber, message);
            return smsManager.sendSMSGeneric(countryCode, contactNumber, 1, message, "", "");
        }


        public MethodResult RemindContact(RemindRequest remindRequest)
        {

            Guid requestorId = new Guid(remindRequest.RequestorId);

            var resCode = Context.GetUserCountryCode(requestorId);
            string initiatorCountryCode = resCode.FirstOrDefault().ToString();
            remindRequest.ContactNumbersForRemindFormatted = new List<PhoneContact>();

            if (remindRequest.UserIdsForRemind == null)
            {
                remindRequest.UserIdsForRemind = new List<string>();
                if (remindRequest.EventId == null)
                {
                    throw new Exception("No event or contacts specified.");
                }
            }


            if (remindRequest.UserIdsForRemind.Count>0)
            {
                remindRequest.ContactNumbersForRemindFormatted = remindRequest.UserIdsForRemind.Select(userId =>
                    {
                        //PhoneContact pc = PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, new PhoneContact() { MobileNumber = contact, MobileNumberStoredInRequestorPhone = contact }, this.countryCodes);
                        //pc.GCMClientId = GetGcmClientIdForMobile(new GcmClientIdRequest() { MobileNumber  = pc.MobileNumber, CountryCode = pc.CountryCode});
                        PhoneContact pc = new PhoneContact();
                        pc.UserId = userId;
                        pc.GCMClientId = GetGcmClientIdOfUser(userId);
                        return pc;
                    }).ToList();
            }
            else
            {
                Event currentEvent = GetEventsInternal(new EventRequest() { EventId = remindRequest.EventId.ToString(), RequestorId = remindRequest.RequestorId.ToString() }).FirstOrDefault();
                remindRequest.EventName = currentEvent.Name;
                foreach(EventParticipant user in currentEvent.UserList )
                {
                    PhoneContact pc = new PhoneContact() 
                        {   UserId = user.UserId,
                            MobileNumber = user.MobileNumber,
                            CountryCode=user.CountryCode
                        };
                    pc.GCMClientId = GetGcmClientIdOfUser(pc.UserId);
                    remindRequest.ContactNumbersForRemindFormatted.Add( pc);
                }
            }
            
            pushNotifier = new DefaultNotificationManager();
            

            MethodResult mr = new MethodResult();
            mr.Status = pushNotifier.NotifyRemindContact(remindRequest);

            return mr;

        }


    }
}

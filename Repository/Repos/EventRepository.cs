using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using Watchus.NotificationManager;
using Watchus.SMSNotificationManager;
using WatchUs.Common.Utility;
using WatchUs.Interface.PushNotification;
using WatchUs.Interface.Repository;
using WatchUs.Interface.SMSNotification;
using WatchUs.Model;

namespace WatchUs.Repository
{
    public class EventRepository : Repository, IEventRepository
    {
        
        INotificationManager pushNotifier;
        ISMSNotificationManager smsNotifier;
        List<CountryCode> countryCodes;
        #region .ctor
        /// <summary>
        /// release version repository
        /// </summary>
        /// <param name="context">the context</param>
        public EventRepository(WatchUsEntities context)
            : base(context)
        {
            this.countryCodes = GetCountryCodes();
        }

        #endregion

        public Event CreateEvent(Event evnt)
        {          
            List<EventParticipant> UnregisteredUserList = new List<EventParticipant>();
            List<EventParticipant> RegisteredTempUserList = new List<EventParticipant>();
            List<EventParticipant> additionalRegisteredUsers = new List<EventParticipant>();

            evnt = ParseUserList(evnt, ref UnregisteredUserList, ref additionalRegisteredUsers, ref RegisteredTempUserList);

            evnt.ParticipantUpdateAction = 1; //Setting action to sync.


            string eventId = Context.AddEvent(Serializer.Serialize(evnt)).SingleOrDefault().ToString().ToUpper();
            if (String.IsNullOrEmpty(eventId))
            {
                throw new Exception("Failed to create event.");
            }

            Event createdEvent = GetEventsInternal(new EventRequest() { EventId = eventId, RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyEventCreation(createdEvent);
            //send notification to initiator regarding additional registered users
            pushNotifier.NotifyAdditionalRegisteredUserInfoToHost(additionalRegisteredUsers, createdEvent);
            
            //send sms to unregistered users
            smsNotifier = new DefaultSMSNotification();
            smsNotifier.sendEventInviteSMSToMultipleContactsAsync(RegisteredTempUserList, createdEvent.Name, createdEvent.InitiatorName);

            return ClientDataHelper.suppressSensitiveData(createdEvent);
        }


        public List<Event> GetEvent(EventRequest eventRequest)
        {            
            //Return all events for user if event id is null
            List<Event> eventList = new List<Event>();
            string req = Serializer.Serialize(eventRequest);
            var objRes = Context.GetAllEventsForUser(req).FirstOrDefault();
            if (!string.IsNullOrEmpty(objRes))
            {
                string res = objRes.ToString();
                
                var resList = Serializer.DeserializeFromXml<List<Event>>(res).ToList();
                if (resList.Count > 0)
                {
                    foreach (Event ev in resList)
                    {
                        Event ev1 = AdjustRecurringEventTiming(ev);
                        if (ev1.EndTime > DateTime.UtcNow)
                        {
                            eventList.Add(ev1);
                        }
                    }
                    //eventList.AddRange(resList);
                }                
            }
            return eventList;
        }


        
        public Event EditEvent(Event evnt, Boolean updateParticipantsOnly)
        {
            Event currentEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            if (currentEvent == null)
            {
                throw new Exception("EventId not active.");
            }
            evnt.UpdateParticipantsOnly = updateParticipantsOnly;
            List<EventParticipant> UnregisteredUserList = new List<EventParticipant>();
            List<EventParticipant> RegisteredTempUserList = new List<EventParticipant>();
            List<EventParticipant> additionalRegisteredUsers = new List<EventParticipant>();
            evnt = ParseUserList(evnt, ref UnregisteredUserList, ref additionalRegisteredUsers, ref RegisteredTempUserList);

            if (!evnt.UserList.Any(x => x.UserId.ToString().ToLower() == currentEvent.InitiatorId.ToString().ToLower()))
            {
                evnt.UserList.Add(new EventParticipant() { UserId = currentEvent.InitiatorId.ToString() });
            }

            List<string> addedUserGcmList = GetAddedUserGcmList(evnt, currentEvent);
            List<string> removedUserGcmList = GetRemovedUserGcmList(evnt, currentEvent);
            List<EventParticipant> NewlyAddedTempUserList = GetAddedTempUserList(evnt, currentEvent);

            evnt.ParticipantUpdateAction = 1; //Setting action to Sync.
            if (Context.UpdateEvent(Serializer.Serialize(evnt)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to update event/particpants.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyEventUpdate(updatedEvent, removedUserGcmList);
            pushNotifier.NotifyAddParticipantToEvent(currentEvent, addedUserGcmList);
            pushNotifier.NotifyRemoveParticipantFromEvent(currentEvent, removedUserGcmList);

            //send notification to initiator regarding additional registered users
            pushNotifier.NotifyAdditionalRegisteredUserInfoToHost(additionalRegisteredUsers, updatedEvent);


            //send sms to unregistered users
            smsNotifier = new DefaultSMSNotification();
            smsNotifier.sendEventInviteSMSToMultipleContactsAsync(NewlyAddedTempUserList, updatedEvent.Name, updatedEvent.InitiatorName);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }


        public Event UpdateParticipants(Event evnt)
        {
            Event currentEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();

            evnt.UpdateParticipantsOnly = true;
            List<EventParticipant> UnregisteredUserList = new List<EventParticipant>();
            List<EventParticipant> RegisteredTempUserList = new List<EventParticipant>();
            List<EventParticipant> additionalRegisteredUsers = new List<EventParticipant>();
            evnt = ParseUserList(evnt, ref UnregisteredUserList, ref additionalRegisteredUsers, ref RegisteredTempUserList);

            if (!evnt.UserList.Any(x => x.UserId.ToString().ToLower() == currentEvent.InitiatorId.ToString().ToLower()))
            {
                evnt.UserList.Add(new EventParticipant() { UserId = currentEvent.InitiatorId.ToString() });
            }

            List<string> addedUserGcmList = GetAddedUserGcmList(evnt, currentEvent);
            List<string> removedUserGcmList = GetRemovedUserGcmList(evnt, currentEvent);
            List<EventParticipant> NewlyAddedTempUserList = GetAddedTempUserList(evnt, currentEvent);

            evnt.ParticipantUpdateAction = 1; //Setting action to Sync.
            if (Context.UpdateEvent(Serializer.Serialize(evnt)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to update event particpants.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyEventUpdateParticipants(currentEvent, removedUserGcmList);
            pushNotifier.NotifyAddParticipantToEvent(currentEvent, addedUserGcmList);
            pushNotifier.NotifyRemoveParticipantFromEvent(currentEvent, removedUserGcmList);

            //send notification to initiator regarding additional registered users
            pushNotifier.NotifyAdditionalRegisteredUserInfoToHost(additionalRegisteredUsers, currentEvent);

            //send sms to unregistered users
            smsNotifier = new DefaultSMSNotification();
            smsNotifier.sendEventInviteSMSToMultipleContactsAsync(NewlyAddedTempUserList, updatedEvent.Name, updatedEvent.InitiatorName);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }


        public Event UpdateEventLocation(EventRequest eventRequest)
        {
            if (Context.UpdateEventLocation(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to update event location.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyEventUpdateLocation(eventRequest, updatedEvent);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }

        public Event AddParticipants(Event evnt)
        {
            Event currentEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();

            List<EventParticipant> UnregisteredUserList = new List<EventParticipant>();
            List<EventParticipant> RegisteredTempUserList = new List<EventParticipant>();
            List<EventParticipant> additionalRegisteredUsers = new List<EventParticipant>();
            evnt = ParseUserList(evnt, ref UnregisteredUserList, ref additionalRegisteredUsers, ref RegisteredTempUserList);
            List<EventParticipant> NewlyAddedTempUserList = GetAddedTempUserList(evnt, currentEvent);

            evnt.UpdateParticipantsOnly = true;
            evnt.ParticipantUpdateAction = 2; //setting update participant action to Add 
            if (Context.UpdateEvent(Serializer.Serialize(evnt)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to Add event particpants.");
            }

            List<string> adddedParticipantGcms = GetGcmList(evnt);
            

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyAddParticipantToEvent(updatedEvent, adddedParticipantGcms);
            //send notification to initiator regarding additional registered users
            pushNotifier.NotifyAdditionalRegisteredUserInfoToHost(additionalRegisteredUsers, updatedEvent);

            //send sms to unregistered users
            smsNotifier = new DefaultSMSNotification();
            smsNotifier.sendEventInviteSMSToMultipleContactsAsync(NewlyAddedTempUserList, updatedEvent.Name, updatedEvent.InitiatorName);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }


        public Event RemoveParticipants(Event evnt)
        {
            List<EventParticipant> UnregisteredUserList = new List<EventParticipant>();
            List<EventParticipant> RegisteredTempUserList = new List<EventParticipant>();
            List<EventParticipant> additionalRegisteredUsers = new List<EventParticipant>();
            evnt = ParseUserList(evnt, ref UnregisteredUserList, ref additionalRegisteredUsers, ref RegisteredTempUserList);

            evnt.UpdateParticipantsOnly = true;
            evnt.ParticipantUpdateAction = 3; //setting update participant action to Remove 
            if (Context.UpdateEvent(Serializer.Serialize(evnt)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to remove event particpants.");
            }
            List<string> removedParticipantGcms = GetGcmList(evnt);

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = evnt.EventId.ToString(), RequestorId = evnt.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyRemoveParticipantFromEvent(updatedEvent, removedParticipantGcms);
            //send notification to initiator regarding additional registered users
            pushNotifier.NotifyAdditionalRegisteredUserInfoToHost(additionalRegisteredUsers, updatedEvent);

            //send sms to unregistered users
            //smsNotifier = new DefaultSMSNotification();
            //smsNotifier.sendEventInviteSMSToMultipleContacts(RegisteredTempUserList, updatedEvent.Name, updatedEvent.InitiatorName);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }



        public Event ExtendEvent(EventRequest eventRequest)
        {
            Event currentEvent = GetEvent(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();

            if (Context.ExtendEvent(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to extend event.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyExtendEvent(updatedEvent, eventRequest);
            
            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }



        
        public Event EndEvent(EventRequest eventRequest)
        {
            Event currentEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();

            if(Context.EndEvent(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to end event.");
            }
            //Event updatedEvent = GetEvent(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyEndEvent(currentEvent);

            return ClientDataHelper.suppressSensitiveData(currentEvent);
        }

        public Event LeaveEvent(EventRequest eventRequest)
        {
            Event currentEvent = GetEvent(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();

            if( Context.LeaveEvent(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to Leave event.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyLeaveEvent(updatedEvent, eventRequest);

            return ClientDataHelper.suppressSensitiveData(updatedEvent);
        }


        public Boolean DeleteEvent(EventRequest eventRequest)
        {
            Event currentEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();

            if (Context.DeleteEvent(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to Delete event.");
            }
            pushNotifier = new DefaultNotificationManager();
            //send notification to registered users
            pushNotifier.NotifyDeleteEvent(currentEvent);
            return true;
        }


        public Boolean RespondToInvite(EventRequest eventRequest)
        {
            if (Context.RespondToEventInvite(Serializer.Serialize(eventRequest)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Failed to Respond to event.");
            }

            Event updatedEvent = GetEventsInternal(new EventRequest() { EventId = eventRequest.EventId.ToString(), RequestorId = eventRequest.RequestorId.ToString() }).FirstOrDefault();
            if (updatedEvent == null)
            { throw new Exception("Failed to Respond to event as event ended."); }

            pushNotifier = new DefaultNotificationManager();
            pushNotifier.NotifyEventResponse(eventRequest, updatedEvent);
            return true;
        }


        private Event ParseUserList(Event evnt, ref List<EventParticipant> UnregisteredUserList, ref List<EventParticipant> additionalRegisteredUsers, ref List<EventParticipant> RegisteredTempUserList)
        {
            //List<EventParticipant> additionalRegisteredUsers;
            additionalRegisteredUsers = new List<EventParticipant>();

            ContactsRequest cr = new ContactsRequest();
            cr.RequestorId = evnt.RequestorId.ToString();
            var resCode = Context.GetUserCountryCode(evnt.RequestorId);

            string initiatorCountryCode = resCode.FirstOrDefault().ToString();

                
            List<EventParticipant> UserList = evnt.UserList;
            //send only registered users to db while creating event. remaining users will need
            evnt.UserList = UserList.Where(x => !string.IsNullOrEmpty(x.UserId)).ToList();

            //Get Unregistered User list or Event Participant where user id is not present
            UnregisteredUserList = UserList.Where(x => string.IsNullOrEmpty(x.UserId) && !string.IsNullOrEmpty(x.MobileNumber)).ToList();
            //Properly Format the Country code and Mobile number
            UnregisteredUserList = UnregisteredUserList.Select(c =>
            {
                return PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, c, this.countryCodes);
            }).ToList();

            if (UnregisteredUserList.Count > 0)
            {
                //Find registered users from the mobile numbers for users whose userid is not provided
                cr.ContactList = UnregisteredUserList.Select(x => x.MobileNumber).ToList<string>();
                cr.ContactListFormatted = cr.ContactList.Select(c =>
                {
                    return PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, new PhoneContact() { MobileNumber = c, MobileNumberStoredInRequestorPhone = c }, this.countryCodes);
                }).ToList();

                //Amongst the UserList if there are users (without userid) but the mobilenumber+country code is already regstered
                //Such users will be identified as Additional Registered users
                //These users id are however not present in Initiator phone
                var res = Context.GetRegisteredContacts(Serializer.Serialize(cr));
                //var abc = res.FirstOrDefault();
                if (res != null)
                {                    
                    var sRes = res.FirstOrDefault().ToString();
                    List<PhoneContact> pcl = Serializer.DeserializeFromXml<List<PhoneContact>>(sRes).ToList();

                    if (pcl.Count > 0)
                    {
                        additionalRegisteredUsers = pcl.Select(item => new EventParticipant()
                        {
                            CountryCode = item.CountryCode,
                            MobileNumber = item.MobileNumber,
                            UserId = item.UserId,
                            MobileNumberStoredInRequestorPhone = item.MobileNumberStoredInRequestorPhone
                        }).ToList();

                        //Format Country code and mobile number
                        additionalRegisteredUsers = additionalRegisteredUsers.Select(c =>
                        {
                            return PhoneNumberHelper.FormatMobileNumberAndCountryCode(initiatorCountryCode, c, this.countryCodes);
                        }).ToList();

                        //Remove the additional registered users from Unregistered list
                        //Use an extra varible since ref variables are not allowed in lamda
                        List<EventParticipant> additionalRegisteredUsers1 = additionalRegisteredUsers;
                        UnregisteredUserList = UnregisteredUserList.Where(p => !additionalRegisteredUsers1.Any(x => x.MobileNumber == p.MobileNumber && x.CountryCode == p.CountryCode)).ToList();
                    }
                }

                //Update the UserList with additional registered users found from mobile numbers
                evnt.UserList.AddRange(additionalRegisteredUsers);

                //additionalRegisteredUsers1 = additionalRegisteredUsers;
                if (UnregisteredUserList.Count > 0)
                {
                    RegisteredTempUserList = RegisterTempUsers(UnregisteredUserList);
                    evnt.UserList.AddRange(RegisteredTempUserList);
                }
            }

            return evnt;
        }


        private List<String> GetAddedUserGcmList(Event evnt, Event currentEvent)
        {
            List<string> addedUserList = new List<string>();

            var addedList = evnt.UserList
                .Where(p2 => !currentEvent.UserList
                .Any(p1 => p1.UserId.ToString().ToLower() == p2.UserId.ToString().ToLower()))
                .ToList();

            addedList.ForEach( x=> {
                addedUserList.Add(Context.GetUserGcmClientId(new Guid(x.UserId)).FirstOrDefault().ToString());                
            });

            return addedUserList;
        }


        private List<String> GetRemovedUserGcmList(Event evnt, Event currentEvent)
        {
            List<string> removedUserList = new List<string>();

            var removedList = currentEvent.UserList
                .Where(p2 => !evnt.UserList
                .Any(p1 => p1.UserId.ToString().ToLower() == p2.UserId.ToString().ToLower()))
                .ToList();

            removedUserList.AddRange(removedList.Select(x => x.GCMClientId));

            return removedUserList;
        }

        private List<EventParticipant> GetAddedTempUserList(Event evnt, Event currentEvent)
        {
            List<EventParticipant> addedTempUserList = new List<EventParticipant>();

            var addedList = evnt.UserList
                .Where(p2 => !currentEvent.UserList
                .Any(p1 => p1.UserId.ToString().ToLower() == p2.UserId.ToString().ToLower()))
                .ToList();

            addedList.ForEach(x =>
            {
                //if (Context.GetUserGcmClientId(new Guid(x.UserId)).FirstOrDefault().ToString().ToUpper().CompareTo("TEMP")==0)
                if (x.IsUserTemporary)
                    addedTempUserList.Add(new EventParticipant() { UserId = x.UserId, MobileNumber = x.MobileNumber, CountryCode = x.CountryCode });
            });

            return addedTempUserList;
        }

        private List<String> GetGcmList(Event evnt)
        {
            List<string> gcms = new List<string>();
            ContactsRepository cr = new ContactsRepository(Context);
            evnt.UserList.ForEach(user =>
            {
                String uid = user.UserId.ToLower();
                var res = Context.GetUserGcmClientId(new Guid(user.UserId));
                if (user.UserId.ToLower() != evnt.RequestorId.ToString().ToLower())
                {
                    gcms.Add(res.FirstOrDefault().ToString());
                }
            });

            return gcms;
        }

        public List<EventParticipant> RegisterTempUsers(List<EventParticipant> UnregisteredUserList)
        {
            List<EventParticipant> RegisteredTempUserList =  new List<EventParticipant>();

            RegisteredTempUserList = UnregisteredUserList.Select(c => 
            {
                string userId = RegisterTempUser(new UserProfile() { CountryCode = c.CountryCode, MobileNumber = c.MobileNumber});
                return new EventParticipant() { CountryCode = c.CountryCode, MobileNumber = c.MobileNumber, UserId = userId, IsUserTemporary=true};
            }).ToList();

            return RegisteredTempUserList;
        }

        //public List<CountryCode> GetCountryCodes()
        //{
        //    List<CountryCode> ccList = Context.ws_mCountryDialingCodes.Select(item => new CountryCode()
        //    {
        //        Code = item.Code,
        //        Name = item.Name
        //    }).ToList<CountryCode>();
        //    return ccList;

        //}

    }
}

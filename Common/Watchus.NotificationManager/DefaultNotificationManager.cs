using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Watchus.GCMServer;
using WatchUs.Interface.PushNotification;
using WatchUs.Model;

namespace Watchus.NotificationManager
{
    public class DefaultNotificationManager : INotificationManager
    {
        IPushNotifier notifier;

        public DefaultNotificationManager()
        {
            this.notifier = new GCMNotifier();
        }
        //Used for event invite, event end
        public PushNotification GetMessage(Event evt, string notificationType)
        {
            return new PushNotification() { 
                EventId = evt.EventId.ToString(),
                EventName=evt.Name,
                Type = notificationType, //"EventInvite",
                InitiatorId=evt.InitiatorId.ToString(),
                InitiatorName = evt.InitiatorName
            };
        }

        //Used for event invite, event end
        public PushNotification GetMessageForLeaveEvent(Event evt, EventRequest eventRequest)
        {
            return new PushNotification()
            {
                EventId = evt.EventId.ToString(),
                EventName = evt.Name,
                Type = "EventLeave",
                EventResponderId = eventRequest.RequestorId.ToString(),
                EventResponderName = evt.UserList.Where(x=> x.UserId.ToString().ToLower() == eventRequest.RequestorId.ToString().ToLower()).ToList()[0].ProfileName.ToString()
            };
        }

        //Used for remind contact 
        public PushNotification GetMessage(RemindRequest remindReq)
        {
            PushNotification pn =  new PushNotification();

                if(remindReq.EventId != null)
                {
                    pn.EventId = remindReq.EventId.ToString();
                    if (!string.IsNullOrEmpty(remindReq.EventName))
                        pn.EventName = remindReq.EventName;
                }
                pn.Type = "RemindContact";
                pn.InitiatorId = remindReq.RequestorId;
                pn.InitiatorName = remindReq.RequestorName;
                return pn;    
        }

        //Used for update event location
        public PushNotification GetMessageForUpdateLocation(Event evt, EventRequest eventRequest, string notificationType)
        {
            return new PushNotification()
            {
                EventId = evt.EventId.ToString(),
                EventName = evt.Name,
                Type = notificationType, 
                InitiatorId = evt.InitiatorId.ToString(),
                InitiatorName = evt.InitiatorName,
                DestinationName = eventRequest.DestinationName
            };
        }

        public PushNotification GetMessageForExtend(Event evt, string notificationType, int extendEventDuration)
        {
            return new PushNotification()
            {
                EventId = evt.EventId.ToString(),
                EventName = evt.Name,
                Type = notificationType, //"EventInvite",
                InitiatorId = evt.InitiatorId.ToString(),
                InitiatorName = evt.InitiatorName,
                ExtendEventDuration = extendEventDuration
            };
        }

        //Used for event acceptance
        public PushNotification GetMessage(EventRequest eventRequest, Event evt, string notificationType)
        {
            return new PushNotification()
            {
                EventId = evt.EventId.ToString(),
                EventName = evt.Name,
                Type = notificationType, //"EventResponse",
                InitiatorId = evt.InitiatorId.ToString(),
                EventResponderId = eventRequest.RequestorId.ToString(),
                EventResponderName = evt.UserList.First(x=> x.UserId.ToString().ToLower() == eventRequest.RequestorId.ToLower()).ProfileName,
                EventAcceptanceStateId = eventRequest.EventAcceptanceStateId,
                TrackingAccepted = eventRequest.TrackingAccepted
            };
        }
        public PushNotification GetMessage(string notificationType, string userId, string mobileNumber)
        {
            return new PushNotification()
            {
                Type = notificationType, 
                UserId = userId,
                MobileNumber = mobileNumber
            };
        }


        public Boolean NotifyEventCreation(Event evt)
        {
            try
            {
                PushNotification pn = GetMessage(evt, "EventInvite");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user => 
                    {
                        if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower()))  
                        {
                            registrationIds.Add(user.GCMClientId);
                        }
                    });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds  , NotificationData=pn}).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        public Boolean NotifyEventUpdate(Event evt, List<string> removedParticipantsGcms)
        {
            try
            {
                if (removedParticipantsGcms == null)
                {
                    removedParticipantsGcms = new List<string>();
                }

                PushNotification pn = GetMessage(evt, "EventUpdate");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower()) &&  (! removedParticipantsGcms.Contains(user.GCMClientId)) ) // && (user.EventAcceptanceStateId != 0))                       
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public Boolean NotifyEventUpdateParticipants(Event evt, List<string> removedParticipantsGcms)
        {
            try
            {
                if (removedParticipantsGcms == null)
                {
                    removedParticipantsGcms = new List<string>();
                }

                PushNotification pn = GetMessage(evt, "EventUpdateParticipants");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower()) && (!removedParticipantsGcms.Contains(user.GCMClientId))) // && (user.EventAcceptanceStateId != 0))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        public Boolean NotifyEventUpdateLocation(EventRequest eventRequest, Event evt)
        {
            try
            {
                PushNotification pn = GetMessageForUpdateLocation(evt,eventRequest, "EventUpdateLocation");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower())) // && (user.EventAcceptanceStateId != 0))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        public Boolean NotifyAddParticipantToEvent(Event evt, List<string> adddedParticipantGcms)
        {
            try
            {
                //PushNotification pn = GetMessage(evt, "EventUpdate");
                if (adddedParticipantGcms.Count == 0)
                { return true; }

                PushNotification pn2 = GetMessage(evt, "EventInvite");

                //Get all participants gcms and remove newly added user gcms. 
                //As existing users will get ParticipantsAdded notification
                //New users will get EventInvite notification
                //List<string> registrationIds = new List<string>();
                //evt.UserList.ForEach(user =>
                //{
                //    if ( !user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower()) ) 
                //    {
                //        if(! adddedParticipantGcms.Contains(user.GCMClientId))
                //        registrationIds.Add(user.GCMClientId);
                //    }
                //});

                adddedParticipantGcms = validateGcmIds(adddedParticipantGcms);
                //Notify newly added users of event invitation
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = adddedParticipantGcms, NotificationData = pn2 }).Enqueue();

                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public Boolean NotifyRemoveParticipantFromEvent(Event evt, List<string> removedParticipantGcms)
        {
            try
            {
                if (removedParticipantGcms.Count == 0)
                { return true; }

                PushNotification pn = GetMessage(evt, "RemovedFromEvent");

                removedParticipantGcms = validateGcmIds(removedParticipantGcms);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = removedParticipantGcms, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        public Boolean NotifyEndEvent(Event evt)
        {
            try
            {
                PushNotification pn = GetMessage(evt, "EventEnd");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower())) // && (user.EventAcceptanceStateId != 0))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public Boolean NotifyExtendEvent(Event evt, EventRequest eventRequest)
        {
            try
            {
                PushNotification pn = GetMessageForExtend(evt, "EventExtend", eventRequest.ExtendEventDuration);

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower())) //  && (user.EventAcceptanceStateId != 0))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public Boolean NotifyDeleteEvent(Event evt)
        {
            try
            {
                PushNotification pn = GetMessage(evt, "EventDeleted");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(evt.InitiatorId.ToString().ToLower()))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        public Boolean NotifyLeaveEvent(Event evt, EventRequest eventRequest)
        {
            try
            {
                PushNotification pn = GetMessageForLeaveEvent(evt, eventRequest);

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(user =>
                {
                    if (!user.UserId.ToString().ToLower().Equals(eventRequest.RequestorId.ToString().ToLower())) // && (user.EventAcceptanceStateId != 0))
                    {
                        registrationIds.Add(user.GCMClientId);
                    }
                });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        
        public Boolean NotifyAdditionalRegisteredUserInfoToHost(List<EventParticipant> additionalRegisteredUsers, Event evt)
        {
            try 
            {
                List<string> registrationIds = new List<string>();
                registrationIds.Add(evt.InitiatorGCMClientId.ToString());
                registrationIds = validateGcmIds(registrationIds);

                additionalRegisteredUsers.ForEach(x =>
                {
                    PushNotification pn = GetMessage("RegisteredUserUpdate", x.UserId, x.MobileNumberStoredInRequestorPhone);
                    new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                    //this.notifier.SendInvite(registrationIds, pn);
                });
                
                
                return true;
            }
            catch(Exception)
            {
                return false;
            }
        }

        public Boolean NotifyEventResponse(EventRequest eventRequest, Event evt)
        {
            try
            {
                PushNotification pn = GetMessage(eventRequest, evt, "EventResponse");

                List<string> registrationIds = new List<string>();
                evt.UserList.ForEach(x =>
                    {
                        if (!x.UserId.ToString().ToLower().Equals(eventRequest.RequestorId.ToString().ToLower())) // && (x.EventAcceptanceStateId != 0))
                        registrationIds.Add(x.GCMClientId.ToString());
                    });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                //this.notifier.SendInvite(registrationIds, pn);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public Boolean NotifyRemindContact(RemindRequest remindReq)
        {
            try
            {
                PushNotification pn = GetMessage(remindReq);

                List<string> registrationIds = new List<string>();
                remindReq.ContactNumbersForRemindFormatted.ForEach(contact =>
                    {
                        if (!string.IsNullOrEmpty(contact.UserId))
                        {
                            if (!contact.UserId.ToString().ToLower().Equals(remindReq.RequestorId.ToString().ToLower()))
                                registrationIds.Add(contact.GCMClientId);
                        }
                        else {
                            registrationIds.Add(contact.GCMClientId);
                        }
                    });

                registrationIds = validateGcmIds(registrationIds);
                new NotificationTaskManager(new NotificationContainer() { RegistrationIds = registrationIds, NotificationData = pn }).Enqueue();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        List<string> validateGcmIds(List<string> registrationIds)
        {
            List<string> regIdsWithoutTemp = new List<string>();
            if (registrationIds.Count == 0)
            {
                throw new Exception("No valid gcm ids passed.");
            }
            registrationIds.ForEach(x=>
                {
                    if (x.ToUpper().CompareTo("TEMP") != 0)
                    {
                        regIdsWithoutTemp.Add(x);
                    }
                });
            return regIdsWithoutTemp;
        }
    }
}

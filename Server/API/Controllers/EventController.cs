using System;
using System.Collections.Generic;
using System.Web.Http;
using Watchus.NotificationManager;
using WatchUs.Interface.PushNotification;
using WatchUs.Interface.Repository;
using WatchUs.Model;

namespace WatchUs.APIService.Controllers
{
    public class EventController : ApiController
    {
        //INotificationManager notifier;
        // Get all event associated to current user or get specific event details.
        [Route("api/Event/Get")]
        [HttpPost]
        public GenericApiResult GetEventsForUser(EventRequest eventRequest)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                result.ListOfEvents = repo.GetEvent(eventRequest);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "no records found";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        //// Get details of a given event.
        //[Route("api/Event/GetEventDetails")]
        //[HttpPost]
        //public Event GetEventDetails(EventRequest eventRequest)
        //{
        //    return repo.GetEvent(eventRequest);
        //}

        // Create a new event and add particpants(userevent) and send invites
        [Route("api/Event/CreateEvent")]
        [HttpPost]
        public GenericApiResult CreateEvent(Event evnt)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();
            evnt.RequestorId = evnt.InitiatorId;
            try
            {
                result.ListOfEvents.Add(repo.CreateEvent(evnt));
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch(Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to create event.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        // Update event and particpants
        [Route("api/Event/Update")]
        [HttpPost]
        public GenericApiResult Update(Event evnt)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.EditEvent(evnt,false));                
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to edit event.";
                result.ErrorLog = ex.ToString();
            }
            return result;            
        }

        // Update  particpants
        [Route("api/Event/UpdateParticipants")]
        [HttpPost]
        public GenericApiResult UpdateParticipants(Event evnt)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.UpdateParticipants(evnt));
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to edit event.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        // Create a new event and add particpants(userevent) and send invites
        [Route("api/Event/UpdateEventLocation")]
        [HttpPost]
        public GenericApiResult UpdateEventLocation(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.UpdateEventLocation(eventRequest));
                result.Id = eventRequest.EventId;
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to update event location.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }



        // Add particpants(userevent) and send notification
        [Route("api/Event/AddParticipants")]
        [HttpPost]
        public GenericApiResult AddParticipants(Event evnt)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.AddParticipants(evnt));
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to Add Participants.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


        // Remove particpants(userevent) and send notification 
        [Route("api/Event/RemoveParticipants")]
        [HttpPost]
        public GenericApiResult RemoveParticipants(Event evnt)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.RemoveParticipants(evnt));
                result.Status = true;
                result.ErrorMessage = "";                
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to remove participants.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


        // Create a new event and add particpants(userevent) and send invites
        [Route("api/Event/ExtendEvent")]
        [HttpPost]
        public GenericApiResult ExtendEvent(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();

            try
            {
                result.ListOfEvents.Add(repo.ExtendEvent(eventRequest));
                result.Id = eventRequest.EventId;
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to extend event.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


        // DELETE api/event/5
        [Route("api/Event/DeleteEvent")]
        [HttpPost]
        public GenericApiResult Delete(EventRequest eventRequest)
        {            
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();
            try
            {
                repo.DeleteEvent(eventRequest);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to delete event.";
                result.ErrorLog = ex.ToString();
            }
            return result;   
        }

        // End Event
        [Route("api/Event/EndEvent")]
        [HttpPost]
        public GenericApiResult EndEvent(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();
            try
            {
                repo.EndEvent(eventRequest);
                result.Id = eventRequest.EventId;
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to end event.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        // End Event
        [Route("api/Event/LeaveEvent")]
        [HttpPost]
        public GenericApiResult LeaveEvent(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            result.ListOfEvents = new List<Event>();
            try
            {
                repo.LeaveEvent(eventRequest);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to Leave event.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        // Respond to event invite [Accept/Reject]
        [Route("api/Event/RespondToInvite")]
        [HttpPost]
        public GenericApiResult RespondToInvite(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
            {
                result.Status = repo.RespondToInvite(eventRequest);
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to respond to event invite.";
                result.ErrorLog = ex.ToString();
            }
            return result;  
        }

        // User Starts / Stops Tracking related to Event
        [Route("api/Event/StartStopTracking")]
        [HttpPost]
        public GenericApiResult StartStopTracking(EventRequest eventRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
            {
                //repo.StartStopTracking(eventRequest);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to respond to event invite.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }




         #region Private Fields

        private IEventRepository repo;
        #endregion  Private Fields

        #region .ctor

        public EventController(IEventRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor
    }
}

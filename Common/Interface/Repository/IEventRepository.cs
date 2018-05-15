using System;
using System.Collections.Generic;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface IEventRepository
    {
        Event CreateEvent(Event evnt);

        List<Event> GetEvent(EventRequest eventRequest);

        Event EditEvent(Event evnt, Boolean updateParticipantsOnly);

        Event UpdateParticipants(Event evnt);

        Event UpdateEventLocation(EventRequest eventRequest);

        Event AddParticipants(Event evnt);

        Event RemoveParticipants(Event evnt);

        Event ExtendEvent(EventRequest evnt);

        Event EndEvent(EventRequest evnt);

        Event LeaveEvent(EventRequest evnt);

        Boolean DeleteEvent(EventRequest evnt);

        Boolean RespondToInvite(EventRequest eventRequest);

        List<CountryCode> GetCountryCodes();
        //void AcceptEvent(EventRequest eventRequest);
        //void RejectEvent(EventRequest eventRequest);

        //ICollection<Event> GetAllEvents(EventRequest eventRequest);
    }
}

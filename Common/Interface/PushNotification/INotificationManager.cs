using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.PushNotification
{
    public interface INotificationManager
    {
        WatchUs.Model.PushNotification GetMessage(Event evt, string notificationType);
        WatchUs.Model.PushNotification GetMessage(EventRequest eventRequest, Event evt, string notificationType);
        Boolean NotifyEventCreation(Event evt);
        Boolean NotifyEventUpdate(Event evt, List<string> removedParticipantsGcms);
        Boolean NotifyEventUpdateParticipants(Event evt, List<string> removedParticipantsGcms);
        Boolean NotifyEventUpdateLocation(EventRequest eventRequest, Event evt);
        Boolean NotifyAddParticipantToEvent(Event evt, List<string> adddedParticipantGcms);
        Boolean NotifyRemoveParticipantFromEvent(Event evt, List<string> removedParticipantsGcms);
        Boolean NotifyEndEvent(Event evt);
        Boolean NotifyExtendEvent(Event evt, EventRequest eventRequest);
        Boolean NotifyLeaveEvent(Event evt, EventRequest eventRequest);
        Boolean NotifyDeleteEvent(Event evt);
        Boolean NotifyEventResponse(EventRequest eventRequest, Event evt);
        Boolean NotifyAdditionalRegisteredUserInfoToHost(List<EventParticipant> additionalRegisteredUsers, Event evt);
        Boolean NotifyRemindContact(RemindRequest remindReq);
    }
}

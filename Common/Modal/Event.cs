using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class Event
    {   
        public Guid EventId {get;set;}
        public string Name {get;set;}
        public int EventTypeId { get; set; }
        public string Description {get;set;}        
        public DateTime? StartTime {get;set;}
        public DateTime? EndTime {get;set;}
        public int Duration {get;set;}
        public List<EventParticipant> UserList { get; set; }
        public Guid InitiatorId {get;set;}
        public string InitiatorName { get; set; }
        public string InitiatorGCMClientId { get; set; }
        public int EventStateId {get;set;}
        public int TrackingStateId { get; set; }
        public decimal? DestinationLatitude { get; set; }
        public decimal? DestinationLongitude { get; set; }
        public string DestinationName { get; set; }
        public string DestinationAddress { get; set; }
        public bool? IsTrackingRequired { get; set; }
        public int ReminderTypeId { get; set; }
        public Int16? ReminderOffset { get; set; }  // Interval prior to The Start Time at which Reminder has to be shown
        public Int16? TrackingStartOffset { get; set; } // Interval prior to The Start Time at which Tracking has to be started
        public DateTime? TrackingStopTime { get; set; }
        public Boolean IsQuickEvent { get; set; }
        public Boolean IsDeleted { get; set; }
        public Boolean IsRecurring { get; set; }
        public int RecurrenceFrequencyTypeId { get; set; }
        public int RecurrenceCount { get; set; }
        public int RecurrenceFrequency { get; set; }
        public string RecurrenceDaysOfWeek { get; set; }
        
        public int RecurrenceRemaining { get; set; }
        public DateTime RecurrenceActualStartTime { get; set; }

        public Guid? RequestorId { get; set; } 
        public int EventAcceptanceStateOfRequestor { get; set; }
        public Boolean HasRequestorAcceptedTracking { get; set; }
        public Boolean UpdateParticipantsOnly { get; set; }
        public int ParticipantUpdateAction { get; set; }
    }
}

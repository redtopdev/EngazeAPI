using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class UserLocation
    {
        public string UserId { get; set; }
        public string ProfileName { get; set; }
        public string MobileNumber { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string LocationAddress { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; } //Time at which location was tracked.
        public decimal ETA { get; set; }
        public int ArrivalStatus { get; set; }  // On time, ahead, delayed
        public string EventId { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int Duration { get; set; }
        public bool IsRecurring { get; set; }
        public int RecurrenceFrequencyTypeId { get; set; }
        public int RecurrenceCount { get; set; }
        public int RecurrenceFrequency { get; set; }
        public string RecurrenceDaysOfWeek { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class EventParticipant
    {
        public Guid EventId { get; set; }
        public string UserId { get; set; }  //Pass Guid for registered users. Pass empty/null for non registered
        public string ProfileName { get; set; }
        public string CountryCode { get; set; }
        public string MobileNumber { get; set; }
        public string GCMClientId { get; set; }
        public int EventAcceptanceStateId { get; set; }
        public bool IsTrackingAccepted { get; set; }
        public DateTime TrackingStartTime { get; set; }
        public DateTime TrackingEndTime { get; set; }
        public int TrackingEndReason { get; set; }
        public bool IsTrackingActive { get; set; }
        public DateTime UserEventEndTime { get; set; }
        public int UserEventStateId { get; set; }
        public string MobileNumberStoredInRequestorPhone { get; set; }
        public bool IsUserLocationShared { get; set; }
        public bool IsUserTemporary { get; set; }
    }
}

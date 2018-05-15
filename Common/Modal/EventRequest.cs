using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{   
    /// <summary>
    ///  This class is used for holding the request  object for getting Event list, Accepting event etc
    /// </summary>
    public class EventRequest
    {
        public string RequestorId { get; set; }
        public string EventId { get; set; }
        public int EventAcceptanceStateId { get; set; }     
        public Boolean TrackingAccepted { get; set; }
        public int ExtendEventDuration { get; set; }
        public decimal? DestinationLatitude { get; set; }
        public decimal? DestinationLongitude { get; set; }
        public string DestinationName { get; set; }
        public string DestinationAddress { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class RemindRequest
    {
        public string EventName { get; set; }
        public string EventId { get; set; }
        public string RequestorId { get; set; }
        public string RequestorName { get; set; }  
        public List<string> UserIdsForRemind { get; set; }
        public List<PhoneContact> ContactNumbersForRemindFormatted { get; set; }

    }
}

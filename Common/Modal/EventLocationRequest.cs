using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class EventLocationRequest
    {
        public string RequestorId { get; set; }
        public string EventId { get; set; }
        public List<string> UserIds { get; set; }
    }
}

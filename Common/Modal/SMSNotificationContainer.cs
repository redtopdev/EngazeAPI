using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class SMSNotificationContainer
    {
        public string CountryCode { get; set; }
        public string MobileNumber { get; set; }
        public int MessageType { get; set; }
        public string OTP { get; set; }
        public string EventName { get; set; }
        public string HostName { get; set; }        
    }
}

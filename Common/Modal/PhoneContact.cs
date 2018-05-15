using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class PhoneContact
    {
        public string UserId { get; set; }
        public string CountryCode { get; set; }
        public string MobileNumber { get; set; }
        public string MobileNumberStoredInRequestorPhone { get; set; }
        public string GCMClientId { get; set; }
    }
}

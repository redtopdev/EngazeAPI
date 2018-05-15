using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class ContactsRequest
    {
        public List<string> ContactList { get; set; }
        public List<PhoneContact> ContactListFormatted { get; set; }
        public string RequestorId { get; set; }
        public string RequestorName { get; set; }
        public string ContactNumberForInvite { get; set; }
        public string ContactNumberForRemind { get; set; }
        public string EventNameForRemind { get; set; }
        public string CountryCodeForSMS { get; set; }
        public string ContactNumberForSMS { get; set; }
        public string MessageForSMS { get; set; }

    }
}

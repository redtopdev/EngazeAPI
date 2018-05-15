using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class GenericApiResult
    {
        public string Id { get; set; }
        public bool Status { get; set; }  //SUCCESS or FAILED.
        public string ErrorMessage { get; set; } //formatted error.
        public string ErrorLog { get; set; } //detailed error.
        public List<Event> ListOfEvents { get; set; }
        public List<UserLocation> ListOfUserLocation { get; set; }
        public List<PhoneContact> ListOfRegisteredContacts { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class NotificationContainer
    {
        public List<string> RegistrationIds {get; set;}
        public PushNotification NotificationData { get; set; }
    }
}

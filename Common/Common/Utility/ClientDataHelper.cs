using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Common.Utility
{
    public class ClientDataHelper
    {
        public static Event suppressSensitiveData(Event evnt)
        {
            evnt.InitiatorGCMClientId = null;
            evnt.UserList = evnt.UserList.Select(s => {s.GCMClientId = null; return s;}).ToList();
            return evnt;
        }
    }
}

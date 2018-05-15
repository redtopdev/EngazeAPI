using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.PushNotification
{
    public interface IPushNotifier
    {
        void Invite(Event evnt, List<UserProfile> users);
        void SendInvite(List<string> registrationIds, WatchUs.Model.PushNotification notificationData);
    }
}

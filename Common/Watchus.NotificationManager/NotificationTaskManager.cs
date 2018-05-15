using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading;
using Watchus.GCMServer;
using WatchUs.Interface.PushNotification;
using WatchUs.Model;


namespace Watchus.NotificationManager
{
    public class NotificationTaskManager : NotificationTaskQueue
    {
        IPushNotifier notifier;
        public NotificationTaskManager(NotificationContainer UserData)
            : base(UserData)
        {
            this.notifier = new GCMNotifier();
        }
        protected override void Task()
        {
            Thread.Sleep(1000);
            //Console.WriteLine(UserData.ToString());
            this.notifier.SendInvite(UserData.RegistrationIds, UserData.NotificationData);
        }
    
    }
}

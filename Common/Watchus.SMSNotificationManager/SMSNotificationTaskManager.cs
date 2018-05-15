using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using WatchUs.Common.Utility;
using WatchUs.Interface.SMSNotification;
using WatchUs.Model;

namespace Watchus.SMSNotificationManager
{
    public class SMSNotificationTaskManager : SMSNotificationTaskQueue
    {
        //ISMSNotificationManager smsNotifier;
        public SMSNotificationTaskManager(SMSNotificationContainer UserData)
            : base(UserData)
        {
            //this.smsNotifier = new DefaultSMSNotification();
        }
        protected override void Task()
        {
            Thread.Sleep(1000);
            //Console.WriteLine(UserData.ToString());
            SMSHelper.sendSMSGeneric(UserData.CountryCode, UserData.MobileNumber, UserData.MessageType, UserData.OTP, UserData.HostName, UserData.EventName);
        }
    
    }
}

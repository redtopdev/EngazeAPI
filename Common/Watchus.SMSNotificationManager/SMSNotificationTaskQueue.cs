﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace Watchus.SMSNotificationManager
{
    public abstract class SMSNotificationTaskQueue
    {
         public SMSNotificationContainer UserData { get; private set; }
         

        public TaskDelegate TaskDlgt { get; private set; }
        protected abstract void Task();

        public void Enqueue()
        {
            TaskDlgt = new TaskDelegate(Task);
            
            lock(lockObject)
            {
                if(Busy)
                    _q.Enqueue(TaskDlgt);
                else {
                    Busy = true;
                    TaskDlgt.BeginInvoke(new AsyncCallback(this.TaskCallback), TaskDlgt);
                }
            }
        }

        private static Queue _q = new Queue();
        private static bool Busy = false;
        private static object lockObject = new object();

        public SMSNotificationTaskQueue(SMSNotificationContainer Data)
        {
            UserData = Data;
        }

        public delegate void TaskDelegate();

        private void TaskCallback(IAsyncResult ar)
        {
            TaskDelegate dlgt = ar.AsyncState as TaskDelegate;
            
            if(dlgt.Equals(TaskDlgt))
                dlgt.EndInvoke(ar);
            NextTask();
        }
        private void NextTask()
        {
            TaskDelegate dlgt;
            lock(lockObject)
            {
                if(_q.Count > 0)
                {
                    dlgt = (TaskDelegate)_q.Dequeue();
                    dlgt.BeginInvoke(TaskCallback,dlgt);
                }
                else
                    Busy = false;
            }
        }

    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class UserFeedback
    {
        public Guid UserFeedbackId { get; set; }
        public Guid RequestorId { get; set; }
        public string Feedback { get; set; }
        public string FeedbackCategory { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UserEmailId { get; set; } 
    }
}

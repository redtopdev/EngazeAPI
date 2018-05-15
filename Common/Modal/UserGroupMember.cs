using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class UserGroupMember
    {
        public Guid UserGroupId { get; set; }
        public string UserId { get; set; }
        public string MobileNumber { get; set; }
        public bool IsAdmin { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedOn { get; set; }
        public string IsDeleted { get; set; }

    }
}

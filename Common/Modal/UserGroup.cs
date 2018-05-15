using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class UserGroup
    {
        public Guid UserGroupId { get; set; }
        public string UserGroupName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedOn { get; set; }
        public string IsDeleted { get; set; }
        public List<UserGroupMember> UserList { get; set; } //This is not a field in DB, but can be used while fetching/writing.

        public Guid? RequestorId { get; set; }
        public string NewUserGroupIdHolder { get; set; } //temp field to be used to save the created UserGroupId
    }
}

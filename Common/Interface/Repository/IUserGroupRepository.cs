using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface IUserGroupRepository
    {
        UserGroup GetUserGroupDetails(Guid userGroupId);
        Guid AddUserGroup(UserGroup userGroup);
        void DeleteGroup(UserGroupRequest userGroupRequest);
        void UpdateGroup(UserGroup userGroup);
        string LeaveGroup(UserGroupRequest userGroupRequest);
    }
}

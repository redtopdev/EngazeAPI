using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Common.Utility;
using WatchUs.Interface.Repository;
using WatchUs.Model;


namespace WatchUs.Repository
{
    public class UserGroupRepository : Repository, IUserGroupRepository
    {
                #region .ctor
        /// <summary>
        /// release version repository
        /// </summary>
        /// <param name="context">the context</param>
        public UserGroupRepository(WatchUsEntities context)
            : base(context)
        {
        }
                #endregion

        public UserGroup GetUserGroupDetails(Guid userGroupId)
        {
            return null;
        }

        public Guid AddUserGroup(UserGroup userGroup)
        {
            userGroup.NewUserGroupIdHolder = "$userGroupId$";
            List<UserGroupMember> UserList = userGroup.UserList;
            List<UserGroupMember> UnregisteredUserList = UserList.Where(x => string.IsNullOrEmpty(x.UserId)).ToList();

            //send sms to unregistered users
            //[TBD]

            //send only registered users to db while creating user group. 
            //call addusergroup & syncusergroupmembers
            userGroup.UserList = UserList.Where(x => !string.IsNullOrEmpty(x.UserId)).ToList();
            String serialized = Serializer.Serialize(userGroup);
            return Context.AddUserGroup(serialized).SingleOrDefault().Value;
            //Context.SyncUserGroupMembers(serialized); //This is no longer required as sp is called within AddUserGroup
        }

        public void DeleteGroup(UserGroupRequest userGroupRequest)
        {
            //call deleteusergroup 
            String serialized = Serializer.Serialize(userGroupRequest);
            Context.DeleteUserGroup(serialized);
        }

        public void UpdateGroup(UserGroup userGroup)
        {
            //call updateusergroup & syncusergroupmembers
            String serialized = Serializer.Serialize(userGroup);
            Context.UpdateUserGroup(serialized);
            Context.SyncUserGroupMembers(serialized);
        }

        public string LeaveGroup(UserGroupRequest userGroupRequest)
        {
            //call updateusergroup & syncusergroupmembers
            String serialized = Serializer.Serialize(userGroupRequest);
            return Context.LeaveUserGroup(serialized).SingleOrDefault().ToString();
        }
    }
}

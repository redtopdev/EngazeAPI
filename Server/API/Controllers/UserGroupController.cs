using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WatchUs.Interface.Repository;
using WatchUs.Model;


namespace WatchUs.APIService.Controllers
{
    public class UserGroupController : ApiController
    {

        [Route("api/UserGroup/Get")]
        public UserGroup Get(Guid userGroupId)
        {
            return repo.GetUserGroupDetails(userGroupId);
        }

        [Route("api/UserGroup/Add")]
        [HttpPost]
        public GenericApiResult Add(UserGroup userGroup)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
                {
                    result.Id = repo.AddUserGroup(userGroup).ToString();
                    result.Status = true;
                    result.ErrorMessage = "";
                }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to create group.";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        [Route("api/UserGroup/Update")]
        [HttpPost]
        public GenericApiResult Update(UserGroup userGroup)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
            {
                repo.UpdateGroup(userGroup);
                result.Id = userGroup.UserGroupId.ToString();
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to update group.";
                result.ErrorLog = ex.ToString();
            }
            return result;            
        }

        [Route("api/UserGroup/Delete")]
        [HttpPost]
        public GenericApiResult Delete(UserGroupRequest userGroupRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
            {
                repo.DeleteGroup(userGroupRequest);
                result.Id = userGroupRequest.UserGroupId.ToString();
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to delete group.";
                result.ErrorLog = ex.ToString();
            }
            return result;              
        }


        [Route("api/UserGroup/LeaveGroup")]
        [HttpPost]
        public GenericApiResult LeaveGroup(UserGroupRequest userGroupRequest)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            try
            {
                string res = repo.LeaveGroup(userGroupRequest);
                if (res.CompareTo("SUCCESS") != 0)
                {
                    throw new Exception(res);
                }

                result.Id = userGroupRequest.UserGroupId.ToString();
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to leave group.";
                result.ErrorLog = ex.ToString();
            }
            return result;   
            
        }
        
        #region Private Fields

        private IUserGroupRepository repo;
        #endregion  Private Fields

        #region .ctor

        public UserGroupController(IUserGroupRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor
    }
}

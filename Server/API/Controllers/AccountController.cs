using System.Web.Security;
using WatchUs.Model;
using WatchUs.Interface.Repository;
using System.Web.Http;
using System;


namespace WatchUs.API.Controllers
{
   
    //[Authorize]
    public class AccountController : ApiController
    {

        #region Private Fields

        private IUserAccountRepository repo;
        #endregion  Private Fields

        #region .ctor

        
        public AccountController(IUserAccountRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor

        [Route("api/Account/Register")]
        [HttpPost]
        public GenericApiResult Register(UserProfile userProfile)
        {
            GenericApiResult result;
            result = new GenericApiResult();
            //if (ModelState.IsValid)
            //{
                // Attempt to register the user
                try
                {
                    result.Id = repo.Register(userProfile);
                    result.Status = true;
                    result.ErrorMessage = "";
                }
                catch (MembershipCreateUserException e)
                {
                    //ModelState.AddModelError("", "Unable to register");
                    result.Id = "";
                    result.Status = false;
                    result.ErrorMessage = "Unable to register";
                    result.ErrorLog = e.ToString();
                }
            //}
            //else
            //{
            //    return "";
            //}
            return result;
        }

        [Route("api/Account/SaveFeedback")]
        [HttpPost]
        public GenericApiResult SaveFeedback(UserFeedback userFeedback)
        {
            GenericApiResult result;
            result = new GenericApiResult();

            try
            {
                repo.SaveFeedback(userFeedback);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception e)
            {
                result.Id = "";
                result.Status = false;
                result.ErrorMessage = "Unable to Save feedback";
                result.ErrorLog = e.ToString();
            }
            return result;
        }
    }
}

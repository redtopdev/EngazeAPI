using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;
using WatchUs.Interface.Repository;
using WatchUs.Common.Utility;

namespace WatchUs.Repository
{
    public class UserAccountRepository : Repository, IUserAccountRepository
    {

        #region .ctor
        /// <summary>
        /// repository
        /// </summary>
        /// <param name="context">the context</param>
        public UserAccountRepository(WatchUsEntities context)
            : base(context)
        {
        }
        #endregion

        public string Register(UserProfile userProfile)
        {
            userProfile.ModifiedOn = userProfile.CreatedOn;
            return Context.AddUserProfile(Serializer.Serialize(userProfile)).SingleOrDefault().ToString();
        }

        public Boolean SaveFeedback(UserFeedback userFeedback)
        {

            if (Context.SaveUserFeedback(Serializer.Serialize(userFeedback)).SingleOrDefault().Value == 0)
            {
                throw new Exception("Unable to save feedback.");
            }
            userFeedback.UserEmailId = Context.GetUserEmailId(userFeedback.RequestorId).SingleOrDefault().ToString();

            new EmailHelper().sendEmailViaWebApi(userFeedback.FeedbackCategory, userFeedback.Feedback, userFeedback.UserEmailId);
            return true;
            
        }

        public string GetUserKey(Guid UserID)
        {
            return "";
        }

        public bool IsAuthenticated(Guid UserID, string token)
        {
            return false;
        }
        public UserAuthentication GetUserToken(Guid UserID)
        {
            return null;
        }


    }
}

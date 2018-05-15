using System;
using System.Collections.Generic;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface IUserAccountRepository:IRepository
    {
        string Register(UserProfile userProfile);
        string GetUserKey(Guid UserID);
        bool IsAuthenticated(Guid UserID, string token);
        UserAuthentication GetUserToken(Guid UserID);
        Boolean SaveFeedback(UserFeedback userFeedback);
    }
}

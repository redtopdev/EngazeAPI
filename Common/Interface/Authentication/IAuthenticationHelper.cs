using System;
using WatchUs.Model;

namespace WatchUs.Interface.Authentication
{
    public interface IAuthenticationHelper
    {
        string GetUserKey(Guid UserID);
        bool IsAuthenticated(Guid UserID, string token);
        UserAuthentication GetUserToken(Guid UserID);
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Interface.Authentication;
using WatchUs.Model;
using WatchUs.Repository;
using WatchUs.Interface.Repository;

namespace WatchUs.AuthenticationManager
{
    public class AuthenticationHelper : IAuthenticationHelper
    {
        IUserAccountRepository userAccountRepo = null;
        IUserAccountRepository UserAccountRepo
        {
            get
            {
                if (userAccountRepo == null)
                {
                   // userAccountRepo = new UserAccountRepository();
                }
                return userAccountRepo;
            }
        }

        public string GetUserKey(Guid UserID)
        {
            return UserAccountRepo.GetUserKey(UserID);          
        }
        public bool IsAuthenticated(Guid userID, string token)
        {
            return UserAccountRepo.IsAuthenticated(userID, token);
        }

        public UserAuthentication GetUserToken(Guid userID)
        {
            return UserAccountRepo.GetUserToken(userID);
        }
    }
}

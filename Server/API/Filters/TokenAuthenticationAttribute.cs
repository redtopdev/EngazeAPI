using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Http.Results;
using WatchUs.AuthenticationManager;
using WatchUs.Interface.Authentication;
using WatchUs.Interface.Utility;
using WatchUs.EncryptionManager;
using System.Configuration;

namespace WatchUs.APIService
{
    public class TokenAuthenticationAttribute : Attribute, IAuthenticationFilter
    {

        public bool AllowMultiple { get { return false; } }
        public IAuthenticationHelper authHelper;
        public IAuthenticationHelper AuthHelper
        {
            get
            {
                if (authHelper == null)
                {
                    authHelper = new AuthenticationHelper();
                }
                return authHelper;
            }
        }

        public IEncryptionManager encryptionMgr;
        public IEncryptionManager EncryptionManager
        {
            get
            {
                if (encryptionMgr == null)
                {
                    encryptionMgr = new RijndaelManagedEncryption(ConfigurationManager.AppSettings["RIJNDAELINPUTKEY"].ToString());
                }
                return encryptionMgr;
            }
        }

        public Task AuthenticateAsync(HttpAuthenticationContext context,
              CancellationToken cancellationToken)
        {
            var req = context.Request;
            // Get credential from the Authorization header             
            if (req.Headers.Authorization != null )
            {
                var creds = req.Headers.Authorization.Parameter;
                string decodedToken = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(creds));
                Guid userID = new Guid(decodedToken.Substring(0, decodedToken.IndexOf(':')));
                string password = decodedToken.Substring(decodedToken.IndexOf(':') + 1);
                string userKey = AuthHelper.GetUserKey(userID);
                if (AuthHelper.IsAuthenticated(userID, EncryptionManager.DecryptText(password,userKey)))
                {
                    var claims = new List<Claim>()
                          {
                            new Claim(ClaimTypes.NameIdentifier, userID.ToString()),
                          };
                    var id = new ClaimsIdentity(claims, password.ToString());
                    var principal = new ClaimsPrincipal(new[] { id });
                    // The request message contains valid credential
                    context.Principal = principal;
                }
                else
                {
                    // The request message contains invalid credential
                    context.ErrorResult = new UnauthorizedResult(
                      new AuthenticationHeaderValue[0], context.Request);
                }
            }
            return Task.FromResult(0);
        }

        public Task ChallengeAsync(HttpAuthenticationChallengeContext context,
  CancellationToken cancellationToken)
        {
            context.Result = new ResultWithChallenge(context.Result);
            return Task.FromResult(0);
        }

    }
}
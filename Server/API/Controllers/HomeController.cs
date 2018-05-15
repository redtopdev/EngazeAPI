using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Watchus.GCMServer;
using WatchUs.Interface.Repository;
using WatchUs.Model;


namespace WatchUs.API.Controllers
{
    public class HomeController : ApiController
    {
          #region Private Fields

        private IRepository repo;
        #endregion  Private Fields

        #region .ctor


        public HomeController(IRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor

         [Route("api/CountryCodes")]
        [HttpGet]
        public ICollection<CountryDialingCode> CountryCodes()
        {
            return repo.GetCountryDialingCodes();
        }

        [Route("api/SN")]
        [HttpGet]
         public void SendNotification()
         {
             GCMNotifier nf = new GCMNotifier();
             nf.Invite(null, null);
         }
    }
}

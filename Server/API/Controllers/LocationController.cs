using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WatchUs.Interface.Repository;
using WatchUs.Model;

namespace WatchUs.API.Controllers
{
    public class LocationController : ApiController
    {

        #region Private Fields

        private ILocationRepository repo;
        #endregion  Private Fields

        #region .ctor

        public LocationController(ILocationRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor


        [Route("api/Location/Upload")]
        [HttpPost]
        public GenericApiResult Post(UserLocation userLocation)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                result.Id = repo.UploadUserLocation(userLocation);
                result.Status = true;
                result.ErrorMessage="";                
            }
            catch(Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "location could not be saved";
                result.ErrorLog = ex.Message;       
            }
            return result;
        }


        [Route("api/Location/Get")]
        [HttpPost]
        public GenericApiResult Get(EventLocationRequest eventLocationRequest)
        {
            GenericApiResult result = new GenericApiResult();

            try
            {   
                result.ListOfUserLocation = repo.GeUserLocation(eventLocationRequest);
                result.Status = true;
                result.ErrorMessage="";
            }
            catch(Exception ex)
            {
                result.ListOfUserLocation = new List<UserLocation>();
                result.Status = false;
                result.ErrorMessage = "no records or requestor not authenticated.";
                result.ErrorLog = ex.Message;
            }
            return result;
        }
    }
}

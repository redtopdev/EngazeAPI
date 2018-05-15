using System.Collections.Generic;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface ILocationRepository:IRepository
    {
        string UploadUserLocation(UserLocation userLocation);

        List<UserLocation> GeUserLocation(EventLocationRequest eventLocationRequest);
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.Utility
{
    public interface IGeocodingHelper
    {
        string GetLocationAddress(UserLocation userLocation);
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Geocoding;
using Geocoding.Google;
using WatchUs.Model;
using WatchUs.Interface.Utility;
using System.Configuration;


namespace Watchus.Geocoding
{
    public class DefaultGeocodingHelper:IGeocodingHelper
    {
        public string GetLocationAddress(UserLocation userLocation)
        {
            string geoCodingAPIKey = ConfigurationManager.AppSettings["GeoCodingAPIKey"].ToString();
            //IGeocoder geocoder = new GoogleGeocoder("AIzaSyB3qF_1mFfeu2Jwt6Z9zmFK6GrbthVaLwI");//api key
            string formattedAdrress;
            Location loc;
            IEnumerable<Address> addressList = null;
            Boolean errorFlag = false;

            IGeocoder geocoder;
            geocoder = new GoogleGeocoder(geoCodingAPIKey);//api key

            try
            {
                formattedAdrress = string.Empty;
                loc = new Location(Double.Parse(userLocation.Latitude.ToString()), Double.Parse(userLocation.Longitude.ToString()));
                addressList = geocoder.ReverseGeocode(loc);
                if (addressList == null)
                { throw new Exception(); }
            }
            catch (Exception ex)
            {
                errorFlag = true;
            }

            try
            {
                if (errorFlag)
                {
                    geocoder = new GoogleGeocoder();//api key
                    formattedAdrress = string.Empty;
                    loc = new Location(Double.Parse(userLocation.Latitude.ToString()), Double.Parse(userLocation.Longitude.ToString()));
                    addressList = geocoder.ReverseGeocode(loc);
                }
            }
            catch (Exception ex1)
            {

            }

            if (addressList != null && addressList.Count() > 0)
            {
                formattedAdrress = addressList.First().FormattedAddress;
            }
            else
            {
                formattedAdrress = ConfigurationManager.AppSettings["GeoCodingAddressNotFoundText"].ToString();
            }

            return formattedAdrress;            
        }
    }
}

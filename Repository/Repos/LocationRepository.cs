using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Watchus.Geocoding;
using WatchUs.Common.Utility;
using WatchUs.Interface.Repository;
using WatchUs.Interface.Utility;
using WatchUs.Model;


namespace WatchUs.Repository
{
    public class LocationRepository : Repository, ILocationRepository
    {
        IGeocodingHelper geocodingHelper;
        IGeocodingHelper GeocodingHelper {
            get {
                    if (geocodingHelper == null)
                    {
                        geocodingHelper = new DefaultGeocodingHelper();                
                    }
                    return geocodingHelper;
                }
        }
        #region .ctor
        /// <summary>
        /// repository
        /// </summary>
        /// <param name="context">the context</param>
        public LocationRepository(WatchUsEntities context)
            : base(context)
        {
        }
        #endregion

        public string UploadUserLocation(UserLocation userLocation)
        {
            string locationAddress = this.GeocodingHelper.GetLocationAddress(userLocation);
            userLocation.LocationAddress = locationAddress;
            var res = Context.AddUserLocation(Serializer.Serialize(userLocation));
            return res.FirstOrDefault().ToString();
        }

        public List<UserLocation> GeUserLocation(EventLocationRequest eventLocationRequest)
        {
            List<UserLocation> listUserLoc = new List<UserLocation>();
            var res = Context.GetUserLocation(Serializer.Serialize(eventLocationRequest)).FirstOrDefault();
            if (!string.IsNullOrEmpty(res))
            {
                var list = Serializer.DeserializeFromXml<List<UserLocation>>(res);
                if (list.Count > 0)
                {
                    if (list[0].IsRecurring)
                    {
                        list = removePastLocationForRecurrentEvents(list);
                    }

                    if (eventLocationRequest.UserIds != null)
                    {
                        foreach (UserLocation userLoc in list)
                        {
                            if (eventLocationRequest.UserIds.Contains(userLoc.UserId))
                            {
                                listUserLoc.Add(userLoc);
                            }
                        }
                    }
                    else
                    {
                        listUserLoc.AddRange(list.ToList());
                    }
                }
            }
            return listUserLoc;    

        }

        private List<UserLocation> removePastLocationForRecurrentEvents(List<UserLocation> userLocList)
        {
            List<UserLocation> newListUserLocation = new List<UserLocation>();
            foreach (UserLocation userLoc in userLocList)
            {
                Event evt = new Event();
                evt.EventId = new Guid(userLoc.EventId.ToString());
                evt.StartTime = userLoc.StartTime;
                evt.EndTime = userLoc.EndTime;
                evt.Duration = userLoc.Duration;
                evt.IsRecurring = userLoc.IsRecurring;
                evt.RecurrenceFrequencyTypeId = userLoc.RecurrenceFrequencyTypeId;
                evt.RecurrenceCount = userLoc.RecurrenceCount;
                evt.RecurrenceFrequency = userLoc.RecurrenceFrequency;
                evt.RecurrenceDaysOfWeek = userLoc.RecurrenceDaysOfWeek;
                evt = AdjustRecurringEventTiming(evt);

                if (evt.StartTime <= userLoc.CreatedOn && evt.EndTime >= userLoc.CreatedOn)
                {
                    newListUserLocation.Add(userLoc);
                }
            }
            return newListUserLocation;
        }
    }
}

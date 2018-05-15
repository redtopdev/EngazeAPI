namespace WatchUs.Repository
{
    using System.Collections.Generic;
    using WatchUs.Interface.Repository;
    //using Interface.Repository;
    using WatchUs.Logging;
    using WatchUs.Model;
    using System.Linq;
    using WatchUs.Common.Utility;
    using System;

    public class Repository : RepositoryBase, IRepository
    {
        #region Constants
        protected static ILogger logger = LogManager.GetLogger(typeof(Repository));
        #endregion

        #region public methods

        public ICollection<CountryDialingCode> GetCountryDialingCodes()
        {
            return Context.GetCountryDialingCodes().
                Select(item => new CountryDialingCode() { Code = item.Code, Name = item.Name }).ToList();
        }

        public List<CountryCode> GetCountryCodes()
        {
            List<CountryCode> ccList = Context.ws_mCountryDialingCodes.Select(item => new CountryCode()
            {
                Code = item.Code,
                Name = item.Name
            }).ToList<CountryCode>();
            return ccList;

        }

        public string RegisterTempUser(UserProfile userProfile)
        {
            //userProfile.ModifiedOn = userProfile.CreatedOn;
            return Context.AddTempUserProfile(Serializer.Serialize(userProfile)).SingleOrDefault().ToString();
        }

        public List<Event> GetEventsInternal(EventRequest eventRequest)
        {
            //Return all events for user if event id is null
            
            List<Event> eventList = new List<Event>();
            string req = Serializer.Serialize(eventRequest);
            var objRes = Context.GetEventsInternal(req).FirstOrDefault();
            if (!string.IsNullOrEmpty(objRes))
            {
                string res = objRes.ToString();

                var resList = Serializer.DeserializeFromXml<List<Event>>(res).ToList();
                if (resList.Count > 0)
                {
                    foreach (Event ev in resList)
                    {
                        Event ev1 = AdjustRecurringEventTiming(ev);
                        if (ev1.EndTime > DateTime.UtcNow)
                        {
                            eventList.Add(ev1);
                        }
                    }
                    //eventList.AddRange(resList);
                }
            }
            return eventList;
        }


        public Event AdjustRecurringEventTiming(Event evt)
        {
            DateTime currentEndTime;
            DateTime nextStartTime;
            int recurrenceFrequency=1;
            int i = 0;            

            if (evt.IsRecurring)
            {
                currentEndTime = ((DateTime)evt.StartTime).AddMinutes(evt.Duration);
                nextStartTime = (DateTime)evt.StartTime;
                evt.RecurrenceRemaining = evt.RecurrenceCount;
                if (!(evt.RecurrenceFrequency == 0))
                {
                    recurrenceFrequency = evt.RecurrenceFrequency;
                }

                switch (evt.RecurrenceFrequencyTypeId)
                {
                    case 1: //daily
                        i = 0;
                        while (currentEndTime < DateTime.UtcNow && i < evt.RecurrenceCount-1)
                        {
                            i = i + 1;
                            currentEndTime = currentEndTime.AddDays(recurrenceFrequency);
                            nextStartTime = nextStartTime.AddDays(recurrenceFrequency);
                        }

                        break;
                    case 2:  //weekly
                        i = 0;
                        List<string> daysOfWeekList = evt.RecurrenceDaysOfWeek.Split(",".ToCharArray()).ToList();
                        
                        //reorder days of week if the starting day comes in middle
                        List<string> daysOfWeekOrdered = new List<string>();
                        daysOfWeekOrdered = ReorderDaysOfWeek(daysOfWeekList, nextStartTime);

                        int k = 0;
                        int daysToAdd=0;
                        while (currentEndTime < DateTime.UtcNow && i < evt.RecurrenceCount-1)
                        {

                            daysToAdd = Int16.Parse(daysOfWeekOrdered[k]) - ((int)nextStartTime.DayOfWeek + 1);
                            if (daysToAdd < 0)
                            {
                                daysToAdd += (7 * recurrenceFrequency);
                            }
                            
                            //if (k > 0)
                            //{
                            //    if (Int16.Parse(daysOfWeekOrdered[k]) < Int16.Parse(daysOfWeekOrdered[k - 1]))
                            //    {
                            //        daysToAdd = (7 - Int16.Parse(daysOfWeekOrdered[k - 1])) + Int16.Parse(daysOfWeekOrdered[k]);
                            //    }
                            //}
                            

                            nextStartTime = nextStartTime.AddDays(daysToAdd);
                            currentEndTime = nextStartTime.AddMinutes(evt.Duration);
                            k = k + 1;
                            if (k == daysOfWeekOrdered.Count())
                            {
                                k = 0;
                            }
                            i = i + 1;
                            //weeksCount = evt.RecurrenceCount / daysOfWeekCount;                            
                            //currentEndTime = currentEndTime.AddDays(7 * recurrenceFrequency);
                            //nextStartTime = nextStartTime.AddDays(7 * recurrenceFrequency);
                        }

                        break;
                    case 3: //monthly
                        i = 0;
                        while (currentEndTime < DateTime.UtcNow && i < evt.RecurrenceCount-1)
                        {
                            i = i + 1;
                            currentEndTime = currentEndTime.AddMonths(recurrenceFrequency);
                            nextStartTime = nextStartTime.AddMonths(recurrenceFrequency);
                        }

                        break;
                }
                evt.RecurrenceActualStartTime = (DateTime)evt.StartTime;
                evt.StartTime = nextStartTime;
                evt.EndTime = currentEndTime;
                evt.RecurrenceRemaining = evt.RecurrenceCount - i;
            }
            return evt;
        }
        #endregion public methods


        List<string> ReorderDaysOfWeek(List<string> daysOfWeek, DateTime nextStartTime)
        {

            daysOfWeek = BubbleSort(daysOfWeek);
            List<string> daysOfWeekOrdered = new List<string>();
            List<string> daysOfWeekTemp1 = new List<string>();
            //Reorder the daysOfWeek based on actual start day 
            int j = 0;
            while (Int16.Parse(daysOfWeek[j]) != ((int)nextStartTime.DayOfWeek+1))
            {
                daysOfWeekTemp1.Add(daysOfWeek[j]);
                j = j + 1;
            }
            daysOfWeekTemp1.Add(daysOfWeek[j]);
            j = j + 1;

            while (j < daysOfWeek.Count())
            {
                daysOfWeekOrdered.Add(daysOfWeek[j]);
                j = j + 1;                                
            }
            daysOfWeekOrdered.AddRange(daysOfWeekTemp1);

            return daysOfWeekOrdered;
        }

        List<string> BubbleSort(List<string> list)
        {
            string temp;
            for (int i = 0; i < list.Count; i++)
            {
                for (int j = 0; j < list.Count-i-1; j++)
                { 
                    if( Int16.Parse(list[j]) > Int16.Parse(list[j+1]) )
                    {
                        temp = list[j];                        
                        list[j] = list[j+1];
                        list[j + 1] = temp;
                        
                    }
                }
            }
            return list;
        }

        #region .ctor
        /// <summary>
        /// repository
        /// </summary>
        /// <param name="context">the context</param>
        public Repository(WatchUsEntities context)
            : base(context)
        {
        }
        #endregion
    }
}

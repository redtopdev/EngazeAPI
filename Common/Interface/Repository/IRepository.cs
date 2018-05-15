using System.Collections.Generic;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface IRepository
    {
        ICollection<CountryDialingCode> GetCountryDialingCodes();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Common.Utility
{
    public class PhoneNumberHelper
    {
        
        public static EventParticipant FormatMobileNumberAndCountryCode(string referenceCountryCode, EventParticipant participant, List<CountryCode> countryCodes)
        {
            if (string.IsNullOrEmpty(participant.MobileNumberStoredInRequestorPhone))
            {
                participant.MobileNumberStoredInRequestorPhone = participant.MobileNumber;
            }

            if (!participant.MobileNumber.Contains("+") )
            {
                if (!participant.MobileNumberStoredInRequestorPhone.Contains("+"))
                {
                    participant.CountryCode = referenceCountryCode;
                }
                if (participant.MobileNumberStoredInRequestorPhone.Substring(0, 1) == "0")
                {
                    participant.MobileNumber = participant.MobileNumber.Substring(1);
                }
            }
            else if (participant.MobileNumber.Length > 6 && participant.MobileNumber.Contains("+"))
            {                
                participant.CountryCode = MatchCountryCode(participant.MobileNumber, countryCodes);
                participant.MobileNumber = participant.MobileNumber.Remove(0, participant.CountryCode.Length);
            }
            return participant;
        }

        public static PhoneContact FormatMobileNumberAndCountryCode(string referenceCountryCode, PhoneContact phoneNumber, List<CountryCode> countryCodes)
        {
            if (phoneNumber.MobileNumber == null) { phoneNumber.MobileNumber = ""; }
            if (phoneNumber.MobileNumber.Length < 5 || phoneNumber.MobileNumber.Contains("*") || phoneNumber.MobileNumber.Contains("#") || phoneNumber.MobileNumber.Contains("_") || phoneNumber.MobileNumber.Contains("?"))
            {
                phoneNumber.CountryCode = "0";
                phoneNumber.MobileNumber = "0";
                return phoneNumber;
            }
            if (!phoneNumber.MobileNumber.Contains("+"))
            {
                phoneNumber.CountryCode = referenceCountryCode;
                if (phoneNumber.MobileNumber.Substring(0, 1) == "0")
                {
                    phoneNumber.MobileNumber = phoneNumber.MobileNumber.Substring(1);
                }
            }
            else if (phoneNumber.MobileNumber.Length > 6 && phoneNumber.MobileNumber.Contains("+"))
            {
                phoneNumber.CountryCode = MatchCountryCode(phoneNumber.MobileNumber, countryCodes);
                phoneNumber.MobileNumber = phoneNumber.MobileNumber.Remove(0, phoneNumber.CountryCode.Length);
            }
            return phoneNumber;
        }

        public static string MatchCountryCode(string mobileNumber, List<CountryCode> countryCodes)
        {
            int index = -1;

            for (int i = 5; i > 1; i--)
            {
                index = countryCodes.FindIndex(x => x.Code == mobileNumber.Substring(0, i));
                if (index >= 0)
                {
                    return mobileNumber.Substring(0, i);
                }

            }

            return "";
        }
    }
        
}

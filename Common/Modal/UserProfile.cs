using System;

namespace WatchUs.Model
{
    public class UserProfile
    {
        public Guid UserId { get; set; }
        public string GCMClientId { get; set; }        
        public string ProfileName { get; set; } //Mandatory
        public string ImageUrl { get; set; } 
        public string DeviceId { get; set; } //IMEI Number
        public string CountryCode { get; set; }
        public string MobileNumber { get; set; }
        
        public string FirstName { get; set; } 
        public string LastName { get; set; }        
        public string Email { get; set; } //mandatory
        public DateTime DateOfBirth { get; set; }         
        
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}

//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WatchUs.Repository
{
    using System;
    using System.Collections.Generic;
    
    public partial class ws_UserProfile
    {
        public System.Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string ProfileName { get; set; }
        public string Email { get; set; }
        public Nullable<System.DateTime> DateOfBirth { get; set; }
        public string DeviceId { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
        public string GCMClientId { get; set; }
        public string ImageUrl { get; set; }
        public string CountryCode { get; set; }
        public string MobileNumber { get; set; }
        public bool IsUserTemporary { get; set; }
    }
}
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
    
    public partial class ws_UserLocation
    {
        public System.Guid UserId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<decimal> ETA { get; set; }
        public Nullable<int> ArrivalStatus { get; set; }
        public System.Guid UserLocationId { get; set; }
        public string LocationAddress { get; set; }
    }
}

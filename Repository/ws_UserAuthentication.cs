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
    
    public partial class ws_UserAuthentication
    {
        public System.Guid UserID { get; set; }
        public string Token { get; set; }
        public string Salt { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<bool> LastAccessedOn { get; set; }
    }
}

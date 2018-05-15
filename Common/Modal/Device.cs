using System;

namespace WatchUs.Model
{
    public class Device
    {
        public Guid DeviceId { get; set; }
        public string ClientAuthenticationCode { get; set; }
        public string IMEINumber { get; set; }
        public string MobileNumber { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }
        public DateTime ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }
}

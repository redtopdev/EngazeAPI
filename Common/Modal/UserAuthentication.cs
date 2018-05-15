using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class UserAuthentication
    {
        public Guid UserID { get; set; }
        public string Token { get; set; } //Should this be saved in separated DB?
        public string Salt { get; set; }
        public bool IsDeleted { get; set; }
        public bool CreatedOn { get; set; }
        public bool LastAccessedOn { get; set; } 
    }
}

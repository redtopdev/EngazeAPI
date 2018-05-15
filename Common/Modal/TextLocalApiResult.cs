using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Model
{
    public class TextLocalApiResult
    {
        public string status {get;set;}
        public List<TxtLocalResponseError> errors { get; set; }
    }

}

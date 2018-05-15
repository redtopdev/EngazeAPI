using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WatchUs.Interface.Utility
{
    public interface IEncryptionManager
    {
        string EncryptText(string text, string salt);
        string DecryptText(string cipherText, string salt);
        bool IsBase64String(string base64String);
    }
}

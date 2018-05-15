using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WatchUs.Model;

namespace WatchUs.Interface.Repository
{
    public interface IContactsRepository
    {
        List<PhoneContact> GetRegisteredUsers(ContactsRequest contactsRequest);
        MethodResult InviteContact(ContactsRequest contactRequest);
        MethodResult SendSMSOTP(ContactsRequest contactRequest);
        MethodResult RemindContact(RemindRequest remindRequest);
        String GetGcmClientIdOfUser(String userId);
    }
}

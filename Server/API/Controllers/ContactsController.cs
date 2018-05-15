using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WatchUs.Interface.Repository;
using WatchUs.Model;

namespace WatchUs.API.Controllers
{
    public class ContactsController : ApiController
    {

        // Get all event associated to current user or get specific event details.
        [Route("api/Contacts/GetRegisteredContacts")]
        [HttpPost]
        public GenericApiResult GetRegisteredContacts(ContactsRequest contactsRequest)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                result.ListOfRegisteredContacts = repo.GetRegisteredUsers(contactsRequest);
                result.Status = true;
                result.ErrorMessage = "";
            }
            catch (Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "no records found";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


        [Route("api/Contacts/InviteContact")]
        [HttpPost]
        public GenericApiResult InviteContact(ContactsRequest contactRequest)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                MethodResult mr = repo.InviteContact(contactRequest);
                result.Status = mr.Status;
                result.ErrorMessage = mr.Message;
            }
            catch (Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "sending invitation failed";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }

        [Route("api/Contacts/SendSMSOTP")]
        [HttpPost]
        public GenericApiResult SendSMSOTP(ContactsRequest contactRequest)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                MethodResult mr = repo.SendSMSOTP(contactRequest);
                result.Status = mr.Status;
                result.ErrorMessage = mr.Message;
            }
            catch (Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "sending SMS failed";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


        [Route("api/Contacts/RemindContact")]
        [HttpPost]
        public GenericApiResult RemindContact(RemindRequest remindRequest)
        {
            GenericApiResult result = new GenericApiResult();
            try
            {
                MethodResult mr = repo.RemindContact(remindRequest);
                result.Status = mr.Status;
                result.ErrorMessage = mr.Message;
            }
            catch (Exception ex)
            {
                result.Id = string.Empty;
                result.Status = false;
                result.ErrorMessage = "sending reminder failed";
                result.ErrorLog = ex.ToString();
            }
            return result;
        }


               #region Private Fields

        private IContactsRepository repo;
        #endregion  Private Fields

        #region .ctor

        public ContactsController(IContactsRepository repository)
        {
            repo = repository;
        }
        #endregion .ctor
    }
}

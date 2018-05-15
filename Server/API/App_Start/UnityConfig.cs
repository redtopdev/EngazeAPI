using Microsoft.Practices.Unity;
using System.Web.Http;
using Unity.WebApi;
using Watchus.NotificationManager;
using Watchus.SMSNotificationManager;
using WatchUs.Interface.PushNotification;
using WatchUs.Interface.Repository;
using WatchUs.Interface.SMSNotification;
using WatchUs.Repository;

namespace WatchUs.APIService
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
			var container = new UnityContainer();
            
            // register all your components with the container here
            // it is NOT necessary to register your controllers

            container.RegisterType<IUserAccountRepository, UserAccountRepository>();
            container.RegisterType<ILocationRepository, LocationRepository>();
            container.RegisterType<IRepository, Repository.Repository>();
            container.RegisterType<IEventRepository, EventRepository>();
            container.RegisterType<IUserGroupRepository, UserGroupRepository>();
            container.RegisterType<IContactsRepository, ContactsRepository>();
            container.RegisterType<INotificationManager, DefaultNotificationManager>();
            container.RegisterType<ISMSNotificationManager, DefaultSMSNotification>();
            //container.RegisterType < WatchUsDBEntities,;
            
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}
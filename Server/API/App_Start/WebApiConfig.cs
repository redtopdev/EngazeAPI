using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using WatchUs.API.Filters;

namespace WatchUs.APIService
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();
            RegisterWebApiFilters(config);

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }

        public static void RegisterWebApiFilters(HttpConfiguration config)
        {
           config.Filters.Add(new APIExceptionHandler());
        }
    }
}

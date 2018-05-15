﻿using System.Web.Http;
using System.Web.Mvc;

namespace WatchUs.APIService
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            AreaRegistration.RegisterAllAreas();
            UnityConfig.RegisterComponents();  
        }
    }
}
    
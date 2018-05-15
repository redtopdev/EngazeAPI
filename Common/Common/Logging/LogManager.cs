#region Using Directives



#endregion

namespace WatchUs.Logging
{
    #region Using Directives Region

    using System;
    using System.Configuration;
    using System.IO;
    using log4net.Appender;
    using log4net.Config;
    using log4net;

    #endregion

    /// <summary>
    /// 	Provides a way of getting objects that implements the ILogger interface
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1053:StaticHolderTypesShouldNotHaveConstructors")]
    public class LogManager
    {
        #region Type Initializer

        static LogManager()
        {
            try
            {
                string loggingValue = ConfigurationManager.AppSettings["logging"];
                string path = AppDomain.CurrentDomain.BaseDirectory;

                FileInfo file = new FileInfo(string.Format("{0}\\{1}", path, loggingValue));
                XmlConfigurator.ConfigureAndWatch(file);
            }
            catch
            {
                // failsafe configuration which logs to the console
                BasicConfigurator.Configure(new ConsoleAppender());
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 	Returns different instances of ILogger interface depending of application settings.
        /// 	Currently there's support only for log4net.
        /// </summary>
        /// <param name = "classType"></param>
        /// <returns></returns>
        public static ILogger GetLogger(Type classType)
        {
            return new Log4NetLogger(classType);
        }

        public static void SetStaticContext(string property, string propertyValue) 
        {
            LogicalThreadContext.Stacks[property].Push(propertyValue);
        }
        #endregion
    }
}
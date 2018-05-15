namespace WatchUs.Logging
{
    #region Using Directives Region

    using System;
    using log4net;
    using log4net.Config;

    #endregion

    /// <summary>
    /// Provides an implementation of ILogger (wrapper over the log4net).
    /// </summary>
    public class Log4NetLogger : ILogger
    {
        #region Constructors 

        /// <summary>
        /// Initializes a new instance of the Log4NetLogger class.
        /// </summary>
        public Log4NetLogger(Type classType)
        {
            Configure();
            log4Net = log4net.LogManager.GetLogger(classType);
        }

        #endregion

        #region Public Methods 

        public Guid LogException(Exception exception)
        {
            Guid id = Guid.NewGuid();
            ErrorFormat("Error identifier: {0} Error: {1}", id, exception);
            return id;
        }

        /// <summary>
        /// Outputs a message with debug severity.
        /// </summary>
        /// <param name="message">The message.</param>
        public void Debug(object message)
        {
            log4Net.Debug(message);
        }

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        public void DebugFormat(string format, params object[] args)
        {
            log4Net.DebugFormat(format, args);
        }

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        public void DebugFormat(string format, object arg)
        {
            log4Net.DebugFormat(format, arg);
        }

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        public void DebugFormat(string format, object arg0, object arg1)
        {
            log4Net.DebugFormat(format, arg0, arg1);
        }

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        public void DebugFormat(string format, object arg0, object arg1, object arg2)
        {
            log4Net.DebugFormat(format, arg0, arg1, arg2);
        }

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void DebugFormat(IFormatProvider provider, string format, params object[] args)
        {
            log4Net.DebugFormat(provider, format, args);
        }

        /// <summary>
        /// Outputs a message with informational severity.
        /// </summary>
        /// <param name="message">The message.</param>
        public void Info(object message)
        {
            log4Net.Info(message);
        }

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        public void InfoFormat(string format, params object[] args)
        {
            log4Net.InfoFormat(format, args);
        }

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        public void InfoFormat(string format, object arg)
        {
            log4Net.InfoFormat(format, arg);
        }

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        public void InfoFormat(string format, object arg0, object arg1)
        {
            log4Net.InfoFormat(format, arg0, arg1);
        }

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        public void InfoFormat(string format, object arg0, object arg1, object arg2)
        {
            log4Net.InfoFormat(format, arg0, arg1, arg2);
        }

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void InfoFormat(IFormatProvider provider, string format, params object[] args)
        {
            log4Net.InfoFormat(provider, format, args);
        }

        /// <summary>
        /// Outputs a message with warning severity.
        /// </summary>
        /// <param name="message">The message.</param>
        public void Warn(object message)
        {
            log4Net.Warn(message);
        }

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void WarnFormat(string format, params object[] args)
        {
            log4Net.WarnFormat(format, args);
        }

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg"></param>
        public void WarnFormat(string format, object arg)
        {
            log4Net.WarnFormat(format, arg);
        }

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        public void WarnFormat(string format, object arg0, object arg1)
        {
            log4Net.WarnFormat(format, arg0, arg1);
        }

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        public void WarnFormat(string format, object arg0, object arg1, object arg2)
        {
            log4Net.WarnFormat(format, arg0, arg1, arg2);
        }

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void WarnFormat(IFormatProvider provider, string format, params object[] args)
        {
            log4Net.WarnFormat(provider, format, args);
        }

        /// <summary>
        /// Outputs a message with error severity.
        /// </summary>
        /// <param name="message">The message.</param>
        public void Error(object message)
        {
            log4Net.Error(message);
        }

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void ErrorFormat(string format, params object[] args)
        {
            log4Net.ErrorFormat(format, args);
            log4Net.Error("-----------------------------------------------------------------------------------------------------------------------------");
        }

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg"></param>
        public void ErrorFormat(string format, object arg)
        {
            log4Net.ErrorFormat(format, arg);
            log4Net.Error("-----------------------------------------------------------------------------------------------------------------------------");
        }

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        public void ErrorFormat(string format, object arg0, object arg1)
        {
            log4Net.ErrorFormat(format, arg0, arg1);
            log4Net.Error("-----------------------------------------------------------------------------------------------------------------------------");
        }

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        public void ErrorFormat(string format, object arg0, object arg1, object arg2)
        {
            log4Net.ErrorFormat(format, arg0, arg1, arg2);
            log4Net.Error("-----------------------------------------------------------------------------------------------------------------------------");
        }

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void ErrorFormat(IFormatProvider provider, string format, params object[] args)
        {
            log4Net.ErrorFormat(provider, format, args);
            log4Net.Error("-----------------------------------------------------------------------------------------------------------------------------");
        }

        /// <summary>
        /// Outputs a message with fatal severity.
        /// </summary>
        /// <param name="message">The message.</param>
        public void Fatal(object message)
        {
            log4Net.Fatal(message);
        }

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void FatalFormat(string format, params object[] args)
        {
            log4Net.FatalFormat(format, args);
        }

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg"></param>
        public void FatalFormat(string format, object arg)
        {
            log4Net.FatalFormat(format, arg);
        }

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        public void FatalFormat(string format, object arg0, object arg1)
        {
            log4Net.FatalFormat(format, arg0, arg1);
        }

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        public void FatalFormat(string format, object arg0, object arg1, object arg2)
        {
            log4Net.FatalFormat(format, arg0, arg1, arg2);
        }

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public void FatalFormat(IFormatProvider provider, string format, params object[] args)
        {
            log4Net.FatalFormat(provider, format, args);
        }

        /// <summary>
        /// Outputs a message with debug severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        public void Debug(object message, Exception ex)
        {
            log4Net.Debug(message, ex);
        }

        /// <summary>
        /// Outputs a message with information severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        public void Info(object message, Exception ex)
        {
            log4Net.Info(message, ex);
        }

        /// <summary>
        /// Outputs a message with warning severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        public void Warn(object message, Exception ex)
        {
            log4Net.Warn(message, ex);
        }

        /// <summary>
        /// Outputs a message with error severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        public void Error(object message, Exception ex)
        {
            log4Net.Error(message, ex);
        }

        /// <summary>
        /// Outputs a message with fatal severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        public void Fatal(object message, Exception ex)
        {
            log4Net.Fatal(message, ex);
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Sets the log4net configuration file (only once, for the first time).
        /// </summary>
        private void Configure()
        {
            if (isConfigured)
            {
                return;
            }

            XmlConfigurator.Configure();

            isConfigured = true;
        }

        #endregion

        #region Private Attributes 

        private readonly ILog log4Net;
        private bool isConfigured;

        #endregion
    }
}
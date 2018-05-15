
namespace WatchUs.Logging
{
    #region Using Directives Region

    using System;

    #endregion

    /// <summary>
    /// Interface of the logger.
    /// </summary>
    public interface ILogger
    {
        #region Public Methods

        Guid LogException(Exception exception);

        /// <summary>
        /// Outputs a message with debug severity.
        /// </summary>
        /// <param name="message">The message.</param>
        void Debug(object message);

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        void DebugFormat(string format, params object[] args);

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        void DebugFormat(string format, object arg);

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        void DebugFormat(string format, object arg0, object arg1);

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        void DebugFormat(string format, object arg0, object arg1, object arg2);

        /// <summary>
        /// Outputs a formated message with debug severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        void DebugFormat(IFormatProvider provider, string format, params object[] args);

        /// <summary>
        /// Outputs a message with informational severity.
        /// </summary>
        /// <param name="message">The message.</param>
        void Info(object message);

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        void InfoFormat(string format, params object[] args);

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        void InfoFormat(string format, object arg);

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        void InfoFormat(string format, object arg0, object arg1);

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        void InfoFormat(string format, object arg0, object arg1, object arg2);

        /// <summary>
        /// Outputs a formated message with informational severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        void InfoFormat(IFormatProvider provider, string format, params object[] args);

        /// <summary>
        /// Outputs a message with warning severity.
        /// </summary>
        /// <param name="message">The message.</param>
        void Warn(object message);

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        void WarnFormat(string format, params object[] args);

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        void WarnFormat(string format, object arg);

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        void WarnFormat(string format, object arg0, object arg1);

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        void WarnFormat(string format, object arg0, object arg1, object arg2);

        /// <summary>
        /// Outputs a formated message with warning severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        void WarnFormat(IFormatProvider provider, string format, params object[] args);

        /// <summary>
        /// Outputs a message with error severity.
        /// </summary>
        /// <param name="message">The message.</param>
        void Error(object message);

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        void ErrorFormat(string format, params object[] args);

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        void ErrorFormat(string format, object arg);

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        void ErrorFormat(string format, object arg0, object arg1);

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        void ErrorFormat(string format, object arg0, object arg1, object arg2);

        /// <summary>
        /// Outputs a formated message with error severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        void ErrorFormat(IFormatProvider provider, string format, params object[] args);

        /// <summary>
        /// Outputs a message with fatal severity.
        /// </summary>
        /// <param name="message">The message.</param>
        void Fatal(object message);

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="args">The arguments</param>
        void FatalFormat(string format, params object[] args);

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format">The format</param>
        /// <param name="arg">The argument</param>
        void FatalFormat(string format, object arg);

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        void FatalFormat(string format, object arg0, object arg1);

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="format"></param>
        /// <param name="arg0"></param>
        /// <param name="arg1"></param>
        /// <param name="arg2"></param>
        void FatalFormat(string format, object arg0, object arg1, object arg2);

        /// <summary>
        /// Outputs a formated message with fatal severity.
        /// </summary>
        /// <param name="provider"></param>
        /// <param name="format"></param>
        /// <param name="args"></param>
        void FatalFormat(IFormatProvider provider, string format, params object[] args);

        /// <summary>
        /// Outputs a message with debug severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        void Debug(object message, Exception ex);

        /// <summary>
        /// Outputs a message with information severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        void Info(object message, Exception ex);

        /// <summary>
        /// Outputs a message with warning severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        void Warn(object message, Exception ex);

        /// <summary>
        /// Outputs a message with error severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        void Error(object message, Exception ex);

        /// <summary>
        /// Outputs a message with fatal severity.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="ex">The exception to associate with the message.</param>
        void Fatal(object message, Exception ex);

        #endregion
    }
}
namespace WatchUs.Logging
{
    /// <summary>
    /// This class contains extension methods for <see cref="ILogger"/> interface.
    /// </summary>
    public static class ILoggerExtensions
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1062:Validate arguments of public methods", MessageId = "0")]
        public static void Entering(this ILogger logger, string method)
        {
            logger.Debug(string.Format("Entering - {0}", method));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1062:Validate arguments of public methods", MessageId = "0")]
        public static void Leaving(this ILogger logger, string method)
        {
            logger.Debug(string.Format("Leaving - {0}", method));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1062:Validate arguments of public methods", MessageId = "0")]
        public static T Leaving<T>(this ILogger logger, string method, T result)
        {
            logger.Debug(string.Format("Leaving - {0}", method));
            return result;
        }
    }
}
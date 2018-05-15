// -----------------------------------------------------------------------
// <copyright file="ReleaseVersionCloneExceptionHandler.cs" company="Microsoft">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace WatchUs.API.Filters
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http;
    using System.Web.Http.Filters;
    using WatchUs.Logging;
  
   
    
    /// <summary>
    /// release version clone exception handler
    /// </summary>
    public class APIExceptionHandler : ExceptionFilterAttribute
    {
        
        /// <summary>
        /// On exception
        /// </summary>
        #region Private Members
        private static ILogger logger = LogManager.GetLogger(typeof(ApiController));
        #endregion
        /// <summary>
        /// on exception
        /// </summary>
        /// <param name="context">HTTP action executed context</param>
        public override void OnException(HttpActionExecutedContext context)
        {
            Guid guid = logger.LogException(context.Exception);
            throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.InternalServerError)
            {
                Content = new StringContent("An error has occured, please contact Coordify Support with guid " + guid.ToString()),
                ReasonPhrase = "Internal Server Exception"
            });
        }
    }
}

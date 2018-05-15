// -----------------------------------------------------------------------
// <copyright file="ReleaseVersionCloneExceptionHandler.cs" company="Microsoft">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace WatchUs.API.Filters
{
    using System.Net;
    using System.Net.Http;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;

    /// <summary>
    /// release version model validation attribute
    /// </summary>
    public class APIModelValidationAttribute : ActionFilterAttribute
    {
        /// <summary>
        /// on action executing
        /// </summary>
        /// <param name="actionContext">action context</param>
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (!actionContext.ModelState.IsValid)
            {
                //dynamic errors = new JsonObject();
                //JsonValu
                actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.BadRequest, actionContext.ModelState);
            }
            base.OnActionExecuting(actionContext);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace WatchUs.APIService
{
    public class ResultWithChallenge : IHttpActionResult
    {
        private readonly IHttpActionResult next;
        public ResultWithChallenge(IHttpActionResult next)
        {
            this.next = next;
        }
        public async Task<HttpResponseMessage> ExecuteAsync(
          CancellationToken cancellationToken)
        {
            var response = await next.ExecuteAsync(cancellationToken);
            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                response.Headers.WwwAuthenticate.Add(
                  new AuthenticationHeaderValue("basic", "somechallenge"));
            }
            return response;
        }
    }

}
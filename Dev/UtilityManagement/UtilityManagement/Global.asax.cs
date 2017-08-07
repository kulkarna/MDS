using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Configuration;
using UtilityLogging;
using UtilityUnityLogging;

namespace UtilityManagement
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();
            GlobalFilters.Filters.Add(new HandleErrorAttribute());
        }

        protected void Application_Error(Object sender, EventArgs e)
        {
            var exception = Server.GetLastError();
            ILogger _logger = UnityLoggerGenerator.GenerateLogger();
            _logger.LogError(string.Format("UtilityManagement.MvcApplication.Application_Error(Object sender, EventArgs e)  {0} {1} {2}",
                exception.Message, exception.InnerException == null ? string.Empty : exception.InnerException.ToString(), exception.StackTrace ?? string.Empty));
            //if (exception.ToString().Contains("login"))
            //{
            //    try
            //    {
            //        Response.Clear();
            //        string redirectUrl = System.Configuration.ConfigurationManager.AppSettings["RedirectUrl"];
            //        HttpContext.Current.Response.Redirect(redirectUrl);
            //        //Response.End();
            //        //HttpContext.Current.RewritePath("Account/Login");
            //        //Response.Redirect("Account/Login"); 
            //        return;
            ////        Response.RedirectToRoute("Account");
            ////        Response.Redirect("/Account"); 
            ////        return;
            //    }
            //    catch (Exception exc)
            //    {
            //        string s = string.Empty;
            //    }
            //}
            if (exception is HttpUnhandledException)
            {
                Server.Transfer("~/Shared/Error");
            }
            if (exception != null)
            {
                Response.Redirect("/Error");
            }
            try
            {
                // This is to stop a problem where we were seeing "gibberish" in the chrome and firefox browsers
                HttpApplication app = sender as HttpApplication;
                app.Response.Filter = null;
            }
            catch
            {
            }
        }
    }
}
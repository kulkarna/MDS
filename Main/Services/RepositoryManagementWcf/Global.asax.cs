using System;
using System.ServiceModel.Activation;
using System.Web.Routing;

namespace LibertyPower.RepositoryManagement.Web
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            //RouteTable.Routes.Add(new ServiceRoute("Pricing/v1", new NinjectFileLessServiceHostFactory(), typeof(LibertyPower.RepositoryManagement.Pricing.v1.Pricing)));
            RouteTable.Routes.Add(new ServiceRoute("Accounts/v1", new NinjectFileLessServiceHostFactory(), typeof(LibertyPower.RepositoryManagement.v1.Accounts)));
        }

        protected void Session_Start(object sender, EventArgs e)
        {
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {
        }

        protected void Session_End(object sender, EventArgs e)
        {
        }

        protected void Application_End(object sender, EventArgs e)
        {
        }
    }
}
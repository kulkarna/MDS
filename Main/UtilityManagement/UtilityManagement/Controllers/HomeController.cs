using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class HomeController : ControllerBaseWithoutUtilDropDown
    {
        public HomeController()
            : base()
        {
            try
            {
                ViewBag.IndexPageName = "Home";
                ViewBag.PageName = "Home";
                ViewBag.PageDisplayName = "Home";
            }
            catch (Exception exc)
            {
                string s = string.Empty;
            }
        }

        public override ActionResult Index()
        {
            try
            {

                ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";
                ViewBag.UserName = "Not Logged In";
                ViewBag.IndexPageName = "Home";
                //if (Session["UtilityManagement_UserName"] == null || string.IsNullOrWhiteSpace(Session["UtilityManagement_UserName"].ToString()))
                //    return RedirectToAction("Index", "Authentication");

                System.Security.Principal.IPrincipal user = this.HttpContext.User;
                ViewBag.UserName = user.Identity.Name;
                return View();
            }
            catch (Exception)
            {
                return View();
            }
        }
        
        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}

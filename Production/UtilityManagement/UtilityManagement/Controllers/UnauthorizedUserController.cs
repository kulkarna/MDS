using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class UnauthorizedUserController : ControllerBase
    {
        public UnauthorizedUserController()
            : base()
        {
            ViewBag.PageName = "Unauthorized User";
            ViewBag.PageDisplayName = "Unauthorized User";
        }

        //
        // GET: /UnauthorizedUser/
        public ActionResult Index(string activityName)
        {
            try
            {
                UtilityManagement.Models.UnauthorizedUserModel model = new Models.UnauthorizedUserModel();
                model.ActivityName = activityName;
                ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";
                return View(model);
            }
            catch (Exception)
            {
                string s = string.Empty;
                throw;
            }
        }

    }
}

using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class AuthenticationController : Controller
    {
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
        
        #region public constructors
        public AuthenticationController()
        {
            try
            {
                ViewBag.IndexPageName = "Login";
                ViewBag.PageName = "Login";
                ViewBag.PageDisplayName = "Login";
            }
            catch (Exception exc)
            {
                string s = exc.Message;
            }
        }
        #endregion

        //
        // GET: /Account/Login
        //[AllowAnonymous]
        public ActionResult Login()
        {
            ViewBag.IndexPageName = "Login";
            ViewBag.PageName = "Login";
            ViewBag.PageDisplayName = "Login";
            return View();
        }

        //
        // GET: /Account/Login
        //[AllowAnonymous]
        public ActionResult Index()
        {
            Session["LoginError"] = "false";
            ViewBag.IndexPageName = "Login";
            ViewBag.PageName = "Login";
            ViewBag.PageDisplayName = "Login";
            return View(new UtilityManagement.Models.LoginModel() { UserName = "Enter User Name Here", Password = "" });
        }

        [HttpPost]
        public ActionResult Index(UtilityManagement.Models.LoginModel loginModel, string submitButton)
        {
            if (loginModel != null && db.Users.Where(x => x.UserName == loginModel.UserName && x.Password == loginModel.Password).Count() > 0)
            {
                Session["UtilityManagement_UserName"] = loginModel.UserName;
                return RedirectToAction("Index", "Home");
            }
            Session["LoginError"] = "true";
            return View(new UtilityManagement.Models.LoginModel());
        }

        //
        // GET: /Account/Logoff
        [AllowAnonymous]
        public ActionResult Logoff()
        {
            Session["UtilityManagement_UserName"] = null;
            return RedirectToAction("Index", "Home");
        }


        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            Session["UtilityManagement_UserName"] = null;
            return RedirectToAction("Index", "Home");
        }

        //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            Session["RegisterUserNameError"] = "false";
            Session["RegisterPasswordError"] = "false";
            Session["RegisterConfirmPasswordError"] = "false";
            Session["RegisterUserNameExistsError"] = "false";
            ViewBag.Title = "Register";
            ViewBag.IndexPageName = "Register";
            ViewBag.PageName = "Register";
            ViewBag.PageDisplayName = "Register";

            return View(new UtilityManagement.Models.RegisterModel() { UserName = "Enter User Name Here", Password = string.Empty, ConfirmPassword = string.Empty });
        }

        [HttpPost]
        public ActionResult Register(UtilityManagement.Models.RegisterModel registerModel, string submitButton)
        {
            try
            {
                Session["RegisterUserNameError"] = "false";
                Session["RegisterPasswordError"] = "false";
                Session["RegisterConfirmPasswordError"] = "false";
                Session["RegisterUserNameExistsError"] = "false";
                if (registerModel != null && db.Users.Where(x => x.UserName == registerModel.UserName).Count() > 0)
                {
                    Session["RegisterUserNameExistsError"] = "true";
                    return View(registerModel);
                }
                if (registerModel != null && (string.IsNullOrWhiteSpace(registerModel.UserName) || registerModel.UserName.Length <= 5))
                {
                    Session["RegisterUserNameError"] = "true";
                    return View(registerModel);
                }
                if (registerModel != null && (string.IsNullOrWhiteSpace(registerModel.Password) || registerModel.Password.Length <= 5))
                {
                    Session["RegisterPasswordError"] = "true";
                    return View(registerModel);
                }
                if (registerModel != null && !string.IsNullOrWhiteSpace(registerModel.Password) && registerModel.ConfirmPassword != registerModel.Password)
                {
                    Session["RegisterConfirmPasswordError"] = "true";
                    return View(registerModel);
                }
                User user = new User()
                {
                    Id = Guid.NewGuid(),
                    UserName = registerModel.UserName,
                    Password = registerModel.Password,
                    CreatedBy = registerModel.UserName,
                    LastModifiedBy = registerModel.UserName,
                    CreatedDate = DateTime.Now,
                    LastModifiedDate = DateTime.Now,
                    Inactive = false
                };
                db.Users.Add(user);
                db.SaveChanges();

                //_logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "Home");
            }
            catch (Exception exc)
            {
                string s = string.Empty;
                return RedirectToAction("Index", "Error");
            }
        }
        //
        // GET: /Account/ExternalLoginFailure
        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        #region Helpers
        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
        }
        #endregion
    }
}

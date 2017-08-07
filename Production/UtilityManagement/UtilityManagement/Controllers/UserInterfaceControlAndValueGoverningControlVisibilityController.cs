using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Utilities;
using UserInterfaceValidationExtensions;
using UtilityLogging;
using UtilityUnityLogging;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class UserInterfaceControlAndValueGoverningControlVisibilityController : Controller
    {
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
        private const string CLASS = "UserInterfaceControlAndValueGoverningControlVisibilityController";
        private ILogger _logger = UnityLoggerGenerator.GenerateLogger();

        //
        // GET: /UserInterfaceControlAndValueGoverningControlVisibility/
        public ActionResult Index()
        {
            var userinterfacecontrolandvaluegoverningcontrolvisibilities = db.UserInterfaceControlAndValueGoverningControlVisibilities.Include(u => u.UserInterfaceForm).Include(u => u.UserInterfaceFormControl);
            return View(userinterfacecontrolandvaluegoverningcontrolvisibilities.ToList());
        }

        //
        // GET: /UserInterfaceControlAndValueGoverningControlVisibility/Details/5
        public ActionResult Details(Guid id)
        {
            UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility = db.UserInterfaceControlAndValueGoverningControlVisibilities.Find(id);
            if (userinterfacecontrolandvaluegoverningcontrolvisibility == null)
            {
                return HttpNotFound();
            }
            return View(userinterfacecontrolandvaluegoverningcontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlAndValueGoverningControlVisibility/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            UserInterfaceControlAndValueGoverningControlVisibility userInterfaceControlAndValueGoverningControlVisibility = new UserInterfaceControlAndValueGoverningControlVisibility()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };

            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName");
            ViewBag.UserInterfaceFormControlGoverningVisibilityId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName");
            return View(userInterfaceControlAndValueGoverningControlVisibility);
        }

        //
        // POST: /UserInterfaceControlAndValueGoverningControlVisibility/Create
        [HttpPost]
        public ActionResult Create(UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfacecontrolandvaluegoverningcontrolvisibility.Id = Guid.NewGuid();
                userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedDate = DateTime.Now;
                userinterfacecontrolandvaluegoverningcontrolvisibility.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfacecontrolandvaluegoverningcontrolvisibility.LastModifiedDate = DateTime.Now;
                if (userinterfacecontrolandvaluegoverningcontrolvisibility.IsUserInterfaceControlAndValueGoverningControlVisibilityValid())
                {
                    db.UserInterfaceControlAndValueGoverningControlVisibilities.Add(userinterfacecontrolandvaluegoverningcontrolvisibility);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }

            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlGoverningVisibilityId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormControlGoverningVisibilityId);
            return View(userinterfacecontrolandvaluegoverningcontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlAndValueGoverningControlVisibility/Edit/5
        public ActionResult Edit(Guid id)
        {
            Session["IsPostBack"] = "false";
            UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility = db.UserInterfaceControlAndValueGoverningControlVisibilities.Find(id);
            if (userinterfacecontrolandvaluegoverningcontrolvisibility == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedBy;
            Session["CreatedDate"] = userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedDate;
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlGoverningVisibilityId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormControlGoverningVisibilityId);
            return View(userinterfacecontrolandvaluegoverningcontrolvisibility);
        }

        //
        // POST: /UserInterfaceControlAndValueGoverningControlVisibility/Edit/5
        [HttpPost]
        public ActionResult Edit(UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedBy = Session["CreatedBy"] == null ? "NULL USER NAME" : Session["CreatedBy"].ToString();
                userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedDate = Session["CreatedDate"] == null ? DateTime.Now : (DateTime)Session["CreatedDate"];
                userinterfacecontrolandvaluegoverningcontrolvisibility.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfacecontrolandvaluegoverningcontrolvisibility.LastModifiedDate = DateTime.Now;
                if (userinterfacecontrolandvaluegoverningcontrolvisibility.IsUserInterfaceControlAndValueGoverningControlVisibilityValid())
                {
                    db.Entry(userinterfacecontrolandvaluegoverningcontrolvisibility).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                Session["CreatedBy"] = userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedBy;
                Session["CreatedDate"] = userinterfacecontrolandvaluegoverningcontrolvisibility.CreatedDate;
            }
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlGoverningVisibilityId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolandvaluegoverningcontrolvisibility.UserInterfaceFormControlGoverningVisibilityId);
            return View(userinterfacecontrolandvaluegoverningcontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlAndValueGoverningControlVisibility/Delete/5
        public ActionResult Delete(Guid id)
        {
            UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility = db.UserInterfaceControlAndValueGoverningControlVisibilities.Find(id);
            if (userinterfacecontrolandvaluegoverningcontrolvisibility == null)
            {
                return HttpNotFound();
            }
            return View(userinterfacecontrolandvaluegoverningcontrolvisibility);
        }

        //
        // POST: /UserInterfaceControlAndValueGoverningControlVisibility/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            UserInterfaceControlAndValueGoverningControlVisibility userinterfacecontrolandvaluegoverningcontrolvisibility = db.UserInterfaceControlAndValueGoverningControlVisibilities.Find(id);
            db.UserInterfaceControlAndValueGoverningControlVisibilities.Remove(userinterfacecontrolandvaluegoverningcontrolvisibility);
            db.SaveChanges();
            return RedirectToAction("Index");
        }


        [HttpPost]
        public JsonResult PopulateUserInterfaceFormIdList(string userInterfaceFormId)
        {
            string method = string.Format("PopulateUserInterfaceFormIdList(userInterfaceFormId:{0})", userInterfaceFormId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = db.usp_UserInterfaceFormControls_SELECT_By_UserInterfaceFormId(userInterfaceFormId).ToList().OrderBy(x => x.ControlName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }


        [HttpPost]
        public JsonResult PopulateUserInterfaceFormControlValueList(string userInterfaceFormId)
        {
            string method = string.Format("PopulateUserInterfaceFormControlValueList(userInterfaceFormId:{0})", userInterfaceFormId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                var data = db.usp_UserInterfaceFormControlValues_SELECT_By_UserInterfaceFormControlId(userInterfaceFormId).ToList().OrderBy(x => x.ControlValueGoverningVisibiltiy);
                jsonResult.Data = db.usp_UserInterfaceFormControlValues_SELECT_By_UserInterfaceFormControlId(userInterfaceFormId).ToList().OrderBy(x => x.ControlValueGoverningVisibiltiy);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }


        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }

        private void VerifyMessageIdAndErrorMessageSession()
        {
            Session[Common.ERRORMESSAGE] = string.Empty;
            if (Session[Common.MESSAGEID] == null || string.IsNullOrWhiteSpace(Session[Common.MESSAGEID].ToString()))
                Session[Common.MESSAGEID] = Guid.NewGuid().ToString();
        }

        private void ErrorHandler(Exception exc, string method)
        {
            _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, exc.Message), exc);
            _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, Common.END));
            Session[Common.ERRORMESSAGE] = exc == null ? "NULL EXCEPTION OBJECT" : exc.Message;
        }

    }
}
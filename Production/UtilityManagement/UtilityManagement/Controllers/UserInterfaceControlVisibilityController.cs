using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;
using UtilityManagementRepository;
using UtilityLogging;
using UtilityUnityLogging;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class UserInterfaceControlVisibilityController : Controller
    {
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
        private const string CLASS = "UserInterfaceControlAndValueGoverningControlVisibilityController";
        private ILogger _logger = UnityLoggerGenerator.GenerateLogger();

        //
        // GET: /UserInterfaceControlVisibility/
        public ActionResult Index()
        {
            var userinterfacecontrolvisibilities = db.UserInterfaceControlVisibilities.Include(u => u.UserInterfaceControlAndValueGoverningControlVisibility).Include(u => u.UserInterfaceForm).Include(u => u.UserInterfaceFormControl);
            return View(userinterfacecontrolvisibilities.ToList());
        }

        //
        // GET: /UserInterfaceControlVisibility/Details/5
        public ActionResult Details(Guid id)
        {
            UserInterfaceControlVisibility userinterfacecontrolvisibility = db.UserInterfaceControlVisibilities.Find(id);
            if (userinterfacecontrolvisibility == null)
            {
                return HttpNotFound();
            }
            return View(userinterfacecontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlVisibility/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            UserInterfaceControlVisibility userInterfaceControlVisibility = new UserInterfaceControlVisibility()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };

            ViewBag.UserInterfaceControlAndValueGoverningControlVisibilityId = new SelectList(db.UserInterfaceControlAndValueGoverningControlVisibilities, "Id", "ControlValueGoverningVisibiltiy");
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName");
            ViewBag.UserInterfaceFormControlId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName");
            return View(userInterfaceControlVisibility);
        }

        //
        // POST: /UserInterfaceControlVisibility/Create

        [HttpPost]
        public ActionResult Create(UserInterfaceControlVisibility userinterfacecontrolvisibility)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfacecontrolvisibility.Id = Guid.NewGuid();
                userinterfacecontrolvisibility.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                userinterfacecontrolvisibility.CreatedDate = DateTime.Now;
                userinterfacecontrolvisibility.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                userinterfacecontrolvisibility.LastModifiedDate = DateTime.Now;
                if (userinterfacecontrolvisibility.IsUserInterfaceControlVisibilityValid())
                {
                    db.UserInterfaceControlVisibilities.Add(userinterfacecontrolvisibility);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }

            ViewBag.UserInterfaceControlAndValueGoverningControlVisibilityId = new SelectList(db.UserInterfaceControlAndValueGoverningControlVisibilities, "Id", "ControlValueGoverningVisibiltiy", userinterfacecontrolvisibility.UserInterfaceControlAndValueGoverningControlVisibilityId);
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolvisibility.UserInterfaceFormControlId);
            return View(userinterfacecontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlVisibility/Edit/5
        public ActionResult Edit(Guid id)
        {
            Session["IsPostBack"] = "false";
            UserInterfaceControlVisibility userinterfacecontrolvisibility = db.UserInterfaceControlVisibilities.Find(id);
            if (userinterfacecontrolvisibility == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = userinterfacecontrolvisibility.CreatedBy;
            Session["CreatedDate"] = userinterfacecontrolvisibility.CreatedDate;

            ViewBag.UserInterfaceControlAndValueGoverningControlVisibilityId = new SelectList(db.UserInterfaceControlAndValueGoverningControlVisibilities, "Id", "ControlValueGoverningVisibiltiy", userinterfacecontrolvisibility.UserInterfaceControlAndValueGoverningControlVisibilityId);
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolvisibility.UserInterfaceFormControlId);
            return View(userinterfacecontrolvisibility);
        }

        //
        // POST: /UserInterfaceControlVisibility/Edit/5
        [HttpPost]
        public ActionResult Edit(UserInterfaceControlVisibility userinterfacecontrolvisibility)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfacecontrolvisibility.CreatedBy = Session["CreatedBy"] == null ? "NULL USER NAME" : Session["CreatedBy"].ToString();
                userinterfacecontrolvisibility.CreatedDate = Session["CreatedDate"] == null ? DateTime.Now : (DateTime)Session["CreatedDate"];
                userinterfacecontrolvisibility.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfacecontrolvisibility.LastModifiedDate = DateTime.Now;
                if (userinterfacecontrolvisibility.IsUserInterfaceControlVisibilityValid())
                {
                    db.Entry(userinterfacecontrolvisibility).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                Session["CreatedBy"] = userinterfacecontrolvisibility.CreatedBy;
                Session["CreatedDate"] = userinterfacecontrolvisibility.CreatedDate;
            }
            ViewBag.UserInterfaceControlAndValueGoverningControlVisibilityId = new SelectList(db.UserInterfaceControlAndValueGoverningControlVisibilities, "Id", "ControlValueGoverningVisibiltiy", userinterfacecontrolvisibility.UserInterfaceControlAndValueGoverningControlVisibilityId);
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfacecontrolvisibility.UserInterfaceFormId);
            ViewBag.UserInterfaceFormControlId = new SelectList(db.UserInterfaceFormControls, "Id", "ControlName", userinterfacecontrolvisibility.UserInterfaceFormControlId);
            return View(userinterfacecontrolvisibility);
        }

        //
        // GET: /UserInterfaceControlVisibility/Delete/5
        public ActionResult Delete(Guid id)
        {
            UserInterfaceControlVisibility userinterfacecontrolvisibility = db.UserInterfaceControlVisibilities.Find(id);
            if (userinterfacecontrolvisibility == null)
            {
                return HttpNotFound();
            }
            return View(userinterfacecontrolvisibility);
        }

        //
        // POST: /UserInterfaceControlVisibility/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            UserInterfaceControlVisibility userinterfacecontrolvisibility = db.UserInterfaceControlVisibilities.Find(id);
            db.UserInterfaceControlVisibilities.Remove(userinterfacecontrolvisibility);
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
                //var data = db.usp_UserInterfaceFormControl_SELECT_By_UserInterfaceFormId(userInterfaceFormId).ToList().OrderBy(x => x.ControlName);
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
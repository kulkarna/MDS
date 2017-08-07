using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using UtilityManagementRepository;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class RateClassAliasController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "RateClassAliasController";
        private const string UTILITYMANAGEMENT_RATECLASS_INDEX = "UTILITYMANAGEMENT_RATECLASS_INDEX";
        private const string UTILITYMANAGEMENT_RATECLASS_CREATE = "UTILITYMANAGEMENT_RATECLASS_CREATE";
        private const string UTILITYMANAGEMENT_RATECLASS_EDIT = "UTILITYMANAGEMENT_RATECLASS_EDIT";
        private const string UTILITYMANAGEMENT_RATECLASS_DETAIL = "UTILITYMANAGEMENT_RATECLASS_DETAIL";
        private const string UTILITYMANAGEMENT_RATECLASS_UPLD = "UTILITYMANAGEMENT_RATECLASS_UPLD";
        private const string UTILITYMANAGEMENT_RATECLASS_DOWNLD = "UTILITYMANAGEMENT_RATECLASS_DOWNLD";
        #endregion

        #region public constructors
        public RateClassAliasController()
            : base()
        {
            ViewBag.PageName = "RateClassAlias";
            ViewBag.IndexPageName = "RateClass";
            ViewBag.PageDisplayName = "Rate Class Alias";
        }
        #endregion

        #region public methods
        //
        // GET: /RateClassAlias/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_DETAIL });
                }

                RateClassAlia rateClassAlias = _db.RateClassAlias.Find(id);

                if (rateClassAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClassAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClassAlias));
                return View(rateClassAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        [HttpPost]
        public ActionResult Details(RateClassAlia rateClassAlias, string submitButton)
        {
            string method = string.Format(" Details(RateClassAlia rateClassAlias{0}, submitButton:{1})", rateClassAlias == null ? "NULL VALUE" : rateClassAlias.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_DETAIL });
                }

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RateClassAlias", new { id = rateClassAlias.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "RateClass");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        //
        // GET: /RateClassAlias/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_CREATE });
                }

                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                RateClassAlia rateClassAlias = new RateClassAlia()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RateClassId = GetRateClassSelectListById(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClassAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClassAlias));
                return View(rateClassAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RateClassAlia rateClassAlias = new RateClassAlia();
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                ViewBag.RateClassId = GetRateClassSelectListById(uci);
                return View(rateClassAlias);
            }
        }

        //
        // POST: /RateClassAlias/Create
        [HttpPost]
        public ActionResult Create(RateClassAlia rateClassAlias, string submitButton)
        {
            string method = string.Format("Create(RateClassAlia rateClassAlias:{0}, submitButton:{1})", rateClassAlias == null ? "NULL VALUE" : rateClassAlias.ToString(), submitButton ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                rateClassAlias.Id = Guid.NewGuid();
                rateClassAlias.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                rateClassAlias.CreatedDate = DateTime.Now;
                rateClassAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                rateClassAlias.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid &&
                    rateClassAlias.IsRateClassAliasValid()
                        && _db.RateClassAlias.Where(x => x.RateClassId == rateClassAlias.RateClassId && x.RateClassCodeAlias == rateClassAlias.RateClassCodeAlias && x.Id != rateClassAlias.Id).Count<RateClassAlia>() == 0)
                {
                    _db.RateClassAlias.Add(rateClassAlias);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "RateClass");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                ViewBag.RateClassId = GetRateClassSelectListById(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(rateClassAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                ViewBag.RateClassId = GetRateClassSelectListById(uci);
                return View(new RateClass());
            }
        }

        //
        // GET: /RateClassAlias/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_EDIT });
                }

                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                RateClassAlia rateClassAlias = _db.RateClassAlias.Find(id);
                if (rateClassAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = rateClassAlias.CreatedBy;
                Session[Common.CREATEDDATE] = rateClassAlias.CreatedDate;
                Session["RateClassId"] = rateClassAlias.RateClassId;

                ViewBag.RateClassId = GetRateClassSelectList(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClassAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClassAlias));

                return View(rateClassAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RateClassAlia rateClassAlias = _db.RateClassAlias.Find(id);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                ViewBag.RateClassId = GetRateClassSelectList(uci);
                return View(rateClassAlias);
            }
        }

        //
        // POST: /RateClassAlias/Edit/5
        [HttpPost]
        public ActionResult Edit(RateClassAlia rateClassAlias, string submitButton)
        {
            string method = string.Format("Edit(RateClassAlia rateClassAlias:{0})", rateClassAlias == null ? "NULL VALUE" : rateClassAlias.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                rateClassAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                rateClassAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                rateClassAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; 
                rateClassAlias.LastModifiedDate = DateTime.Now;
                rateClassAlias.RateClassId = Common.NullSafeGuid(Session["RateClassId"]);
                if (ModelState.IsValid &&
                    rateClassAlias.IsRateClassAliasValid()
                        && _db.RateClassAlias.Where(x => x.RateClassId == rateClassAlias.RateClassId && x.RateClassCodeAlias == rateClassAlias.RateClassCodeAlias && x.Id != rateClassAlias.Id).Count<RateClassAlia>() == 0)
                {
                    _db.Entry(rateClassAlias).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "RateClass");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                string rateClassCodeAlias = rateClassAlias.RateClassCodeAlias;
                rateClassAlias = _db.RateClassAlias.Find(rateClassAlias.Id);
                rateClassAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                rateClassAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                rateClassAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                rateClassAlias.LastModifiedDate = DateTime.Now;
                rateClassAlias.RateClassCodeAlias = rateClassCodeAlias;
                ViewBag.RateClassId = GetRateClassSelectList(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(rateClassAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                ViewBag.RateClassId = GetRateClassSelectList(uci);
                return View(rateClassAlias);
            }
        }

        public ActionResult RateClassIdTitleClick()
        {
            string method = "RateClassIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RateClassAliasTitleClick()
        {
            string method = "RateClassAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassAlias");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
        #endregion
    }
}
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
    public class LpStandardRateClassController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "LpStandardRateClassController";
        private const string UTILITYMANAGEMENT_RATECLASS_INDEX = "UTILITYMANAGEMENT_RATECLASS_INDEX";
        private const string UTILITYMANAGEMENT_RATECLASS_CREATE = "UTILITYMANAGEMENT_RATECLASS_CREATE";
        private const string UTILITYMANAGEMENT_RATECLASS_EDIT = "UTILITYMANAGEMENT_RATECLASS_EDIT";
        private const string UTILITYMANAGEMENT_RATECLASS_DETAIL = "UTILITYMANAGEMENT_RATECLASS_DETAIL";
        private const string UTILITYMANAGEMENT_RATECLASS_UPLD = "UTILITYMANAGEMENT_RATECLASS_UPLD";
        private const string UTILITYMANAGEMENT_RATECLASS_DOWNLD = "UTILITYMANAGEMENT_RATECLASS_DOWNLD";
        #endregion

        #region public constructors
        public LpStandardRateClassController()
            : base()
        {
            ViewBag.PageName = "LpStandardRateClass";
            ViewBag.IndexPageName = "RateClass";
            ViewBag.PageDisplayName = "LP Standard Rate Class";
        }
        #endregion

        #region public methods
        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_RATECLASS_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<RateClass>());
        }

        //
        // GET: /RateClass/Details/5
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

                LpStandardRateClass lpStandardRateClass = _db.LpStandardRateClasses.Find(id);

                if (lpStandardRateClass == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardRateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardRateClass));
                return View(lpStandardRateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        [HttpPost]
        public ActionResult Details(LpStandardRateClass lpStandardRateClass, string submitButton)
        {
            string method = string.Format(" Details(LpStandardRateClass lpStandardRateClass{0}, submitButton:{1})", lpStandardRateClass == null ? "NULL VALUE" : lpStandardRateClass.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LpStandardRateClass", new { id = lpStandardRateClass.Id });
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
        // GET: /RateClass/Create
        public ActionResult Create(string utilityCompanyId)
        {
            string method = "Create(utilityCompanyId)";
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
                LpStandardRateClass lpStandardRateClass = new LpStandardRateClass()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardRateClass));
                return View(lpStandardRateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        //
        // POST: /RateClass/Create
        [HttpPost]
        public ActionResult Create(LpStandardRateClass lpStandardRateClass)
        {
            string method = string.Format("Create(LpStandardRateClass lpStandardRateClass:{0})", lpStandardRateClass == null ? "NULL VALUE" : lpStandardRateClass.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = GetUserName(messageId);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                lpStandardRateClass.Id = Guid.NewGuid();
                lpStandardRateClass.CreatedBy = userName;
                lpStandardRateClass.CreatedDate = DateTime.Now;
                lpStandardRateClass.LastModifiedBy = userName;
                lpStandardRateClass.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid &&
                    lpStandardRateClass.IsLpStandardRateClassValid() &&
                    _db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == lpStandardRateClass.UtilityCompanyId && x.LpStandardRateClassCode == lpStandardRateClass.LpStandardRateClassCode && x.Id != lpStandardRateClass.Id).Count<LpStandardRateClass>() == 0)
                {
                    _db.LpStandardRateClasses.Add(lpStandardRateClass);
                    _db.SaveChanges();
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "RateClass");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardRateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(new LpStandardRateClass());
            }
        }

        //
        // GET: /RateClass/Edit/5
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
                
                Session[Common.ISPOSTBACK] = "false";
                LpStandardRateClass lpStandardRateClass = _db.LpStandardRateClasses.Find(id);
                if (lpStandardRateClass == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = lpStandardRateClass.CreatedBy;
                Session[Common.CREATEDDATE] = lpStandardRateClass.CreatedDate;
                Session["UtilityCompanyId"] = lpStandardRateClass.UtilityCompanyId;
                Session["UtilityCompanyName"] = lpStandardRateClass.UtilityCompany.UtilityCode;
                Session["LpStandardRateClassCode"] = lpStandardRateClass.LpStandardRateClassCode;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(lpStandardRateClass.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardRateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardRateClass));

                return View(lpStandardRateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RateClass rateClass = _db.RateClasses.Find(id);
                return View(rateClass);
            }
        }

        //
        // POST: /RateClass/Edit/5
        [HttpPost]
        public ActionResult Edit(LpStandardRateClass lpStandardRateClass, string submitButton)
        {
            string method = string.Format("Edit(LpStandardRateClass lpStandardRateClass:{0})", lpStandardRateClass == null ? "NULL VALUE" : lpStandardRateClass.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = GetUserName(messageId);
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                lpStandardRateClass.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                lpStandardRateClass.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                lpStandardRateClass.LastModifiedBy = userName; // GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                lpStandardRateClass.LastModifiedDate = DateTime.Now;
                lpStandardRateClass.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                if (ModelState.IsValid
                        && _db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == lpStandardRateClass.UtilityCompanyId && x.LpStandardRateClassCode == lpStandardRateClass.LpStandardRateClassCode && x.Id != lpStandardRateClass.Id).Count<LpStandardRateClass>() == 0
                        && lpStandardRateClass.IsLpStandardRateClassValid())
                {
                    _db.Entry(lpStandardRateClass).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "RateClass");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                lpStandardRateClass.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                lpStandardRateClass.UtilityCompany = _db.LpStandardRateClasses.Find(lpStandardRateClass.Id).UtilityCompany;
                lpStandardRateClass.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardRateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                lpStandardRateClass = _db.LpStandardRateClasses.Find(lpStandardRateClass.Id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(lpStandardRateClass.UtilityCompanyId.ToString());
                return View(lpStandardRateClass);
            }
        }

        public ActionResult UtilityCodeTitleClick()
        {
            string method = "UtilityCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LpStandardRateClassCodeTitleClick()
        {
            string method = "LpStandardRateClassCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardRateClassCode");

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

        private List<LpStandardRateClass> ObtainResponse()
        {
            var response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LpStandardRateClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClassCode).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClassCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }

        public override ActionResult ObtainActionResult()
        {
            var response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LpStandardRateClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClassCode).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClassCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return View(response);
        }
        #endregion
    }
}
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
    public class LpStandardTariffCodeController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "LpStandardTariffCodeController";
        private const string UTILITYMANAGEMENT_TARIFFCODE_INDEX = "UTILITYMANAGEMENT_TARIFFCODE_INDEX";
        private const string UTILITYMANAGEMENT_TARIFFCODE_CREATE = "UTILITYMANAGEMENT_TARIFFCODE_CREATE";
        private const string UTILITYMANAGEMENT_TARIFFCODE_EDIT = "UTILITYMANAGEMENT_TARIFFCODE_EDIT";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DETAIL = "UTILITYMANAGEMENT_TARIFFCODE_DETAIL";
        private const string UTILITYMANAGEMENT_TARIFFCODE_UPLD = "UTILITYMANAGEMENT_TARIFFCODE_UPLD";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DOWNLD = "UTILITYMANAGEMENT_TARIFFCODE_DOWNLD";
        #endregion

        #region public constructors
        public LpStandardTariffCodeController()
            : base()
        {
            ViewBag.PageName = "LpStandardTariffCode";
            ViewBag.IndexPageName = "TariffCode";
            ViewBag.PageDisplayName = "Lp Standard Tariff Code";
        }
        #endregion

        #region public methods
        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_TARIFFCODE_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<TariffCode>());
        }

        //
        // GET: /TariffCode/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_DETAIL });
                }

                LpStandardTariffCode lpStandardTariffCode = _db.LpStandardTariffCodes.Find(id);

                if (lpStandardTariffCode == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardTariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardTariffCode));
                return View(lpStandardTariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        [HttpPost]
        public ActionResult Details(LpStandardTariffCode lpStandardTariffCode, string submitButton)
        {
            string method = string.Format(" Details(LpStandardTariffCode lpStandardTariffCode{0}, submitButton:{1})", lpStandardTariffCode == null ? "NULL VALUE" : lpStandardTariffCode.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LpStandardTariffCode", new { id = lpStandardTariffCode.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "TariffCode");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        //
        // GET: /TariffCode/Create
        public ActionResult Create(string utilityCompanyId)
        {
            string method = string.Format("Create(utilityCompanyId:{0})", utilityCompanyId ?? "NULL");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_CREATE });
                }

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());

                Session[Common.ISPOSTBACK] = "false";
                LpStandardTariffCode lpStandardTariffCode = new LpStandardTariffCode()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci
                };
                SetViewBag();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardTariffCode));
                return View(lpStandardTariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        private void SetViewBag()
        {
            Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
            ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
        }

        //
        // POST: /TariffCode/Create
        [HttpPost]
        public ActionResult Create(LpStandardTariffCode lpStandardTariffCode)
        {
            string method = string.Format("Create(LpStandardTariffCode lpStandardTariffCode:{0})", lpStandardTariffCode == null ? "NULL VALUE" : lpStandardTariffCode.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                lpStandardTariffCode.Id = Guid.NewGuid();
                lpStandardTariffCode.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                lpStandardTariffCode.CreatedDate = DateTime.Now;
                lpStandardTariffCode.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                lpStandardTariffCode.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid &&
                    lpStandardTariffCode.IsLpStandardTariffCodeValid() &&
                    _db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == lpStandardTariffCode.UtilityCompanyId && x.LpStandardTariffCodeCode == lpStandardTariffCode.LpStandardTariffCodeCode && x.Id != lpStandardTariffCode.Id).Count<LpStandardTariffCode>() == 0)
                {
                    _db.LpStandardTariffCodes.Add(lpStandardTariffCode);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                SetViewBag();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardTariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                SetViewBag();

                return View(new LpStandardTariffCode());
            }
        }

        //
        // GET: /TariffCode/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                LpStandardTariffCode lpStandardTariffCode = _db.LpStandardTariffCodes.Find(id);
                if (lpStandardTariffCode == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = lpStandardTariffCode.CreatedBy;
                Session[Common.CREATEDDATE] = lpStandardTariffCode.CreatedDate;
                Session["UtilityCompanyId"] = lpStandardTariffCode.UtilityCompanyId;
                Session["UtilityCompanyName"] = lpStandardTariffCode.UtilityCompany.UtilityCode;
                Session["LpStandardTariffCodeCode"] = lpStandardTariffCode.LpStandardTariffCodeCode;

                SetViewBag();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardTariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardTariffCode));

                return View(lpStandardTariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                TariffCode TariffCode = _db.TariffCodes.Find(id);
                return View(TariffCode);
            }
        }

        //
        // POST: /TariffCode/Edit/5
        [HttpPost]
        public ActionResult Edit(LpStandardTariffCode lpStandardTariffCode, string submitButton)
        {
            string method = string.Format("Edit(LpStandardTariffCode lpStandardTariffCode:{0})", lpStandardTariffCode == null ? "NULL VALUE" : lpStandardTariffCode.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                lpStandardTariffCode.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                lpStandardTariffCode.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                lpStandardTariffCode.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                lpStandardTariffCode.LastModifiedDate = DateTime.Now;
                lpStandardTariffCode.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                if (ModelState.IsValid
                    && lpStandardTariffCode.IsLpStandardTariffCodeValid()
                    && _db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == lpStandardTariffCode.UtilityCompanyId && x.LpStandardTariffCodeCode == lpStandardTariffCode.LpStandardTariffCodeCode && x.Id != lpStandardTariffCode.Id).Count<LpStandardTariffCode>() == 0)
                {
                    _db.Entry(lpStandardTariffCode).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                SetViewBag();
                lpStandardTariffCode.UtilityCompany = _db.LpStandardTariffCodes.Find(lpStandardTariffCode.Id).UtilityCompany;
                lpStandardTariffCode.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardTariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                lpStandardTariffCode = _db.LpStandardTariffCodes.Find(lpStandardTariffCode.Id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(lpStandardTariffCode.UtilityCompanyId.ToString());
                return View(lpStandardTariffCode);
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

        public ActionResult LpStandardTariffCodeCodeTitleClick()
        {
            string method = "LpStandardTariffCodeCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardTariffCodeCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult InactiveTitleClick()
        //{
        //    string method = "InactiveTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("Inactive");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        //public ActionResult CreatedByTitleClick()
        //{
        //    string method = "CreatedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        //public ActionResult CreatedDateTitleClick()
        //{
        //    string method = "CreatedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        //public ActionResult LastModifiedByTitleClick()
        //{
        //    string method = "LastModifiedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        //public ActionResult LastModifiedDateTitleClick()
        //{
        //    string method = "LastModifiedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<LpStandardTariffCode> ObtainResponse()
        {
            var response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LpStandardTariffCodeCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardTariffCodeCode).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardTariffCodeCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}
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
    public class LpStandardLoadProfileController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "LpStandardLoadProfileController";
        private const string UTILITYMANAGEMENT_LOADPROFILE_INDEX = "UTILITYMANAGEMENT_LOADPROFILE_INDEX";
        private const string UTILITYMANAGEMENT_LOADPROFILE_CREATE = "UTILITYMANAGEMENT_LOADPROFILE_CREATE";
        private const string UTILITYMANAGEMENT_LOADPROFILE_EDIT = "UTILITYMANAGEMENT_LOADPROFILE_EDIT";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DETAIL = "UTILITYMANAGEMENT_LOADPROFILE_DETAIL";
        private const string UTILITYMANAGEMENT_LOADPROFILE_UPLD = "UTILITYMANAGEMENT_LOADPROFILE_UPLD";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DOWNLD = "UTILITYMANAGEMENT_LOADPROFILE_DOWNLD";
        #endregion

        #region public constructors
        public LpStandardLoadProfileController()
            : base()
        {
            ViewBag.PageName = "LpStandardLoadProfile";
            ViewBag.IndexPageName = "LoadProfile";
            ViewBag.PageDisplayName = "LP Standard Load Profile";
        }
        #endregion

        #region public methods
        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_LOADPROFILE_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<LoadProfile>());
        }

        //
        // GET: /LoadProfile/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_DETAIL });
                }

                LpStandardLoadProfile lpStandardLoadProfile = _db.LpStandardLoadProfiles.Find(id);

                if (lpStandardLoadProfile == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardLoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardLoadProfile));
                return View(lpStandardLoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LoadProfile());
            }
        }

        [HttpPost]
        public ActionResult Details(LpStandardLoadProfile lpStandardLoadProfile, string submitButton)
        {
            string method = string.Format(" Details(LpStandardLoadProfile lpStandardLoadProfile{0}, submitButton:{1})", lpStandardLoadProfile == null ? "NULL VALUE" : lpStandardLoadProfile.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LpStandardLoadProfile", new { id = lpStandardLoadProfile.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "LoadProfile");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LoadProfile());
            }
        }

        //
        // GET: /LoadProfile/Create
        public ActionResult Create(string utilityCompanyId)
        {
            string method = "Create(utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_CREATE });
                }

                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());

                Session[Common.ISPOSTBACK] = "false";
                LpStandardLoadProfile lpStandardLoadProfile = new LpStandardLoadProfile()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci
                };
                SetViewBag();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardLoadProfile));
                return View(lpStandardLoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LpStandardLoadProfile());
            }
        }

        //
        // POST: /LoadProfile/Create
        [HttpPost]
        public ActionResult Create(LpStandardLoadProfile lpStandardLoadProfile)
        {
            string method = string.Format("Create(LpStandardLoadProfile lpStandardLoadProfile:{0})", lpStandardLoadProfile == null ? "NULL VALUE" : lpStandardLoadProfile.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                lpStandardLoadProfile.Id = Guid.NewGuid();
                lpStandardLoadProfile.CreatedBy = Common.NullSafeString(GetUserName(messageId));
                lpStandardLoadProfile.CreatedDate = DateTime.Now;
                lpStandardLoadProfile.LastModifiedBy = Common.NullSafeString(GetUserName(messageId));
                lpStandardLoadProfile.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid &&
                    lpStandardLoadProfile.IsLpStandardLoadProfileValid() &&
                    _db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == lpStandardLoadProfile.UtilityCompanyId && x.LpStandardLoadProfileCode == lpStandardLoadProfile.LpStandardLoadProfileCode && x.Id != lpStandardLoadProfile.Id).Count<LpStandardLoadProfile>() == 0)
                {
                    _db.LpStandardLoadProfiles.Add(lpStandardLoadProfile);
                    _db.SaveChanges();
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "LoadProfile");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                SetViewBag();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardLoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(new LpStandardLoadProfile());
            }
        }

        private void SetViewBag()
        {
            Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
            ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
        }

        //
        // GET: /LoadProfile/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_EDIT });
                }
                
                Session[Common.ISPOSTBACK] = "false";
                LpStandardLoadProfile lpStandardLoadProfile = _db.LpStandardLoadProfiles.Find(id);
                if (lpStandardLoadProfile == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = lpStandardLoadProfile.CreatedBy;
                Session[Common.CREATEDDATE] = lpStandardLoadProfile.CreatedDate;
                Session["UtilityCompanyId"] = lpStandardLoadProfile.UtilityCompanyId;
                Session["UtilityCompanyName"] = lpStandardLoadProfile.UtilityCompany.UtilityCode;
                Session["LpStandardLoadProfileCode"] = lpStandardLoadProfile.LpStandardLoadProfileCode;

                SetViewBag();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} lpStandardLoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, lpStandardLoadProfile));

                return View(lpStandardLoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                LoadProfile LoadProfile = _db.LoadProfiles.Find(id);
                SetViewBag();
                return View(LoadProfile);
            }
        }

        //
        // POST: /LoadProfile/Edit/5
        [HttpPost]
        public ActionResult Edit(LpStandardLoadProfile lpStandardLoadProfile, string submitButton)
        {
            string method = string.Format("Edit(LpStandardLoadProfile lpStandardLoadProfile:{0})", lpStandardLoadProfile == null ? "NULL VALUE" : lpStandardLoadProfile.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = Common.NullSafeString(GetUserName(messageId));
                Session[Common.ISPOSTBACK] = "true";
                lpStandardLoadProfile.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                lpStandardLoadProfile.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                lpStandardLoadProfile.LastModifiedBy = userName; 
                lpStandardLoadProfile.LastModifiedDate = DateTime.Now;
                lpStandardLoadProfile.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                if (ModelState.IsValid &&
                    _db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == lpStandardLoadProfile.UtilityCompanyId && x.LpStandardLoadProfileCode == lpStandardLoadProfile.LpStandardLoadProfileCode && x.Id != lpStandardLoadProfile.Id).Count<LpStandardLoadProfile>() == 0 &&
                    lpStandardLoadProfile.IsLpStandardLoadProfileValid())
                {
                    _db.Entry(lpStandardLoadProfile).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "LoadProfile");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                Session[Common.CREATEDBY] = lpStandardLoadProfile.CreatedBy;
                Session[Common.CREATEDDATE] = lpStandardLoadProfile.CreatedDate;
                Session["UtilityCompanyId"] = lpStandardLoadProfile.UtilityCompanyId;

                SetViewBag();
                lpStandardLoadProfile.UtilityCompany = _db.LpStandardLoadProfiles.Find(lpStandardLoadProfile.Id).UtilityCompany;
                lpStandardLoadProfile.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(lpStandardLoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                lpStandardLoadProfile = _db.LpStandardLoadProfiles.Find(lpStandardLoadProfile.Id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(lpStandardLoadProfile.UtilityCompanyId.ToString());
                return View(lpStandardLoadProfile);
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

        public ActionResult LpStandardLoadProfileCodeTitleClick()
        {
            string method = "LpStandardLoadProfileCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardLoadProfileCode");

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

        private List<LpStandardLoadProfile> ObtainResponse()
        {
            var response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LpStandardLoadProfileCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfileCode).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfileCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }


        public override ActionResult ObtainActionResult()
        {
            var response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LpStandardLoadProfileCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfileCode).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfileCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return View(response);
        }
        #endregion
    }
}
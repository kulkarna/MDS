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
    public class LoadProfileAliasController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "LoadProfileAliasController";
        private const string UTILITYMANAGEMENT_LOADPROFILE_INDEX = "UTILITYMANAGEMENT_LOADPROFILE_INDEX";
        private const string UTILITYMANAGEMENT_LOADPROFILE_CREATE = "UTILITYMANAGEMENT_LOADPROFILE_CREATE";
        private const string UTILITYMANAGEMENT_LOADPROFILE_EDIT = "UTILITYMANAGEMENT_LOADPROFILE_EDIT";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DETAIL = "UTILITYMANAGEMENT_LOADPROFILE_DETAIL";
        private const string UTILITYMANAGEMENT_LOADPROFILE_UPLD = "UTILITYMANAGEMENT_LOADPROFILE_UPLD";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DOWNLD = "UTILITYMANAGEMENT_LOADPROFILE_DOWNLD";
        #endregion

        #region public constructors
        public LoadProfileAliasController()
            : base()
        {
            ViewBag.PageName = "LoadProfileAlias";
            ViewBag.IndexPageName = "LoadProfile";
            ViewBag.PageDisplayName = "Load Profile Alias";
        }
        #endregion

        #region public methods
        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_LOADPROFILE_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<LoadProfile>());
        }

        //
        // GET: /LoadProfileAlias/Details/5
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

                Session[Common.ISPOSTBACK] = "true";
                LoadProfileAlia LoadProfileAlias = _db.LoadProfileAlias.Find(id);

                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                if (LoadProfileAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfileAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, LoadProfileAlias));
                return View(LoadProfileAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LoadProfile());
            }
        }

        [HttpPost]
        public ActionResult Details(LoadProfileAlia LoadProfileAlias, string submitButton)
        {
            string method = string.Format(" Details(LoadProfileAlia LoadProfileAlias{0}, submitButton:{1})", LoadProfileAlias == null ? "NULL VALUE" : LoadProfileAlias.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LoadProfileAlias", new { id = LoadProfileAlias.Id });
                }
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
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
        // GET: /LoadProfileAlias/Create
        public ActionResult Create()
        {
            string method = "Create()";
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
                LoadProfileAlia LoadProfileAlias = new LoadProfileAlia()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.LoadProfileId = GetLoadProfileSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfileAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, LoadProfileAlias));
                return View(LoadProfileAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                LoadProfileAlia LoadProfileAlias = new LoadProfileAlia();
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                ViewBag.LoadProfileId = GetLoadProfileSelectListById(uci);
                return View(LoadProfileAlias);
            }
        }

        //
        // POST: /LoadProfileAlias/Create
        [HttpPost]
        public ActionResult Create(LoadProfileAlia loadProfileAlias, string submitButton)
        {
            string method = string.Format("Create(LoadProfileAlia LoadProfileAlias:{0}, submitButton:{1})", loadProfileAlias == null ? "NULL VALUE" : loadProfileAlias.ToString(), submitButton ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                loadProfileAlias.Id = Guid.NewGuid();
                loadProfileAlias.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfileAlias.CreatedDate = DateTime.Now;
                loadProfileAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfileAlias.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid &&
                    loadProfileAlias.IsLoadProfileAliasValid() &&
                    _db.LoadProfileAlias.Where(x => x.LoadProfileId == loadProfileAlias.LoadProfileId && x.LoadProfileCodeAlias == loadProfileAlias.LoadProfileCodeAlias && x.Id != loadProfileAlias.Id).Count<LoadProfileAlia>() == 0)
                {
                    _db.LoadProfileAlias.Add(loadProfileAlias);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "LoadProfile");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                ViewBag.LoadProfileId = GetLoadProfileSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(loadProfileAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                ViewBag.LoadProfileId = GetLoadProfileSelectListById(uci);
                return View(new LoadProfile());
            }
        }

        //
        // GET: /LoadProfileAlias/Edit/5
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
                
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                LoadProfileAlia LoadProfileAlias = _db.LoadProfileAlias.Find(id);
                if (LoadProfileAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = LoadProfileAlias.CreatedBy;
                Session[Common.CREATEDDATE] = LoadProfileAlias.CreatedDate;
                Session["LoadProfileId"] = LoadProfileAlias.LoadProfileId;

                ViewBag.LoadProfileId = GetLoadProfileSelectList(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfileAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, LoadProfileAlias));

                return View(LoadProfileAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                LoadProfileAlia LoadProfileAlias = _db.LoadProfileAlias.Find(id);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                ViewBag.LoadProfileId = GetLoadProfileSelectList(uci);
                return View(LoadProfileAlias);
            }
        }

        //
        // POST: /LoadProfileAlias/Edit/5
        [HttpPost]
        public ActionResult Edit(LoadProfileAlia loadProfileAlias, string submitButton)
        {
            string method = string.Format("Edit(LoadProfileAlia loadProfileAlias:{0})", loadProfileAlias == null ? "NULL VALUE" : loadProfileAlias.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                loadProfileAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                loadProfileAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                loadProfileAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfileAlias.LastModifiedDate = DateTime.Now;
                loadProfileAlias.LoadProfileId = Common.NullSafeGuid(Session["LoadProfileId"]);

                if (ModelState.IsValid &&
                    loadProfileAlias.IsLoadProfileAliasValid() &&
                    _db.LoadProfileAlias.Where(x => x.LoadProfileId == loadProfileAlias.LoadProfileId && x.LoadProfileCodeAlias == loadProfileAlias.LoadProfileCodeAlias && x.Id != loadProfileAlias.Id).Count<LoadProfileAlia>() == 0)
                {
                    _db.Entry(loadProfileAlias).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "LoadProfile");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                string loadProfileCodeAlias = loadProfileAlias.LoadProfileCodeAlias;
                loadProfileAlias = _db.LoadProfileAlias.Find(loadProfileAlias.Id);
                loadProfileAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                loadProfileAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                loadProfileAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfileAlias.LastModifiedDate = DateTime.Now;
                loadProfileAlias.LoadProfileCodeAlias = loadProfileCodeAlias;
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.LoadProfileId = GetLoadProfileSelectList(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(loadProfileAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                ViewBag.LoadProfileId = GetLoadProfileSelectList(uci);
                return View(loadProfileAlias);
            }
        }

        public ActionResult LoadProfileIdTitleClick()
        {
            string method = "LoadProfileIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LoadProfileAliasTitleClick()
        {
            string method = "LoadProfileAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileAlias");

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
using DataAccessLayerEntityFramework;
using ExcelBusinessLayer;
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
    public class LoadProfileController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "LoadProfileController";
        private const string UTILITYMANAGEMENT_LOADPROFILE_INDEX = "UTILITYMANAGEMENT_LOADPROFILE_INDEX";
        private const string UTILITYMANAGEMENT_LOADPROFILE_CREATE = "UTILITYMANAGEMENT_LOADPROFILE_CREATE";
        private const string UTILITYMANAGEMENT_LOADPROFILE_EDIT = "UTILITYMANAGEMENT_LOADPROFILE_EDIT";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DETAIL = "UTILITYMANAGEMENT_LOADPROFILE_DETAIL";
        private const string UTILITYMANAGEMENT_LOADPROFILE_UPLD = "UTILITYMANAGEMENT_LOADPROFILE_UPLD";
        private const string UTILITYMANAGEMENT_LOADPROFILE_DOWNLD = "UTILITYMANAGEMENT_LOADPROFILE_DOWNLD";
        #endregion

        #region public constructors
        public LoadProfileController()
            : base()
        {
            ViewBag.PageName = "LoadProfile";
            ViewBag.IndexPageName = "LoadProfile";
            ViewBag.PageDisplayName = "Load Profile";
        }
        #endregion

        #region public methods
        //
        // GET: /LoadProfile/
        [HttpGet]
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_LOADPROFILE_INDEX))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_INDEX });
                }

                Models.LoadProfileModel response = null;
                string url = Request.Url.ToString();

                if (utilityCompanyId == null && Session["LoadProfile_UtilityCompanyId_Set"] == null && url.IndexOf("/LoadProfile/Index/") == -1 && url.Length - url.IndexOf("/LoadProfile/Index/") < 49)
                {
                    response = ObtainResponse();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();
                }
                else
                {
                    if (utilityCompanyId == null)
                        if (Session["LoadProfile_UtilityCompanyId_Set"] == null)
                        {
                            utilityCompanyId = url.Substring(url.IndexOf("/LoadProfile/Index/") + 19);
                            Session["LoadProfile_UtilityCompanyId_Set"] = utilityCompanyId;
                        }
                        else
                            utilityCompanyId = Session["LoadProfile_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);
                    response = ObtainResponse(id);

                    Session["UtilityCode"] = string.Empty;
                    if (response != null && response.LpStandardRateList != null && response.LpStandardRateList.Count > 0 && response.LpStandardRateList[0] != null && response.LpStandardRateList[0].UtilityCompany != null && !string.IsNullOrWhiteSpace(response.LpStandardRateList[0].UtilityCompany.UtilityCode))
                    {
                        Session["UtilityCode"] = response.LpStandardRateList[0].UtilityCompany.UtilityCode;
                    }
                    else
                    {
                        Session["UtilityCode"] = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault().UtilityCode;
                    }

                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId);
                }
                response.SelectedUtilityCompanyId = utilityCompanyId;

                if (Session["ResultData"] != null)
                {
                    response.ResultData = (List<string>)Session["ResultData"];
                    Session["ResultDataOld"] = Session["ResultData"];
                    Session["ResultData"] = null;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.LoadProfileModel());
            }
        }



        [HttpPost]
        public ActionResult Index()
        {
            string method = "Index() POST";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                string userName = GetUserName(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_LOADPROFILE_UPLD))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_UPLD });
                }

                string path = @"Temp";

                //if (file != null)
                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    LoadProfileBusinessLayer loadProfileBusinessLayer = new LoadProfileBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                    string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                    string fileFileName = file.FileName;
                    if (fileFileName.LastIndexOf('\\') > 0)
                    {
                        fileFileName = fileFileName.Substring(fileFileName.LastIndexOf('\\') + 1);
                    }
                    string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", path, fileFileName));

                    if (!filePathAndName.Trim().ToLower().EndsWith(".xlsx"))
                    {
                        Session["ResultData"] = new List<string>() { "Invalid File." };
                        return RedirectToAction("Index");
                    }

                    file.SaveAs(filePathAndName);

                    loadProfileBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(loadProfileBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = loadProfileBusinessLayer.TabSummaryWithRowNumbersList;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<LoadProfile>());
            }
        }

        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["LoadProfile_UtilityCompanyId_Set"] = utilityCompanyId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return null;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        //
        // GET: /LoadProfile/
        public ActionResult IndexLoadProfileOnly()
        {
            string method = "IndexLoadProfileOnly()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponseLoadProfileOnly();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<LoadProfile>());
            }
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

                LoadProfile LoadProfile = _db.LoadProfiles.Find(id);

                if (LoadProfile == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, LoadProfile));
                return View(LoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LoadProfile());
            }
        }

        [HttpPost]
        public ActionResult Details(LoadProfile LoadProfile, string submitButton)
        {
            string method = string.Format(" Details(LoadProfile LoadProfile{0}, submitButton:{1})", LoadProfile == null ? "NULL VALUE" : LoadProfile.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LoadProfile", new { id = LoadProfile.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LoadProfile());
            }
        }

        //
        // GET: /LoadProfile/Create
        [HttpGet]
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

                if (utilityCompanyId == null && Session["LoadProfile_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Company Not Selected {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }

                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                LoadProfile LoadProfile = new LoadProfile()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci,
                    LoadProfileId = CalculateLoadProfileId(),
                    Id = Guid.NewGuid()

                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardLoadProfileId = GetLpStandardLoadProfilesSelectList(uci);
                ViewBag.Id = LoadProfile.Id;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, LoadProfile));
                return View(LoadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                LoadProfile loadProfile = new LoadProfile();
                SetViewBag(loadProfile);
                return View(loadProfile);
            }
        }

        //
        // POST: /LoadProfile/Create
        [HttpPost]
        public ActionResult Create(LoadProfile loadProfile, string submitButton)
        {
            string method = string.Format("Create(LoadProfile LoadProfile:{0})", loadProfile == null ? "NULL VALUE" : loadProfile.ToString());
            Guid uci = Guid.Empty;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                if (loadProfile.Id == null || loadProfile.Id == Guid.Empty)
                    loadProfile.Id = Guid.NewGuid();
                loadProfile.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfile.CreatedDate = DateTime.Now;
                loadProfile.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfile.LastModifiedDate = DateTime.Now;
                loadProfile.LoadProfileId = CalculateLoadProfileId();
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid
                    && _db.LoadProfiles.Where(x => x.UtilityCompanyId == loadProfile.UtilityCompanyId && x.LoadProfileCode == loadProfile.LoadProfileCode && x.Id != loadProfile.Id).Count<LoadProfile>() == 0
                    && loadProfile.IsLoadProfileValid())
                {
                    _db.LoadProfiles.Add(loadProfile);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardLoadProfileId = GetLpStandardLoadProfilesSelectList(uci);
                //SetViewBag(loadProfile);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(loadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardLoadProfileId = GetLpStandardLoadProfilesSelectList(uci);
                return View(new LoadProfile());
            }
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
                LoadProfile loadProfile = _db.LoadProfiles.Find(id);
                if (loadProfile == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                SetSession(loadProfile);
                SetViewBag(loadProfile);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LoadProfile:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, loadProfile));

                return View(loadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                LoadProfile loadProfile = _db.LoadProfiles.Find(id);
                SetViewBag(loadProfile);
                return View(loadProfile);
            }
        }

        //
        // POST: /LoadProfile/Edit/5
        [HttpPost]
        public ActionResult Edit(LoadProfile loadProfile, string submitButton)
        {
            string method = string.Format("Edit(LoadProfile LoadProfile:{0})", loadProfile == null ? "NULL VALUE" : loadProfile.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                loadProfile.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                loadProfile.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                loadProfile.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                loadProfile.LastModifiedDate = DateTime.Now;
                loadProfile.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                loadProfile.LoadProfileId = Common.NullSafeInteger(Session["LoadProfileId"]);

                if (ModelState.IsValid
                    && _db.LoadProfiles.Where(x => x.UtilityCompanyId == loadProfile.UtilityCompanyId && x.LoadProfileCode == loadProfile.LoadProfileCode && x.Id != loadProfile.Id).Count<LoadProfile>() == 0
                    && loadProfile.IsLoadProfileValid())
                {
                    _db.Entry(loadProfile).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                loadProfile.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                loadProfile.LpStandardLoadProfileId = Common.NullSafeGuid(Session["LpStandardLoadProfileId"]);
                loadProfile.UtilityCompany = _db.LoadProfiles.Find(loadProfile.Id).UtilityCompany;
                loadProfile.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                loadProfile.AccountType = _db.LoadProfiles.Find(loadProfile.Id).AccountType;
                loadProfile.AccountType.Name = Session["AccountTypeName"] == null ? "NULL VALUE" : Session["AccountTypeName"].ToString();
                loadProfile.LpStandardLoadProfile = _db.LoadProfiles.Find(loadProfile.Id).LpStandardLoadProfile;
                SetSession(loadProfile);
                SetViewBag(loadProfile);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(loadProfile);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                loadProfile = _db.LoadProfiles.Find(loadProfile.Id);
                SetViewBag(loadProfile);
                return View(loadProfile);
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
                return RedirectToAction("Index", "LoadProfile");
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
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult LoadProfileCodeTitleClick()
        {
            string method = "LoadProfileCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult LoadProfileLpStandardLoadProfileTitleClick()
        {
            string method = "LoadProfileLpStandardLoadProfileTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileLpStandardLoadProfile");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult LoadProfileAliasLoadProfileIdTitleClick()
        {
            string method = "LoadProfileAliasLoadProfileIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileAliasLoadProfileId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult LoadProfileCodeAliasTitleClick()
        {
            string method = "LoadProfileCodeAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfileCodeAlias");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult DescriptionTitleClick()
        {
            string method = "DescriptionTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Description");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult AccountTypeTitleClick()
        {
            string method = "AccountTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
            }
        }

        public ActionResult LpStandardLoadProfileTitleClick()
        {
            string method = "LpStandardLoadProfileTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardLoadProfile");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "LoadProfile");
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

        [HttpPost]
        public JsonResult PopulateRequestModeTypeList(string requestModeEnrollmentTypeId)
        {
            string method = string.Format("PopulateRequestModeTypeList(requestModeEnrollmentTypeId:{0})", requestModeEnrollmentTypeId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                string historicalUsageName = Common.NullSafeString(ConfigurationManager.AppSettings["RequestModeHistoricalUsageDatabaseName"]);
                jsonResult.Data = _db.usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(requestModeEnrollmentTypeId, historicalUsageName).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        public ActionResult Download()
        {
            string method = "Download()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                LoadProfileBusinessLayer loadProfileBusinessLayer = new LoadProfileBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LoadProfile_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                loadProfileBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));

                // download file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                response.ClearContent();
                response.Clear();
                response.ContentType = "application/vnd.xls";
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                response.TransmitFile(filePathAndName);
                response.End();

                // delete file
                System.IO.File.Delete(filePathAndName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "LoadProfile");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        public ActionResult DownloadAll()
        {
            string method = "DownloadAll()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                LoadProfileBusinessLayer loadProfileBusinessLayer = new LoadProfileBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LoadProfile_{1}{2}{3}{4}{5}{6}.xlsx", "All", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                loadProfileBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));

                // download file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                response.ClearContent();
                response.Clear();
                response.ContentType = "application/vnd.xls";
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                response.TransmitFile(filePathAndName);
                response.End();

                // delete file
                System.IO.File.Delete(filePathAndName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "LoadProfile");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        public ActionResult DownloadSummary()
        {
            string method = "DownloadSummary()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_LOADPROFILE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_LOADPROFILE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                LoadProfileBusinessLayer loadProfileBusinessLayer = new LoadProfileBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LoadProfileImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                System.IO.StreamWriter sw = System.IO.File.CreateText(filePathAndName);
                string fileData = string.Empty;
                if (Session["TabSummaryWithRowNumbersList"] != null && ((List<string>)Session["TabSummaryWithRowNumbersList"]).Count > 0)
                {
                    foreach (string dataElement in (List<string>)Session["TabSummaryWithRowNumbersList"])
                    {
                        sw.WriteLine(dataElement);
                    }
                }
                sw.Flush();
                sw.Close();

                // download file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                response.ClearContent();
                response.Clear();
                response.ContentType = "application/vnd.xls";
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                response.TransmitFile(filePathAndName);
                response.End();

                // delete file
                System.IO.File.Delete(filePathAndName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "LoadProfile");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private UtilityManagement.Models.LoadProfileModel ObtainResponse(Guid utilityCompanyId)
        {
            var response = new UtilityManagement.Models.LoadProfileModel()
            {
                LpStandardRateList = _db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).Include(r => r.LpStandardLoadProfile).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                LoadProfileAliasList = _db.LoadProfileAlias.Where(x => x.LoadProfile.UtilityCompanyId == utilityCompanyId).Include(r => r.LoadProfile).OrderBy(x => x.LoadProfile.LoadProfileCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "LoadProfileCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileCodeImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileCodeImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LoadProfileCode).ToList();
                    }
                    break;
                case "LoadProfileId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileIdImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LoadProfileId).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileIdImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LoadProfileId).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    }
                    break;
                case "LoadProfileLpStandardLoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileLpStandardLoadProfileImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileLpStandardLoadProfileImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.LoadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    }
                    break;


                case "LpStandardLoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpStandardLoadProfileImageUrl = Common.DOWNARROW;
                        response.LpStandardRateList = _db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.LpStandardLoadProfileImageUrl = Common.UPARROW;
                        response.LpStandardRateList = _db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfileCode).ToList();
                    }
                    break;


                case "LoadProfileAliasLoadProfileId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileAliasLoadProfileIdImageUrl = Common.DOWNARROW;
                        response.LoadProfileAliasList = _db.LoadProfileAlias.Where(x => x.LoadProfile.UtilityCompanyId == utilityCompanyId).Include(r => r.LoadProfile).OrderByDescending(x => x.LoadProfile.LoadProfileId).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileAliasLoadProfileIdImageUrl = Common.UPARROW;
                        response.LoadProfileAliasList = _db.LoadProfileAlias.Where(x => x.LoadProfile.UtilityCompanyId == utilityCompanyId).Include(r => r.LoadProfile).OrderBy(x => x.LoadProfile.LoadProfileId).ToList();
                    }
                    break;
                case "LoadProfileCodeAlias":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileCodeAliasImageUrl = Common.DOWNARROW;
                        response.LoadProfileAliasList = _db.LoadProfileAlias.Where(x => x.LoadProfile.UtilityCompanyId == utilityCompanyId).Include(r => r.LoadProfile).OrderByDescending(x => x.LoadProfileCodeAlias).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileCodeAliasImageUrl = Common.UPARROW;
                        response.LoadProfileAliasList = _db.LoadProfileAlias.Where(x => x.LoadProfile.UtilityCompanyId == utilityCompanyId).Include(r => r.LoadProfile).OrderBy(x => x.LoadProfileCodeAlias).ToList();
                    }
                    break;

            }
            return response;
        }

        private UtilityManagement.Models.LoadProfileModel ObtainResponse()
        {
            var response = new UtilityManagement.Models.LoadProfileModel()
            {
                LpStandardRateList = _db.LpStandardLoadProfiles.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                LoadProfileList = _db.LoadProfiles.Include(r => r.UtilityCompany).Include(r => r.LpStandardLoadProfile).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                LoadProfileAliasList = _db.LoadProfileAlias.Include(r => r.LoadProfile).OrderBy(x => x.LoadProfile.LoadProfileCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            return response;
        }

        private List<LoadProfile> ObtainResponseLoadProfileOnly()
        {
            var response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "LoadProfileCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LoadProfileCode).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LoadProfileCode).ToList();
                    break;
                case "LoadProfileId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LoadProfileId).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LoadProfileId).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    break;
                case "LpStandardLoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardLoadProfile.LpStandardLoadProfileCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.LoadProfiles.Include(r => r.LpStandardLoadProfile).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }

        private int CalculateLoadProfileId()
        {
            int max = _db.LoadProfiles.Count();
            if (max == 0)
                max = 0;
            else
                max = _db.LoadProfiles.Max(u => u.LoadProfileId) + 1;
            return (int)max + 1;
        }

        private void SetViewBag(LoadProfile loadProfile)
        {
            Guid uci = new Guid(Session["LoadProfile_UtilityCompanyId_Set"].ToString());
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(loadProfile.UtilityCompanyId.ToString());
            ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
            ViewBag.AccountTypeId = GetAccountTypeSelectList(loadProfile.AccountTypeId);
            ViewBag.LpStandardLoadProfileId = GetLpStandardLoadProfilesSelectList(uci, loadProfile.LpStandardLoadProfileId);
        }

        private void SetSession(LoadProfile loadProfile)
        {
            Session[Common.CREATEDBY] = loadProfile.CreatedBy;
            Session[Common.CREATEDDATE] = loadProfile.CreatedDate;
            Session["UtilityCompanyId"] = loadProfile.UtilityCompanyId;
            Session["UtilityCompanyName"] = loadProfile.UtilityCompany.UtilityCode;
            Session["AccountTypeName"] = loadProfile.AccountType.Name;
            Session["AccountTypeId"] = loadProfile.AccountTypeId;
            Session["LpStandardLoadProfileId"] = loadProfile.LpStandardLoadProfileId;
            Session["LpStandardLoadProfileName"] = loadProfile.LpStandardLoadProfile.LpStandardLoadProfileCode;
            Session["LoadProfileId"] = loadProfile.LoadProfileId;
        }
        #endregion
    }
}
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
using System.Security.Principal;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class RateClassController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "RateClassController";
        private const string UTILITYMANAGEMENT_RATECLASS_INDEX = "UTILITYMANAGEMENT_RATECLASS_INDEX";
        private const string UTILITYMANAGEMENT_RATECLASS_CREATE = "UTILITYMANAGEMENT_RATECLASS_CREATE";
        private const string UTILITYMANAGEMENT_RATECLASS_EDIT = "UTILITYMANAGEMENT_RATECLASS_EDIT";
        private const string UTILITYMANAGEMENT_RATECLASS_DETAIL = "UTILITYMANAGEMENT_RATECLASS_DETAIL";
        private const string UTILITYMANAGEMENT_RATECLASS_UPLD = "UTILITYMANAGEMENT_RATECLASS_UPLD";
        private const string UTILITYMANAGEMENT_RATECLASS_DOWNLD = "UTILITYMANAGEMENT_RATECLASS_DOWNLD";
        #endregion

        #region public constructors
        public RateClassController()
            : base()
        {
            ViewBag.PageName = "RateClass";
            ViewBag.IndexPageName = "RateClass";
            ViewBag.PageDisplayName = "Rate Class";
        }
        #endregion

        #region public methods
        [HttpGet]
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_INDEX });
                }

                Models.RateClassModel response = null;
                string url = Request.Url.ToString();
                if (utilityCompanyId == null && Session["RateClass_UtilityCompanyId_Set"] == null && url.IndexOf("/RateClass/Index/") == -1 && url.Length - url.IndexOf("/RateClass/Index/") < 49)
                {
                    response = ObtainResponse();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();
                }
                else
                {
                    if (utilityCompanyId == null)
                        if (Session["RateClass_UtilityCompanyId_Set"] == null)
                        {
                            utilityCompanyId = url.Substring(url.IndexOf("/RateClass/Index/") + 17);
                            Session["RateClass_UtilityCompanyId_Set"] = utilityCompanyId;
                        }
                        else
                            utilityCompanyId = Session["RateClass_UtilityCompanyId_Set"].ToString();
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
                    Session["ResultDataOld"] = Session["ResultData"];
                    response.ResultData = (List<string>)Session["ResultData"];
                    Session["ResultData"] = null;
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RateClass>());
            }
        }

        [HttpPost]
        public ActionResult Index()
        {
            VerifyMessageIdAndErrorMessageSession();
            string messageId = Session[Common.MESSAGEID].ToString();
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                string userName = Common.NullSafeString(GetUserName(messageId));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_UPLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_UPLD });
                }

                string path = @"Temp";

                //if (file != null)
                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    RateClassBusinessLayer rateClassBusinessLayer = new RateClassBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                    string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                    string fileFileName = file.FileName;
                    if(fileFileName.LastIndexOf('\\') > 0 )
                    {
                        fileFileName = fileFileName.Substring(fileFileName.LastIndexOf('\\')+1);
                    }
                    string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", path, fileFileName));

                    if (!filePathAndName.Trim().ToLower().EndsWith(".xlsx"))
                    {
                        Session["ResultData"] = new List<string>() { "Invalid File." };
                        return RedirectToAction("Index");
                    }

                    file.SaveAs(filePathAndName);

                    rateClassBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(rateClassBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = rateClassBusinessLayer.TabSummaryWithRowNumbersList;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RateClass>());
            }
        }

        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["RateClass_UtilityCompanyId_Set"] = utilityCompanyId;
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
        // GET: /RateClass/
        public ActionResult IndexRateClassOnly()
        {
            string method = "IndexRateClassOnly()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponseRateClassOnly();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RateClass>());
            }
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

                RateClass rateClass = _db.RateClasses.Find(id);

                if (rateClass == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClass));
                return View(rateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        [HttpPost]
        public ActionResult Details(RateClass rateClass, string submitButton)
        {
            string method = string.Format(" Details(RateClass rateClass{0}, submitButton:{1})", rateClass == null ? "NULL VALUE" : rateClass.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RateClass", new { id = rateClass.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RateClass());
            }
        }

        //
        // GET: /RateClass/Create
        [HttpGet]
        public ActionResult Create(string utilityCompanyId)
        {
            string method = string.Format("Create(utilityCompanyId:{0})", utilityCompanyId);
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

                if (utilityCompanyId == null && Session["RateClass_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Company Not Selected {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }

                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                RateClass rateClass = new RateClass()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci,
                    RateClassId = CalculateRateClassId(),
                    Id = Guid.NewGuid()
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(uci);
                ViewBag.Id = rateClass.Id;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClass));
                return View(rateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RateClass rateClass = new RateClass();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(rateClass.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(rateClass.AccountTypeId);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(uci);
                return View(rateClass);
            }
        }

        //
        // POST: /RateClass/Create
        [HttpPost]
        public ActionResult Create(RateClass rateClass, string submitButton)
        {
            string method = string.Format("Create(RateClass rateClass:{0})", rateClass == null ? "NULL VALUE" : rateClass.ToString());
            Guid uci = Guid.Empty;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                rateClass.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                rateClass.CreatedDate = DateTime.Now;
                rateClass.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                rateClass.LastModifiedDate = DateTime.Now;
                rateClass.RateClassId = CalculateRateClassId();
                if (rateClass.Id == null || rateClass.Id == Guid.Empty)
                    rateClass.Id = Guid.NewGuid();

                if (ModelState.IsValid && rateClass.IsRateClassValid()
                        && _db.RateClasses.Where(x => x.UtilityCompanyId == rateClass.UtilityCompanyId && x.RateClassCode == rateClass.RateClassCode && x.Id != rateClass.Id).Count<RateClass>() == 0)
                {

                    _db.RateClasses.Add(rateClass);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(rateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(uci);
                return View(new RateClass());
            }
        }

        private void SetSaveViewBag()
        {
            Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
            ViewBag.AccountTypeId = GetAccountTypeSelectList();
            ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
            ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList();
        }

        private int CalculateRateClassId()
        {
            int max = _db.RateClasses.Count();
            if (max == 0)
                max = 0;
            else
                max = _db.RateClasses.Max(u => u.RateClassId) + 1;
            return (int)max + 1;
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
                RateClass rateClass = _db.RateClasses.Find(id);
                if (rateClass == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = rateClass.CreatedBy;
                Session[Common.CREATEDDATE] = rateClass.CreatedDate;
                Session["UtilityCompanyId"] = rateClass.UtilityCompanyId;
                Session["UtilityCompanyName"] = rateClass.UtilityCompany.UtilityCode;
                Session["AccountTypeName"] = rateClass.AccountType.Name;
                Session["AccountTypeId"] = rateClass.AccountTypeId;
                Session["LpStandardRateClassId"] = rateClass.LpStandardRateClassId;
                Session["LpStandardRateClassName"] = rateClass.LpStandardRateClass.LpStandardRateClassCode;
                Session["RateClassId"] = rateClass.RateClassId;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(rateClass.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(rateClass.AccountTypeId);
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(rateClass.UtilityCompanyId, rateClass.LpStandardRateClassId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} rateClass:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, rateClass));

                return View(rateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RateClass rateClass = _db.RateClasses.Find(id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(rateClass.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(rateClass.AccountTypeId);
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList(rateClass.UtilityCompanyId, rateClass.LpStandardRateClassId);
                return View(rateClass);
            }
        }

        //
        // POST: /RateClass/Edit/5
        [HttpPost]
        public ActionResult Edit(RateClass rateClass, string submitButton)
        {
            string method = string.Format("Edit(RateClass rateClass:{0})", rateClass == null ? "NULL VALUE" : rateClass.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                rateClass.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                rateClass.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                rateClass.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                rateClass.LastModifiedDate = DateTime.Now;
                rateClass.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                rateClass.RateClassId = Common.NullSafeInteger(Session["RateClassId"]);

                if (ModelState.IsValid
                    && _db.RateClasses.Where(x => x.UtilityCompanyId == rateClass.UtilityCompanyId && x.RateClassCode == rateClass.RateClassCode && x.Id != rateClass.Id).Count<RateClass>() == 0 &&
                    rateClass.IsRateClassValid())
                {
                    _db.Entry(rateClass).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                rateClass.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                rateClass.LpStandardRateClassId = Common.NullSafeGuid(Session["LpStandardRateClassId"]);

                SetSaveViewBag();
                rateClass.UtilityCompany = _db.RateClasses.Find(rateClass.Id).UtilityCompany;
                rateClass.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                rateClass.AccountType = _db.RateClasses.Find(rateClass.Id).AccountType;
                rateClass.AccountType.Name = Session["AccountTypeName"] == null ? "NULL VALUE" : Session["AccountTypeName"].ToString();
                rateClass.LpStandardRateClass = _db.RateClasses.Find(rateClass.Id).LpStandardRateClass;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(rateClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                rateClass = _db.RateClasses.Find(rateClass.Id);
                ViewBag.AccountTypeId = GetAccountTypeSelectList(rateClass.AccountTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(rateClass.UtilityCompanyId.ToString());
                ViewBag.LpStandardRateClassId = GetLpStandardRateClasssSelectList();
                return View(rateClass);
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
                return RedirectToAction("Index", "RateClass");
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
                return RedirectToAction("Index", "RateClass");
            }
        }

        public ActionResult RateClassCodeTitleClick()
        {
            string method = "RateClassCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "RateClass");
            }
        }

        public ActionResult RateClassLpStandardRateClassTitleClick()
        {
            string method = "RateClassLpStandardRateClassTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassLpStandardRateClass");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "RateClass");
            }
        }

        public ActionResult RateClassAliasRateClassIdTitleClick()
        {
            string method = "RateClassAliasRateClassIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassAliasRateClassId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "RateClass");
            }
        }

        public ActionResult RateClassCodeAliasTitleClick()
        {
            string method = "RateClassCodeAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClassCodeAlias");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "RateClass");
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
                return RedirectToAction("Index", "RateClass");
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
                return RedirectToAction("Index", "RateClass");
            }
        }

        public ActionResult LpStandardRateClassTitleClick()
        {
            string method = "LpStandardRateClassTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardRateClass");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "RateClass");
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


        public ActionResult DownloadAll()
        {
            string method = "DownloadAll()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                RateClassBusinessLayer rateClassBusinessLayer = new RateClassBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_RateClass_{1}{2}{3}{4}{5}{6}.xlsx", "All", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                rateClassBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));

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
                return RedirectToAction("Index", "RateClass");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                RateClassBusinessLayer rateClassBusinessLayer = new RateClassBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["RateClass_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_RateClass_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                rateClassBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));

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
                return RedirectToAction("Index", "RateClass");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_RATECLASS_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_RATECLASS_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_RateClassImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "RateClass");
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

        private UtilityManagement.Models.RateClassModel ObtainResponse(Guid utilityCompanyId)
        {
            var response = new UtilityManagement.Models.RateClassModel()
            {
                LpStandardRateList = _db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).Include(r => r.LpStandardRateClass).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                RateClassAliasList = _db.RateClassAlias.Where(x => x.RateClass.UtilityCompanyId == utilityCompanyId).Include(r => r.RateClass).OrderBy(x => x.RateClass.RateClassCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "RateClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassCodeImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassCodeImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.RateClassCode).ToList();
                    }
                    break;
                case "RateClassId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassIdImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RateClassId).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassIdImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.RateClassId).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    }
                    break;
                case "RateClassLpStandardRateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassLpStandardRateClassImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassLpStandardRateClassImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.RateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    }
                    break;


                case "LpStandardRateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpStandardRateClassImageUrl = Common.DOWNARROW;
                        response.LpStandardRateList = _db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.LpStandardRateClassImageUrl = Common.UPARROW;
                        response.LpStandardRateList = _db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClassCode).ToList();
                    }
                    break;


                case "RateClassAliasRateClassId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassAliasRateClassIdImageUrl = Common.DOWNARROW;
                        response.RateClassAliasList = _db.RateClassAlias.Where(x => x.RateClass.UtilityCompanyId == utilityCompanyId).Include(r => r.RateClass).OrderByDescending(x => x.RateClass.RateClassId).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassAliasRateClassIdImageUrl = Common.UPARROW;
                        response.RateClassAliasList = _db.RateClassAlias.Where(x => x.RateClass.UtilityCompanyId == utilityCompanyId).Include(r => r.RateClass).OrderBy(x => x.RateClass.RateClassId).ToList();
                    }
                    break;
                case "RateClassCodeAlias":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassCodeAliasImageUrl = Common.DOWNARROW;
                        response.RateClassAliasList = _db.RateClassAlias.Where(x => x.RateClass.UtilityCompanyId == utilityCompanyId).Include(r => r.RateClass).OrderByDescending(x => x.RateClassCodeAlias).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassCodeAliasImageUrl = Common.UPARROW;
                        response.RateClassAliasList = _db.RateClassAlias.Where(x => x.RateClass.UtilityCompanyId == utilityCompanyId).Include(r => r.RateClass).OrderBy(x => x.RateClassCodeAlias).ToList();
                    }
                    break;
            }
            return response;
        }

        private UtilityManagement.Models.RateClassModel ObtainResponse()
        {
            var response = new UtilityManagement.Models.RateClassModel()
            {
                LpStandardRateList = _db.LpStandardRateClasses.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                RateClassList = _db.RateClasses.Include(r => r.UtilityCompany).Include(r => r.LpStandardRateClass).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                RateClassAliasList = _db.RateClassAlias.Include(r => r.RateClass).OrderBy(x => x.RateClass.RateClassCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            return response;
        }

        private List<RateClass> ObtainResponseRateClassOnly()
        {
            var response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "RateClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RateClassCode).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.RateClassCode).ToList();
                    break;
                case "RateClassId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RateClassId).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.RateClassId).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    break;
                case "LpStandardRateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardRateClass.LpStandardRateClassCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.RateClasses.Include(r => r.LpStandardRateClass).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}
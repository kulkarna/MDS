using DataAccessLayerEntityFramework;
using ExcelBusinessLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Text;
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
    public class TariffCodeController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "TariffCodeController";
        private const string UTILITYMANAGEMENT_TARIFFCODE_INDEX = "UTILITYMANAGEMENT_TARIFFCODE_INDEX";
        private const string UTILITYMANAGEMENT_TARIFFCODE_CREATE = "UTILITYMANAGEMENT_TARIFFCODE_CREATE";
        private const string UTILITYMANAGEMENT_TARIFFCODE_EDIT = "UTILITYMANAGEMENT_TARIFFCODE_EDIT";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DETAIL = "UTILITYMANAGEMENT_TARIFFCODE_DETAIL";
        private const string UTILITYMANAGEMENT_TARIFFCODE_UPLD = "UTILITYMANAGEMENT_TARIFFCODE_UPLD";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DOWNLD = "UTILITYMANAGEMENT_TARIFFCODE_DOWNLD";
        #endregion

        #region public constructors
        public TariffCodeController()
            : base()
        {
            ViewBag.PageName = "TariffCode";
            ViewBag.IndexPageName = "TariffCode";
            ViewBag.PageDisplayName = "Tariff Code";
        }
        #endregion

        #region public methods
        [HttpGet]
        public ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_INDEX });
                }

                Models.TariffCodeModel response = null;
                if (utilityCompanyId == null && Session["TariffCode_UtilityCompanyId_Set"] == null)
                {
                    response = ObtainResponse();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();
                }
                else
                {
                    if (utilityCompanyId == null)
                        utilityCompanyId = Session["TariffCode_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);
                    response = ObtainResponse(id);

                    Session["UtilityCode"] = string.Empty;
                    if (response != null && response.LpStandardTariffCodeList != null && response.LpStandardTariffCodeList.Count > 0 && response.LpStandardTariffCodeList[0] != null && response.LpStandardTariffCodeList[0].UtilityCompany != null && !string.IsNullOrWhiteSpace(response.LpStandardTariffCodeList[0].UtilityCompany.UtilityCode))
                    {
                        Session["UtilityCode"] = response.LpStandardTariffCodeList[0].UtilityCompany.UtilityCode;
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
                return View(new List<TariffCode>());
            }
        }

        [HttpPost]
        public ActionResult Index()
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                string userName = GetUserName(messageId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_UPLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_UPLD });
                }

                string path = @"Temp";

                //if (file != null)
                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    TariffCodeBusinessLayer tariffCodeBusinessLayer = new TariffCodeBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
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

                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} file.SaveAs({3}) b4", Common.NAMESPACE, CLASS, method, filePathAndName));
                    file.SaveAs(filePathAndName);
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} file.SaveAs({3})", Common.NAMESPACE, CLASS, method, filePathAndName));

                    tariffCodeBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} tariffCodeBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode:{3}, filePathAndName:{4}, userName:{5})", Common.NAMESPACE, CLASS, method, Common.NullSafeString(utilityCode), Common.NullSafeString(filePathAndName), Common.NullSafeString(userName)));

                    // delete the file
                    System.IO.File.Delete(filePathAndName);
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} System.IO.File.Delete({3})", Common.NAMESPACE, CLASS, method, filePathAndName));

                    List<string> resultData = new List<string>();
                    resultData.AddRange(tariffCodeBusinessLayer.TabsSummaryList);
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} resultData.AddRange(tariffCodeBusinessLayer.TabsSummaryList)", Common.NAMESPACE, CLASS, method));

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = tariffCodeBusinessLayer.TabSummaryWithRowNumbersList;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<TariffCode>());
            }
        }

        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["TariffCode_UtilityCompanyId_Set"] = utilityCompanyId;
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
        // GET: /TariffCode/
        public ActionResult IndexTariffCodeOnly()
        {
            string method = "IndexTariffCodeOnly()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponseTariffCodeOnly();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<TariffCode>());
            }
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

                TariffCode TariffCode = _db.TariffCodes.Find(id);

                if (TariffCode == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCode));
                return View(TariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        [HttpPost]
        public ActionResult Details(TariffCode TariffCode, string submitButton)
        {
            string method = string.Format(" Details(TariffCode TariffCode{0}, submitButton:{1})", TariffCode == null ? "NULL VALUE" : TariffCode.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "TariffCode", new { id = TariffCode.Id });
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
            string method = string.Format("Create(utilityCompanyId:{0})", utilityCompanyId);
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

                Session[Common.ISPOSTBACK] = "false";

                if (utilityCompanyId == null && Session["TariffCode_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Company Not Selected {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                TariffCode TariffCode = new TariffCode()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci,
                    TariffCodeId = CalculateTariffCodeId(),
                    Id = Guid.NewGuid()

                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList(_db.AccountTypes.Where(x => x.Name == "Undetermined").FirstOrDefault().Id);
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(uci);
                ViewBag.Id = TariffCode.Id;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCode));
                return View(TariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                TariffCode TariffCode = new TariffCode();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(TariffCode.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(TariffCode.AccountTypeId);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(uci);
                return View(TariffCode);
            }
        }

        //
        // POST: /TariffCode/Create
        [HttpPost]
        public ActionResult Create(TariffCode TariffCode, string submitButton)
        {
            string method = string.Format("Create(TariffCode TariffCode:{0})", TariffCode == null ? "NULL VALUE" : TariffCode.ToString());
            Guid uci = Guid.Empty;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));


                uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                TariffCode.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                TariffCode.CreatedDate = DateTime.Now;
                TariffCode.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                TariffCode.LastModifiedDate = DateTime.Now;
                TariffCode.TariffCodeId = CalculateTariffCodeId();
                if (TariffCode.Id == null || TariffCode.Id == Guid.Empty)
                    TariffCode.Id = Guid.NewGuid();
                if (ModelState.IsValid
                    && TariffCode.IsTariffCodeValid()
                    && _db.TariffCodes.Where(x => x.UtilityCompanyId == TariffCode.UtilityCompanyId && x.TariffCodeCode == TariffCode.TariffCodeCode && x.Id != TariffCode.Id).Count<TariffCode>() == 0)
                {
                    _db.TariffCodes.Add(TariffCode);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(uci);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(TariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(TariffCode.UtilityCompanyId.ToString());
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(uci);
                return View(new TariffCode());
            }
        }

        private int CalculateTariffCodeId()
        {
            int max = _db.TariffCodes.Count();
            if (max == 0)
                max = 0;
            else
                max = _db.TariffCodes.Max(u => u.TariffCodeId);
            return (int)max + 1;
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
                TariffCode TariffCode = _db.TariffCodes.Find(id);
                if (TariffCode == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = TariffCode.CreatedBy;
                Session[Common.CREATEDDATE] = TariffCode.CreatedDate;
                Session["UtilityCompanyId"] = TariffCode.UtilityCompanyId;
                Session["UtilityCompanyName"] = TariffCode.UtilityCompany.UtilityCode;
                Session["AccountTypeName"] = TariffCode.AccountType.Name;
                Session["AccountTypeId"] = TariffCode.AccountTypeId;
                Session["LpStandardTariffCodeId"] = TariffCode.LpStandardTariffCodeId;
                Session["LpStandardTariffCodeName"] = TariffCode.LpStandardTariffCode.LpStandardTariffCodeCode;
                Session["TariffCodeId"] = TariffCode.TariffCodeId;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(TariffCode.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(TariffCode.AccountTypeId);
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(TariffCode.UtilityCompanyId, TariffCode.LpStandardTariffCodeId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCode:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCode));

                return View(TariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                TariffCode TariffCode = _db.TariffCodes.Find(id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(TariffCode.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(TariffCode.AccountTypeId);
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList(TariffCode.LpStandardTariffCodeId);
                return View(TariffCode);
            }
        }

        //
        // POST: /TariffCode/Edit/5
        [HttpPost]
        public ActionResult Edit(TariffCode tariffCode, string submitButton)
        {
            string method = string.Format("Edit(TariffCode tariffCode:{0})", tariffCode == null ? "NULL VALUE" : tariffCode.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                tariffCode.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                tariffCode.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                tariffCode.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                tariffCode.LastModifiedDate = DateTime.Now;
                tariffCode.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                tariffCode.TariffCodeId = Common.NullSafeInteger(Session["TariffCodeId"]);
                if (ModelState.IsValid
                    && tariffCode.IsTariffCodeValid()
                    && _db.TariffCodes.Where(x => x.UtilityCompanyId == tariffCode.UtilityCompanyId && x.TariffCodeCode == tariffCode.TariffCodeCode && x.Id != tariffCode.Id).Count<TariffCode>() == 0)
                {
                    _db.Entry(tariffCode).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                tariffCode.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                tariffCode.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                tariffCode.LpStandardTariffCodeId = Common.NullSafeGuid(Session["LpStandardTariffCodeId"]);
                tariffCode.UtilityCompany = _db.TariffCodes.Find(tariffCode.Id).UtilityCompany;
                tariffCode.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                tariffCode.AccountType = _db.TariffCodes.Find(tariffCode.Id).AccountType;
                tariffCode.AccountType.Name = Session["AccountTypeName"] == null ? "NULL VALUE" : Session["AccountTypeName"].ToString();
                tariffCode.LpStandardTariffCode = _db.TariffCodes.Find(tariffCode.Id).LpStandardTariffCode;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(tariffCode);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                tariffCode = _db.TariffCodes.Find(tariffCode.Id);
                ViewBag.AccountTypeId = GetAccountTypeSelectList(tariffCode.AccountTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(tariffCode.UtilityCompanyId.ToString());
                ViewBag.LpStandardTariffCodeId = GetLpStandardTariffCodesSelectList();
                return View(tariffCode);
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
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult TariffCodeIdTitleClick()
        {
            string method = "TariffCodeIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult TariffCodeCodeTitleClick()
        {
            string method = "TariffCodeCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult TariffCodeLpStandardTariffCodeTitleClick()
        {
            string method = "TariffCodeLpStandardTariffCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeLpStandardTariffCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult TariffCodeAliasTariffCodeIdTitleClick()
        {
            string method = "TariffCodeAliasTariffCodeIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeAliasTariffCodeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult TariffCodeCodeAliasTitleClick()
        {
            string method = "TariffCodeCodeAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeCodeAlias");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
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
                return RedirectToAction("Index", "TariffCode");
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
                return RedirectToAction("Index", "TariffCode");
            }
        }

        public ActionResult LpStandardTariffCodeTitleClick()
        {
            string method = "LpStandardTariffCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardTariffCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index", "TariffCode");
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
        //        return RedirectToAction("Index", "TariffCode");
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
        //        return RedirectToAction("Index", "TariffCode");
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
        //        return RedirectToAction("Index", "TariffCode");
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
        //        return RedirectToAction("Index", "TariffCode");
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
        //        return RedirectToAction("Index", "TariffCode");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_DOWNLD });
                }
                
                // declare local variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                TariffCodeBusinessLayer tariffCodeBusinessLayer = new TariffCodeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // sve the file
                string fileName = string.Format(@"{0}_TariffCode_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                tariffCodeBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));

                // download the file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                response.ClearContent();
                response.Clear();
                response.ContentType = "application/vnd.xls";
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                response.TransmitFile(filePathAndName);
                response.End();

                // delete the file
                System.IO.File.Delete(filePathAndName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "TariffCode");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_DOWNLD });
                }

                // declare local variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                TariffCodeBusinessLayer tariffCodeBusinessLayer = new TariffCodeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save the file
                string fileName = string.Format(@"{0}_TariffCode_{1}{2}{3}{4}{5}{6}.xlsx", "All", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                tariffCodeBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));

                // download the file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                response.ClearContent();
                response.Clear();
                response.ContentType = "application/vnd.xls";
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                response.TransmitFile(filePathAndName);
                response.End();

                // delete the file
                System.IO.File.Delete(filePathAndName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "TariffCode");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_TariffCodeImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "TariffCode");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        public ActionResult Upload(string fileAndPathName)
        {
            string method = string.Format("Upload(fileAndPathName:{0})",fileAndPathName);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = GetUserName(messageId);
                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_UPLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_UPLD });
                }

                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                TariffCodeBusinessLayer tariffCodeBusinessLayer = new TariffCodeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);

                Session[Common.ISPOSTBACK] = "false";
                tariffCodeBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, fileAndPathName, userName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private UtilityManagement.Models.TariffCodeModel ObtainResponse(Guid utilityCompanyId)
        {
            var response = new UtilityManagement.Models.TariffCodeModel()
            {
                LpStandardTariffCodeList = _db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).Include(r => r.LpStandardTariffCode).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                TariffCodeAliasList = _db.TariffCodeAlias.Where(x => x.TariffCode.UtilityCompanyId == utilityCompanyId).Include(r => r.TariffCode).OrderBy(x => x.TariffCode.TariffCodeCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "TariffCodeCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeCodeImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.TariffCodeCode).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeCodeImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.TariffCodeCode).ToList();
                    }
                    break;
                case "TariffCodeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeIdImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.TariffCodeId).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeIdImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.TariffCodeId).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    }
                    break;
                case "TariffCodeLpStandardTariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeLpStandardTariffCodeImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeLpStandardTariffCodeImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.TariffCodeList = _db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    }
                    break;


                case "LpStandardTariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpStandardTariffCodeImageUrl = Common.DOWNARROW;
                        response.LpStandardTariffCodeList = _db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardTariffCodeCode).ToList();
                    }
                    else
                    {
                        ViewBag.LpStandardTariffCodeImageUrl = Common.UPARROW;
                        response.LpStandardTariffCodeList = _db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardTariffCodeCode).ToList();
                    }
                    break;


                case "TariffCodeAliasTariffCodeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeAliasTariffCodeIdImageUrl = Common.DOWNARROW;
                        response.TariffCodeAliasList = _db.TariffCodeAlias.Where(x => x.TariffCode.UtilityCompanyId == utilityCompanyId).Include(r => r.TariffCode).OrderByDescending(x => x.TariffCode.TariffCodeId).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeAliasTariffCodeIdImageUrl = Common.UPARROW;
                        response.TariffCodeAliasList = _db.TariffCodeAlias.Where(x => x.TariffCode.UtilityCompanyId == utilityCompanyId).Include(r => r.TariffCode).OrderBy(x => x.TariffCode.TariffCodeId).ToList();
                    }
                    break;
                case "TariffCodeCodeAlias":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeCodeAliasImageUrl = Common.DOWNARROW;
                        response.TariffCodeAliasList = _db.TariffCodeAlias.Where(x => x.TariffCode.UtilityCompanyId == utilityCompanyId).Include(r => r.TariffCode).OrderByDescending(x => x.TariffCodeCodeAlias).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeCodeAliasImageUrl = Common.UPARROW;
                        response.TariffCodeAliasList = _db.TariffCodeAlias.Where(x => x.TariffCode.UtilityCompanyId == utilityCompanyId).Include(r => r.TariffCode).OrderBy(x => x.TariffCodeCodeAlias).ToList();
                    }
                    break;

            }
            return response;
        }

        private UtilityManagement.Models.TariffCodeModel ObtainResponse()
        {
            var response = new UtilityManagement.Models.TariffCodeModel()
            {
                LpStandardTariffCodeList = _db.LpStandardTariffCodes.Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                TariffCodeList = _db.TariffCodes.Include(r => r.UtilityCompany).Include(r => r.LpStandardTariffCode).OrderBy(x => x.UtilityCompany.UtilityCode).ToList(),
                TariffCodeAliasList = _db.TariffCodeAlias.Include(r => r.TariffCode).OrderBy(x => x.TariffCode.TariffCodeCode).ToList()
            };
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            return response;
        }

        private List<TariffCode> ObtainResponseTariffCodeOnly()
        {
            var response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "TariffCodeCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.TariffCodeCode).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.TariffCodeCode).ToList();
                    break;
                case "TariffCodeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.TariffCodeId).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.TariffCodeId).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    break;
                case "LpStandardTariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardTariffCode.LpStandardTariffCodeCode).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.TariffCodes.Include(r => r.LpStandardTariffCode).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}
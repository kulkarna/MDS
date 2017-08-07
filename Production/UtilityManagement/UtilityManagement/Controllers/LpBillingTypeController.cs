using DataAccessLayerEntityFramework;
using System;
using System.IO;
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
using UtilityManagement.ChartHelpers;
using System.Web.UI.DataVisualization.Charting;
using ExcelBusinessLayer;
using System.Runtime.Caching;


namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class LpBillingTypeController : ControllerBaseWithUtilDropDown
    {
        #region private variables
        private const string CLASS = "LpBillingTypeController";
        private const string UTILITYOFFEREDBILILNGTYPE = "LpBillingTypeController";
        private const string LPAPPROVEDBILLINGTYPE = "LpApprovedBillingType";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_INDEX = "UTILITYMANAGEMENT_BILLINGTYPE_INDEX";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_CREATE = "UTILITYMANAGEMENT_BILLINGTYPE_CREATE";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_EDIT = "UTILITYMANAGEMENT_BILLINGTYPE_EDIT";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_DETAIL = "UTILITYMANAGEMENT_BILLINGTYPE_DETAIL";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_UPLD = "UTILITYMANAGEMENT_BILLINGTYPE_UPLD";
        private const string UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD = "UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD";
        private const string CHACHE_EXPIRATION_SECONDS = "CHACHE_EXPIRATION_SECONDS";
        #endregion


        #region public constructors
        public LpBillingTypeController()
            : base()
        {
            ViewBag.PageName = "LpBillingType";
            ViewBag.IndexPageName = "LpBillingType";
            ViewBag.PageDisplayName = "LP Billing Type";
        }
        #endregion


        #region actions
        //
        // GET: /LpBillingType/Create
        [HttpGet]
        public ActionResult Create(string utilityCompanyId)
        {
            string method = "Create(string utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_CREATE });
                }

                if (utilityCompanyId == null && Session["LpBillingType_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Company Not Selected {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }

                Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel = new Models.LibertyPowerBillingTypeListModel() 
                { CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), LastModifiedDate = DateTime.Now, SelectedUtilityCompanyId = uci.ToString() };

                SetViewBag(uci);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} libertyPowerBillingTypeListModel:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, libertyPowerBillingTypeListModel));
                return View(libertyPowerBillingTypeListModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel = new Models.LibertyPowerBillingTypeListModel();
                Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                SetViewBag(uci);
                return View(libertyPowerBillingTypeListModel);
            }
        }

        //
        // POST: /LpBillingType/Create
        [HttpPost]
        public ActionResult Create(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel, string submitButton)
        {
            string method = string.Format("Create(LibertyPowerBillingTypeListModel libertyPowerBillingTypeModel:{0})", libertyPowerBillingTypeListModel == null ? "NULL VALUE" : libertyPowerBillingTypeListModel.ToString());
            Guid utilityCompanyId = Common.NullSafeGuid(libertyPowerBillingTypeListModel.SelectedUtilityCompanyId);
            LpBillingType lpBillingType = new LpBillingType();
            try
            {
                Session["ErrorMessage"] = string.Empty;
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                //if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_CREATE))
                //{
                //    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                //    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_CREATE });
                //}

                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                }

                Session[Common.ISPOSTBACK] = "true";
                libertyPowerBillingTypeListModel = InitializeLibertyPowerBillingTypeListModel(libertyPowerBillingTypeListModel);
                int temp = 0;

                if (IsLpBillingTypeValid(libertyPowerBillingTypeListModel) && int.TryParse(Request["Terms"].ToString(), out temp))
                {
                    List<bool> isADuplicateResult = GetDuplicateRecordData(utilityCompanyId, libertyPowerBillingTypeListModel.PorDriverId, libertyPowerBillingTypeListModel.LoadProfileId, libertyPowerBillingTypeListModel.RateClassId, libertyPowerBillingTypeListModel.TariffCodeId, libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId);

                    if (isADuplicateResult.Count > 0 && !(isADuplicateResult[0] && isADuplicateResult[1]))
                    {

                        // store LpBillingType
                        if (isADuplicateResult == null || (isADuplicateResult.Count > 0 && !isADuplicateResult[0]))
                        {
                            lpBillingType = LpBillingTypeCreate(libertyPowerBillingTypeListModel);
                            _db.LpBillingTypes.Add(lpBillingType);
                            _db.SaveChanges();
                        }
                        else
                        {
                            lpBillingType = GetLpBillingType(libertyPowerBillingTypeListModel, utilityCompanyId);
                            if (lpBillingType != null)
                            {
                                lpBillingType = LpBillingTypeUpdate(libertyPowerBillingTypeListModel, lpBillingType);
                                _db.Entry(lpBillingType).State = EntityState.Modified;
                                _db.SaveChanges();
                            }
                        }

                        LpUtilityOfferedBillingType lpUtilityOfferedBillingType = new LpUtilityOfferedBillingType();
                        if (isADuplicateResult == null || (isADuplicateResult.Count > 1 && !isADuplicateResult[1]))
                        {
                            lpUtilityOfferedBillingType = new LpUtilityOfferedBillingType() 
                            { CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                            CreatedDate = DateTime.Now, Id = Guid.NewGuid(), Inactive = lpBillingType.Inactive, 
                            LpBillingTypeId = lpBillingType.Id, 
                            UtilityOfferedBillingTypeId = libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId, 
                            LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                            LastModifiedDate = DateTime.Now };
                            _db.LpUtilityOfferedBillingTypes.Add(lpUtilityOfferedBillingType);
                            _db.SaveChanges();
                        }
                        else
                        {
                            lpUtilityOfferedBillingType = _db.LpUtilityOfferedBillingTypes.Where(x => x.LpBillingTypeId == lpBillingType.Id && x.UtilityOfferedBillingTypeId == libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId).FirstOrDefault();
                            if (lpUtilityOfferedBillingType != null)
                            {
                                lpUtilityOfferedBillingType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
                                lpUtilityOfferedBillingType.LastModifiedDate = DateTime.Now;
                                lpUtilityOfferedBillingType.Inactive = libertyPowerBillingTypeListModel.Inactive;
                                lpUtilityOfferedBillingType.UtilityOfferedBillingTypeId = libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId;

                                _db.Entry(lpUtilityOfferedBillingType).State = EntityState.Modified;
                                _db.SaveChanges();
                            }
                        }

                        LpApprovedBillingType lpApprovedBillingType = new LpApprovedBillingType();
                        if (libertyPowerBillingTypeListModel.LibertyPowerApprovedBillingTypeId && (isADuplicateResult == null || (isADuplicateResult.Count > 2 && !isADuplicateResult[2])))
                        {
                            lpApprovedBillingType = new LpApprovedBillingType() 
                            { CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                                CreatedDate = DateTime.Now, Id = Guid.NewGuid(), 
                                Inactive = lpBillingType.Inactive, LpBillingTypeId = lpBillingType.Id,
                                ApprovedBillingTypeId = libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId, 
                                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                                LastModifiedDate = DateTime.Now,
                                Terms = libertyPowerBillingTypeListModel.Terms };

                            _db.LpApprovedBillingTypes.Add(lpApprovedBillingType);
                            _db.SaveChanges();
                        }
                        else
                        {
                            lpApprovedBillingType = _db.LpApprovedBillingTypes.Where(x => x.LpBillingTypeId == lpBillingType.Id && x.ApprovedBillingTypeId == libertyPowerBillingTypeListModel.LpApprovedBillingTypeId).FirstOrDefault();
                            if (lpApprovedBillingType != null)
                            {
                                lpApprovedBillingType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
                                lpApprovedBillingType.LastModifiedDate = DateTime.Now;
                                lpApprovedBillingType.Inactive = libertyPowerBillingTypeListModel.Inactive;
                                lpApprovedBillingType.ApprovedBillingTypeId = libertyPowerBillingTypeListModel.LpApprovedBillingTypeId == null ? Guid.Empty : (Guid)libertyPowerBillingTypeListModel.LpApprovedBillingTypeId;
                                lpApprovedBillingType.Terms = libertyPowerBillingTypeListModel.Terms;

                                _db.Entry(lpApprovedBillingType).State = EntityState.Modified;
                                _db.SaveChanges();
                            }
                        }
                    }
                    else
                    {
                        Session["ErrorMessage"] = "Record Already Exists!";
                        SetViewBag(Common.NullSafeGuid(utilityCompanyId));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return View(libertyPowerBillingTypeListModel);
                    }

                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                else
                {
                    libertyPowerBillingTypeListModel.SelectedUtilityCompanyId = Common.NullSafeGuid(Session["LpBillingType_UtilityCompanyId_Set"]).ToString();
                }

                SetViewBag(Common.NullSafeGuid(utilityCompanyId));

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(libertyPowerBillingTypeListModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = Common.NullSafeGuid(lpBillingType.UtilityCompanyId);
                SetViewBag(uci);
                return View(libertyPowerBillingTypeListModel);
            }
        }


        //
        // GET: /LpBillingType/Details/5
        public ActionResult Details(string id)
        {
            string method = string.Format("Details(string id:{0})", Common.NullSafeString(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_DETAIL });
                }

                Models.LibertyPowerBillingTypeListModel response = new Models.LibertyPowerBillingTypeListModel();

                if (!string.IsNullOrWhiteSpace(id))
                {
                    List<string> dataList = id.Split('_').ToList();
                    if (dataList != null && dataList.Count == 4)
                    {
                        Guid lpBillingTypeIdId = Common.NullSafeGuid(dataList[1]);
                        Guid lpUtilityOfferedBillingTypeId = Common.NullSafeGuid(dataList[2]);
                        Guid lpApprovedBillingTypeId = Common.NullSafeGuid(dataList[3]);

                        LpBillingType lpBillingType = _db.LpBillingTypes.Find(lpBillingTypeIdId);
                        if (lpBillingType == null)
                        {
                            _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                            return HttpNotFound();
                        }

                        LpUtilityOfferedBillingType lpUtilityOfferedBillingType = _db.LpUtilityOfferedBillingTypes.Where(x => x.LpBillingTypeId == lpBillingType.Id && x.BillingType1.Id == lpUtilityOfferedBillingTypeId).FirstOrDefault();
                        LpApprovedBillingType lpApprovedBillingType = _db.LpApprovedBillingTypes.Where(x => x.LpBillingTypeId == lpBillingType.Id && x.BillingType.Id == lpApprovedBillingTypeId).FirstOrDefault();
                        string accountTypeName = string.Empty;
                        switch (lpBillingType.PorDriver.Name.ToLower().Trim())
                        {
                            case "load profile":
                                accountTypeName = lpBillingType != null && lpBillingType.LoadProfile != null && lpBillingType.LoadProfile.AccountType != null ? lpBillingType.LoadProfile.AccountType.Name : string.Empty;
                                break;
                            case "rate class":
                                accountTypeName = lpBillingType != null && lpBillingType.RateClass != null && lpBillingType.RateClass.AccountType != null ? lpBillingType.RateClass.AccountType.Name : string.Empty;
                                break;
                            case "tariff code":
                                accountTypeName = lpBillingType != null && lpBillingType.TariffCode != null && lpBillingType.TariffCode.AccountType != null ? lpBillingType.TariffCode.AccountType.Name : string.Empty;
                                break;
                        }
                        string lpUtilityOfferedBillingTypeName = lpUtilityOfferedBillingType == null || lpUtilityOfferedBillingType.BillingType1 == null ? null : lpUtilityOfferedBillingType.BillingType1.Name;
                        string lpApprovedBillingTypeName = lpApprovedBillingType == null || lpApprovedBillingType.BillingType == null ? null : lpApprovedBillingType.BillingType.Name;
                        Nullable<int> terms = lpApprovedBillingType == null ? null : lpApprovedBillingType.Terms;
                        response = new Models.LibertyPowerBillingTypeListModel(lpBillingType, lpUtilityOfferedBillingTypeId, lpUtilityOfferedBillingTypeName, lpApprovedBillingTypeId, lpApprovedBillingTypeName, terms, accountTypeName);
                        response.Inactive = lpUtilityOfferedBillingType.Inactive;
                    }
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.LibertyPowerBillingTypeListModel());
            }
        }

        [HttpPost]
        public ActionResult Details(LpBillingType LpBillingType, string submitButton)
        {
            string method = string.Format(" Details(LpBillingType LpBillingType:{0}, submitButton:{1})", LpBillingType == null ? "NULL VALUE" : LpBillingType.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "LpBillingType", new { id = LpBillingType.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new LpBillingType());
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                ExcelBusinessLayer.LpBillingTypeBusinessLayer lpBillingTypeBusinessLayer = new ExcelBusinessLayer.LpBillingTypeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(_db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode);
                Session["UtilityCode"] = utilityCode;
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LpBillingType_{1}{2}{3}{4}{5}{6}.xlsx", "All", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                lpBillingTypeBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));

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
                return RedirectToAction("Index", "LpBillingType");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                ExcelBusinessLayer.LpBillingTypeBusinessLayer lpBillingTypeBusinessLayer = new ExcelBusinessLayer.LpBillingTypeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(_db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode);
                Session["UtilityCode"] = utilityCode;
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LpBillingType_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                lpBillingTypeBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));

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
                return RedirectToAction("Index", "LpBillingType");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                ExcelBusinessLayer.LpBillingTypeBusinessLayer lpBillingTypeBusinessLayer = new ExcelBusinessLayer.LpBillingTypeBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_LpBillingTypeImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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

        [HttpPost]
        public ActionResult Index()
        {
            string method = "Index() POST";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = Common.NullSafeString(GetUserName(messageId));
                // security check
                //if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_UPLD))
                //{
                //    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                //    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_UPLD });
                //}

                string path = @"Temp";

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    LpBillingTypeBusinessLayer lpBillingTypeBusinessLayer = new LpBillingTypeBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["LpBillingType_UtilityCompanyId_Set"].ToString());
                    string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                    if (string.IsNullOrWhiteSpace(utilityCode))
                    {
                        utilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                    }
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

                    lpBillingTypeBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(lpBillingTypeBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = lpBillingTypeBusinessLayer.TabSummaryWithRowNumbersList;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<LoadProfile>());
            }
        }

        //
        // GET: /LpBillingType/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                //if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_INDEX))
                //{
                //    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                //    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_INDEX });
                //}

                Models.LibertyPowerBillingTypeModel response = null;
                if (utilityCompanyId == null && Session["LpBillingType_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[LpBillingType_UtilityCompanyId_Set] == null start");
                    response = ObtainResponse();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[LpBillingType_UtilityCompanyId_Set] == null end");
                }
                else
                {
                    if (utilityCompanyId == null)
                    {
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null start");
                        utilityCompanyId = Session["LpBillingType_UtilityCompanyId_Set"].ToString();
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null end");
                    }
                    Guid id = new Guid(utilityCompanyId);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "Guid id = new Guid(utilityCompanyId)");
                    response = ObtainResponse(id);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "response = ObtainResponse(id)");
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId)");
                }
                response.SelectedUtilityCompanyId = utilityCompanyId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                if (response.LpBillingTypeList == null)
                {
                    response.LpBillingTypeList = new List<Models.LibertyPowerBillingTypeListModel>();
                }
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new UtilityManagement.Models.LibertyPowerBillingTypeModel());
            }
        }


        public ActionResult LpBillingCountChart()
        {
            string method = "LpBillingCountChart()";
            string cacheKey = "LpBillingCountChart";
            _logger.LogInfo(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

            ObjectCache cache = MemoryCache.Default;
            if (cache.Contains(cacheKey))
            {
                ActionResult actionResult = (ActionResult)cache.Get(cacheKey);
                _logger.LogDebug(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("returning actionResult from Cache for cacheKey:{0}", cacheKey));
                _logger.LogInfo(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return actionResult;
            }

            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            _logger.LogDebug(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} chart defined", Common.NAMESPACE, CLASS, method));

            var builder = new LpBillingCountChartBuilder(salesChart);
            builder.CategoryName = "Data";
            builder.OrderYear = 2013;
            builder.BuildChart();

            _logger.LogDebug(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} chart built", Common.NAMESPACE, CLASS, method));

            salesChart.Titles[0].Visible = false;

            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            _logger.LogDebug(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} chart saved to memory stream", Common.NAMESPACE, CLASS, method));

            // Return the contents of the Stream to the client
            ActionResult returnValue = File(imgStream, "image/png");
            CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
            cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
            cache.Add(cacheKey, returnValue, cacheItemPolicy);

            _logger.LogDebug(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} stream converted to return value -- returning returnValue", Common.NAMESPACE, CLASS, method));
            _logger.LogInfo(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
            return returnValue;
        }

        public ActionResult PorDriverTileClick()
        {
            string method = "PorDriverTileClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorDriver");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RateClassTitleClick()
        {
            string method = "RateClassTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RateClass");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult Report()
        {
            return View(new Models.ReportModel());
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

        public ActionResult LoadProfileTileClick()
        {
            string method = "LoadProfileTileClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LoadProfile");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult TariffCodeTitleClick()
        {
            string method = "TariffCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult DefaultBillingTypeTitleClick()
        {
            string method = "DefaultBillingTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("DefaultBillingType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilityOfferedBillingTypeTitleClick()
        {
            string method = "UtilityOfferedBillingTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityOfferedBillingType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LpApprovedBillingTypeTitleClick()
        {
            string method = "LpApprovedBillingTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpApprovedBillingType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
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
                return RedirectToAction("Index");
            }
        }

        public ActionResult TermsTitleClick()
        {
            string method = "TermsTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Terms");

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

        //
        // GET: /LpBillingType/Edit/5
        public ActionResult Edit(string id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeString(id));
            Guid utilityOfferedBillingTypeIdNullable = Guid.Empty;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGTYPE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGTYPE_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";

                string[] guids = id.Split('_');
                Guid lpBillingTypeId = new Guid(guids[1]);
                Guid utilityOfferedBillingTypeId = new Guid(guids[2]);
                Guid lpApprovedBillingTypeId = new Guid(guids[3]);

                LpBillingType lpBillingType = _db.LpBillingTypes.Find(lpBillingTypeId);
                if (lpBillingType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} _db.LpBillingTypes NOT FOUND {4} {3}", Common.NAMESPACE, CLASS, method, Common.END, Common.NullSafeString(lpBillingTypeId)));
                    return RedirectToAction("Index");
                }
                LpUtilityOfferedBillingType lpUtilityOfferedBillingType = _db.LpUtilityOfferedBillingTypes.Where(x => x.LpBillingTypeId == lpBillingTypeId && x.UtilityOfferedBillingTypeId == utilityOfferedBillingTypeId).FirstOrDefault();
                if (lpUtilityOfferedBillingType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} _db.LpUtilityOfferedBillingTypes NOT FOUND {4} {3}", Common.NAMESPACE, CLASS, method, Common.END, Common.NullSafeString(utilityOfferedBillingTypeId)));
                    return RedirectToAction("Index");
                }

                Models.LibertyPowerBillingTypeListModel modelInput = new Models.LibertyPowerBillingTypeListModel()
                {
                    Id = lpBillingTypeId,
                    LpApprovedBillingTypeId = lpApprovedBillingTypeId,
                    UtilityOfferedBillingTypeId = utilityOfferedBillingTypeId
                };

                Session[Common.CREATEDBY] = lpBillingType.CreatedBy;
                Session[Common.CREATEDDATE] = lpBillingType.CreatedDate;
                Session["UtilityCompanyId"] = lpBillingType.UtilityCompanyId;
                Session["UtilityCompanyName"] = lpBillingType.UtilityCompany.UtilityCode;
                Session["LpBillingType_UtilityOfferedBillingTypeId"] = utilityOfferedBillingTypeId;

                Models.LibertyPowerBillingTypeListModel model = GenerateModel(modelInput, lpBillingType);
                model.Inactive = lpUtilityOfferedBillingType.Inactive;

                Session["LpBillingTypePorDriverId"] = model.PorDriverId;
                Session["LpBillingTypeLoadProfileId"] = model.LoadProfileId;
                Session["LpBillingTypeRateClassId"] = model.RateClassId;
                Session["LpBillingTypeTariffCodeId"] = model.TariffCodeId;
                Session["LpBillingTypeId"] = model.Id;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} LpBillingType:{4} {3}", Common.NAMESPACE, CLASS,
                    method, Common.END, lpBillingType));

                return View(model);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        //
        // POST: /LpBillingType/Edit/5
        [HttpPost]
        public ActionResult Edit(Models.LibertyPowerBillingTypeListModel model, string submitButton)
        {
            string method = string.Format("Edit(Models.LibertyPowerBillingTypeListModel model:{0},string submitButton:{1})", model == null ? "NULL VALUE" : model.ToString(), Common.NullSafeString(submitButton));
            Guid utilityOfferedBillingTypeIdNullable = Guid.Empty;
            LpUtilityOfferedBillingType lpUtilityOfferedBillingType; 
            LpApprovedBillingType lpApprovedBillingType;
            try
            {
                Session["ErrorMessage"] = string.Empty;
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = GetUserName(messageId);
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                }

                string tempId = Request.Form["Id"].ToString();
                tempId.IndexOf('_');
                string preParsedTempId = tempId.Substring(tempId.IndexOf('_') + 1);
                string parsedId = preParsedTempId.Substring(0, preParsedTempId.IndexOf('_'));
                model = ModifyModel(model, parsedId);

                Session[Common.ISPOSTBACK] = "true";
                Guid theId = new Guid(Session["LpBillingTypeId"].ToString());
                LpBillingType lpBillingType = _db.LpBillingTypes.Find(theId);
                Guid lpBillingType_UtilityOfferedBillingTypeId = Common.NullSafeGuid(Session["LpBillingType_UtilityOfferedBillingTypeId"]);
                if (IsModelValid(model))
                {
                    lpBillingType = PopulateLpBillingType(lpBillingType, model);
                    lpBillingType.LastModifiedBy = userName;
                    lpUtilityOfferedBillingType = (LpUtilityOfferedBillingType)_db.LpUtilityOfferedBillingTypes.Where(x => x.LpBillingTypeId == theId &&
                        x.BillingType1.Id == lpBillingType_UtilityOfferedBillingTypeId).FirstOrDefault();
                    lpUtilityOfferedBillingType.LastModifiedBy = userName;
                    lpApprovedBillingType = (LpApprovedBillingType)_db.LpApprovedBillingTypes.Where(x => x.LpBillingTypeId == theId &&
                        x.BillingType.Id == model.UtilityOfferedBillingTypeId).FirstOrDefault(); // && model.LibertyPowerApprovedBillingTypeId).FirstOrDefault();
                    lpUtilityOfferedBillingType.LastModifiedBy = userName;

                    UpdateLpApprovedBillingType(messageId, lpApprovedBillingType, model, theId, userName);

                    UpdateLpUtilityOfferedBillingType(messageId, lpUtilityOfferedBillingType, model, theId, userName);

                    lpBillingType.Id = theId;
                    lpBillingType.DefaultBillingTypeId = model.DefaultBillingTypeId;
                    lpBillingType.Inactive = false;
                    lpBillingType.LoadProfileId = model.LoadProfileId;
                    lpBillingType.RateClassId = model.RateClassId;
                    lpBillingType.TariffCodeId = model.TariffCodeId;
                    _db.Entry(lpBillingType).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                else
                {
                    model = GenerateModel(model, lpBillingType);

                    Session["LpBillingTypePorDriverId"] = model.PorDriverId;
                    Session["LpBillingTypeLoadProfileId"] = model.LoadProfileId;
                    Session["LpBillingTypeRateClassId"] = model.RateClassId;
                    Session["LpBillingTypeTariffCodeId"] = model.TariffCodeId;
                    Session["LpBillingTypeId"] = model.Id;

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return View(model);
                }
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                SetViewBag(Common.NullSafeGuid(model.SelectedUtilityCompanyId));
                return View(model);
            }
        }

        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["LpBillingType_UtilityCompanyId_Set"] = utilityCompanyId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return null;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private Models.LibertyPowerBillingTypeListModel GenerateModel(Models.LibertyPowerBillingTypeListModel model, LpBillingType lpBillingType)
        {
            Guid utilityOfferedBillingTypeIdNullable = Guid.Empty;
            Guid? lpApprovedBillingTypeIdNullable = null;
            LpUtilityOfferedBillingType lpUtilityOfferedBillingType;
            LpApprovedBillingType lpApprovedBillingType;

            model.SelectedUtilityCompanyId = Common.NullSafeString(Common.NullSafeGuid(Session["UtilityCompanyId"]));
            model.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
            model.CreatedDate = (DateTime)Session[Common.CREATEDDATE];

            lpApprovedBillingType = (LpApprovedBillingType)_db.LpApprovedBillingTypes.Where(x => x.ApprovedBillingTypeId == model.LpApprovedBillingTypeId && x.LpBillingTypeId == model.Id).FirstOrDefault();
            lpUtilityOfferedBillingType = (LpUtilityOfferedBillingType)_db.LpUtilityOfferedBillingTypes.Where(x => x.UtilityOfferedBillingTypeId == model.UtilityOfferedBillingTypeId
                && x.LpBillingTypeId == model.Id).FirstOrDefault();

            string utilityOfferedBillingTypeName = lpUtilityOfferedBillingType != null ? lpUtilityOfferedBillingType.BillingType1.Name : null;
            if (lpUtilityOfferedBillingType != null && lpUtilityOfferedBillingType.UtilityOfferedBillingTypeId != Guid.Empty)
            {
                utilityOfferedBillingTypeIdNullable = lpUtilityOfferedBillingType.UtilityOfferedBillingTypeId;
            }

            string lpApprovedBillingTypeName = lpApprovedBillingType != null ? lpApprovedBillingType.BillingType.Name : null;
            if (lpApprovedBillingType != null && lpApprovedBillingType.ApprovedBillingTypeId != Guid.Empty)
            {
                lpApprovedBillingTypeIdNullable = lpApprovedBillingType.ApprovedBillingTypeId;
            }

            int? terms = lpApprovedBillingType != null ? lpApprovedBillingType.Terms : null;

            string accountTypeName = string.Empty;
            switch (lpBillingType.PorDriver.Name.ToLower().Trim())
            {
                case "load profile":
                    accountTypeName = lpBillingType != null && lpBillingType.LoadProfile != null && lpBillingType.LoadProfile.AccountType != null ? lpBillingType.LoadProfile.AccountType.Name : string.Empty;
                    break;
                case "rate class":
                    accountTypeName = lpBillingType != null && lpBillingType.RateClass != null && lpBillingType.RateClass.AccountType != null ? lpBillingType.RateClass.AccountType.Name : string.Empty;
                    break;
                case "tariff code":
                    accountTypeName = lpBillingType != null && lpBillingType.TariffCode != null && lpBillingType.TariffCode.AccountType != null ? lpBillingType.TariffCode.AccountType.Name : string.Empty;
                    break;
            }

            SelectList selectListLoadProfile = GetLoadProfileSelectList(Common.NullSafeGuid(lpBillingType.UtilityCompanyId), lpBillingType.LoadProfileId);
            if (selectListLoadProfile != null)
            {
                if (selectListLoadProfile.ToList().Count > 2)
                    selectListLoadProfile.ToList().RemoveAt(2);
                if (selectListLoadProfile.ToList().Count > 1)
                    selectListLoadProfile.ToList().RemoveAt(1);
            }

            SelectList selectListRateClass = GetRateClassSelectList(Common.NullSafeGuid(lpBillingType.UtilityCompanyId), lpBillingType.RateClassId);
            if (selectListRateClass != null)
            {
                if (selectListRateClass.ToList().Count > 2)
                    selectListRateClass.ToList().RemoveAt(2);
                if (selectListRateClass.ToList().Count > 1)
                    selectListRateClass.ToList().RemoveAt(1);
            }

            SelectList selectListTariffCode = GetTariffCodeSelectList(Common.NullSafeGuid(lpBillingType.UtilityCompanyId), lpBillingType.TariffCodeId);
            if (selectListTariffCode != null)
            {
                if (selectListTariffCode.ToList().Count > 2)
                    selectListTariffCode.ToList().RemoveAt(2);
                if (selectListTariffCode.ToList().Count > 1)
                    selectListTariffCode.ToList().RemoveAt(1);
            }

            SelectList defaultBillingTypeIds = GetBillingTypeIdNameSelectList(lpBillingType.DefaultBillingTypeId);
            if (defaultBillingTypeIds != null)
            {
                if (defaultBillingTypeIds.ToList().Count > 1)
                    defaultBillingTypeIds.ToList().Remove(defaultBillingTypeIds.ToList()[1]);
                if (defaultBillingTypeIds.ToList().Count > 0)
                    defaultBillingTypeIds.ToList().Remove(defaultBillingTypeIds.ToList()[0]);
            }

            SelectList utilityOfferedBillingType = GetBillingTypeIdNameSelectList(utilityOfferedBillingTypeIdNullable);
            if (utilityOfferedBillingType != null)
            {
                if (utilityOfferedBillingType.ToList().Count > 1)
                    utilityOfferedBillingType.ToList().RemoveAt(1);
                if (utilityOfferedBillingType.ToList().Count > 0)
                    utilityOfferedBillingType.ToList().RemoveAt(0);
            }



            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(lpBillingType.UtilityCompanyId.ToString());
            ViewBag.PorDriverId = GetPorDriverSelectList(lpBillingType.PorDriverId);
            ViewBag.LoadProfileId = selectListLoadProfile;
            ViewBag.RateClassId = selectListRateClass;
            ViewBag.TariffCodeId = selectListTariffCode;
            ViewBag.DefaultBillingTypeIds = defaultBillingTypeIds;
            ViewBag.LpUtilityOfferedBillingTypeId = utilityOfferedBillingType; 

            Session["LpBillingType_AccountTypeName"] = accountTypeName;

            model = new Models.LibertyPowerBillingTypeListModel(lpBillingType,
                utilityOfferedBillingTypeIdNullable, utilityOfferedBillingTypeName, lpApprovedBillingTypeIdNullable,
                lpApprovedBillingTypeName, terms, accountTypeName);

            return model;
        }

        private List<bool> GetDuplicateRecordData(Guid utilityCompanyId, Guid porDriverId,
            Guid? loadProfileId, Guid? rateClassId, Guid? tariffCodeId, Guid utilityOfferedBillingTypeId)
        {
            string method = string.Format("GetDuplicateRecordData(utilityCompanyId:{0},porDriverId:{1},loadProfileId:{2},rateClassId:{3},tariffCodeId:{4},utilityOfferedBillingTypeId:{5})",
                Common.NullSafeString(utilityCompanyId), Common.NullSafeString(porDriverId), Common.NullSafeString(loadProfileId),
                Common.NullSafeString(rateClassId), Common.NullSafeString(tariffCodeId), Common.NullSafeString(utilityOfferedBillingTypeId));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                List<bool> results = new List<bool>();
                var c = _db.usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists(utilityCompanyId, porDriverId, loadProfileId, rateClassId, tariffCodeId, utilityOfferedBillingTypeId, null).FirstOrDefault();
                results.Add(c.BillingTypeExists == 1);
                results.Add(c.BillingTypeAndUtilityOfferedBillingTypeExist == 1);
                results.Add(c.BillingTypeAndUtilityOfferedBillingAndLibertyPowerApprovedBillingTypeExist == 1);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} return results:{3} {4}", Common.NAMESPACE, CLASS, method, results, Common.END));
                return results;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                throw;
            }
        }

        SelectList GetTrimmedLoadProfileSelectList(Guid utilityCompanyId, Guid? loadProfileId)
        {
            SelectList selectListLoadProfile = GetLoadProfileSelectList(utilityCompanyId, loadProfileId);
            selectListLoadProfile = TrimSelectList(selectListLoadProfile);
            return selectListLoadProfile;
        }

        SelectList GetTrimmedRateClassSelectList(Guid utilityCompanyId, Guid? rateClassId)
        {
            SelectList selectListRateClass = GetLoadProfileSelectList(utilityCompanyId, rateClassId);
            selectListRateClass = TrimSelectList(selectListRateClass);
            return selectListRateClass;
        }

        SelectList GetTrimmedTariffCodeSelectList(Guid utilityCompanyId, Guid? tariffCodeId)
        {
            SelectList selectListTariffCode = GetTariffCodeSelectList(utilityCompanyId, tariffCodeId);
            selectListTariffCode = TrimSelectList(selectListTariffCode);
            return selectListTariffCode;
        }


        private Models.LibertyPowerBillingTypeListModel InitializeLibertyPowerBillingTypeListModel(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel)
        {
            libertyPowerBillingTypeListModel.Id = Guid.NewGuid();
            libertyPowerBillingTypeListModel.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
            libertyPowerBillingTypeListModel.CreatedDate = DateTime.Now;
            libertyPowerBillingTypeListModel.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
            libertyPowerBillingTypeListModel.LastModifiedDate = DateTime.Now;
            return libertyPowerBillingTypeListModel;
        }

        public bool IsADuplicate(Models.LibertyPowerBillingTypeListModel model)
        {

            string requestForm = Request.Form[0].ToString();
            List<string> requestFormList = requestForm.Split('_').ToList();
            Guid tempUtilityOfferedBillingTypeId = new Guid(requestFormList[2]);
            Guid tempLpBillingTypeId = new Guid(requestFormList[1]);

            var lpBillingTypes = _db.LpBillingTypes.Where(x => x.UtilityCompanyId == new Guid(model.SelectedUtilityCompanyId) &&
                    x.PorDriverId == model.PorDriverId && ((x.PorDriver.Name.Trim().ToLower() == "rate class" && x.RateClassId == model.RateClassId) ||
                      (x.PorDriver.Name.Trim().ToLower() == "load profile" && x.LoadProfileId == model.LoadProfileId) ||
                      (x.PorDriver.Name.Trim().ToLower() == "tariff code" && x.TariffCodeId == model.TariffCodeId)) ).FirstOrDefault();

            int countUtilityOfferedBillingTypes = _db.LpUtilityOfferedBillingTypes.Where( x => x.LpBillingTypeId == model.Id &&
                        x.UtilityOfferedBillingTypeId == model.UtilityOfferedBillingTypeId ).Count();

            var luobt = _db.LpUtilityOfferedBillingTypes.Where(x => x.LpBillingTypeId == tempLpBillingTypeId && x.UtilityOfferedBillingTypeId == tempUtilityOfferedBillingTypeId).FirstOrDefault();

            int luobtCount = _db.LpUtilityOfferedBillingTypes.Where(x => x.Id != luobt.Id && x.LpBillingTypeId == tempLpBillingTypeId && x.UtilityOfferedBillingTypeId == model.UtilityOfferedBillingTypeId).Count();

            int countLpBillingTypes = lpBillingTypes == null ? 0 : 1;

            bool returnValue = countLpBillingTypes > 0 && luobtCount > 0;
            if (returnValue)
            {
                Session["ErrorMessage"] = "This is a duplicate record!";
            }

            return returnValue;

        }

        public bool IsLpBillingTypeValid(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel)
        {
            return
            libertyPowerBillingTypeListModel != null && Common.IsValidString(libertyPowerBillingTypeListModel.CreatedBy) &&
            Common.IsValidDate(libertyPowerBillingTypeListModel.CreatedDate) && Common.IsValidString(libertyPowerBillingTypeListModel.LastModifiedBy) &&
            Common.IsValidDate(libertyPowerBillingTypeListModel.LastModifiedDate) && Common.IsValidGuid(libertyPowerBillingTypeListModel.PorDriverId) &&
            ((libertyPowerBillingTypeListModel.TariffCodeId != null && Common.IsValidGuid((Guid)libertyPowerBillingTypeListModel.TariffCodeId)) ||
                (libertyPowerBillingTypeListModel.RateClassId != null && Common.IsValidGuid((Guid)libertyPowerBillingTypeListModel.RateClassId)) ||
                (libertyPowerBillingTypeListModel.LoadProfileId != null && Common.IsValidGuid((Guid)libertyPowerBillingTypeListModel.LoadProfileId))
            ) && Common.IsValidGuid(libertyPowerBillingTypeListModel.DefaultBillingTypeId) &&
            Common.IsValidGuid(Common.NullSafeGuid(libertyPowerBillingTypeListModel.SelectedUtilityCompanyId));
        }

        private bool IsModelValid(Models.LibertyPowerBillingTypeListModel model)
        {
            string method = string.Format("IsModelValid(Models.LibertyPowerBillingTypeListModel model:{0})", model == null ? "NULL VALUE" : model.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                model.PorDriverId = new Guid(Session["LpBillingTypePorDriverId"] == null ? Guid.Empty.ToString() : Session["LpBillingTypePorDriverId"].ToString());
                int terms = 0;

                if (model.DefaultBillingTypeId != null && model.DefaultBillingTypeId != Guid.Empty && model.PorDriverId != null
                    && model.PorDriverId != Guid.Empty && model.UtilityOfferedBillingTypeId != null && model.UtilityOfferedBillingTypeId != Guid.Empty
                    && ((Request.Form["Terms"] != null && int.TryParse(Request.Form["Terms"].ToString(), out terms) && model.Terms >= 0) || 
                    (string.IsNullOrWhiteSpace(Request.Form["Terms"]) && model.Terms == null)) && !string.IsNullOrWhiteSpace(model.SelectedUtilityCompanyId)
                    && !IsADuplicate(model))
                {
                    string porDriverName = _db.PorDrivers.Where(x => x.Id == model.PorDriverId).FirstOrDefault().Name;
                    switch (porDriverName.ToLower())
                    {
                        case "load profile":
                            returnValue = Session["LpBillingTypeLoadProfileId"] != null && Session["LpBillingTypeLoadProfileId"].ToString() != Guid.Empty.ToString();
                            break;
                        case "tariff code":
                            returnValue = Session["LpBillingTypeTariffCodeId"] != null && Session["LpBillingTypeTariffCodeId"].ToString() != Guid.Empty.ToString();
                            break;
                        case "rate class":
                            returnValue = Session["LpBillingTypeRateClassId"] != null && Session["LpBillingTypeRateClassId"].ToString() != Guid.Empty.ToString();
                            break;
                    }
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} returnValue:{3} {4}", Common.NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                throw;
            }
        }

        private Models.LibertyPowerBillingTypeListModel ModifyModel(Models.LibertyPowerBillingTypeListModel model, string parsedId)
        {
            model.Id = Common.NullSafeGuid(parsedId);
            model.SelectedUtilityCompanyId = Common.NullSafeString(Common.NullSafeGuid(Session["UtilityCompanyId"]));
            model.LoadProfileId = Common.NullSafeGuid(Session["LpBillingTypeLoadProfileId"] ?? Guid.Empty);
            model.RateClassId = Common.NullSafeGuid(Session["LpBillingTypeRateClassId"] ?? Guid.Empty);
            model.TariffCodeId = Common.NullSafeGuid(Session["LpBillingTypeTariffCodeId"] ?? Guid.Empty);
            return model;
        }

        private Models.LibertyPowerBillingTypeModel ObtainResponse()
        {
            var response = new Models.LibertyPowerBillingTypeModel();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            return response;
        }

        private UtilityManagement.Models.LibertyPowerBillingTypeModel ObtainResponse(Guid utilityCompanyId)
        {
            var response = new UtilityManagement.Models.LibertyPowerBillingTypeModel();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;

            var resultSet = _db.usp_LibertyPowerBillingType_SELECT_By_UtilityCompanyId(utilityCompanyId);
            response.LpBillingTypeList = new List<Models.LibertyPowerBillingTypeListModel>();
            foreach (var item in resultSet)
            {
                Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel = new Models.LibertyPowerBillingTypeListModel();
                libertyPowerBillingTypeListModel.DefaultBillingTypeId = item.DefaultBillingTypeId;
                libertyPowerBillingTypeListModel.DefaultBillingTypeName = item.DefaultBillingType;
                libertyPowerBillingTypeListModel.Id = item.Id;
                libertyPowerBillingTypeListModel.LoadProfileId = item.LoadProfileId ?? Guid.Empty;
                libertyPowerBillingTypeListModel.LoadProfileCode = item.LoadProfileCode;
                libertyPowerBillingTypeListModel.PorDriverId = item.PorDriverId;
                libertyPowerBillingTypeListModel.PorDriverName = item.Name;
                libertyPowerBillingTypeListModel.RateClassId = item.RateClassId ?? Guid.Empty;
                libertyPowerBillingTypeListModel.RateClassCode = item.RateClassCode;
                libertyPowerBillingTypeListModel.TariffCodeId = item.TariffCodeId ?? Guid.Empty;
                libertyPowerBillingTypeListModel.TariffCode = item.TariffCodeCode;
                libertyPowerBillingTypeListModel.UtilityCode = item.UtilityCode;
                libertyPowerBillingTypeListModel.LpApprovedBillingTypeId = item.LpApprovedBillingTypeId ?? Guid.Empty; ;
                libertyPowerBillingTypeListModel.LpApprovedBillingTypeName = item.LpApprovedBillingType;
                libertyPowerBillingTypeListModel.SelectedUtilityCompanyId = item.UtilityCompanyId.ToString();
                libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeId = item.LpUtilityOfferedBillingTypeId ?? Guid.Empty; ;
                libertyPowerBillingTypeListModel.UtilityOfferedBillingTypeName = item.LpUtilityOfferedBillingType;
                libertyPowerBillingTypeListModel.AccountTypeName = item.AccountType;
                libertyPowerBillingTypeListModel.Terms = item.Terms;
                libertyPowerBillingTypeListModel.CreatedBy = item.CreatedBy;
                libertyPowerBillingTypeListModel.CreatedDate = item.CreatedDate;
                libertyPowerBillingTypeListModel.LastModifiedBy = item.LastModifiedBy;
                libertyPowerBillingTypeListModel.LastModifiedDate = item.LastModifiedDate;
                libertyPowerBillingTypeListModel.Inactive = item.Inactive;
                response.LpBillingTypeList.Add(libertyPowerBillingTypeListModel);
            }

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "PorDriver":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DriverImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.PorDriverName).ToList();
                    }
                    else
                    {
                        ViewBag.DriverImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.PorDriverName).ToList();
                    }
                    break;
                case "LoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.LoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.LoadProfileCode).ToList();
                    }
                    break;
                case "RateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.RateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.RateClassCode).ToList();
                    }
                    break;
                case "TariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.TariffCode).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.TariffCode).ToList();
                    }
                    break;
                case "DefaultBillingType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DefaultBillingTypeImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.DefaultBillingTypeName).ToList();
                    }
                    else
                    {
                        ViewBag.DefaultBillingTypeImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.DefaultBillingTypeName).ToList();
                    }
                    break;
                case "UtilityOfferedBillingType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityOfferedBillingTypeImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.UtilityOfferedBillingTypeName).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityOfferedBillingTypeImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.UtilityOfferedBillingTypeName).ToList();
                    }
                    break;
                case "LpApprovedBillingType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpApprovedBillingTypeImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.LpApprovedBillingTypeName).ToList();
                    }
                    else
                    {
                        ViewBag.LpApprovedBillingTypeImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.LpApprovedBillingTypeName).ToList();
                    }
                    break;
                case "Terms":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TermsImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.Terms).ToList();
                    }
                    else
                    {
                        ViewBag.TermsImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.Terms).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.AccountTypeName).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.AccountTypeName).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.LpBillingTypeList = response.LpBillingTypeList.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }

            return response;
        }

        private LpBillingType PopulateLpBillingType(LpBillingType lpBillingType, Models.LibertyPowerBillingTypeListModel model)
        {
            lpBillingType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
            lpBillingType.LastModifiedDate = DateTime.Now;
            lpBillingType.PorDriverId = model.PorDriverId;
            lpBillingType.Inactive = model.Inactive;
            lpBillingType.LoadProfileId = model.LoadProfileId;
            lpBillingType.RateClassId = model.RateClassId;
            lpBillingType.TariffCodeId = model.TariffCodeId;
            lpBillingType.DefaultBillingTypeId = model.DefaultBillingTypeId;
            return lpBillingType;
        }

        private void SetViewBag(Guid uci)
        {
            SelectList loadProfileIdList = GetLoadProfileSelectListRemoveTopTwoSpaces(uci);
            SelectList rateClassIdList = GetRateClassSelectListRemoveTopTwoSpaces(uci);
            SelectList tariffCodeIdList = GetTariffCodeSelectListRemoveTopTwoSpaces(uci);

            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
            ViewBag.PorDriverId = GetPorDriverSelectList();
            ViewBag.LoadProfileId = loadProfileIdList;
            ViewBag.RateClassId = rateClassIdList;
            ViewBag.TariffCodeId = tariffCodeIdList;
            ViewBag.DefaultBillingTypeIds = GetBillingTypeIdSelectList();
            ViewBag.LpApprovedBillingTypeId = GetBillingTypeIdSelectList();
            ViewBag.LpUtilityOfferedBillingTypeId = GetBillingTypeIdSelectList();
            ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
        }

        public SelectList TrimSelectList(SelectList selectList)
        {
            if (selectList != null)
            {
                if (selectList.ToList().Count > 2)
                    selectList.ToList().RemoveAt(2);
                if (selectList.ToList().Count > 1)
                    selectList.ToList().RemoveAt(1);
            }
            return selectList;
        }

        private void UpdateLpApprovedBillingType(string messageId, LpApprovedBillingType lpApprovedBillingType, Models.LibertyPowerBillingTypeListModel model, Guid theId, string userName)
        {
            if (lpApprovedBillingType != null)
            {
                if (model.UtilityOfferedBillingTypeId != null && model.UtilityOfferedBillingTypeId != Guid.Empty && model.LibertyPowerApprovedBillingTypeId)
                {
                    lpApprovedBillingType.ApprovedBillingTypeId = (Guid)model.UtilityOfferedBillingTypeId;
                }
                lpApprovedBillingType.LpBillingTypeId = theId;
                lpApprovedBillingType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
                lpApprovedBillingType.LastModifiedDate = DateTime.Now;
                lpApprovedBillingType.Terms = model.Terms;
                lpApprovedBillingType.Inactive = !model.LibertyPowerApprovedBillingTypeId;
                _db.Entry(lpApprovedBillingType).State = EntityState.Modified;
                _db.SaveChanges();
            }
            else
            {
                if (model.UtilityOfferedBillingTypeId != null && model.UtilityOfferedBillingTypeId != Guid.Empty && model.LibertyPowerApprovedBillingTypeId)
                {
                    lpApprovedBillingType = new LpApprovedBillingType()
                    { Id = Guid.NewGuid(), LpBillingTypeId = theId, ApprovedBillingTypeId = (Guid)model.UtilityOfferedBillingTypeId,
                        LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                        LastModifiedDate = DateTime.Now, 
                        CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                        CreatedDate = DateTime.Now,
                        Terms = model.Terms, Inactive = false };
                    _db.Entry(lpApprovedBillingType).State = EntityState.Added;
                    _db.SaveChanges();
                }
            }
        }

        private void UpdateLpUtilityOfferedBillingType(string messageId, LpUtilityOfferedBillingType lpUtilityOfferedBillingType, Models.LibertyPowerBillingTypeListModel model, Guid theId, string userName)
        {
            if (lpUtilityOfferedBillingType != null)
            {
                if (model.UtilityOfferedBillingTypeId != null && model.UtilityOfferedBillingTypeId != Guid.Empty)
                {
                    lpUtilityOfferedBillingType.LpBillingTypeId = theId;
                    lpUtilityOfferedBillingType.UtilityOfferedBillingTypeId = (Guid)model.UtilityOfferedBillingTypeId;
                    lpUtilityOfferedBillingType.LastModifiedBy = userName;
                    lpUtilityOfferedBillingType.LastModifiedDate = DateTime.Now;
                    lpUtilityOfferedBillingType.Inactive = model.Inactive;
                }
                else
                {
                    lpUtilityOfferedBillingType.LpBillingTypeId = theId;
                    lpUtilityOfferedBillingType.LastModifiedBy = userName;
                    lpUtilityOfferedBillingType.LastModifiedDate = DateTime.Now;
                    lpUtilityOfferedBillingType.Inactive = model.Inactive;
                }
                _db.Entry(lpUtilityOfferedBillingType).State = EntityState.Modified;
                _db.SaveChanges();
            }
            else
            {
                if (model.UtilityOfferedBillingTypeId != null && model.UtilityOfferedBillingTypeId != Guid.Empty)
                {
                    lpUtilityOfferedBillingType = new LpUtilityOfferedBillingType()
                    { Id = Guid.NewGuid(), LpBillingTypeId = theId, UtilityOfferedBillingTypeId = model.UtilityOfferedBillingTypeId,
                        LastModifiedBy = userName, LastModifiedDate = DateTime.Now, CreatedBy = userName, CreatedDate = DateTime.Now, Inactive = false };
                    _db.Entry(lpUtilityOfferedBillingType).State = EntityState.Added;
                    _db.SaveChanges();
                }
            }
        }

        private LpBillingType LpBillingTypeUpdate(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel, LpBillingType lpBillingType)
        {
            lpBillingType.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
            lpBillingType.CreatedDate = DateTime.Now;
            lpBillingType.DefaultBillingTypeId = libertyPowerBillingTypeListModel.DefaultBillingTypeId;
            lpBillingType.Inactive = libertyPowerBillingTypeListModel.Inactive;
            lpBillingType.LoadProfileId = libertyPowerBillingTypeListModel.LoadProfileId;
            lpBillingType.PorDriverId = libertyPowerBillingTypeListModel.PorDriverId;
            lpBillingType.RateClassId = libertyPowerBillingTypeListModel.RateClassId;
            lpBillingType.TariffCodeId = libertyPowerBillingTypeListModel.TariffCodeId;
            lpBillingType.UtilityCompanyId = new Guid(libertyPowerBillingTypeListModel.SelectedUtilityCompanyId);
            return lpBillingType;
        }

        private LpBillingType LpBillingTypeCreate(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel)
        {
            LpBillingType lpBillingType = new LpBillingType()
            { CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now, 
                DefaultBillingTypeId = libertyPowerBillingTypeListModel.DefaultBillingTypeId,
                Inactive = libertyPowerBillingTypeListModel.Inactive, 
                Id = Guid.NewGuid(), 
                LoadProfileId = libertyPowerBillingTypeListModel.LoadProfileId,
                PorDriverId = libertyPowerBillingTypeListModel.PorDriverId,
                RateClassId = libertyPowerBillingTypeListModel.RateClassId,
                TariffCodeId = libertyPowerBillingTypeListModel.TariffCodeId, 
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), LastModifiedDate = DateTime.Now,
                UtilityCompanyId = new Guid(libertyPowerBillingTypeListModel.SelectedUtilityCompanyId)
            };
            if (lpBillingType.LoadProfileId == Guid.Empty)
                lpBillingType.LoadProfileId = null;
            if (lpBillingType.RateClassId == Guid.Empty)
                lpBillingType.RateClassId = null;
            if (lpBillingType.TariffCodeId == Guid.Empty)
                lpBillingType.TariffCodeId = null;

            return lpBillingType;
        }

        private LpBillingType GetLpBillingType(Models.LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel, Guid utilityCompanyId)
        {
            LpBillingType lpBillingType = _db.LpBillingTypes.Where(x => x.UtilityCompanyId == utilityCompanyId && 
                x.PorDriverId == libertyPowerBillingTypeListModel.PorDriverId &&
                (( libertyPowerBillingTypeListModel.LoadProfileId != null && libertyPowerBillingTypeListModel.LoadProfileId != Guid.Empty &&
                    x.LoadProfileId == libertyPowerBillingTypeListModel.LoadProfileId ) ||
                    ( libertyPowerBillingTypeListModel.RateClassId != null && libertyPowerBillingTypeListModel.RateClassId != Guid.Empty &&
                        x.RateClassId == libertyPowerBillingTypeListModel.RateClassId ) ||
                    ( libertyPowerBillingTypeListModel.TariffCodeId != null && libertyPowerBillingTypeListModel.TariffCodeId != Guid.Empty &&
                        x.TariffCodeId == libertyPowerBillingTypeListModel.TariffCodeId ) )).FirstOrDefault();
            var abc = _db.LpBillingTypes.Where(x => x.UtilityCompanyId == utilityCompanyId && x.PorDriverId == libertyPowerBillingTypeListModel.PorDriverId &&
                ( ( libertyPowerBillingTypeListModel.LoadProfileId != null && libertyPowerBillingTypeListModel.LoadProfileId != Guid.Empty &&
                    x.LoadProfileId == libertyPowerBillingTypeListModel.LoadProfileId ) ||
                    ( libertyPowerBillingTypeListModel.RateClassId != null && libertyPowerBillingTypeListModel.RateClassId != Guid.Empty &&
                        x.RateClassId == libertyPowerBillingTypeListModel.RateClassId ) || ( libertyPowerBillingTypeListModel.TariffCodeId != null &&
                        libertyPowerBillingTypeListModel.TariffCodeId != Guid.Empty && x.TariffCodeId == libertyPowerBillingTypeListModel.TariffCodeId ) ));
            return lpBillingType;
        }
        #endregion
    }
}
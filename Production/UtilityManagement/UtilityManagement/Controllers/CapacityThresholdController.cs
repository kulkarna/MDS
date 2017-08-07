using DataAccessLayerEntityFramework;
using ExcelBusinessLayer;
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

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class CapacityThresholdController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string NAMESPACE = "UtilityManagement.Controllers";
        private const string CLASS = "CapacityTresholdController";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_INDEX = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_INDEX";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_CREATE = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_CREATE";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_EDIT = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_EDIT";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_DETAIL = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_DETAIL";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_UPLD = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_UPLD";
        private const string UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD = "UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD";
        #endregion

        #region public constructors
        public CapacityThresholdController()
            : base()
        {
            ViewBag.PageName = "CapacityThreshold";
            ViewBag.IndexPageName = "CapacityThreshold";
            ViewBag.PageDisplayName = "Capacity Threshold";
        }
        #endregion

        #region public methods
        // GET: /CapacityTreshold/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = string.Format("Index(utilityCompanyId:{0})", utilityCompanyId);
            
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_INDEX });
                }

                Guid idTemp = Guid.Empty;
                Models.CapacityTresholdModel capacityTreshold = new Models.CapacityTresholdModel();

                var item = _db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode);
                List<UtilityCompany> utilityList = new List<UtilityCompany>();
                SelectList utilityCompany = null;

                if (utilityCompanyId == null && Session["CapacityTreshold_UtilityCompanyId_Set"] == null && idTemp == Guid.Empty)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty start");
                    utilityList.Add(new UtilityCompany() { Id = Guid.Empty, UtilityCode = string.Empty });
                    utilityList.AddRange(item);
                    utilityCompany = new SelectList(utilityList, "Id", "UtilityCode");

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty ending");
                }
                else
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "!(utilityCompanyId == null && Session[CapacityTreshold_UtilityCompanyId_Set] == null && idTemp == Guid.Empty)");
                    utilityList.AddRange(item);
                    utilityCompanyId = utilityCompanyId ?? Session["CapacityTreshold_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "CapacityTreshold = ObtainResponse(id);");

                    capacityTreshold = ObtainResponse(id);

                    utilityCompany = new SelectList(utilityList, "Id", "UtilityCode", utilityCompanyId);
                    Session["UtilityCode"] = string.Empty;
                    if (capacityTreshold != null && capacityTreshold.CapacityTresholdList != null && capacityTreshold.CapacityTresholdList.Count > 0 && capacityTreshold.CapacityTresholdList[0] != null && !string.IsNullOrWhiteSpace(capacityTreshold.CapacityTresholdList[0].UtilityCode))
                    {
                        Session["UtilityCode"] = capacityTreshold.CapacityTresholdList[0].UtilityCode;
                    }
                    else if (id != null && id != Guid.Empty)
                    {
                        Session["UtilityCode"] = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault().UtilityCode;
                    }
                }
                capacityTreshold.SelectedUtilityCompanyId = utilityCompanyId;
                ViewBag.UtilityCompanyId = utilityCompany;

                _logger.LogDebug(Session["UtilityCode"]);

                if (Session["ResultData"] != null)
                {
                    Session["ResultDataOld"] = Session["ResultData"];
                    if (!(Session["FirstTimeThrough"] != null && (bool)Session["FirstTimeThrough"] == true))
                    {
                        Session["ResultData"] = null;
                        
                    }
                }
                Session["FirstTimeThrough"] = false;
                _logger.LogInfo(Session["FirstTimeThrough"]);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, capacityTreshold));
                return View(capacityTreshold);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.CapacityTresholdModel());
            }
        }

        //
        // GET: /CapacityTreshold/Create
        public ActionResult Create(string utilityCompanyId)
        {
            string method = "Create()";
            Guid uci = new Guid(Session["CapacityTreshold_UtilityCompanyId_Set"].ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_CREATE });
                }
                if (utilityCompanyId == null && Session["CapacityTreshold_UtilityCompanyId_Set"] == null)
                {
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Company Not Selected {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }

                
                Session[Common.ISPOSTBACK] = "false";
                CapacityThresholdRule capacityThresholdRule = new CapacityThresholdRule()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci,
                    IgnoreCapacityFactor=true
                   
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList();
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} capacityThresholdRule:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, capacityThresholdRule));
                return View(capacityThresholdRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList();
                
                return View(new CapacityThresholdRule());
            }
        }

        //
        // POST: /CapacityTreshold/Create
        [HttpPost]
        public ActionResult Create(CapacityThresholdRule capacityThresholdRule, string submitButton)
        {
            string method = string.Format("Create(capacityThresholdRule capacityThresholdRule:{0})", capacityThresholdRule == null ? "NULL VALUE" : capacityThresholdRule.ToString());
            Guid uci = new Guid(Session["CapacityTreshold_UtilityCompanyId_Set"].ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                }
                
                Session[Common.ISPOSTBACK] = "true";
                capacityThresholdRule.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                capacityThresholdRule.CreatedDate = DateTime.Now;
                capacityThresholdRule.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                capacityThresholdRule.LastModifiedDate = DateTime.Now;
                capacityThresholdRule.UtilityCompanyId = uci;
                capacityThresholdRule.IgnoreCapacityFactor = !(capacityThresholdRule.IgnoreCapacityFactor);
                if ((capacityThresholdRule.IgnoreCapacityFactor))
                {
                    capacityThresholdRule.CapacityThreshold = 0;
                    capacityThresholdRule.CapacityThresholdMax = 999;
                    if(ModelState["CapacityThresholdMax"].Errors.Count>0)
                    ModelState["CapacityThresholdMax"].Errors.Clear();
                    if (ModelState["CapacityThreshold"].Errors.Count > 0)
                        ModelState["CapacityThreshold"].Errors.Clear();
                  
                }
                if (ModelState.IsValid)
                {
                    if (capacityThresholdRule.IsCapacityTresholdValid())
                    {
                        _db.CapacityThresholdRules.Add(capacityThresholdRule);
                        try
                        {
                            _db.SaveChanges();
                        }
                        catch (Exception excSave)
                        {
                            if (excSave != null &&
                                excSave.InnerException != null &&
                                excSave.InnerException.InnerException != null &&
                                excSave.InnerException.InnerException.Message != null &&
                                excSave.InnerException.InnerException.Message.Contains("UX_CapacityThresholdRule_UtilityCompanyId_CustomerAccountTypeId_Unique"))
                            {
                                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList();
                                Session["ErrorMessage"] = "Record Already Exists!";
                                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                return View(capacityThresholdRule);
                            }
                        }
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        Session["ErrorMessage"] = capacityThresholdRule.IsCapacityTresholdErrorMessage();
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(capacityThresholdRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList();
                return View(capacityThresholdRule);
            }
        }

        //
        // GET: /CapacityTreshold/Edit/5
        public ActionResult Edit(long id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullableLargeInteger(id));
            
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                CapacityThresholdRule capacityThresholdRule =_db.CapacityThresholdRules.Find(id);
                if (capacityThresholdRule == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = capacityThresholdRule.CreatedBy;
                Session[Common.CREATEDDATE] = capacityThresholdRule.CreatedDate;
                Session["UtilityCompanyId"] = capacityThresholdRule.UtilityCompanyId;
                Session["UtilityCompanyName"] = capacityThresholdRule.UtilityCompany.UtilityCode;
                Session["CustomerAccountTypeId"] = capacityThresholdRule.CustomerAccountTypeId;
                ViewBag.UtilityCompanyId = capacityThresholdRule.UtilityCompanyId;
                ViewBag.UtilityCode = capacityThresholdRule.UtilityCompany.UtilityCode;
                ViewBag.CapacityTresholdMinValue=capacityThresholdRule.CapacityThreshold;
                ViewBag.CapacityTresholdMaxValue =(capacityThresholdRule.CapacityThresholdMax);
                ViewBag.CustomerAccountType = capacityThresholdRule.CustomerAccountType.AccountType;
                Session["CustomerAccountType"] = capacityThresholdRule.CustomerAccountType.AccountType;
                ViewBag.CustomerAccountTypeId = GetAccountIdSelectList(capacityThresholdRule.CustomerAccountTypeId);
                capacityThresholdRule.IgnoreCapacityFactor = !capacityThresholdRule.IgnoreCapacityFactor;
                ViewBag.IgnoreCapacityFactor = capacityThresholdRule.IgnoreCapacityFactor;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} capacityThresholdRule:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, capacityThresholdRule));
                return View(capacityThresholdRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                CapacityThresholdRule capacityThresholdRule = _db.CapacityThresholdRules.Find(id);
                ViewBag.UtilityCompanyId = capacityThresholdRule.UtilityCompanyId;
                ViewBag.UtilityCode = capacityThresholdRule.UtilityCompany.UtilityCode;
                ViewBag.CustomerAccountTypeId = capacityThresholdRule.CustomerAccountTypeId;
                return View(capacityThresholdRule);
            }
        }


        //
        // POST: /CapacityTreshold/Edit/5
        [HttpPost]
        public ActionResult Edit(CapacityThresholdRule capacityThresholdRule, string submitButton)
        {
            string method = string.Format("Edit(CapacityThresholdRule capacityThresholdRule:{0})", capacityThresholdRule == null ? "NULL VALUE" : capacityThresholdRule.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                }

                Session[Common.ISPOSTBACK] = "true";
                capacityThresholdRule.UtilityCompanyId = (Guid)Session["UtilityCompanyId"];
                capacityThresholdRule.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                capacityThresholdRule.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                capacityThresholdRule.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; // Common.GetUserName(User.Identity.Name);
                capacityThresholdRule.LastModifiedDate = DateTime.Now;
                capacityThresholdRule.IgnoreCapacityFactor = !capacityThresholdRule.IgnoreCapacityFactor;
                capacityThresholdRule.CustomerAccountTypeId = Common.NullSafeInteger(Session["CustomerAccountTypeId"]);
                ViewBag.CapacityThresholdMoney = capacityThresholdRule.CapacityThreshold;
                ViewBag.CapacityThresholdUpperLimit = capacityThresholdRule.CapacityThresholdMax;

                if ((capacityThresholdRule.IgnoreCapacityFactor))
                {
                    capacityThresholdRule.CapacityThreshold = 0;
                    capacityThresholdRule.CapacityThresholdMax = 999;
                    if (ModelState["CapacityThresholdMax"].Errors.Count > 0)
                        ModelState["CapacityThresholdMax"].Errors.Clear();
                    if (ModelState["CapacityThreshold"].Errors.Count > 0)
                        ModelState["CapacityThreshold"].Errors.Clear();
                }
                if (ModelState.IsValid)
                {
                    if (capacityThresholdRule.IsCapacityTresholdValid())
                    {
                        _db.Entry(capacityThresholdRule).State = EntityState.Modified;
                        try
                        {
                            _db.SaveChanges();
                        }
                        catch (Exception excSave)
                        {
                            if (excSave != null &&
                                excSave.InnerException != null &&
                                excSave.InnerException.InnerException != null &&
                                excSave.InnerException.InnerException.Message != null &&
                                excSave.InnerException.InnerException.Message.Contains("UX_CapacityThresholdRule_UtilityCompanyId_CustomerAccountTypeId_Unique"))
                            {
                                ViewBag.UtilityCompanyId = capacityThresholdRule.UtilityCompanyId;
                                ViewBag.UtilityCode = capacityThresholdRule.UtilityCompany.UtilityCode;
                                ViewBag.CustomerAccountTypeId = capacityThresholdRule.CustomerAccountTypeId;
                                Session["ErrorMessage"] = "Record Already Exists!";
                                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                               
                                return View(capacityThresholdRule);
                            }
                        }
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        Session["ErrorMessage"] = capacityThresholdRule.IsCapacityTresholdErrorMessage();
                    }
                    Session[Common.CREATEDBY] = capacityThresholdRule.CreatedBy;
                    Session[Common.CREATEDDATE] = capacityThresholdRule.CreatedDate;
                     
                }
                ViewBag.UtilityCompanyId = capacityThresholdRule.UtilityCompanyId;
                ViewBag.UtilityCode = Common.NullSafeString(Session["UtilityCompanyName"]);
                ViewBag.CapacityTresholdMinValue =capacityThresholdRule.CapacityThreshold;
                ViewBag.CapacityTresholdMaxValue = (capacityThresholdRule.CapacityThresholdMax);
                ViewBag.CustomerAccountType = Common.NullSafeString(Session["CustomerAccountType"]);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
               
                return View(capacityThresholdRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
               
                return View(capacityThresholdRule);
            }
        }

        //
        // GET: /CapacityTreshold/Details/5
        public ActionResult Details(long id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeLargeInteger(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_DETAIL });
                }
                Session[Common.ISPOSTBACK] = "false";
                CapacityThresholdRule capacityThresholdRule = _db.CapacityThresholdRules.Find(id);
                if (capacityThresholdRule == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                
                ViewBag.UtilityCompanyId = capacityThresholdRule.UtilityCompanyId;
                ViewBag.UtilityCode = capacityThresholdRule.UtilityCompany.UtilityCode;
                ViewBag.CapacityTresholdMinValue = capacityThresholdRule.CapacityThreshold;
                ViewBag.CapacityTresholdMaxValue = (capacityThresholdRule.CapacityThresholdMax);
                capacityThresholdRule.IgnoreCapacityFactor = !capacityThresholdRule.IgnoreCapacityFactor;
                ViewBag.IgnoreCapacityFactor = capacityThresholdRule.IgnoreCapacityFactor;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} capacityThresholdRule:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, capacityThresholdRule));
                return View(capacityThresholdRule);
                
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View( new CapacityThresholdRule());
            }
        }


        public ActionResult Download()
        {
            string method = "Download()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Utilities.Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                CapacityTresholdRuleBusinessLayer capacityTresholdRuleBusinessLayer = new CapacityTresholdRuleBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["CapacityTreshold_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"{0}_CapacityThresholdRule_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                capacityTresholdRuleBusinessLayer.SaveFromDatabaseToExcel(messageId, uci.ToString(), string.Format(filePathAndName, Guid.NewGuid().ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Saved", Common.NAMESPACE, CLASS, method));

                // download file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response = System.Web.HttpContext.Current.Response", Common.NAMESPACE, CLASS, method));
                response.ClearContent();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ClearContent()", Common.NAMESPACE, CLASS, method));
                response.Clear();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.Clear()", Common.NAMESPACE, CLASS, method));
                response.ContentType = "application/vnd.xls";
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ContentType = \"application/vnd.xls\"", Common.NAMESPACE, CLASS, method));
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Transmitting File", Common.NAMESPACE, CLASS, method));
                response.TransmitFile(filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Transmitted", Common.NAMESPACE, CLASS, method));
                response.End();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Deleting File", Common.NAMESPACE, CLASS, method));
                // delete file
                System.Threading.Thread.Sleep(2000);
                System.IO.File.Delete(filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Deleted", Common.NAMESPACE, CLASS, method));

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "CapacityThreshold");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
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
                string messageId = Utilities.Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                CapacityTresholdRuleBusinessLayer capacityTresholdRuleBusinessLayer = new CapacityTresholdRuleBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["CapacityTreshold_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"All_CapacityThresholdRule_{0}{1}{2}{3}{4}{5}.xlsx",
                    DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'),
                    DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'),
                    DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                capacityTresholdRuleBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Saved", Common.NAMESPACE, CLASS, method));

                // download file
                System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response = System.Web.HttpContext.Current.Response", Common.NAMESPACE, CLASS, method));
                response.ClearContent();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ClearContent()", Common.NAMESPACE, CLASS, method));
                response.Clear();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.Clear()", Common.NAMESPACE, CLASS, method));
                response.ContentType = "application/vnd.xls";
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ContentType = \"application/vnd.xls\"", Common.NAMESPACE, CLASS, method));
                response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Transmitting File", Common.NAMESPACE, CLASS, method));
                response.TransmitFile(filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Transmitted", Common.NAMESPACE, CLASS, method));
                response.End();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Deleting File", Common.NAMESPACE, CLASS, method));
                // delete file
                System.Threading.Thread.Sleep(2000);
                System.IO.File.Delete(filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Deleted", Common.NAMESPACE, CLASS, method));

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "CapacityThreshold");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_CapacityThresholdRuleImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "CapacityThresholdRule");
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
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string userName = Common.NullSafeString(GetUserName(messageId));

                // security check
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_CAPACITYTRESHOLD_UPLD))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_CAPACITYTRESHOLD_UPLD });
                }

                string path = @"Temp";

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.CapacityThresholdExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.CapacityThresholdExcelWorksheetUtility(_logger, LicensePath);
                    CapacityTresholdRuleBusinessLayer capacityTresholdRuleBusinessLayer = new CapacityTresholdRuleBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["CapacityTreshold_UtilityCompanyId_Set"].ToString());
                    string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                    string fileFileName = file.FileName;
                    if (fileFileName.LastIndexOf('\\') > 0)
                    {
                        fileFileName = fileFileName.Substring(fileFileName.LastIndexOf('\\') + 1);
                    }
                    string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", path, fileFileName));

                    if (!filePathAndName.Trim().ToLower().EndsWith(".xlsx"))
                    {
                        Session["ResultData"] = new List<string>() { "Invalid File Type." };
                        Session["FirstTimeThrough"] = true;
                        capacityTresholdRuleBusinessLayer.TabSummaryWithRowNumbersList.Clear();
                        capacityTresholdRuleBusinessLayer.TabSummaryWithRowNumbersList.Add("Invalid File Type.");
                        Session["TabSummaryWithRowNumbersList"] = capacityTresholdRuleBusinessLayer.TabSummaryWithRowNumbersList;
                        return RedirectToAction("Index");
                    }

                    file.SaveAs(filePathAndName);

                    capacityTresholdRuleBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(capacityTresholdRuleBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = capacityTresholdRuleBusinessLayer.TabSummaryWithRowNumbersList;
                }
                Session["FirstTimeThrough"] = true;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<CapacityThresholdRule>());
            }
        }
        #endregion
        #region private and protected methods
        private Models.CapacityTresholdModel ObtainResponse(Guid id)
        {
            List<usp_CapacityThresholdRuleGetByUtilityCode_Result> capacityThresholdRuleList = _db.usp_CapacityThresholdRuleGetByUtilityCode(Convert.ToString(id)).ToList();
            Models.CapacityTresholdModel response = new Models.CapacityTresholdModel();
            response.CapacityTresholdList = new List<Models.CapacityTresholdListModel>();
            foreach (usp_CapacityThresholdRuleGetByUtilityCode_Result item in capacityThresholdRuleList)
            {
                Models.CapacityTresholdListModel capacityTresholdListModel = new Models.CapacityTresholdListModel(item);
                response.CapacityTresholdList.Add(capacityTresholdListModel);
            }
            response.CapacityTresholdList = response.CapacityTresholdList.OrderBy(x => x.AccountType).ToList();
            _logger.LogDebug("ObtainResponse END");
            return response;
        }
        #endregion

        #region public methods returning JsonResult
        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = string.Format("Index(string utilityCompanyId:{0})", utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["CapacityTreshold_UtilityCompanyId_Set"] = utilityCompanyId;
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

        public void ProcessUtilityCompanyId(ref string utilityCompanyId, ref Guid idTemp)
        {
            if (string.IsNullOrWhiteSpace(utilityCompanyId))
            {
                string url = Request.Url.ToString();
                try
                {
                    idTemp = new Guid(url.Substring(url.LastIndexOf('/') + 1));
                    utilityCompanyId = idTemp.ToString();
                }
                catch (Exception) { }
            }
        }
    }

}
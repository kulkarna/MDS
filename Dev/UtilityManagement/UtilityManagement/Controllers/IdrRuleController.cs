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
    public class IdrRuleController : Controller
    {
        #region private variables and constants
        private ILogger _logger;
        private const string ISPOSTBACK = "IsPostBack";
        private const string MESSAGEID = "MessageId";
        private const string NAMESPACE = "UtilityManagement.Controllers";
        private const string CLASS = "IdrRuleController";
        private const string CREATEDBY = "CreatedBy";
        private const string CREATEDDATE = "CreatedDate";
        private const string BEGIN = "BEGIN";
        private const string END = "END";
        private const string ERRORMESSAGE = "ErrorMessage";
        private const string SORTCOLUMNNAME = "SortColumnName";
        private const string SORTDIRECTION = "SortDirection";
        private const string ASC = "Asc";
        private const string DESC = "Desc";
        private Lp_UtilityManagementEntities db;
        #endregion

        #region public constructors
        public IdrRuleController()
        {
            db = new Lp_UtilityManagementEntities();
            _logger = UnityLoggerGenerator.GenerateLogger();
        }
        #endregion

        #region public methods
        //
        // GET: /IdrRule/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ObtainResponse();

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<IdrRule>());
            }
        }

        //
        // GET: /IdrRule/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                IdrRule idrRule = db.IdrRules.Find(id);

                if (idrRule == null)
                {
                    _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", NAMESPACE, CLASS, method, END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRule:{4} {3}", NAMESPACE, CLASS, method, END, idrRule));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new IdrRule());
            }
        }

        //
        // GET: /IdrRule/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                Session[ISPOSTBACK] = "false";
                IdrRule idrRule = new IdrRule()
                {
                    CreatedBy = "User", //Common.GetUserName(User.Identity.Name),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = "User", //Common.GetUserName(User.Identity.Name),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RequestModeTypeId = new SelectList(db.RequestModeTypes.OrderBy(x => x.Name), "Id", "Name");
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                //ViewBag.RateClassId = new SelectList(db.RateClasses.OrderBy(x => x.RateClassCode), "Id", "RateClassCode");
                //ViewBag.LoadProfileId = new SelectList(db.LoadProfiles.OrderBy(x => x.LoadProfileCode), "Id", "LoadProfileCode");
                //ViewBag.ServiceClassId = new SelectList(db.ServiceClasses.OrderBy(x => x.ServiceClassCode), "Id", "ServiceClassCode");
                //ViewBag.MeterTypeId = new SelectList(db.MeterTypes.OrderBy(x => x.MeterTypeCode), "Id", "MeterTypeCode");
                ViewBag.RateClassId = new SelectList(db.usp_RateClass_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.LoadProfileId = new SelectList(db.usp_LoadProfile_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.ServiceClassId = new SelectList(db.usp_ServiceClass_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.MeterTypeId = new SelectList(db.usp_MeterType_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRule:{4} {3}", NAMESPACE, CLASS, method, END, idrRule));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new IdrRule());
            }
        }

        public ActionResult UtilityCompanyIdSelection(Guid utilityCompanyId)
        {
            string method = string.Format("UtilityCompanyIdSelection(utilityCompanyId:{0})", utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                IdrRule idrRule = new IdrRule()
                {
                    CreatedBy = "User", //Common.GetUserName(User.Identity.Name),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = "User", //Common.GetUserName(User.Identity.Name),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RateClassId = db.usp_RateClass_SELECT_By_UtilityCompanyId(utilityCompanyId.ToString()).ToList().OrderBy(x => x.Name);//new SelectList(db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).OrderBy(x => x.RateClassCode), "Id", "RateClassCode");
                ViewBag.LoadProfileId = db.usp_LoadProfile_SELECT_By_UtilityCompanyId(utilityCompanyId.ToString()).ToList().OrderBy(x => x.Name);//new SelectList(db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId).OrderBy(x => x.LoadProfileCode), "Id", "LoadProfileCode");
                ViewBag.ServiceClassId = db.usp_ServiceClass_SELECT_By_UtilityCompanyId(utilityCompanyId.ToString()).ToList().OrderBy(x => x.Name);//new SelectList(db.ServiceClasses.Where(x => x.UtilityCompanyId == utilityCompanyId).OrderBy(x => x.ServiceClassCode), "Id", "ServiceClassCode");
                ViewBag.MeterTypeId = db.usp_MeterType_SELECT_By_UtilityCompanyId(utilityCompanyId.ToString()).ToList().OrderBy(x => x.Name);//new SelectList(db.MeterTypes.Where(x => x.UtilityCompanyId == utilityCompanyId).OrderBy(x => x.MeterTypeCode), "Id", "MeterTypeCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, idrRule));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new IdrRule());
            }
        }

        //
        // POST: /IdrRule/Create
        [HttpPost]
        public ActionResult Create(IdrRule idrRule)
        {
            string method = string.Format("Create(IdrRule idrRule:{0})", idrRule == null ? "NULL VALUE" : idrRule.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                Session[ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    idrRule.Id = Guid.NewGuid();
                    idrRule.CreatedBy = "User"; // Common.GetUserName(User.Identity.Name);
                    idrRule.CreatedDate = DateTime.Now;
                    idrRule.LastModifiedBy = "User"; // Common.GetUserName(User.Identity.Name);
                    idrRule.LastModifiedDate = DateTime.Now;
                    if (idrRule.IsIdrRuleValid())
                    {
                        db.IdrRules.Add(idrRule);
                        db.SaveChanges();
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", NAMESPACE, CLASS, method, END));
                        return RedirectToAction("Index");
                    }
                }
                ViewBag.RequestModeTypeId = new SelectList(db.RequestModeTypes.OrderBy(x => x.Name), "Id", "Name");
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                ViewBag.RateClassId = new SelectList(db.usp_RateClass_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.LoadProfileId = new SelectList(db.usp_LoadProfile_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.ServiceClassId = new SelectList(db.usp_ServiceClass_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                ViewBag.MeterTypeId = new SelectList(db.usp_MeterType_SELECT_By_UtilityCompanyId(idrRule.UtilityCompanyId.ToString()).ToList().OrderBy(x => x.Name), "Id", "Name");
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", NAMESPACE, CLASS, method, END));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new IdrRule());
            }
        }

        //
        // GET: /IdrRule/Edit/5

        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                Session[ISPOSTBACK] = "false";
                IdrRule idrRule = db.IdrRules.Find(id);
                if (idrRule == null)
                {
                    _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", NAMESPACE, CLASS, method, END));
                    return HttpNotFound();
                }
                Session[CREATEDBY] = idrRule.CreatedBy;
                Session[CREATEDDATE] = idrRule.CreatedDate;
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRule:{4} {3}", NAMESPACE, CLASS, method, END, idrRule));

                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                IdrRule idrRule = db.IdrRules.Find(id);
                return View(idrRule);
            }
        }

        //
        // POST: /IdrRule/Edit/5

        [HttpPost]
        public ActionResult Edit(IdrRule idrRule)
        {
            string method = string.Format("Edit(IdrRule idrRule:{0})", idrRule == null ? "NULL VALUE" : idrRule.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                Session[ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    idrRule.CreatedBy = Session[CREATEDBY] == null ? "NULL USER NAME" : Session[CREATEDBY].ToString();
                    idrRule.CreatedDate = Session[CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[CREATEDDATE];
                    idrRule.LastModifiedBy = "User"; // Common.GetUserName(User.Identity.Name);
                    idrRule.LastModifiedDate = DateTime.Now;
                    if (idrRule.IsIdrRuleValid())
                    {
                        db.Entry(idrRule).State = EntityState.Modified;
                        db.SaveChanges();
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", NAMESPACE, CLASS, method, END));
                        return RedirectToAction("Index");
                    }
                    Session[CREATEDBY] = idrRule.CreatedBy;
                    Session[CREATEDDATE] = idrRule.CreatedDate;
                }
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", NAMESPACE, CLASS, method, END));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(idrRule);
            }
        }


        [HttpPost]
        public JsonResult PopulateMeterTypeIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateMeterTypeIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = db.usp_MeterType_SELECT_By_UtilityCompanyId(utilityCompanyId).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", NAMESPACE, CLASS, method, END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        [HttpPost]
        public JsonResult PopulateRateClassIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateRateClassIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = db.usp_RateClass_SELECT_By_UtilityCompanyId(utilityCompanyId).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", NAMESPACE, CLASS, method, END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        [HttpPost]
        public JsonResult PopulateServiceClassIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateServiceClassIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = db.usp_ServiceClass_SELECT_By_UtilityCompanyId(utilityCompanyId).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", NAMESPACE, CLASS, method, END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        [HttpPost]
        public JsonResult PopulateLoadProfileIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateLoadProfileIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = db.usp_LoadProfile_SELECT_By_UtilityCompanyId(utilityCompanyId).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", NAMESPACE, CLASS, method, END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        public ActionResult UtilityCodeTitleClick()
        {
            string method = "UtilityCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("UtilityCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeTypeTitleClick()
        {
            string method = "RequestModeTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("RequestModeType");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult InstructionTitleClick()
        {
            string method = "InstructionTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("Instruction");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MinUsageMWhTitleClick()
        {
            string method = "MinUsageMWhTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("MinUsageMWh");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RateClassCodeTitleClick()
        {
            string method = "RateClassCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("RateClassCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ServiceClassCodeTitleClick()
        {
            string method = "ServiceClassCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("ServiceClassCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LoadProfileCodeTitleClick()
        {
            string method = "LoadProfileCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LoadProfileCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterTypeCodeTitleClick()
        {
            string method = "MeterTypeCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("MeterTypeCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsOnEligibleCustomerListTitleClick()
        {
            string method = "IsOnEligibleCustomerListTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("IsOnEligibleCustomerList");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsHistoricalArchiveAvailableTitleClick()
        {
            string method = "IsHistoricalArchiveAvailableTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("IsHistoricalArchiveAvailable");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult InactiveTitleClick()
        {
            string method = "InactiveTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("Inactive");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreatedByTitleClick()
        {
            string method = "CreatedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("CreatedBy");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreatedDateTitleClick()
        {
            string method = "CreatedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("CreatedDate");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LastModifiedByTitleClick()
        {
            string method = "LastModifiedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LastModifiedBy");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LastModifiedDateTitleClick()
        {
            string method = "LastModifiedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LastModifiedDate");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

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
            db.Dispose();
            base.Dispose(disposing);
        }

        private void VerifyMessageIdAndErrorMessageSession()
        {
            Session[ERRORMESSAGE] = string.Empty;
            if (Session[MESSAGEID] == null || string.IsNullOrWhiteSpace(Session[MESSAGEID].ToString()))
                Session[MESSAGEID] = Guid.NewGuid().ToString();
        }

        private void ErrorHandler(Exception exc, string method)
        {
            _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", NAMESPACE, CLASS, method, exc.Message), exc);
            _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", NAMESPACE, CLASS, method, END));
            Session[ERRORMESSAGE] = exc == null ? "NULL EXCEPTION OBJECT" : exc.Message;
        }

        private ActionResult ManageSortationSession(string sortColumn)
        {
            if (Session[SORTCOLUMNNAME].ToString() == sortColumn && Session[SORTDIRECTION].ToString() == ASC)
                Session[SORTDIRECTION] = DESC;
            else
                Session[SORTDIRECTION] = ASC;
            Session[SORTCOLUMNNAME] = sortColumn;
            return RedirectToAction("Index");
        }

        private List<IdrRule> ObtainResponse()
        {
            var response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[SORTCOLUMNNAME] == null)
                Session[SORTCOLUMNNAME] = "UtilityCode";
            if (Session[SORTDIRECTION] == null)
                Session[SORTDIRECTION] = ASC;
            switch (Session[SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "RequestModeType":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.RequestModeType.Name).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.RequestModeType.Name).ToList();
                    break;
                case "Instruction":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.Instruction).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.Instruction).ToList();
                    break;
                case "MinUsageMWh":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.MinUsageMWh).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.MinUsageMWh).ToList();
                    break;
                case "MaxUsageMWh":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.MaxUsageMWh).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.MaxUsageMWh).ToList();
                    break;
                case "RateClassCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.RateClass.RateClassCode).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.RateClass.RateClassCode).ToList();
                    break;
                case "ServiceClassCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.ServiceClass.ServiceClassCode).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.ServiceClass.ServiceClassCode).ToList();
                    break;
                case "LoadProfileCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.LoadProfile.LoadProfileCode).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.LoadProfile.LoadProfileCode).ToList();
                    break;
                case "MeterTypeCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.MeterType.MeterTypeCode).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.MeterType.MeterTypeCode).ToList();
                    break;
                case "IsOnEligibleCustomerList":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.IsOnEligibleCustomerList).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.IsOnEligibleCustomerList).ToList();
                    break;
                case "IsHistoricalArchiveAvailable":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.IsHistoricalArchiveAvailable).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.IsHistoricalArchiveAvailable).ToList();
                    break;
                case "Inactive":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = db.IdrRules.Include(r => r.RequestModeType).Include(r => r.LoadProfile).Include(r => r.MeterType).Include(r => r.RateClass).Include(r => r.ServiceClass).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}
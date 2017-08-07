using DataAccessLayerEntityFramework;
using System;
using System.IO;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web.Mvc;
using Utilities;
using UtilityManagement.ChartHelpers;
using System.Web.UI.DataVisualization.Charting;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class IdrRuleController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "IdrRuleController";
        private const string UTILITYMANAGEMENT_IDRRULE_INDEX = "UTILITYMANAGEMENT_IDRRULE_INDEX";
        private const string UTILITYMANAGEMENT_IDRRULE_CREATE = "UTILITYMANAGEMENT_IDRRULE_CREATE";
        private const string UTILITYMANAGEMENT_IDRRULE_EDIT = "UTILITYMANAGEMENT_IDRRULE_EDIT";
        private const string UTILITYMANAGEMENT_IDRRULE_DETAIL = "UTILITYMANAGEMENT_IDRRULE_DETAIL";
        private const string UTILITYMANAGEMENT_IDRRULE_UPLD = "UTILITYMANAGEMENT_IDRRULE_UPLD";
        private const string UTILITYMANAGEMENT_IDRRULE_DOWNLD = "UTILITYMANAGEMENT_IDRRULE_DOWNLD";
        #endregion

        #region public constructors
        public IdrRuleController()
            : base()
        {
            ViewBag.PageName = "IdrRule";
            ViewBag.IndexPageName = "IdrRule";
            ViewBag.PageDisplayName = "IDR Rule";
        }
        #endregion

        #region public methods returning ActionResult
        public ActionResult Report()
        {
            return View(new Models.ReportModel());
        }

        public ActionResult IdrRuleCountChart()
        {
            var salesChart = new Chart() { Width = 600, Height = 400 };
            var builder = new IdrRuleCountChartBuilder(salesChart) { CategoryName = "Data", OrderYear = 2013 };
            builder.BuildChart();
            salesChart.Titles[0].Visible = false;

            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
        }

        //
        // GET: /IdrRule/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(utilityCompanyId)";
            Session["ErrorMessage"] = null;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRULE_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRULE_INDEX });
                }

                Session["IdrControllerRequestModeIdrId"] = null;
                Models.IdrRuleModel idrRuleModel = new Models.IdrRuleModel();
                Guid idTemp = Guid.Empty;
                List<IdrRule> idrRules = null;
                Guid requestModeIdrId = Guid.Empty;
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ProcessUtilityCompanyId(ref utilityCompanyId, ref idTemp, ref requestModeIdrId) start");
                ProcessUtilityCompanyId(ref utilityCompanyId, ref idTemp, ref requestModeIdrId);
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ProcessUtilityCompanyId(ref utilityCompanyId, ref idTemp, ref requestModeIdrId) end");

                if (utilityCompanyId == null && Session["SelectedUtilityCompanyId"] == null && idTemp == Guid.Empty)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty start");
                    idrRules = GetBaseResponse().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();
                    ViewBag.HasPreEnrollmentRequestModeIdr = false;
                    ViewBag.HasPostEnrollmentRequestModeIdr = false;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty ending");
                }
                else
                {
                    if ((utilityCompanyId == null || utilityCompanyId == string.Empty) && Session["SelectedUtilityCompanyId"] != null)
                        utilityCompanyId = Session["SelectedUtilityCompanyId"].ToString();
                    else
                        utilityCompanyId = idTemp.ToString();
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("else start, utilityCompanyId:{0};Session[SelectedUtilityCompanyId]:{1};idTemp:{2}", Common.NullSafeString(utilityCompanyId), Common.NullSafeString(Session["SelectedUtilityCompanyId"]), Common.NullSafeString(idTemp)));
                    Guid id = new Guid(utilityCompanyId);
                    idrRuleModel = GenerateIdrRuleModel(id);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "idrRuleModel = GenerateIdrRuleModel(id)");
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId)");
                    ViewBag.HasPreEnrollmentRequestModeIdr = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == id && x.RequestModeEnrollmentType.EnumValue == 0).Count<RequestModeIdr>() > 0;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.HasPreEnrollmentRequestModeIdr = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == id && x.RequestModeEnrollmentType.EnumValue == 0).Count<RequestModeIdr>() > 0");
                    ViewBag.HasPostEnrollmentRequestModeIdr = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == id && x.RequestModeEnrollmentType.EnumValue == 1).Count<RequestModeIdr>() > 0;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.HasPostEnrollmentRequestModeIdr = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == id && x.RequestModeEnrollmentType.EnumValue == 1).Count<RequestModeIdr>() > 0");
                    if (_db.IdrRules.Where(x => x.RequestModeIdrId == requestModeIdrId) == null)
                    {
                        Session["SelectedUtilityCompanyId"] = utilityCompanyId;
                        return RedirectToAction("Create");
                    }
                    if (_db.IdrRules.Where(x => x.RequestModeIdrId == requestModeIdrId).Count<IdrRule>() <= 0 && Common.NullSafeString(Session["FromIdrRequest"]) == "true")
                    {
                        Session["SelectedUtilityCompanyId"] = utilityCompanyId;
                        if (_db.RequestModeIdrs.Where(x => x.Id == requestModeIdrId) != null && _db.RequestModeIdrs.Where(x => x.Id == requestModeIdrId).FirstOrDefault() != null)
                            Session["IdrRuleEnrollmentTypeId"] = Common.NullSafeString(_db.RequestModeIdrs.Where(x => x.Id == requestModeIdrId).FirstOrDefault().RequestModeEnrollmentTypeId);
                        Session["FromIdrRequest"] = "false";
                        return RedirectToAction("Create");
                    }
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "else ending");
                }
                Session["SelectedUtilityCompanyId"] = utilityCompanyId;
                idrRuleModel.SelectedUtilityCompanyId = utilityCompanyId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, idrRules));
                return View(idrRuleModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.IdrRuleModel());
            }
        }

        //
        // GET: /IdrRule/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            Session["ErrorMessage"] = null;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRULE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRULE_DETAIL });
                }

                if (id == Guid.Empty)
                {
                    return RedirectToAction("Index");
                }
                Models.IdrRuleModel idrRuleModel = null;
                List<IdrRule> idrRules = _db.IdrRules.Where(x => x.RequestModeIdrId == id).ToList();
                int zero = 0;
                int one = 1;
                Guid utilityCompanyId = idrRules[0].UtilityCompanyId;
                var preEnrollmentRequestModeIdrAlwaysRequest = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == utilityCompanyId && x.RequestModeEnrollmentType.EnumValue == zero).FirstOrDefault();
                var postEnrollmentRequestModeIdrAlwaysRequest = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == utilityCompanyId && x.RequestModeEnrollmentType.EnumValue == one).FirstOrDefault();

                if (idrRules != null && idrRules.Count > 0)
                {
                    idrRuleModel = new Models.IdrRuleModel()
                    {
                        UtilityId = idrRules[0].UtilityCompanyId,
                        PreEnrollmentRequestModeIdrId = (Guid)(idrRules[0].RequestModeIdrId == null ? Guid.Empty : idrRules[0].RequestModeIdrId),
                        UtilityCode = idrRules[0].UtilityCompany.UtilityCode,
                        PreEnrollmentIdrRules = GenerateIdrRulePerEnrollmentTypeModel(idrRules),
                        PreEnrollmentRequestModeIdrAlwaysRequest = preEnrollmentRequestModeIdrAlwaysRequest != null && (preEnrollmentRequestModeIdrAlwaysRequest.AlwaysRequest == null ? false : (bool)preEnrollmentRequestModeIdrAlwaysRequest.AlwaysRequest),
                        PostEnrollmentRequestModeIdrAlwaysRequest = postEnrollmentRequestModeIdrAlwaysRequest != null && (postEnrollmentRequestModeIdrAlwaysRequest.AlwaysRequest == null ? false : (bool)postEnrollmentRequestModeIdrAlwaysRequest.AlwaysRequest)
                    };
                }
                if (idrRuleModel == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRule:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, idrRules));
                return View(idrRuleModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeIdr());
            }
        }

        [HttpPost]
        public ActionResult Details(IdrRule idrRule, string submitButton)
        {
            string method = string.Format(" Details(IdrRule idrRule:{0}, submitButton:{1})", idrRule == null ? "NULL VALUE" : idrRule.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "IdrRule", new { id = idrRule.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
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
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRULE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRULE_CREATE });
                }

                if (Session["SelectedUtilityCompanyId"] == null || string.IsNullOrWhiteSpace(Session["SelectedUtilityCompanyId"].ToString()))
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "return RedirectToAction(Index)");
                    return RedirectToAction("Index");
                }
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("Guid uci = new Guid(Session[SelectedUtilityCompanyId]:{0}", Session["SelectedUtilityCompanyId"] != null ? Common.NullSafeString(Session["SelectedUtilityCompanyId"]) : ""));
                Guid uci = new Guid(Session["SelectedUtilityCompanyId"].ToString());

                UtilityManagement.Models.IdrRuleCreateModel idrRule = new UtilityManagement.Models.IdrRuleCreateModel()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    UtilityCompanyId = uci,
                    AlwaysRequest = false
                };

                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "PopulateViewBag begin");
                PopulateViewBag();
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "PopulateViewBag end");

                string enrollmentType = string.Empty;
                if (Session["IdrRuleEnrollmentTypeId"] != null && idrRule != null && idrRule.EnrollmentTypeId != null && _db.RequestModeEnrollmentTypes.Where(x => x.Id == idrRule.EnrollmentTypeId) != null)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "first if");
                    idrRule.EnrollmentTypeId = new Guid(Session["IdrRuleEnrollmentTypeId"].ToString());
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "1");
                    enrollmentType = _db.RequestModeEnrollmentTypes.Where(x => x.Id == idrRule.EnrollmentTypeId).FirstOrDefault().Name;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "2");
                    var alwaysRequestObject = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentTypeId == idrRule.EnrollmentTypeId).FirstOrDefault();
                    idrRule.AlwaysRequest = alwaysRequestObject != null && alwaysRequestObject.AlwaysRequest != null && ((bool)alwaysRequestObject.AlwaysRequest);
                    Session["IdrController_AlwaysRequest"] = idrRule.AlwaysRequest;
                }
                else
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "else");
                    enrollmentType = Request.Url.ToString().Substring(Request.Url.ToString().LastIndexOf('/') + 1);
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "else 1");
                    enrollmentType = enrollmentType.Replace("EnrollmentCheckBox", " Enrollment");
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("enrollmentType:{0}",enrollmentType));
                    var requestModeEnrollmentTypesObject = _db.RequestModeEnrollmentTypes.Where(x => x.Name == enrollmentType);
                    if (requestModeEnrollmentTypesObject != null && requestModeEnrollmentTypesObject.FirstOrDefault() != null)
                    {
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "if (requestModeEnrollmentTypesObject != null && requestModeEnrollmentTypesObject.FirstOrDefault() != null)");
                        idrRule.EnrollmentTypeId = requestModeEnrollmentTypesObject.FirstOrDefault().Id;
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("idrRule.EnrollmentTypeId :{0}", idrRule.EnrollmentTypeId));
                        var alwaysRequestObject = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentTypeId == idrRule.EnrollmentTypeId).FirstOrDefault();
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("alwaysRequestObject:{0}", alwaysRequestObject));
                        idrRule.AlwaysRequest = alwaysRequestObject != null && alwaysRequestObject.AlwaysRequest != null && ((bool)alwaysRequestObject.AlwaysRequest);
                        Session["IdrController_AlwaysRequest"] = idrRule.AlwaysRequest;
                        _logger.LogDebug(Session[Common.MESSAGEID].ToString(), string.Format("Session[IdrController_AlwaysRequest]:{0}", Common.NullSafeString(Session["IdrController_AlwaysRequest"])));
                    }
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "else 3");
                }
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.EnrollmentTypeText = enrollmentType");
                ViewBag.EnrollmentTypeText = enrollmentType;
                _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "ViewBag.RequestModeTypeText = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == idrRule.UtilityCompanyId && x.RequestModeEnrollmentTypeId == idrRule.EnrollmentTypeId).FirstOrDefault().RequestModeType.Name");
                ViewBag.RequestModeTypeText = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == idrRule.UtilityCompanyId && x.RequestModeEnrollmentTypeId == idrRule.EnrollmentTypeId).FirstOrDefault().RequestModeType.Name;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRule:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, idrRule));
                return View(idrRule);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //
        // POST: /IdrRule/Create
        [HttpPost]
        public ActionResult Create(UtilityManagement.Models.IdrRuleCreateModel idrRuleCreateModel, string submitButton)
        {
            string method = string.Format("Create(IdrRule idrRule:{0})", idrRuleCreateModel == null ? "NULL VALUE" : idrRuleCreateModel.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["SelectedUtilityCompanyId"].ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), "A");

                Session[Common.ISPOSTBACK] = "true";

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), "B");

                Guid requestModeIdrId = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentType.Id == idrRuleCreateModel.EnrollmentTypeId).First().Id;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), "C");

                if (
                        (idrRuleCreateModel.MaximumUsageMWh == null && idrRuleCreateModel.MinimumUsageMWh != null)
                        || (idrRuleCreateModel.MaximumUsageMWh != null && idrRuleCreateModel.MinimumUsageMWh == null)
                        || (idrRuleCreateModel.MinimumUsageMWh > idrRuleCreateModel.MaximumUsageMWh)
                        || 
                        (
                            idrRuleCreateModel.MinimumUsageMWh == null 
                            && idrRuleCreateModel.MaximumUsageMWh == null 
                            && idrRuleCreateModel.RateClassId == Guid.Empty 
                            && idrRuleCreateModel.LoadProfileId == Guid.Empty 
                            && idrRuleCreateModel.TariffCodeId == Guid.Empty 
                            && idrRuleCreateModel.IsEligible == false 
                            && idrRuleCreateModel.IsHia == false
                        )
                    )
                {
                    PopulateViewBag();
                    string enrollmentType = Request.Url.ToString().Substring(Request.Url.ToString().LastIndexOf('/') + 1);
                    enrollmentType = enrollmentType.Replace("EnrollmentCheckBox", " Enrollment");
                    ViewBag.EnrollmentTypeText = enrollmentType;
                    idrRuleCreateModel.EnrollmentTypeId = _db.RequestModeEnrollmentTypes.Where(x => x.Name == enrollmentType).FirstOrDefault().Id;
                    ViewBag.RequestModeTypeText = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentTypeId == idrRuleCreateModel.EnrollmentTypeId).FirstOrDefault().RequestModeType.Name;
                    return View(idrRuleCreateModel);
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), "D");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} After requestModeIdr Save", Common.NAMESPACE, CLASS, method));

                IdrRule idrRule = new IdrRule()
                {
                    Id = Guid.NewGuid(),
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    Inactive = idrRuleCreateModel.Inactive,
                    IsHistoricalArchiveAvailable = idrRuleCreateModel.IsHia,
                    IsOnEligibleCustomerList = idrRuleCreateModel.IsEligible,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    LoadProfileId = idrRuleCreateModel.LoadProfileId != Guid.Empty ? idrRuleCreateModel.LoadProfileId : (Guid?)null,
                    RateClassId = idrRuleCreateModel.RateClassId != Guid.Empty ? idrRuleCreateModel.RateClassId : (Guid?)null,
                    TariffCodeId = idrRuleCreateModel.TariffCodeId != Guid.Empty ? idrRuleCreateModel.TariffCodeId : (Guid?)null,
                    MaxUsageMWh = idrRuleCreateModel.MaximumUsageMWh,
                    MinUsageMWh = idrRuleCreateModel.MinimumUsageMWh,
                    UtilityCompanyId = idrRuleCreateModel.UtilityCompanyId,
                    RequestModeIdrId = requestModeIdrId,
                    RequestModeTypeId = idrRuleCreateModel.EnrollmentTypeId
                };

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), "E");

                //var idrRuleSaveData = _db.RequestModeIdrs.Where(x => x.UtilityCompany.Id == idrRuleCreateModel.UtilityCompanyId && x.RequestModeEnrollmentTypeId == idrRuleCreateModel.EnrollmentTypeId).FirstOrDefault();
                //if (idrRuleSaveData != null)
                //    idrRuleSaveData.AlwaysRequest = idrRuleCreateModel.AlwaysRequest;
                //idrRule.RequestModeIdr.AlwaysRequest = idrRuleCreateModel.AlwaysRequest;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Before idrRule Save", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                UtilityManagementRepository.IDataRepository dataRepository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                dataRepository.usp_IdrRule_INSERT(Session[Common.MESSAGEID].ToString(), idrRule.Id, idrRule.UtilityCompanyId, idrRule.RateClassId, idrRule.LoadProfileId, idrRule.TariffCodeId,
                    idrRule.MinUsageMWh, idrRule.MaxUsageMWh, idrRule.IsOnEligibleCustomerList, idrRule.IsHistoricalArchiveAvailable,
                    idrRule.RequestModeIdrId, idrRule.RequestModeTypeId, idrRuleCreateModel.AlwaysRequest, idrRule.Inactive, idrRule.CreatedBy);

                //_db.IdrRules.Add(idrRule);
                //_db.Entry(idrRule).State = EntityState.Added;
                //_db.SaveChanges();


                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Before requestModeIdr Save", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                //var requestModeIdr = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentType.Id == idrRuleCreateModel.EnrollmentTypeId).First();
                //requestModeIdr.AlwaysRequest = idrRuleCreateModel.AlwaysRequest;
                //_db.Entry(requestModeIdr).State = EntityState.Modified;
                //_db.SaveChanges();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                PopulateViewBag();
                string enrollmentType = Request.Url.ToString().Substring(Request.Url.ToString().LastIndexOf('/') + 1);
                enrollmentType = enrollmentType.Replace("EnrollmentCheckBox", " Enrollment");
                ViewBag.EnrollmentTypeText = enrollmentType;
                idrRuleCreateModel.EnrollmentTypeId = _db.RequestModeEnrollmentTypes.Where(x => x.Name == enrollmentType).FirstOrDefault().Id;
                return View(idrRuleCreateModel);
            }
        }

        public Models.IdrRuleEditListModel GenerateEditIdrRules(Guid? id, ref Guid utilityCompanyId)
        {
            Models.IdrRuleEditListModel returnValue = new Models.IdrRuleEditListModel() { IdrRuleEditRowList = new List<Models.IdrRuleEditRowModel>() };
            List<IdrRule> idrRules = _db.IdrRules.Where(x => x.RequestModeIdrId == id).ToList();
            var requestModeIdr = _db.RequestModeIdrs.Where(x => x.Id == id).FirstOrDefault();
            if (requestModeIdr != null)
            {
                bool? alwaysRequest = requestModeIdr.AlwaysRequest;
                if (requestModeIdr.RequestModeEnrollmentType != null && requestModeIdr.RequestModeEnrollmentType.EnumValue == 0)
                {
                    returnValue.PreEnrollmentRequestModeIdrAlwaysRequest = alwaysRequest != null && (bool)alwaysRequest;
                }
                if (requestModeIdr.RequestModeEnrollmentType != null && requestModeIdr.RequestModeEnrollmentType.EnumValue == 1)
                {
                    returnValue.PostEnrollmentRequestModeIdrAlwaysRequest = alwaysRequest != null && (bool)alwaysRequest;
                }
            }
            if (idrRules != null && idrRules.Count > 0)
            {
                utilityCompanyId = idrRules[0].UtilityCompanyId;

                foreach (IdrRule idrRule in idrRules)
                {
                    Models.IdrRuleEditRowModel idrRuleEditRowModel = new Models.IdrRuleEditRowModel()
                    {
                        CreatedBy = idrRule.CreatedBy,
                        CreatedDate = idrRule.CreatedDate,
                        IdrRuleId = idrRule.Id,
                        Inactive = idrRule.Inactive,
                        IsEligible = idrRule.IsOnEligibleCustomerList,
                        IsHia = idrRule.IsHistoricalArchiveAvailable,
                        LastModifiedBy = idrRule.LastModifiedBy,
                        LastModifiedDate = idrRule.LastModifiedDate,
                        LoadProfileId = idrRule.LoadProfile1 == null || idrRule.LoadProfile1.Id == null ? Guid.Empty : idrRule.LoadProfile1.Id,
                        RateClassId = idrRule.RateClass == null || idrRule.RateClass.Id == null ? Guid.Empty : idrRule.RateClass.Id,
                        TariffCodeId = idrRule.TariffCode == null || idrRule.TariffCode.Id == null ? Guid.Empty : idrRule.TariffCode.Id,
                        MaxUsageMWh = idrRule.MaxUsageMWh,
                        MinUsageMWh = idrRule.MinUsageMWh,

                        EnrollmentType = idrRule.RequestModeIdr.RequestModeEnrollmentType.Name,
                        RequestModeIdrId = idrRule.RequestModeIdrId,
                        RequestModeType = idrRule.RequestModeIdr.RequestModeType.Name,
                        UtilityCode = idrRule.UtilityCompany.UtilityCode,
                        UtilityCompanyId = utilityCompanyId,

                        RateClassSelectList = GetRateClassSelectList(utilityCompanyId, idrRule.RateClassId),
                        LoadProfileSelectList = GetLoadProfileSelectList(utilityCompanyId, idrRule.LoadProfileId),
                        TariffCodeSelectList = GetTariffCodeSelectList(utilityCompanyId, idrRule.TariffCodeId)
                    };
                    returnValue.IdrRuleEditRowList.Add(idrRuleEditRowModel);
                }
            }
            return returnValue;
        }


        //
        // GET: /IdrRule/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRULE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRULE_EDIT });
                }

                Models.IdrRuleEditListModel idrRuleEditListModel = null;
                Guid utilityCompanyId = Guid.Empty;

                if (Session["IdrControllerRequestModeIdrId"] != null)
                    id = new Guid(Session["IdrControllerRequestModeIdrId"].ToString());

                if (id == Guid.Empty)
                {
                    return RedirectToAction("Index");
                }

                if (Session["ErrorMessage"] != null && Session["ErrorMessage"].ToString() != string.Empty)
                {
                    utilityCompanyId = (Guid)Session["IdrRule_UtilityCompanyId"];
                    idrRuleEditListModel = (Models.IdrRuleEditListModel)Session["IdrRuleEditListModel"];
                    Dictionary<int, string> errorMessageDictionary = (Dictionary<int, string>)Session["ErrorMessage"];
                    int counter = 0;
                    foreach (Models.IdrRuleEditRowModel item in idrRuleEditListModel.IdrRuleEditRowList)
                    {
                        idrRuleEditListModel.IdrRuleEditRowList[counter].ErrorMessage = errorMessageDictionary[counter];
                        counter++;
                    }
                }
                else
                {
                   idrRuleEditListModel = GenerateEditIdrRules(id, ref utilityCompanyId);
                    if (idrRuleEditListModel == null)
                    {
                        _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return HttpNotFound();
                    }
                    Session["IdrRule_UtilityCompanyId"] = utilityCompanyId;
                }

                ViewBag.RateClassId = GetRateClassSelectList(utilityCompanyId);
                ViewBag.LoadProfileId = GetLoadProfileSelectList(utilityCompanyId);
                ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(utilityCompanyId);

                Session["ErrorModel"] = null;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} idrRuleEditListModel:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, idrRuleEditListModel));
                return View(idrRuleEditListModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.IdrRuleEditListModel());
            }
        }

        //
        // POST: /IdRrule/Edit/5
        [HttpPost]
        public ActionResult Edit(UtilityManagement.Models.IdrRuleEditListModel idrRuleEditListModel, string submitButton)
        {
            string method = string.Format("Edit(IdrRuleModel idrRuleEditListModel:{0})", idrRuleEditListModel == null ? "NULL VALUE" : idrRuleEditListModel.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                Session["ErrorMessage"] = string.Empty;
                Session["IdrControllerRequestModeIdrId"] = null;

                Dictionary<int, bool> isEligibleDictionary = ParseFormDataToBool("item.IsEligible");
                Dictionary<int, bool> isHiaDictionary = ParseFormDataToBool("item.IsHia");
                Dictionary<int, bool> inactiveDictionary = ParseFormDataToBool("item.Inactive");
                Dictionary<int, int?> minUsageMWhDictionary = ParseFormDataToInt("item.MinUsageMWh");
                Dictionary<int, int?> maxUsageMWhDictionary = ParseFormDataToInt("item.MaxUsageMWh");
                Dictionary<int, Guid?> idrRuleIdDictionary = ParseGuidsFromFormString("item.IdrRuleId");
                Dictionary<int, Guid?> requestModeIdrIdDictionary = ParseGuidsFromFormString("item.RequestModeIdrId");
                Dictionary<int, string> createdByDictionary = ParseStringsFromString(Request.Form["item.CreatedBy"]);
                Dictionary<int, DateTime> createdDateDictionary = ParseDatesFromString(Request.Form["item.CreatedDate"]);
                Dictionary<int, string> enrollmentTypeDictionary = ParseStringsFromString(Request.Form["item.EnrollmentType"]);
                Dictionary<int, string> requestModeTypeDictionary = ParseStringsFromString(Request.Form["item.RequestModeType"]);
                Dictionary<int, string> utilityCodeDictionary = ParseStringsFromString(Request.Form["item.UtilityCode"]);

                Guid tempGuid = idrRuleIdDictionary[0] ?? Guid.Empty;
                Guid utilityCompanyId = _db.IdrRules.Where(x => x.Id == tempGuid).FirstOrDefault().UtilityCompanyId;
                Session["IdrRule_UtilityCompanyId"] = utilityCompanyId;
                int rowCount = CalculateRowCount();

                Dictionary<int, Guid?> rateClassIdDictionary = new Dictionary<int, Guid?>();
                Dictionary<int, Guid?> loadProfileIdDictionary = new Dictionary<int, Guid?>();
                Dictionary<int, Guid?> tariffCodeIdDictionary = new Dictionary<int, Guid?>();
                bool? preEnrollmentRequestModeIdrAlwaysRequest = idrRuleEditListModel.PreEnrollmentRequestModeIdrAlwaysRequest;
                bool? postEnrollmentRequestModeIdrAlwaysRequest = idrRuleEditListModel.PostEnrollmentRequestModeIdrAlwaysRequest;
                idrRuleEditListModel = new Models.IdrRuleEditListModel();
                idrRuleEditListModel.IdrRuleEditRowList = new List<Models.IdrRuleEditRowModel>();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} for (int i = 0; i <= rowCount; i++)", Common.NAMESPACE, CLASS, method));
                
                for (int i = 0; i <= rowCount; i++)
                {
                    rateClassIdDictionary.Add(i, GenerateNullableGuidFromFormKey("RateClassId_{0}",i));
                    loadProfileIdDictionary.Add(i, GenerateNullableGuidFromFormKey("LoadProfileId_{0}", i));
                    tariffCodeIdDictionary.Add(i, GenerateNullableGuidFromFormKey("TariffCodeId_{0}", i));
                    Models.IdrRuleEditRowModel idrRuleEditModel = new Models.IdrRuleEditRowModel()
                    {
                        CreatedBy = createdByDictionary[i],
                        CreatedDate = createdDateDictionary[i],
                        IdrRuleId = (Guid)idrRuleIdDictionary[i],
                        Inactive = inactiveDictionary[i],
                        IsEligible = isEligibleDictionary[i],
                        IsHia = isHiaDictionary[i],
                        LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                        LastModifiedDate = DateTime.Now,
                        LoadProfileId = loadProfileIdDictionary[i],
                        MaxUsageMWh = maxUsageMWhDictionary[i],
                        MinUsageMWh = minUsageMWhDictionary[i],
                        RateClassId = rateClassIdDictionary[i],
                        RequestModeIdrId = requestModeIdrIdDictionary[i],
                        TariffCodeId = tariffCodeIdDictionary[i],
                        UtilityCompanyId = utilityCompanyId,
                        RequestModeType = requestModeTypeDictionary[i],
                        EnrollmentType = enrollmentTypeDictionary[i],
                        UtilityCode = utilityCodeDictionary[i]
                    };
                    idrRuleEditListModel.IdrRuleEditRowList.Add(idrRuleEditModel);
                }

                Dictionary<int, string> errorMessageDictionary = new Dictionary<int, string>();
                if (AreIdrRulesValid(rowCount, utilityCompanyId, createdByDictionary, createdDateDictionary, idrRuleIdDictionary, inactiveDictionary, isHiaDictionary, isEligibleDictionary,
                    loadProfileIdDictionary, maxUsageMWhDictionary, minUsageMWhDictionary, rateClassIdDictionary, requestModeIdrIdDictionary, tariffCodeIdDictionary, out errorMessageDictionary))
                {
                    SaveIdrRule(rowCount, utilityCompanyId, createdByDictionary, createdDateDictionary, idrRuleIdDictionary, inactiveDictionary, isHiaDictionary, isEligibleDictionary,
                        loadProfileIdDictionary, maxUsageMWhDictionary, minUsageMWhDictionary, rateClassIdDictionary, requestModeIdrIdDictionary, tariffCodeIdDictionary,
                        postEnrollmentRequestModeIdrAlwaysRequest, preEnrollmentRequestModeIdrAlwaysRequest);
                }
                else
                {
                    Session["ErrorMessage"] = errorMessageDictionary;
                    Session["IdrControllerRequestModeIdrId"] = requestModeIdrIdDictionary[0].Value;
                    Session["IdrRuleEditListModel"] = idrRuleEditListModel;
                    return RedirectToAction("Edit");
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new UtilityManagement.Models.IdrRuleEditListModel());
            }
        }
        #endregion

        #region public methods returning JsonResult
        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["SelectedUtilityCompanyId"] = utilityCompanyId;
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

        public Models.IdrRuleModel GenerateIdrRuleModel(Guid id)
        {
            List<usp_IdrRule_IndexSelected_Result> usp_IdrRule_IndexSelected_Result_List = ObtainResponse(id, 0);
            var preEnrollmentIdrRules = GenerateIdrRulePerEnrollmentTypeModelList(usp_IdrRule_IndexSelected_Result_List);
            Guid preEnrollmentRequestModeIdrId = usp_IdrRule_IndexSelected_Result_List == null || usp_IdrRule_IndexSelected_Result_List.Count == 0 || usp_IdrRule_IndexSelected_Result_List[0].RequestModeIdrId == null ? Guid.Empty : (Guid)usp_IdrRule_IndexSelected_Result_List[0].RequestModeIdrId;
            usp_IdrRule_IndexSelected_Result_List = ObtainResponse(id, 1);
            Guid postEnrollmentRequestModeIdrId = usp_IdrRule_IndexSelected_Result_List == null || usp_IdrRule_IndexSelected_Result_List.Count == 0 || usp_IdrRule_IndexSelected_Result_List[0].RequestModeIdrId == null ? Guid.Empty : (Guid)usp_IdrRule_IndexSelected_Result_List[0].RequestModeIdrId;
            var postEnrollmentIdrRules = GenerateIdrRulePerEnrollmentTypeModelList(usp_IdrRule_IndexSelected_Result_List);

            var preEnrollmentRequestModeIdr = _db.RequestModeIdrs.Find(preEnrollmentRequestModeIdrId);
            var postEnrollmentRequestModeIdr = _db.RequestModeIdrs.Find(postEnrollmentRequestModeIdrId);

            bool preEnrollmentRequestModeIdrAlwaysRequest = preEnrollmentRequestModeIdr != null && preEnrollmentRequestModeIdr.AlwaysRequest != null && (bool)preEnrollmentRequestModeIdr.AlwaysRequest;
            bool postEnrollmentRequestModeIdrAlwaysRequest = postEnrollmentRequestModeIdr != null && postEnrollmentRequestModeIdr.AlwaysRequest != null && (bool)postEnrollmentRequestModeIdr.AlwaysRequest;

            Models.IdrRuleModel idrRuleModel = new Models.IdrRuleModel()
            {
                UtilityId = id,
                PreEnrollmentRequestModeIdrId = preEnrollmentRequestModeIdrId,
                PreEnrollmentIdrRules = preEnrollmentIdrRules,
                PostEnrollmentRequestModeIdrId = postEnrollmentRequestModeIdrId,
                PostEnrollmentIdrRules = postEnrollmentIdrRules,
                PreEnrollmentRequestModeIdrAlwaysRequest = preEnrollmentRequestModeIdrAlwaysRequest,
                PostEnrollmentRequestModeIdrAlwaysRequest = postEnrollmentRequestModeIdrAlwaysRequest
            };
            return idrRuleModel;
        }

        public List<Models.IdrRulePerEnrollmentTypeModel> GenerateIdrRulePerEnrollmentTypeModelList(List<usp_IdrRule_IndexSelected_Result> usp_IdrRule_IndexSelected_Result_List)
        {
            List<Models.IdrRulePerEnrollmentTypeModel> returnValue = new List<Models.IdrRulePerEnrollmentTypeModel>();
            foreach (usp_IdrRule_IndexSelected_Result usp_IdrRule_IndexSelected_Result in usp_IdrRule_IndexSelected_Result_List)
            {
                Models.IdrRulePerEnrollmentTypeModel idrRulePerEnrollmentTypeModel = new Models.IdrRulePerEnrollmentTypeModel()
                {
                    CreatedBy = usp_IdrRule_IndexSelected_Result.CreatedBy,
                    CreatedDate = usp_IdrRule_IndexSelected_Result.CreatedDate,
                    IdrRuleId = usp_IdrRule_IndexSelected_Result.IdrRuleId,
                    Inactive = usp_IdrRule_IndexSelected_Result.Inactive,
                    IsEligible = usp_IdrRule_IndexSelected_Result.IsOnEligibleCustomerList,
                    IsHia = usp_IdrRule_IndexSelected_Result.IsHistoricalArchiveAvailable,
                    LastModifiedBy = usp_IdrRule_IndexSelected_Result.LastModifiedBy,
                    LastModifiedDate = usp_IdrRule_IndexSelected_Result.LastModifiedDate,
                    LoadProfile = usp_IdrRule_IndexSelected_Result.LoadProfileCode == null ? string.Empty : usp_IdrRule_IndexSelected_Result.LoadProfileCode,
                    RateClass = usp_IdrRule_IndexSelected_Result.RateClassCode == null ? string.Empty : usp_IdrRule_IndexSelected_Result.RateClassCode,
                    TariffCode = usp_IdrRule_IndexSelected_Result.TariffCodeCode == null ? string.Empty : usp_IdrRule_IndexSelected_Result.TariffCodeCode,
                    MaxUsageMWh = usp_IdrRule_IndexSelected_Result.MaxUsageMWh,
                    MinUsageMWh = usp_IdrRule_IndexSelected_Result.MinUsageMWh,
                    RequestModeEnrollmentTypeName = usp_IdrRule_IndexSelected_Result.RequestModeEnrollmentTypeName,
                    RequestModeTypeName = usp_IdrRule_IndexSelected_Result.RequestModeTypeName
                };
                returnValue.Add(idrRulePerEnrollmentTypeModel);
            }
            return returnValue;
        }

        public void ProcessUtilityCompanyId(ref string utilityCompanyId, ref Guid idTemp, ref Guid requestModeIdrId)
        {
            if (string.IsNullOrWhiteSpace(utilityCompanyId))
            {
                string url = Request.Url.ToString();
                try
                {
                    int semi = url.LastIndexOf(';');
                    int slash = url.LastIndexOf('/');
                    idTemp = new Guid(url.Substring(semi + 1));
                    utilityCompanyId = idTemp.ToString();
                    requestModeIdrId = new Guid(url.Substring(slash + 1, semi - slash-1));
                }
                catch (Exception) { }
            }
        }

        public Dictionary<int, string> ParseFormDataToString(string formDataName)
        {
            string method = string.Format("ParseFormDataToString(string formDataName:{0})", formDataName ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string formDataNameData = Request.Form[formDataName];
                Dictionary<int, string> returnValue = ParseStringsFromString(formDataNameData);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));

                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new Dictionary<int, string>();
            }
        }

        public Dictionary<int, string> ParseStringsFromString(string unparsedString)
        {
            Dictionary<int, string> returnValue = new Dictionary<int, string>();
            string[] arrayedString = unparsedString.Split(',');
            int counter = 0;
            foreach (string item in arrayedString)
            {
                returnValue.Add(counter, item);
                counter++;
            }
            return returnValue;
        }

        public Dictionary<int, DateTime> ParseDatesFromString(string unparsedString)
        {
            Dictionary<int, DateTime> returnValue = new Dictionary<int, DateTime>();
            string[] arrayedString = unparsedString.Split(',');
            int counter = 0;
            foreach (string item in arrayedString)
            {
                DateTime dateTime = DateTime.MinValue;
                DateTime.TryParse(item, out dateTime);
                returnValue.Add(counter, dateTime);
                counter++;
            }
            return returnValue;
        }

        public Dictionary<int, bool> ParseFormDataToBool(string formDataName)
        {
            string method = string.Format("ParseFormDataToBool(string formDataName:{0})", formDataName ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string formDataNameData = Request.Form[formDataName];
                Dictionary<int, bool> returnValue = ParseBoolsFromString(formDataNameData);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));

                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new Dictionary<int, bool>();
            }
        }

        public Dictionary<int, int?> ParseFormDataToInt(string formDataName)
        {
            string method = string.Format("ParseFormDataToInt(string formDataName:{0})", formDataName ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string formDataNameData = Request.Form[formDataName];
                Dictionary<int, int?> returnValue = ParseIntsFromString(formDataNameData);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));

                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new Dictionary<int, int?>();
            }
        }

        public bool AreIdrRulesValid(int rowCount, Guid utilityCompanyId, Dictionary<int, string> createdByDictionary, Dictionary<int, DateTime> createdDateDictionary,
            Dictionary<int, Guid?> idrRuleIdDictionary, Dictionary<int, bool> inactiveDictionary, Dictionary<int, bool> isHiaDictionary, Dictionary<int, bool> isEligibleDictionary,
             Dictionary<int, Guid?> loadProfileIdDictionary, Dictionary<int, int?> maxUsageMWhDictionary, Dictionary<int, int?> minUsageMWhDictionary, Dictionary<int, Guid?> rateClassIdDictionary,
             Dictionary<int, Guid?> requestModeIdrIdDictionary, Dictionary<int, Guid?> tariffCodeIdDictionary, out Dictionary<int, string> errorMessageDictionary)
        {
            string method = string.Format("ValidateIdrRules(int rowCount, Guid utilityCompanyId, Dictionary<int, string> createdByDictionary, Dictionary<int, DateTime> createdDateDictionary, Dictionary<int, Guid?> idrRuleIdDictionary, Dictionary<int, bool> inactiveDictionary, Dictionary<int, bool> isHiaDictionary, Dictionary<int, bool> isEligibleDictionary, Dictionary<int, Guid?> loadProfileIdDictionary, Dictionary<int, int?> maxUsageMWhDictionary, Dictionary<int, int?> minUsageMWhDictionary, Dictionary<int, Guid?> rateClassIdDictionary, Dictionary<int, Guid?> requestModeIdrIdDictionary)");
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                bool returnValue = true;
                errorMessageDictionary = new Dictionary<int, string>(rowCount);
                for (int i = 0; i <= rowCount; i++)
                {
                    if ((minUsageMWhDictionary[i] == null && maxUsageMWhDictionary[i] != null) || (minUsageMWhDictionary[i] != null && maxUsageMWhDictionary[i] == null))
                    {
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} VALIDATION FAILED ON MIN/MAX returning false {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        errorMessageDictionary[i] = "Either both Minimum Usage MWh and Maximum Usage MWh must be specified or neither should be specified.";
                        returnValue = false;
                    }
                    else if ((minUsageMWhDictionary[i] != null && maxUsageMWhDictionary[i] != null) && 
                            ((minUsageMWhDictionary[i] > maxUsageMWhDictionary[i]) || (minUsageMWhDictionary[i] < 0) || (maxUsageMWhDictionary[i] < 0)))
                    {
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} VALIDATION FAILED ON MIN/MAX returning false {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        errorMessageDictionary[i] = "The Mimimum Usage MWh must be less than or equal to the Maximum Usage MWh.";
                        returnValue = false; 
                    }
                    else if (loadProfileIdDictionary[i] == null && rateClassIdDictionary[i] == null && tariffCodeIdDictionary[i] == null && minUsageMWhDictionary[i] == null && maxUsageMWhDictionary[i] == null && !isEligibleDictionary[i] && !isHiaDictionary[i])
                    {
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} VALIDATION FAILED ON ALL FACTUORS NULL returning false {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        errorMessageDictionary[i] = "Please specify at least one rule to save the record.";
                        returnValue = false;
                    }
                    else
                    {
                        errorMessageDictionary[i] = string.Empty;
                    }
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} VALIDATION SUCCESS true {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                errorMessageDictionary = new Dictionary<int, string>(rowCount);
                ErrorHandler(exc, method);
                return false;
            }
        }

        public void SaveIdrRule(int rowCount, Guid utilityCompanyId, Dictionary<int, string> createdByDictionary, Dictionary<int, DateTime> createdDateDictionary,
            Dictionary<int, Guid?> idrRuleIdDictionary, Dictionary<int, bool> inactiveDictionary, Dictionary<int, bool> isHiaDictionary, Dictionary<int, bool> isEligibleDictionary,
             Dictionary<int, Guid?> loadProfileIdDictionary, Dictionary<int, int?> maxUsageMWhDictionary, Dictionary<int, int?> minUsageMWhDictionary, Dictionary<int, Guid?> rateClassIdDictionary,
             Dictionary<int, Guid?> requestModeIdrIdDictionary, Dictionary<int, Guid?> tariffCodeIdDictionary, bool? postEnrollmentRequestModeIdrAlwaysRequest, bool? preEnrollmentRequestModeIdrAlwaysRequest)
        {
            string method = string.Format("SaveIdrRule(int rowCount:{0}, Guid utilityCompanyId:{1}, Dictionary<int, string> createdByDictionary, Dictionary<int, DateTime> createdDateDictionary, Dictionary<int, Guid?> idrRuleIdDictionary, Dictionary<int, bool> inactiveDictionary, Dictionary<int, bool> isHiaDictionary, Dictionary<int, bool> isEligibleDictionary, Dictionary<int, Guid?> loadProfileIdDictionary, Dictionary<int, int?> maxUsageMWhDictionary, Dictionary<int, int?> minUsageMWhDictionary, Dictionary<int, Guid?> rateClassIdDictionary, Dictionary<int, Guid?> requestModeIdrIdDictionary, postEnrollmentRequestModeIdrAlwaysRequest:{2}, preEnrollmentRequestModeIdrAlwaysRequest:{3})",
                rowCount, utilityCompanyId, postEnrollmentRequestModeIdrAlwaysRequest, preEnrollmentRequestModeIdrAlwaysRequest);
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                for (int i = 0; i <= rowCount; i++)
                {
                    IdrRule idrRule = _db.IdrRules.Find((Guid)idrRuleIdDictionary[i]);

                    idrRule.CreatedBy = createdByDictionary[i];
                    idrRule.CreatedDate = createdDateDictionary[i];
                    idrRule.Id = (Guid)idrRuleIdDictionary[i];
                    idrRule.Inactive = inactiveDictionary[i];
                    idrRule.IsHistoricalArchiveAvailable = isHiaDictionary[i];
                    idrRule.IsOnEligibleCustomerList = isEligibleDictionary[i];
                    idrRule.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));;
                    idrRule.LastModifiedDate = DateTime.Now;
                    idrRule.LoadProfileId = loadProfileIdDictionary[i];
                    idrRule.RateClassId = rateClassIdDictionary[i];
                    idrRule.TariffCodeId = tariffCodeIdDictionary[i];
                    idrRule.MaxUsageMWh = maxUsageMWhDictionary[i];
                    idrRule.MinUsageMWh = minUsageMWhDictionary[i];
                    idrRule.RequestModeIdrId = requestModeIdrIdDictionary[i];
                    idrRule.UtilityCompanyId = utilityCompanyId;
                    _db.Entry(idrRule).State = EntityState.Modified;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "-+-+- Before Save Of IDR Rule");
                    _db.SaveChanges();
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "-+-+- After Save Of IDR Rule");
                    var requestModeIdr = _db.RequestModeIdrs.Find(requestModeIdrIdDictionary[i]);
                    switch (requestModeIdr.RequestModeEnrollmentType.EnumValue)
                    {
                        case 0:
                            requestModeIdr.AlwaysRequest = preEnrollmentRequestModeIdrAlwaysRequest;
                            break;
                        case 1:
                            requestModeIdr.AlwaysRequest = postEnrollmentRequestModeIdrAlwaysRequest;
                            break;
                    }
                    //if (requestModeIdr.RequestModeEnrollmentType.EnumValue == 0)
                    //{
                    //    requestModeIdr.AlwaysRequest = preEnrollmentRequestModeIdrAlwaysRequest;
                    //}
                    //else if (requestModeIdr.RequestModeEnrollmentType.EnumValue == 1)
                    //{
                    //    requestModeIdr.AlwaysRequest = postEnrollmentRequestModeIdrAlwaysRequest;
                    //}
                    _db.Entry(requestModeIdr).State = EntityState.Modified;
                    //_db.Entry(idrRule).State = EntityState.Modified;
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "-+-+- Before Save Of Request Mode Idr");
                    _db.SaveChanges();
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "-+-+- After Save Of Request Mode Idr");
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
            }
        }

        public Guid? GenerateNullableGuidFromFormKey(string keyFormat, int counter)
        {
            string method = string.Format("GenerateNullableGuidFromFormKey(string keyFormat:{0}, int counter:{1})", keyFormat ?? "NULL VALUE", counter);
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string keyName = string.Format(keyFormat, counter);
                string formValue = Request.Form[keyName];
                Guid? guidId = null;
                if (formValue != null && formValue != Guid.Empty.ToString())
                    guidId = new Guid(formValue);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return guidId;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        public int CalculateRowCount()
        {
            int rowCount = 0;
            foreach (string key in Request.Form.Keys)
            {
                int keyIndexOfUnderscore = key.IndexOf('_');
                int row = 0;
                if (keyIndexOfUnderscore > 0 && int.TryParse(key.Substring(keyIndexOfUnderscore + 1), out row) && row > rowCount)
                {
                    rowCount = row;
                }
            }
            return rowCount;
        }

        public List<UtilityManagement.Models.IdrRulePerEnrollmentTypeModel> GenerateIdrRulePerEnrollmentTypeModel(List<IdrRule> idrRuleList)
        {
            string method = string.Format("GenerateIdrRulePerEnrollmentTypeModel(List<IdrRule> idrRuleList:{0})", idrRuleList);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                List<UtilityManagement.Models.IdrRulePerEnrollmentTypeModel> returnValue = new List<UtilityManagement.Models.IdrRulePerEnrollmentTypeModel>();
                foreach (IdrRule idrRule in idrRuleList)
                {
                    Models.IdrRulePerEnrollmentTypeModel idrRulePerEnrollmentTypeModel = new Models.IdrRulePerEnrollmentTypeModel()
                    {
                        CreatedBy = idrRule.CreatedBy,
                        CreatedDate = idrRule.CreatedDate,
                        IdrRuleId = idrRule.Id,
                        Inactive = idrRule.Inactive,
                        IsEligible = idrRule.IsOnEligibleCustomerList,
                        IsHia = idrRule.IsHistoricalArchiveAvailable,
                        LastModifiedBy = idrRule.LastModifiedBy,
                        LastModifiedDate = idrRule.LastModifiedDate,
                        LoadProfile = idrRule.LoadProfile1 == null || idrRule.LoadProfile1.LoadProfileCode == null ? string.Empty : idrRule.LoadProfile1.LoadProfileCode,
                        RateClass = idrRule.RateClass == null || idrRule.RateClass.RateClassCode == null ? string.Empty : idrRule.RateClass.RateClassCode,
                        TariffCode = idrRule.TariffCode == null || idrRule.TariffCode.TariffCodeCode == null ? string.Empty : idrRule.TariffCode.TariffCodeCode,
                        MaxUsageMWh = idrRule.MaxUsageMWh,
                        MinUsageMWh = idrRule.MinUsageMWh,
                        RequestModeEnrollmentTypeName = idrRule.RequestModeIdr.RequestModeEnrollmentType.Name,
                        RequestModeTypeName = idrRule.RequestModeIdr.RequestModeType.Name
                    };
                    returnValue.Add(idrRulePerEnrollmentTypeModel);
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} returnValue:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new List<UtilityManagement.Models.IdrRulePerEnrollmentTypeModel>();
            }
        }

        public Dictionary<int, Guid?> ParseGuidsFromFormString(string formString)
        {
            string guidList = Request.Form[formString];
            return ParseGuidsFromString(guidList);
        }

        public Dictionary<int, Guid?> ParseGuidsFromString(string unparsedGuid)
        {
            Dictionary<int, Guid?> returnValue = new Dictionary<int, Guid?>();
            string[] arrayedGuid = unparsedGuid.Split(',');
            int counter = 0;
            foreach (string item in arrayedGuid)
            {
                Guid? outValue = null;
                Guid value = Guid.Empty;
                if (Guid.TryParse(item, out value))
                {
                    outValue = value;
                }
                returnValue.Add(counter, outValue);
                counter++;
            }
            return returnValue;
        }

        public Dictionary<int, bool> ParseBoolsFromString(string unparsedString)
        {
            int bias = 0;
            Dictionary<int, bool> returnValue = new Dictionary<int, bool>();
            string[] arrayedString = unparsedString.Split(',');
            int counter = 0;
            bool wasPreviousTrue = false;
            foreach (string item in arrayedString)
            {
                bool value = false;
                bool.TryParse(item, out value);
                if (!wasPreviousTrue)
                {
                    returnValue.Add(counter - bias, value);
                    wasPreviousTrue = value;
                }
                else
                {
                    bias++;
                    wasPreviousTrue = false;
                }
                counter++;
            }
            return returnValue;
        }

        public Dictionary<int, int?> ParseIntsFromString(string unparsedString)
        {
            Dictionary<int, int?> returnValue = new Dictionary<int, int?>();
            string[] arrayedString = unparsedString.Split(',');
            int counter = 0;
            foreach (string item in arrayedString)
            {
                int? outValue = null;
                int value = 0;
                if (int.TryParse(item, out value))
                {
                    outValue = value;
                }
                returnValue.Add(counter, outValue);
                counter++;
            }
            return returnValue;
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private void PopulateViewBag()
        {
            Guid uci = new Guid(Session["SelectedUtilityCompanyId"].ToString());
            string utilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
            Guid requestModeEnrollmentTypePreEnrollmentId = _db.RequestModeEnrollmentTypes.Where(x => x.EnumValue == 0).FirstOrDefault().Id;
            var result = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == uci && x.RequestModeEnrollmentTypeId == requestModeEnrollmentTypePreEnrollmentId).FirstOrDefault();
            string requestModeTypeName = string.Empty;
            if (result != null)
            {
                Guid requestModeTypeId = result.RequestModeTypeId;
                requestModeTypeName = _db.RequestModeTypes.Where(x => x.Id == requestModeTypeId).FirstOrDefault().Name;
            }

            ViewBag.RateClassId = GetRateClassSelectList(uci);
            ViewBag.LoadProfileId = GetLoadProfileSelectList(uci);
            ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(uci);
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
            ViewBag.EnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
            ViewBag.UtilityCode = utilityCode;
            ViewBag.ReqeustModeTypeName = requestModeTypeName;
        }

        private void SetEditViewBag(IdrRule idrRule)
        {
            string utilityCode = _db.UtilityCompanies.Where(x => x.Id == idrRule.UtilityCompanyId).FirstOrDefault().UtilityCode;
            Guid requestModeEnrollmentTypePreEnrollmentId = _db.RequestModeEnrollmentTypes.Where(x => x.EnumValue == 0).FirstOrDefault().Id;
            Guid requestModeTypeId = _db.RequestModeIdrs.Where(x => x.UtilityCompanyId == idrRule.UtilityCompanyId && x.RequestModeEnrollmentTypeId == requestModeEnrollmentTypePreEnrollmentId).FirstOrDefault().RequestModeTypeId;
            string requestModeTypeName = _db.RequestModeTypes.Where(x => x.Id == requestModeTypeId).FirstOrDefault().Name;

            ViewBag.UtilityCode = utilityCode;
            ViewBag.ReqeustModeTypeName = requestModeTypeName;
            ViewBag.LoadProfileId = GetLoadProfileSelectList(idrRule.UtilityCompanyId, idrRule.LoadProfileId);
            ViewBag.RateClassId = GetRateClassSelectList(idrRule.UtilityCompanyId, idrRule.RateClassId);
            ViewBag.TariffCodeId = GetTariffCodeSelectList(idrRule.UtilityCompanyId, idrRule.TariffCodeId);
            ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(idrRule.UtilityCompanyId.ToString());
        }

        private List<usp_IdrRule_IndexSelected_Result> ObtainResponse(Guid utilityCompanyId, int enrollmentType)
        {
            var data = _db.usp_IdrRule_IndexSelected(utilityCompanyId, enrollmentType);
            List<usp_IdrRule_IndexSelected_Result> response = new List<usp_IdrRule_IndexSelected_Result>();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "RateClass";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "RateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.RateClassCode).ToList();
                    }
                    else
                    {
                        ViewBag.RateClassImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.RateClassCode).ToList();
                    }
                    break;
                case "LoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.LoadProfileCode).ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.LoadProfileCode).ToList();
                    }
                    break;
                case "TariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.TariffCodeCode).ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.TariffCodeCode).ToList();
                    }
                    break;
                case "UsageMin":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UsageMinImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.MinUsageMWh).ToList();
                    }
                    else
                    {
                        ViewBag.UsageMinImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.MinUsageMWh).ToList();
                    }
                    break;
                case "UsageMax":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UsageMaxImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.MaxUsageMWh).ToList();
                    }
                    else
                    {
                        ViewBag.UsageMaxImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.MaxUsageMWh).ToList();
                    }
                    break;
                case "Eligibility":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.EligibilityImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.IsOnEligibleCustomerList).ToList();
                    }
                    else
                    {
                        ViewBag.EligibilityImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.IsOnEligibleCustomerList).ToList();
                    }
                    break;
                case "Hia":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.HiaImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.IsHistoricalArchiveAvailable).ToList();
                    }
                    else
                    {
                        ViewBag.HiaImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.IsHistoricalArchiveAvailable).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = data.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = data.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
                default:
                    ViewBag.RateClassImageUrl = Common.UPARROW;
                    response = data.OrderBy(x => x.RateClassCode).ToList();
                    break;
            }

            return response;
        }

        private IQueryable<IdrRule> GetBaseResponse()
        {
            return _db.IdrRules.Include(r => r.RateClass).Include(r => r.LoadProfile).Include(r => r.TariffCode).Include(r => r.UtilityCompany);
        }
        #endregion
    }
}
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

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class RequestModeHistoricalUsageController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "RequestModeHistoricalUsageController";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_INDEX = "UTILITYMANAGEMENT_HISTUSAGERQMOD_INDEX";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_CREATE = "UTILITYMANAGEMENT_HISTUSAGERQMOD_CREATE";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_EDIT = "UTILITYMANAGEMENT_HISTUSAGERQMOD_EDIT";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_DETAIL = "UTILITYMANAGEMENT_HISTUSAGERQMOD_DETAIL";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_UPLD = "UTILITYMANAGEMENT_HISTUSAGERQMOD_UPLD";
        private const string UTILITYMANAGEMENT_HISTUSAGERQMOD_DOWNLD = "UTILITYMANAGEMENT_HISTUSAGERQMOD_DOWNLD";
        #endregion


        #region public constructors
        public RequestModeHistoricalUsageController() : base()
        {
            ViewBag.PageName = "RequestModeHistoricalUsage";
            ViewBag.IndexPageName = "RequestModeHistoricalUsage";
            ViewBag.PageDisplayName = "Request Mode Historical Usage";
        }
        #endregion


        #region actions
        public ActionResult Report()
        {
            return View(new Models.ReportModel());
        }

        public ActionResult HuChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            var builder = new HistoricalUsageChartBuilder(salesChart);
            builder.CategoryName = "Data";
            builder.OrderYear = 2013;
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
        // GET: /RequestModeHistoricalUsage/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                
                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HISTUSAGERQMOD_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HISTUSAGERQMOD_INDEX });
                }

                var requestmodehistoricalusages = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusages));
                return View(requestmodehistoricalusages);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.RequestModeHistoricalUsageList());
            }
        }

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_HISTUSAGERQMOD_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<RequestModeHistoricalUsage>());
        }


        //
        // GET: /RequestModeHistoricalUsage/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HISTUSAGERQMOD_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HISTUSAGERQMOD_DETAIL });
                }

                RequestModeHistoricalUsage requestmodehistoricalusage = _db.RequestModeHistoricalUsages.Find(id);
                if (requestmodehistoricalusage == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodehistoricalusage:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusage));
                return View(requestmodehistoricalusage);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeHistoricalUsage());
            }
        }

        [HttpPost]
        public ActionResult Details(RequestModeHistoricalUsage requestmodehistoricalusage, string submitButton)
        {
            string method = string.Format(" Details(RequestModeHistoricalUsage requestmodehistoricalusage:{0}, submitButton:{1})", requestmodehistoricalusage == null ? "NULL VALUE" : requestmodehistoricalusage.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RequestModeHistoricalUsage", new { id = requestmodehistoricalusage.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeHistoricalUsage());
            }
        }

        //
        // GET: /RequestModeHistoricalUsage/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HISTUSAGERQMOD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HISTUSAGERQMOD_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeHistoricalUsage requestModeHistoricalUsage = new RequestModeHistoricalUsage()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeHistoricalUsage:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeHistoricalUsage));
                return View(requestModeHistoricalUsage);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeHistoricalUsage requestModeHistoricalUsage = new RequestModeHistoricalUsage();
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(requestModeHistoricalUsage);
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

        public ActionResult EnrollmentTypeTileClick()
        {
            string method = "EnrollmentTypeTileClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("EnrollmentType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeTypeClick()
        {
            string method = "RequestModeTypeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AddressClick()
        {
            string method = "AddressClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Address");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult EmailTemplateClick()
        {
            string method = "EmailTemplateClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Template");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult InstructionsClick()
        {
            string method = "InstructionsClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Instruction");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilitySlaClick()
        {
            string method = "UtilitySlaClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilitySla");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LibertyPowerSlaClick()
        {
            string method = "LibertyPowerSlaClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LibertyPowerSla");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LoaClick()
        {
            string method = "LoaClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Loa");

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

        [HttpPost]
        public JsonResult PopulateRequestModeEnrollmentTypeIdList(string requestModeEnrollmentTypeId)
        {
            string method = string.Format("PopulateRequestModeEnrollmentTypeIdList(requestModeEnrollmentTypeId:{0})", requestModeEnrollmentTypeId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = _db.usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(requestModeEnrollmentTypeId).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

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

        [HttpPost]
        public JsonResult ValidateIcapAndHistoricalUsageRequestModeTypesForCreate(string utilityCompanyId, string requestModeTypeId)
        {
            string method = string.Format("ValidateIcapAndHistoricalUsageRequestModeTypesForCreate(utilityCompanyId:{0},requestModeTypeId:{1})", utilityCompanyId, requestModeTypeId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                var res = _db.usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType(utilityCompanyId, requestModeTypeId);
                jsonResult.Data = res;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        [HttpPost]
        public JsonResult ValidateIcapAndHistoricalUsageRequestModeTypesForEdit(string requestModeIcapId, string requestModeTypeId)
        {
            string method = string.Format("ValidateIcapAndHistoricalUsageRequestModeTypesForEdit(requestModeIcapId:{0},requestModeTypeId:{1})", requestModeIcapId, requestModeTypeId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = _db.usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType_EDIT(requestModeIcapId, requestModeTypeId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        [HttpPost]
        public JsonResult GetVisibilityData(string formName)
        {
            string method = string.Format("GetVisibilityData(formName:{0})", formName);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = _db.usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(formName);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
            }
        }

        //
        // POST: /RequestModeHistoricalUsage/Create
        [HttpPost]
        public ActionResult Create(RequestModeHistoricalUsage requestmodehistoricalusage, string submitButton)
        {
            string method = string.Format("Create(RequestModeHistoricalUsage requestmodehistoricalusage:{0})", requestmodehistoricalusage == null ? "NULL VALUE" : requestmodehistoricalusage.ToString());
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
                if (ModelState.IsValid)
                {
                    requestmodehistoricalusage.Id = Guid.NewGuid();
                    requestmodehistoricalusage.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusage.CreatedDate = DateTime.Now;
                    requestmodehistoricalusage.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusage.LastModifiedDate = DateTime.Now;
                    if (requestmodehistoricalusage.IsRequestModeHistoricalUsageValid(true))
                    {
                        if (string.IsNullOrEmpty(requestmodehistoricalusage.EmailTemplate))
                            requestmodehistoricalusage.EmailTemplate = "NA";
                        if (string.IsNullOrEmpty(requestmodehistoricalusage.AddressForPreEnrollment))
                            requestmodehistoricalusage.AddressForPreEnrollment = "NA";
                        _db.RequestModeHistoricalUsages.Add(requestmodehistoricalusage);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        requestmodehistoricalusage.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                        requestmodehistoricalusage.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                        requestmodehistoricalusage.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                    }
                }

                requestmodehistoricalusage.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestmodehistoricalusage.CreatedDate = DateTime.Now;
                requestmodehistoricalusage.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestmodehistoricalusage.LastModifiedDate = DateTime.Now;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodehistoricalusage);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                return View(requestmodehistoricalusage);
            }
        }

        //
        // GET: /RequestModeHistoricalUsage/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HISTUSAGERQMOD_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HISTUSAGERQMOD_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeHistoricalUsage requestmodehistoricalusage = _db.RequestModeHistoricalUsages.Find(id);
                if (requestmodehistoricalusage == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestmodehistoricalusage.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodehistoricalusage.CreatedDate;
                Session["UtilityCompanyId"] = requestmodehistoricalusage.UtilityCompanyId;
                Session["UtilityCompanyName"] = requestmodehistoricalusage.UtilityCompany.UtilityCode;
                Session["RequestModeEnrollmentTypeName"] = requestmodehistoricalusage.RequestModeEnrollmentType.Name;
                Session["RequestModeEnrollmentTypeId"] = requestmodehistoricalusage.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodehistoricalusage:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusage));
                return View(requestmodehistoricalusage);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeHistoricalUsage requestmodehistoricalusage = _db.RequestModeHistoricalUsages.Find(id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                return View(requestmodehistoricalusage);
            }
        }

        //
        // POST: /RequestModeHistoricalUsage/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeHistoricalUsage requestmodehistoricalusage, string submitButton)
        {
            string method = string.Format("Edit(RequestModeHistoricalUsage requestmodehistoricalusage:{0})", requestmodehistoricalusage == null ? "NULL VALUE" : requestmodehistoricalusage.ToString());
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
                if (ModelState.IsValid)
                {
                    requestmodehistoricalusage.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestmodehistoricalusage.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestmodehistoricalusage.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusage.LastModifiedDate = DateTime.Now;
                    requestmodehistoricalusage.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestmodehistoricalusage.RequestModeEnrollmentTypeId = Common.NullSafeGuid(Session["RequestModeEnrollmentTypeId"]);
                    if (requestmodehistoricalusage.IsRequestModeHistoricalUsageValid(false))
                    {
                        if (string.IsNullOrEmpty(requestmodehistoricalusage.EmailTemplate))
                            requestmodehistoricalusage.EmailTemplate = "NA";
                        if (string.IsNullOrEmpty(requestmodehistoricalusage.AddressForPreEnrollment))
                            requestmodehistoricalusage.AddressForPreEnrollment = "NA";
                        _db.Entry(requestmodehistoricalusage).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    requestmodehistoricalusage.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestmodehistoricalusage.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    requestmodehistoricalusage.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }
                Session["RequestModeEnrollmentTypeId"] = requestmodehistoricalusage.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                requestmodehistoricalusage.UtilityCompany = _db.RequestModeHistoricalUsages.Find(requestmodehistoricalusage.Id).UtilityCompany;
                requestmodehistoricalusage.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                requestmodehistoricalusage.RequestModeEnrollmentType = _db.RequestModeHistoricalUsages.Find(requestmodehistoricalusage.Id).RequestModeEnrollmentType;
                requestmodehistoricalusage.RequestModeEnrollmentType.Name = Session["RequestModeEnrollmentTypeName"] == null ? "NULL VALUE" : Session["RequestModeEnrollmentTypeName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodehistoricalusage);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                requestmodehistoricalusage = _db.RequestModeHistoricalUsages.Find(requestmodehistoricalusage.Id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodehistoricalusage.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodehistoricalusage.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusage.UtilityCompanyId.ToString());
                return View(requestmodehistoricalusage);
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private Models.RequestModeHistoricalUsageModel ObtainResponse()
        {
            List<RequestModeHistoricalUsage> requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();

            Models.RequestModeHistoricalUsageModel response = new Models.RequestModeHistoricalUsageModel();
            response.RequestModeHistoricalList = new List<Models.RequestModeHistoricalUsageList>();
           
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                       requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                       requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "EnrollmentType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    break;
                case "RequestModeType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.RequestModeType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.RequestModeType.Name).ToList();
                    }
                    break;
                case "Address":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AddressImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AddressForPreEnrollment).ToList();
                    }
                    else
                    {
                        ViewBag.AddressImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.AddressForPreEnrollment).ToList();
                    }
                    break;
                case "Template":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TemplateImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.EmailTemplate).ToList();
                    }
                    else
                    {
                        ViewBag.TemplateImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.EmailTemplate).ToList();
                    }
                    break;
                case "Instruction":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InstructionImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Instructions).ToList();
                    }
                    else
                    {
                        ViewBag.InstructionImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.Instructions).ToList();
                    }
                    break;
                case "UtilitySla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilitySlaImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilitysSlaHistoricalUsageResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.UtilitySlaImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilitysSlaHistoricalUsageResponseInDays).ToList();
                    }
                    break;
                case "LibertyPowerSla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays).ToList();
                    }
                    break;
                case "Loa":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoaImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.IsLoaRequired).ToList();
                    }
                    else
                    {
                        ViewBag.LoaImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.IsLoaRequired).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        requestModeHistoricalUsageList = _db.RequestModeHistoricalUsages.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            foreach (RequestModeHistoricalUsage item in requestModeHistoricalUsageList)
            {
                Models.RequestModeHistoricalUsageList RequestModeHistoricalUsageListModel = new Models.RequestModeHistoricalUsageList(item);
                response.RequestModeHistoricalList.Add(RequestModeHistoricalUsageListModel);
            }
            return response;
        }
        #endregion
    }
}
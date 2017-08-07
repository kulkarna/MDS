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
    public class RequestModeIcapController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "RequestModeIcapController";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_INDEX = "UTILITYMANAGEMENT_ICAPRQMOD_INDEX";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_CREATE = "UTILITYMANAGEMENT_ICAPRQMOD_CREATE";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_EDIT = "UTILITYMANAGEMENT_ICAPRQMOD_EDIT";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_DETAIL = "UTILITYMANAGEMENT_ICAPRQMOD_DETAIL";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_UPLD = "UTILITYMANAGEMENT_ICAPRQMOD_UPLD";
        private const string UTILITYMANAGEMENT_ICAPRQMOD_DOWNLD = "UTILITYMANAGEMENT_ICAPRQMOD_DOWNLD";
        #endregion


        #region public constructors
        public RequestModeIcapController() : base()
        {
            ViewBag.PageName = "RequestModeIcap";
            ViewBag.IndexPageName = "RequestModeIcap";
            ViewBag.PageDisplayName = "Request Mode I-Cap";
        }
        #endregion


        #region actions
        public ActionResult HuFunnelChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            var builder = new HistoricalUsageFunnelChartBuilder(salesChart);
            builder.CategoryName = "Data";
            builder.OrderYear = 2013;
            builder.BuildFunnelChart();

            salesChart.Titles[0].Visible = false;

            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
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

        public ActionResult PorCountChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            var builder = new PorCountChartBuilder(salesChart);
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

        public ActionResult Report()
        {
            return View(new Models.ReportModel());
        }

        //
        // GET: /RequestModeIcap/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPRQMOD_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPRQMOD_INDEX });
                }

                var requestModeIcaps = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIcaps));
                return View(requestModeIcaps);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.RequestModeIcapModel());
            }
        }

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_ICAPRQMOD_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<RequestModeIcap>());
        }

        //
        // GET: /RequestModeIcap/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPRQMOD_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPRQMOD_DETAIL });
                }

                RequestModeIcap requestModeIcap = _db.RequestModeIcaps.Find(id);
                if (requestModeIcap == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIcap:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIcap));
                return View(requestModeIcap);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeIcap());
            }
        }

        [HttpPost]
        public ActionResult Details(RequestModeIcap requestModeIcap, string submitButton)
        {
            string method = string.Format(" Details(RequestModeIcap requestModeIcap:{0}, submitButton:{1})", requestModeIcap == null ? "NULL VALUE" : requestModeIcap.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RequestModeIcap", new { id = requestModeIcap.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeIcap());
            }
        }

        //
        // GET: /RequestModeIcap/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPRQMOD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPRQMOD_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeIcap requestModeIcap = new RequestModeIcap()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIcap:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIcap));
                return View(requestModeIcap);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeIcap requestModeIcap = new RequestModeIcap();
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(requestModeIcap);
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
                string historicalUsageName = Common.NullSafeString(ConfigurationManager.AppSettings["RequestModeIcapDatabaseName"]);
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
                jsonResult.Data = _db.usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType(utilityCompanyId, requestModeTypeId);

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
                jsonResult.Data = _db.usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType_EDIT(requestModeIcapId, requestModeTypeId);

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
        // POST: /RequestModeIcap/Create
        [HttpPost]
        public ActionResult Create(RequestModeIcap requestModeIcap, string submitButton)
        {
            string method = string.Format("Create(RequestModeIcap requestModeIcap:{0})", requestModeIcap == null ? "NULL VALUE" : requestModeIcap.ToString());
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
                    requestModeIcap.Id = Guid.NewGuid();
                    requestModeIcap.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestModeIcap.CreatedDate = DateTime.Now;
                    requestModeIcap.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestModeIcap.LastModifiedDate = DateTime.Now;
                    if (requestModeIcap.IsRequestModeIcapValid(true))
                    {
                        if (string.IsNullOrEmpty(requestModeIcap.EmailTemplate))
                            requestModeIcap.EmailTemplate = "NA";
                        if (string.IsNullOrEmpty(requestModeIcap.AddressForPreEnrollment))
                            requestModeIcap.AddressForPreEnrollment = "NA";
                        _db.RequestModeIcaps.Add(requestModeIcap);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                requestModeIcap.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestModeIcap.CreatedDate = DateTime.Now;
                requestModeIcap.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestModeIcap.LastModifiedDate = DateTime.Now;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestModeIcap);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                return View(requestModeIcap);
            }
        }

        //
        // GET: /RequestModeIcap/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPRQMOD_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPRQMOD_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeIcap requestModeIcap = _db.RequestModeIcaps.Find(id);
                if (requestModeIcap == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestModeIcap.CreatedBy;
                Session[Common.CREATEDDATE] = requestModeIcap.CreatedDate;
                Session["UtilityCompanyId"] = requestModeIcap.UtilityCompanyId;
                Session["UtilityCompanyName"] = requestModeIcap.UtilityCompany.UtilityCode;
                Session["RequestModeEnrollmentTypeName"] = requestModeIcap.RequestModeEnrollmentType.Name;
                Session["RequestModeEnrollmentTypeId"] = requestModeIcap.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIcap:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIcap));
                return View(requestModeIcap);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeIcap requestModeIcap = _db.RequestModeIcaps.Find(id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                return View(requestModeIcap);
            }
        }

        //
        // POST: /RequestModeIcap/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeIcap requestModeIcap, string submitButton)
        {
            string method = string.Format("Edit(RequestModeIcap requestModeIcap:{0})", requestModeIcap == null ? "NULL VALUE" : requestModeIcap.ToString());
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
                    requestModeIcap.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestModeIcap.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestModeIcap.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestModeIcap.LastModifiedDate = DateTime.Now;
                    requestModeIcap.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestModeIcap.RequestModeEnrollmentTypeId = Common.NullSafeGuid(Session["RequestModeEnrollmentTypeId"]);
                    if (requestModeIcap.IsRequestModeIcapValid(false))
                    {
                        if (string.IsNullOrEmpty(requestModeIcap.EmailTemplate))
                            requestModeIcap.EmailTemplate = "NA";
                        if (string.IsNullOrEmpty(requestModeIcap.AddressForPreEnrollment))
                            requestModeIcap.AddressForPreEnrollment = "NA";
                        _db.Entry(requestModeIcap).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    requestModeIcap.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestModeIcap.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    requestModeIcap.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }
                Session[Common.CREATEDBY] = requestModeIcap.CreatedBy;
                Session[Common.CREATEDDATE] = requestModeIcap.CreatedDate;
                Session["UtilityCompanyId"] = requestModeIcap.UtilityCompanyId;
                Session["RequestModeEnrollmentTypeId"] = requestModeIcap.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                requestModeIcap.UtilityCompany = _db.RequestModeIcaps.Find(requestModeIcap.Id).UtilityCompany;
                requestModeIcap.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                requestModeIcap.RequestModeEnrollmentType = _db.RequestModeIcaps.Find(requestModeIcap.Id).RequestModeEnrollmentType;
                requestModeIcap.RequestModeEnrollmentType.Name = Session["RequestModeEnrollmentTypeName"] == null ? "NULL VALUE" : Session["RequestModeEnrollmentTypeName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestModeIcap);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                requestModeIcap = _db.RequestModeIcaps.Find(requestModeIcap.Id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIcap.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIcap.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIcap.UtilityCompanyId.ToString());
                return View(requestModeIcap);
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private IQueryable<RequestModeIcap> GetBaseData()
        {
            return _db.RequestModeIcaps.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany);
        }

        private Models.RequestModeIcapModel ObtainResponse()
        {
            Models.RequestModeIcapModel response = new Models.RequestModeIcapModel();
            response.RequestModeIcapList = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
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
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "EnrollmentType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    break;
                case "RequestModeType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.RequestModeType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.RequestModeType.Name).ToList();
                    }
                    break;
                case "Address":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AddressImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.AddressForPreEnrollment).ToList();
                    }
                    else
                    {
                        ViewBag.AddressImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.AddressForPreEnrollment).ToList();
                    }
                    break;
                case "Template":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TemplateImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.EmailTemplate).ToList();
                    }
                    else
                    {
                        ViewBag.TemplateImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.EmailTemplate).ToList();
                    }
                    break;
                case "Instruction":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InstructionImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.Instructions).ToList();
                    }
                    else
                    {
                        ViewBag.InstructionImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.Instructions).ToList();
                    }
                    break;
                case "UtilitySla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilitySlaImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.UtilitySlaImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    }
                    break;
                case "LibertyPowerSla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    }
                    break;
                case "Loa":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoaImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.IsLoaRequired).ToList();
                    }
                    else
                    {
                        ViewBag.LoaImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.IsLoaRequired).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.RequestModeIcapList = GetBaseData().OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.RequestModeIcapList = GetBaseData().OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }
        #endregion
    }
}
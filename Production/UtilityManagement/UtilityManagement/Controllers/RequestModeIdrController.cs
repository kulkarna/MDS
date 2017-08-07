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
    public class RequestModeIdrController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "RequestModeIdrController";
        private const string UTILITYMANAGEMENT_IDRRQMOD_INDEX = "UTILITYMANAGEMENT_IDRRQMOD_INDEX";
        private const string UTILITYMANAGEMENT_IDRRQMOD_CREATE = "UTILITYMANAGEMENT_IDRRQMOD_CREATE";
        private const string UTILITYMANAGEMENT_IDRRQMOD_EDIT = "UTILITYMANAGEMENT_IDRRQMOD_EDIT";
        private const string UTILITYMANAGEMENT_IDRRQMOD_DETAIL = "UTILITYMANAGEMENT_IDRRQMOD_DETAIL";
        private const string UTILITYMANAGEMENT_IDRRQMOD_UPLD = "UTILITYMANAGEMENT_IDRRQMOD_UPLD";
        private const string UTILITYMANAGEMENT_IDRRQMOD_DOWNLD = "UTILITYMANAGEMENT_IDRRQMOD_DOWNLD";
        #endregion

        #region public constructors
        public RequestModeIdrController()
            : base()
        {
            ViewBag.PageName = "RequestModeIdr";
            ViewBag.IndexPageName = "RequestModeIdr";
            ViewBag.PageDisplayName = "Request Mode IDR";
        }
        #endregion

        #region public methods
        public ActionResult Report()
        {
            return View(new Models.ReportModel());
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
        // GET: /RequestModeIdr/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                Session["FromIdrRequest"] = "true";
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRQMOD_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRQMOD_INDEX });
                }

                var requestModeIdrs = ObtainResponse();
                ViewBag.PageName = "RequestModeIdr";
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIdrs));
                return View(requestModeIdrs);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.RequestModeIdrModel());
            }

        }

        //
        // GET: /RequestModeIdr/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRQMOD_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRQMOD_DETAIL });
                }

                RequestModeIdr requestModeIdr = _db.RequestModeIdrs.Find(id);
                if (requestModeIdr == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session["UtilityCompanyId"] = requestModeIdr.UtilityCompanyId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIdr:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIdr));
                return View(requestModeIdr);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeIdr());
            }
        }

        [HttpPost]
        public ActionResult Details(RequestModeIdr requestModeIdr, string submitButton)
        {
            string method = string.Format(" Details(RequestModeIdr requestModeIdr:{0}, submitButton:{1})", requestModeIdr == null ? "NULL VALUE" : requestModeIdr.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RequestModeIdr", new { id = requestModeIdr.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeIdr());
            }
        }

        //
        // GET: /RequestModeIdr/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRQMOD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRQMOD_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeIdr requestModeIdr = new RequestModeIdr()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIdr:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIdr));
                return View(requestModeIdr);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeIdr requestModeIdr = new RequestModeIdr();
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(requestModeIdr);
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

        public ActionResult RequestCostAccountClick()
        {
            string method = "RequestCostAccountClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestCostAccount");

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
                string historicalUsageName = Common.NullSafeString(ConfigurationManager.AppSettings["RequestModeIdrDatabaseName"]);
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
        // POST: /RequestModeIdr/Create
        [HttpPost]
        public ActionResult Create(RequestModeIdr requestModeIdr, string submitButton)
        {
            string method = string.Format("Create(RequestModeIdr requestModeIdr:{0})", requestModeIdr == null ? "NULL VALUE" : requestModeIdr.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRQMOD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRQMOD_CREATE });
                }

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
                    requestModeIdr.Id = Guid.NewGuid();
                    requestModeIdr.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                    requestModeIdr.CreatedDate = DateTime.Now;
                    requestModeIdr.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                    requestModeIdr.LastModifiedDate = DateTime.Now;
                    if (requestModeIdr.IsRequestModeIdrValid(true))
                    {
                        if (string.IsNullOrEmpty(requestModeIdr.EmailTemplate))
                            requestModeIdr.EmailTemplate = "NA";
                        if (string.IsNullOrEmpty(requestModeIdr.AddressForPreEnrollment))
                            requestModeIdr.AddressForPreEnrollment = "NA";
                        _db.RequestModeIdrs.Add(requestModeIdr);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                requestModeIdr.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                requestModeIdr.CreatedDate = DateTime.Now;
                requestModeIdr.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                requestModeIdr.LastModifiedDate = DateTime.Now;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestModeIdr);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                return View(requestModeIdr);
            }
        }

        //
        // GET: /RequestModeIdr/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_IDRRQMOD_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_IDRRQMOD_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeIdr requestModeIdr = _db.RequestModeIdrs.Find(id);
                if (requestModeIdr == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestModeIdr.CreatedBy;
                Session[Common.CREATEDDATE] = requestModeIdr.CreatedDate;
                Session["UtilityCompanyId"] = requestModeIdr.UtilityCompanyId;
                Session["UtilityCompanyName"] = requestModeIdr.UtilityCompany.UtilityCode;
                Session["RequestModeEnrollmentTypeName"] = requestModeIdr.RequestModeEnrollmentType.Name;
                Session["RequestModeEnrollmentTypeId"] = requestModeIdr.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeIdr:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeIdr));
                return View(requestModeIdr);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeIdr requestModeIdr = _db.RequestModeIdrs.Find(id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                return View(requestModeIdr);
            }
        }

        //
        // POST: /RequestModeIdr/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeIdr requestModeIdr, string submitButton)
        {
            string method = string.Format("Edit(RequestModeIdr requestModeIdr:{0})", requestModeIdr == null ? "NULL VALUE" : requestModeIdr.ToString());
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
                    requestModeIdr.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestModeIdr.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestModeIdr.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; //Common.GetUserName(User.Identity.Name);
                    requestModeIdr.LastModifiedDate = DateTime.Now;
                    requestModeIdr.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestModeIdr.RequestModeEnrollmentTypeId = Common.NullSafeGuid(Session["RequestModeEnrollmentTypeId"]);
                    if (requestModeIdr.IsRequestModeIdrValid(false))
                    {
                        _db.Entry(requestModeIdr).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    requestModeIdr.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestModeIdr.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    requestModeIdr.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }
                Session[Common.CREATEDBY] = requestModeIdr.CreatedBy;
                Session[Common.CREATEDDATE] = requestModeIdr.CreatedDate;
                Session["UtilityCompanyId"] = requestModeIdr.UtilityCompanyId;
                Session["RequestModeEnrollmentTypeId"] = requestModeIdr.RequestModeEnrollmentTypeId;

                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                requestModeIdr.UtilityCompany = _db.RequestModeIdrs.Find(requestModeIdr.Id).UtilityCompany;
                requestModeIdr.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                requestModeIdr.RequestModeEnrollmentType = _db.RequestModeIdrs.Find(requestModeIdr.Id).RequestModeEnrollmentType;
                requestModeIdr.RequestModeEnrollmentType.Name = Session["RequestModeEnrollmentTypeName"] == null ? "NULL VALUE" : Session["RequestModeEnrollmentTypeName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestModeIdr);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                requestModeIdr = _db.RequestModeIdrs.Find(requestModeIdr.Id);
                ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestModeIdr.RequestModeEnrollmentTypeId);
                ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestModeIdr.RequestModeTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestModeIdr.UtilityCompanyId.ToString());
                return View(requestModeIdr);
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private IQueryable<RequestModeIdr> GetBaseData()
        {
            return _db.RequestModeIdrs.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType).Include(r => r.UtilityCompany);
        }

        private Models.RequestModeIdrModel ObtainResponse()
        {

            Models.RequestModeIdrModel response = new Models.RequestModeIdrModel();
            response.RequestModeIdrList = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
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
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "EnrollmentType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.EnrollmentTypeImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.RequestModeEnrollmentType.Name).ToList();
                    }
                    break;
                case "RequestModeType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.RequestModeType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.RequestModeTypeImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.RequestModeType.Name).ToList();
                    }
                    break;
                case "Address":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AddressImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.AddressForPreEnrollment).ToList();
                    }
                    else
                    {
                        ViewBag.AddressImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.AddressForPreEnrollment).ToList();
                    }
                    break;
                case "Template":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TemplateImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.EmailTemplate).ToList();
                    }
                    else
                    {
                        ViewBag.TemplateImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.EmailTemplate).ToList();
                    }
                    break;
                case "Instruction":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InstructionImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.Instructions).ToList();
                    }
                    else
                    {
                        ViewBag.InstructionImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.Instructions).ToList();
                    }
                    break;
                case "UtilitySla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilitySlaImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.UtilitysSlaIdrResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.UtilitySlaImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.UtilitysSlaIdrResponseInDays).ToList();
                    }
                    break;
                case "LibertyPowerSla":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.LibertyPowersSlaFollowUpIdrResponseInDays).ToList();
                    }
                    else
                    {
                        ViewBag.LibertyPowerSlaImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.LibertyPowersSlaFollowUpIdrResponseInDays).ToList();
                    }
                    break;
                case "Loa":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoaRequiredImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.IsLoaRequired).ToList();
                    }
                    else
                    {
                        ViewBag.LoaRequiredImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.IsLoaRequired).ToList();
                    }
                    break;
                case "RequestCostAccount":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RequestCostAccountImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.RequestCostAccount).ToList();
                    }
                    else
                    {
                        ViewBag.RequestCostAccountImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.RequestCostAccount).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.RequestModeIdrList = GetBaseData().OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.RequestModeIdrList = GetBaseData().OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }
        #endregion
    }
}
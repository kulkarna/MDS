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
    public class RequestModeHistoricalUsageParameterController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "RequestModeHistoricalUsageParameterController";
        private const string UTILITYMANAGEMENT_HUPARAMETER_INDEX = "UTILITYMANAGEMENT_HUPARAMETER_INDEX";
        private const string UTILITYMANAGEMENT_HUPARAMETER_CREATE = "UTILITYMANAGEMENT_HUPARAMETER_CREATE";
        private const string UTILITYMANAGEMENT_HUPARAMETER_EDIT = "UTILITYMANAGEMENT_HUPARAMETER_EDIT";
        private const string UTILITYMANAGEMENT_HUPARAMETER_DETAIL = "UTILITYMANAGEMENT_HUPARAMETER_DETAIL";
        private const string UTILITYMANAGEMENT_HUPARAMETER_UPLD = "UTILITYMANAGEMENT_HUPARAMETER_UPLD";
        private const string UTILITYMANAGEMENT_HUPARAMETER_DOWNLD = "UTILITYMANAGEMENT_HUPARAMETER_DOWNLD";
        #endregion


        #region public constructors
        public RequestModeHistoricalUsageParameterController() : base()
        {
            ViewBag.PageName = "RequestModeHistoricalUsageParameter";
            ViewBag.IndexPageName = "RequestModeHistoricalUsageParameter";
            ViewBag.PageDisplayName = "Request Mode Historical Usage Parameter";
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

            var builder = new HistoricalUsageRequestParameterFunnelChartBuilder(salesChart);
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
        // GET: /RequestModeHistoricalUsageParameter/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HUPARAMETER_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HUPARAMETER_INDEX });
                }

                var requestmodehistoricalusageparameters = ObtainResponse();
                ViewBag.TriStateValues = _db.TriStateValues.ToList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusageparameters));
                return View(requestmodehistoricalusageparameters.ToList());
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RequestModeHistoricalUsageParameter>());
            }
        }

        //
        // GET: /RequestModeHistoricalUsageParameter/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HUPARAMETER_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HUPARAMETER_DETAIL });
                }

                RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter = _db.RequestModeHistoricalUsageParameters.Find(id);
                if (requestmodehistoricalusageparameter == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                ViewBag.TriStateValues = _db.TriStateValues.ToList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodehistoricalusageparameter:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusageparameter));
                return View(requestmodehistoricalusageparameter);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeHistoricalUsageParameter());
            }
        }

        [HttpPost]
        public ActionResult Details(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter, string submitButton)
        {
            string method = string.Format(" Details(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter:{0}, submitButton:{1})", requestmodehistoricalusageparameter == null ? "NULL VALUE" : requestmodehistoricalusageparameter.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "RequestModeHistoricalUsageParameter", new { id = requestmodehistoricalusageparameter.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeHistoricalUsageParameter());
            }
        }

        //
        // GET: /RequestModeHistoricalUsageParameter/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HUPARAMETER_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HUPARAMETER_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter = new RequestModeHistoricalUsageParameter()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                var selectList = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                List<Guid> requestModeHistoricalUsageParameterUtilityCompanyIds = _db.RequestModeHistoricalUsageParameters.Where(x => x.Inactive == false).Select(x=>x.UtilityCompanyId).ToList<Guid>();
                List<UtilityCompany> utilityCompanies = _db.UtilityCompanies.Where(x=>x.Inactive == false && !requestModeHistoricalUsageParameterUtilityCompanyIds.Contains(x.Id)).OrderBy(x=>x.UtilityCode).ToList<UtilityCompany>();
                ViewBag.UtilityCompanyId = new SelectList(utilityCompanies, "Id", "UtilityCode", utilityCompanies);

                ViewBag.IsBillingAccountNumberRequiredId = selectList;
                ViewBag.IsZipCodeRequiredId = selectList;
                ViewBag.IsNameKeyRequiredId = selectList;
                ViewBag.IsMdmaId = selectList;
                ViewBag.IsServiceProviderId = selectList;
                ViewBag.IsMeterInstallerId = selectList;
                ViewBag.IsMeterReaderId = selectList;
                ViewBag.IsMeterOwnerId = selectList;
                ViewBag.IsSchedulingCoordinatorId = selectList;
                ViewBag.HasReferenceNumberId = selectList;
                ViewBag.HasCustomerNumberId = selectList;
                ViewBag.HasPodIdNumberId = selectList;
                ViewBag.HasMeterTypeId = selectList;
                ViewBag.TriStateValues = _db.TriStateValues.ToList();
                ViewBag.IsMeterNumberRequiredId = selectList;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeHistoricalUsageParameter:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeHistoricalUsageParameter));
                return View(requestModeHistoricalUsageParameter);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                var selectList = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter = new RequestModeHistoricalUsageParameter();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.IsBillingAccountNumberRequiredId = selectList;
                ViewBag.IsZipCodeRequiredId = selectList;
                ViewBag.IsNameKeyRequiredId = selectList;
                ViewBag.IsMdmaId = selectList;
                ViewBag.IsServiceProviderId = selectList;
                ViewBag.IsMeterInstallerId = selectList;
                ViewBag.IsMeterReaderId = selectList;
                ViewBag.IsMeterOwnerId = selectList;
                ViewBag.IsSchedulingCoordinatorId = selectList;
                ViewBag.HasReferenceNumberId = selectList;
                ViewBag.HasCustomerNumberId = selectList;
                ViewBag.HasPodIdNumberId = selectList;
                ViewBag.HasMeterTypeId = selectList;
                ViewBag.TriStateValues = _db.TriStateValues.ToList();
                ViewBag.IsMeterNumberRequiredId = selectList;
                return View(requestModeHistoricalUsageParameter);
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

        public ActionResult BillingAccountClick()
        {
            string method = "BillingAccountTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("BillingAccount");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ZipCodeClick()
        {
            string method = "ZipCodeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ZipCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult NameKeyClick()
        {
            string method = "NameKeyClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameKey");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MdmaClick()
        {
            string method = "MdmaClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Mdma");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ServiceProviderClick()
        {
            string method = "ServiceProviderClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ServiceProvider");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterInstallerClick()
        {
            string method = "MeterInstallerClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterInstaller");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterReaderClick()
        {
            string method = "MeterReaderClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterReader");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterOwnerClick()
        {
            string method = "MeterOwnerClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterOwner");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult SchedulingCoordinatorClick()
        {
            string method = "SchedulingCoordinatorClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("SchedulingCoordinator");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ReferenceNumberClick()
        {
            string method = "ReferenceNumberClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ReferenceNumber");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CustomerNumberClick()
        {
            string method = "CustomerNumberClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CustomerNumber");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PodIdNumberClick()
        {
            string method = "PodIdNumberClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PodIdNumber");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterTypeClick()
        {
            string method = "MeterTypeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult MeterNumberClick()
        {
            string method = "MeterNumberClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterNumber");

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
        // POST: /RequestModeHistoricalUsageParameter/Create
        [HttpPost]
        public ActionResult Create(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter, string submitButton)
        {
            string method = string.Format("Create(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter:{0})", requestmodehistoricalusageparameter == null ? "NULL VALUE" : requestmodehistoricalusageparameter.ToString());
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
                    requestmodehistoricalusageparameter.Id = Guid.NewGuid();
                    requestmodehistoricalusageparameter.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusageparameter.CreatedDate = DateTime.Now;
                    requestmodehistoricalusageparameter.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusageparameter.LastModifiedDate = DateTime.Now;
                    if (requestmodehistoricalusageparameter.IsRequestModeHistoricalUsageParameterValid(true))
                    {
                        _db.RequestModeHistoricalUsageParameters.Add(requestmodehistoricalusageparameter);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        requestmodehistoricalusageparameter.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                        requestmodehistoricalusageparameter.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                        requestmodehistoricalusageparameter.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                    }
                }

                requestmodehistoricalusageparameter.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestmodehistoricalusageparameter.CreatedDate = DateTime.Now;
                requestmodehistoricalusageparameter.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                requestmodehistoricalusageparameter.LastModifiedDate = DateTime.Now;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.IsBillingAccountNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodehistoricalusageparameter);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.IsBillingAccountNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                return View(requestmodehistoricalusageparameter);
            }
        }

        //
        // GET: /RequestModeHistoricalUsageParameter/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_HUPARAMETER_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_HUPARAMETER_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter = _db.RequestModeHistoricalUsageParameters.Find(id);
                if (requestmodehistoricalusageparameter == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestmodehistoricalusageparameter.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodehistoricalusageparameter.CreatedDate;
                Session["UtilityCompanyId"] = requestmodehistoricalusageparameter.UtilityCompanyId;
                Session["UtilityCompanyName"] = requestmodehistoricalusageparameter.UtilityCompany.UtilityCode;
                Session["HasCustomerNumberId"] = requestmodehistoricalusageparameter.HasCustomerNumberId;
                Session["HasMeterTypeId"] = requestmodehistoricalusageparameter.HasMeterTypeId;
                Session["HasPodIdNumberId"] = requestmodehistoricalusageparameter.HasPodIdNumberId;
                Session["HasReferenceNumberId"] = requestmodehistoricalusageparameter.HasReferenceNumberId;
                Session["IsBillingAccountNumberRequiredId"] = requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId;
                Session["IsMdmaId"] =requestmodehistoricalusageparameter.IsMdmaId;
                Session["IsMeterInstallerId"] = requestmodehistoricalusageparameter.IsMeterInstallerId;
                Session["IsMeterNumberRequiredId"] = requestmodehistoricalusageparameter.IsMeterNumberRequiredId;
                Session["IsMeterOwnerId"] = requestmodehistoricalusageparameter.IsMeterOwnerId;
                Session["IsMeterReaderId"] = requestmodehistoricalusageparameter.IsMeterReaderId;
                Session["IsNameKeyRequiredId"] = requestmodehistoricalusageparameter.IsNameKeyRequiredId;
                Session["IsSchedulingCoordinatorId"] = requestmodehistoricalusageparameter.IsSchedulingCoordinatorId;
                Session["IsServiceProviderId"] = requestmodehistoricalusageparameter.IsServiceProviderId;
                Session["IsZipCodeRequiredId"] = requestmodehistoricalusageparameter.IsZipCodeRequiredId;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.IsBillingAccountNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId);
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsZipCodeRequiredId);
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsNameKeyRequiredId);
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMdmaId);
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsServiceProviderId);
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterInstallerId);
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterReaderId);
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterOwnerId);
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsSchedulingCoordinatorId);
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasReferenceNumberId);
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasCustomerNumberId);
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasPodIdNumberId);
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasMeterTypeId);
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterNumberRequiredId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodehistoricalusageparameter:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusageparameter));
                return View(requestmodehistoricalusageparameter);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter = _db.RequestModeHistoricalUsageParameters.Find(id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusageparameter.UtilityCompanyId.ToString());
                ViewBag.TriStateValueId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsZipCodeRequiredId);
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsNameKeyRequiredId);
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMdmaId);
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsServiceProviderId);
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterInstallerId);
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterReaderId);
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterOwnerId);
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsSchedulingCoordinatorId);
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasReferenceNumberId);
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasCustomerNumberId);
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasPodIdNumberId);
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasMeterTypeId);
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterNumberRequiredId);
                return View(requestmodehistoricalusageparameter);
            }
        }

        //
        // POST: /RequestModeHistoricalUsageParameter/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter, string submitButton)
        {
            string method = string.Format("Edit(RequestModeHistoricalUsageParameter requestmodehistoricalusageparameter:{0})", requestmodehistoricalusageparameter == null ? "NULL VALUE" : requestmodehistoricalusageparameter.ToString());
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
                    requestmodehistoricalusageparameter.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestmodehistoricalusageparameter.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestmodehistoricalusageparameter.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodehistoricalusageparameter.LastModifiedDate = DateTime.Now;
                    requestmodehistoricalusageparameter.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    if (requestmodehistoricalusageparameter.IsRequestModeHistoricalUsageParameterValid(false))
                    {
                        _db.Entry(requestmodehistoricalusageparameter).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    requestmodehistoricalusageparameter.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    requestmodehistoricalusageparameter.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    requestmodehistoricalusageparameter.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                    requestmodehistoricalusageparameter.HasCustomerNumberId = Common.NullSafeGuid(Session["HasCustomerNumberId"]);
                    requestmodehistoricalusageparameter.HasMeterTypeId = Common.NullSafeGuid(Session["HasMeterTypeId"]);
                    requestmodehistoricalusageparameter.HasPodIdNumberId = Common.NullSafeGuid(Session["HasPodIdNumberId"]);
                    requestmodehistoricalusageparameter.HasReferenceNumberId = Common.NullSafeGuid(Session["HasReferenceNumberId"]);
                    requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId = Common.NullSafeGuid(Session["IsBillingAccountNumberRequiredId"]);
                    requestmodehistoricalusageparameter.IsMdmaId = Common.NullSafeGuid(Session["IsMdmaId"]);
                    requestmodehistoricalusageparameter.IsMeterInstallerId = Common.NullSafeGuid(Session["IsMeterInstallerId"]);
                    requestmodehistoricalusageparameter.IsMeterNumberRequiredId = Common.NullSafeGuid(Session["IsMeterNumberRequiredId"]);
                    requestmodehistoricalusageparameter.IsMeterOwnerId = Common.NullSafeGuid(Session["IsMeterOwnerId"]);
                    requestmodehistoricalusageparameter.IsMeterReaderId = Common.NullSafeGuid(Session["IsMeterReaderId"]);
                    requestmodehistoricalusageparameter.IsNameKeyRequiredId = Common.NullSafeGuid(Session["IsNameKeyRequiredId"]);
                    requestmodehistoricalusageparameter.IsSchedulingCoordinatorId = Common.NullSafeGuid(Session["IsSchedulingCoordinatorId"]);
                    requestmodehistoricalusageparameter.IsServiceProviderId = Common.NullSafeGuid(Session["IsServiceProviderId"]);
                    requestmodehistoricalusageparameter.IsZipCodeRequiredId = Common.NullSafeGuid(Session["IsZipCodeRequiredId"]);
                }
                Session[Common.CREATEDBY] = requestmodehistoricalusageparameter.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodehistoricalusageparameter.CreatedDate;
                Session["UtilityCompanyId"] = requestmodehistoricalusageparameter.UtilityCompanyId;

                Session["HasCustomerNumberId"] = requestmodehistoricalusageparameter.HasCustomerNumberId;
                Session["HasMeterTypeId"] = requestmodehistoricalusageparameter.HasMeterTypeId;
                Session["HasPodIdNumberId"] = requestmodehistoricalusageparameter.HasPodIdNumberId;
                Session["HasReferenceNumberId"] = requestmodehistoricalusageparameter.HasReferenceNumberId;
                Session["IsBillingAccountNumberRequiredId"] = requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId;
                Session["IsMdmaId"] =requestmodehistoricalusageparameter.IsMdmaId;
                Session["IsMeterInstallerId"] = requestmodehistoricalusageparameter.IsMeterInstallerId;
                Session["IsMeterNumberRequiredId"] = requestmodehistoricalusageparameter.IsMeterNumberRequiredId;
                Session["IsMeterOwnerId"] = requestmodehistoricalusageparameter.IsMeterOwnerId;
                Session["IsMeterReaderId"] = requestmodehistoricalusageparameter.IsMeterReaderId;
                Session["IsNameKeyRequiredId"] = requestmodehistoricalusageparameter.IsNameKeyRequiredId;
                Session["IsSchedulingCoordinatorId"] = requestmodehistoricalusageparameter.IsSchedulingCoordinatorId;
                Session["IsServiceProviderId"] = requestmodehistoricalusageparameter.IsServiceProviderId;
                Session["IsZipCodeRequiredId"] = requestmodehistoricalusageparameter.IsZipCodeRequiredId;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusageparameter.UtilityCompanyId.ToString());
                ViewBag.TriStateValueId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsBillingAccountNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId);
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsZipCodeRequiredId);
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsNameKeyRequiredId);
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMdmaId);
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsServiceProviderId);
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterInstallerId);
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterReaderId);
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterOwnerId);
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsSchedulingCoordinatorId);
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasReferenceNumberId);
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasCustomerNumberId);
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasPodIdNumberId);
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasMeterTypeId);
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterNumberRequiredId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodehistoricalusageparameter:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodehistoricalusageparameter));

                requestmodehistoricalusageparameter.UtilityCompany = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).UtilityCompany;
                requestmodehistoricalusageparameter.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                requestmodehistoricalusageparameter.TriStateValue = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue;
                requestmodehistoricalusageparameter.TriStateValue1 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue1;
                requestmodehistoricalusageparameter.TriStateValue2 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue2;
                requestmodehistoricalusageparameter.TriStateValue3 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue3;
                requestmodehistoricalusageparameter.TriStateValue4 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue4;
                requestmodehistoricalusageparameter.TriStateValue5 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue5;
                requestmodehistoricalusageparameter.TriStateValue6 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue6;
                requestmodehistoricalusageparameter.TriStateValue7 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue7;
                requestmodehistoricalusageparameter.TriStateValue8 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue8;
                requestmodehistoricalusageparameter.TriStateValue9 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue9;
                requestmodehistoricalusageparameter.TriStateValue10 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue10;
                requestmodehistoricalusageparameter.TriStateValue11 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue11;
                requestmodehistoricalusageparameter.TriStateValue12 = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id).TriStateValue12;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodehistoricalusageparameter);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                requestmodehistoricalusageparameter = _db.RequestModeHistoricalUsageParameters.Find(requestmodehistoricalusageparameter.Id);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(requestmodehistoricalusageparameter.UtilityCompanyId.ToString());
                ViewBag.TriStateValueId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value");
                ViewBag.IsBillingAccountNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsBillingAccountNumberRequiredId);
                ViewBag.IsZipCodeRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsZipCodeRequiredId);
                ViewBag.IsNameKeyRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsNameKeyRequiredId);
                ViewBag.IsMdmaId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMdmaId);
                ViewBag.IsServiceProviderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsServiceProviderId);
                ViewBag.IsMeterInstallerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterInstallerId);
                ViewBag.IsMeterReaderId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterReaderId);
                ViewBag.IsMeterOwnerId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterOwnerId);
                ViewBag.IsSchedulingCoordinatorId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsSchedulingCoordinatorId);
                ViewBag.HasReferenceNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasReferenceNumberId);
                ViewBag.HasCustomerNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasCustomerNumberId);
                ViewBag.HasPodIdNumberId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasPodIdNumberId);
                ViewBag.HasMeterTypeId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.HasMeterTypeId);
                ViewBag.IsMeterNumberRequiredId = new SelectList(_db.TriStateValues.OrderBy(x => x.NumericValue), "Id", "Value", requestmodehistoricalusageparameter.IsMeterNumberRequiredId);
                return View(requestmodehistoricalusageparameter);
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        private IQueryable<RequestModeHistoricalUsageParameter> GetBaseData()
        {
            return _db.RequestModeHistoricalUsageParameters.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.TriStateValue).Include(r => r.UtilityCompany);
        }

        private List<RequestModeHistoricalUsageParameter> ObtainResponse()
        {
            var response = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
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
                        response = response.OrderByDescending(r => r.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "BillingAccount":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue.Value).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue.Value).ToList();
                    }
                    break;
                case "ZipCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ZipCodeImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue1.Value).ToList();
                    }
                    else
                    {
                        ViewBag.ZipCodeImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue1.Value).ToList();
                    }
                    break;
                case "NameKey":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue2.Value).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue2.Value).ToList();
                    }
                    break;
                case "Mdma":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MdmaImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue3.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MdmaImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue3.Value).ToList();
                    }
                    break;
                case "ServiceProvider":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceProviderImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue4.Value).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceProviderImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue4.Value).ToList();
                    }
                    break;
                case "MeterInstaller":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterInstallerImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue5.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MeterInstallerImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue5.Value).ToList();
                    }
                    break;
                case "MeterReader":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterReaderImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue6.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MeterReaderImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue6.Value).ToList();
                    }
                    break;
                case "MeterOwner":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterOwnerImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue7.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MeterOwnerImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue7.Value).ToList();
                    }
                    break;
                case "SchedulingCoordinator":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.SchedulingCoordinatorImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue8.Value).ToList();
                    }
                    else
                    {
                        ViewBag.SchedulingCoordinatorImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue8.Value).ToList();
                    }
                    break;
                case "ReferenceNumber":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ReferenceNumberImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue9.Value).ToList();
                    }
                    else
                    {
                        ViewBag.ReferenceNumberImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue9.Value).ToList();
                    }
                    break;
                case "CustomerNumber":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CustomerNumberImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue10.Value).ToList();
                    }
                    else
                    {
                        ViewBag.CustomerNumberImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue10.Value).ToList();
                    }
                    break;
                case "PodIdNumber":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PodIdNumberImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue11.Value).ToList();
                    }
                    else
                    {
                        ViewBag.PodIdNumberImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue11.Value).ToList();
                    }
                    break;
                case "MeterType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterTypeImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue11.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MeterTypeImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue11.Value).ToList();
                    }
                    break;
                case "MeterNumber":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TriStateValue12.Value).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TriStateValue12.Value).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }
        #endregion
    }
}
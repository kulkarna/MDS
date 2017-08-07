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
    public class MeterReadCalendarController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string NAMESPACE = "UtilityManagement.Controllers";
        private const string CLASS = "MeterReadCalendarController";
        private const string UTILITYMANAGEMENT_METERREADCAL_INDEX = "UTILITYMANAGEMENT_METERREADCAL_INDEX";
        private const string UTILITYMANAGEMENT_METERREADCAL_CREATE = "UTILITYMANAGEMENT_METERREADCAL_CREATE";
        private const string UTILITYMANAGEMENT_METERREADCAL_EDIT = "UTILITYMANAGEMENT_METERREADCAL_EDIT";
        private const string UTILITYMANAGEMENT_METERREADCAL_DETAIL = "UTILITYMANAGEMENT_METERREADCAL_DETAIL";
        private const string UTILITYMANAGEMENT_METERREADCAL_UPLD = "UTILITYMANAGEMENT_METERREADCAL_UPLD";
        private const string UTILITYMANAGEMENT_METERREADCAL_DOWNLD = "UTILITYMANAGEMENT_METERREADCAL_DOWNLD";
        #endregion

        #region public constructors
        public MeterReadCalendarController() : base()
        {
            ViewBag.PageName = "MeterReadCalendar";
            ViewBag.IndexPageName = "MeterReadCalendar";
            ViewBag.PageDisplayName = "Meter Read Calendar";
        }
        #endregion

        #region public methods
        public ActionResult Report()
        { 
            return View(new Models.ReportModel());
        }

        public ActionResult MeterReadCalendarCountChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            var builder = new MeterReadCalendarCountChartBuilder(salesChart);
            builder.CategoryName = "Data";
            builder.OrderYear = 2014;
            builder.BuildChart();

            salesChart.Titles[0].Visible = false;

            // to do: abstract this into a class or extension
            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
        }


        // GET: /MeterReadCalendar/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = string.Format("Index(utilityCompanyId:{0})",utilityCompanyId);
            Session["ErrorMessage"] = null;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_INDEX });
                }

                Guid idTemp = Guid.Empty;
                Models.MeterReadCalendarModel meterReadCalendars = new Models.MeterReadCalendarModel();

                var item = _db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode);
                List<UtilityCompany> utilityList = new List<UtilityCompany>();
                SelectList utilityCompany = null;

                if (utilityCompanyId == null && Session["MeterReadCalendar_UtilityCompanyId_Set"] == null && idTemp == Guid.Empty)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty start");
                    utilityList.Add(new UtilityCompany() { Id = Guid.Empty, UtilityCode = string.Empty });
                    utilityList.AddRange(item);
                   utilityCompany = new SelectList(utilityList, "Id", "UtilityCode");

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty ending");
                }
                else
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "!(utilityCompanyId == null && Session[MeterReadCalendar_UtilityCompanyId_Set] == null && idTemp == Guid.Empty)");
                    utilityList.AddRange(item);
                    utilityCompanyId = utilityCompanyId ?? Session["MeterReadCalendar_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "MeterReadCalendar = ObtainResponse(id);");

                    meterReadCalendars = ObtainResponse(id);

                    utilityCompany = new SelectList(utilityList, "Id", "UtilityCode", utilityCompanyId);
                    //ViewBag.UtilityCompanyid = GetUtilityCompanyIdSelectList(utilityCompanyId);

                    Session["UtilityCode"] = string.Empty;
                    if (meterReadCalendars != null && meterReadCalendars.MeterReadCalendarList != null && meterReadCalendars.MeterReadCalendarList.Count > 0 && meterReadCalendars.MeterReadCalendarList[0] != null && !string.IsNullOrWhiteSpace(meterReadCalendars.MeterReadCalendarList[0].UtilityCode))
                    {
                        Session["UtilityCode"] = meterReadCalendars.MeterReadCalendarList[0].UtilityCode;
                    }
                    else if (id != null && id != Guid.Empty)
                    {
                        Session["UtilityCode"] = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault().UtilityCode;
                    }
                }
                meterReadCalendars.SelectedUtilityCompanyId = utilityCompanyId;
                ViewBag.UtilityCompanyId = utilityCompany;

                _logger.LogDebug(Session["UtilityCode"]);

                if (Session["ResultData"] != null)
                {
                    Session["ResultDataOld"] = Session["ResultData"];
                    if (!(Session["FirstTimeThrough"] != null && (bool)Session["FirstTimeThrough"] == true))
                    {
                        Session["ResultData"] = null;
                        //Session["FirstTimeThrough"] = false;
                    }
                }
                Session["FirstTimeThrough"] = false;
                _logger.LogInfo(Session["FirstTimeThrough"]);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterReadCalendars)); 
                return View(meterReadCalendars);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.MeterReadCalendarModel());
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
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_METERREADCAL_UPLD))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_UPLD });
                }

                string path = @"Temp";

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    MeterReadCalendarBusinessLayer meterReadCalendarBusinessLayer = new MeterReadCalendarBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["MeterReadCalendar_UtilityCompanyId_Set"].ToString());
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
                        Session["FirstTimeThrough"] = true;
                        return RedirectToAction("Index");
                    }

                    file.SaveAs(filePathAndName);

                    meterReadCalendarBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(meterReadCalendarBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = meterReadCalendarBusinessLayer.TabSummaryWithRowNumbersList;
                }
                Session["FirstTimeThrough"] = true;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<MeterReadCalendar>());
            }
        }

        //
        // GET: /MeterReadCalendar/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_DETAIL });
                }

                MeterReadCalendar meterReadCalendar = _db.MeterReadCalendars.Find(id);

                if (meterReadCalendar == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterReadCalendar:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterReadCalendar));
                return View(meterReadCalendar);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterReadCalendar());
            }
        }

        //
        // GET: /MeterReadCalendar/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                MeterReadCalendar meterReadCalendar = new MeterReadCalendar()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    ReadDate = DateTime.Now.Date
                };
                ViewBag.UtilityId = GetUtilityCompanyIdSelectList();
                ViewBag.YearId = GetYearIdSelectList();
                ViewBag.MonthId = GetMonthIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterReadCalendar:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterReadCalendar));
                return View(meterReadCalendar);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityId = GetUtilityCompanyIdSelectList();
                ViewBag.YearId = GetYearIdSelectList();
                ViewBag.MonthId = GetMonthIdSelectList();
                return View(new MeterReadCalendar());
            }
        }

        //
        // POST: /MeterReadCalendar/Create
        [HttpPost]
        public ActionResult Create(MeterReadCalendar meterReadCalendar, string submitButton)
        {
            string method = string.Format("Create(MeterReadCalendar meterReadCalendar:{0})", meterReadCalendar == null ? "NULL VALUE" : meterReadCalendar.ToString());
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
                meterReadCalendar.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                meterReadCalendar.CreatedDate = DateTime.Now;
                meterReadCalendar.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                meterReadCalendar.LastModifiedDate = DateTime.Now;
                meterReadCalendar.ReadCycleId = !(string.IsNullOrEmpty(meterReadCalendar.ReadCycleId))? meterReadCalendar.ReadCycleId.Trim():"";
                if (ModelState.IsValid)
                {
                    meterReadCalendar.Id = Guid.NewGuid();
                    if (meterReadCalendar.IsMeterReadCalendarValid())
                    {
                        _db.MeterReadCalendars.Add(meterReadCalendar);
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
                                excSave.InnerException.InnerException.Message.Contains("UQ_MeterReadCalendar"))
                            {
                                ViewBag.YearId = GetYearIdSelectList();
                                ViewBag.MonthId = GetMonthIdSelectList();
                                ViewBag.UtilityId = GetUtilityCompanyIdSelectList();
                                Session["ErrorMessage"] = "Record Already Exists!";
                                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                return View(meterReadCalendar);
                            }
                        }
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.YearId = GetYearIdSelectList();
                ViewBag.MonthId = GetMonthIdSelectList();
                ViewBag.UtilityId = GetUtilityCompanyIdSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterReadCalendar);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.YearId = GetYearIdSelectList();
                ViewBag.MonthId = GetMonthIdSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(meterReadCalendar);
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                MeterReadCalendarBusinessLayer meterReadCalendarBusinessLayer = new MeterReadCalendarBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["MeterReadCalendar_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"{0}_MeterReadCalendar_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                meterReadCalendarBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "MeterReadCalendar");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                ErrorHandler(exc, method);
                return null;
            }
        }


        //public ActionResult DownloadAll()
        //{
        //    string method = "DownloadAll()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        string messageId = Utilities.Common.NullSafeString(Session[Common.MESSAGEID]);
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        // security check
        //        if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_DOWNLD))
        //        {
        //            _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
        //            return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_DOWNLD });
        //        }

        //        // declare variables
        //        UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
        //        ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
        //        MeterReadCalendarBusinessLayer meterReadCalendarBusinessLayer = new MeterReadCalendarBusinessLayer(repository, excelWorksheetUtility, _logger);
        //        Guid uci = new Guid(Session["MeterReadCalendar_UtilityCompanyId_Set"].ToString());
        //        string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
        //        Session[Common.ISPOSTBACK] = "false";

        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
        //        // save file
        //        string fileName = string.Format(@"All_MeterReadCalendar_{0}{1}{2}{3}{4}{5}.xlsx", 
        //            DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), 
        //            DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), 
        //            DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
        //        string filePath = @"Temp";
        //        string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
        //        meterReadCalendarBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Saved", Common.NAMESPACE, CLASS, method));

        //        // download file
        //        System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response = System.Web.HttpContext.Current.Response", Common.NAMESPACE, CLASS, method));
        //        response.ClearContent();
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ClearContent()", Common.NAMESPACE, CLASS, method));
        //        response.Clear();
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.Clear()", Common.NAMESPACE, CLASS, method));
        //        response.ContentType = "application/vnd.xls";
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response.ContentType = \"application/vnd.xls\"", Common.NAMESPACE, CLASS, method));
        //        response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Transmitting File", Common.NAMESPACE, CLASS, method));
        //        response.TransmitFile(filePathAndName);
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Transmitted", Common.NAMESPACE, CLASS, method));
        //        response.End();

        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Deleting File", Common.NAMESPACE, CLASS, method));
        //        // delete file
        //        System.Threading.Thread.Sleep(2000);
        //        System.IO.File.Delete(filePathAndName);
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Deleted", Common.NAMESPACE, CLASS, method));

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Download {3}", Common.NAMESPACE, CLASS, method, Common.END));
        //        return RedirectToAction("Index", "MeterReadCalendar");
        //    }
        //    catch (Exception exc)
        //    {
        //        _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
        //        ErrorHandler(exc, method);
        //        return null;
        //    }
        //}

        public ActionResult DownloadSummary()
        {
            string method = "DownloadSummary()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Session[Common.MESSAGEID].ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_MeterReadCalendarImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "MeterReadCalendar");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        //
        // GET: /MeterReadCalendar/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERREADCAL_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERREADCAL_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                MeterReadCalendar meterReadCalendar = _db.MeterReadCalendars.Find(id);
                if (meterReadCalendar == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = meterReadCalendar.CreatedBy;
                Session[Common.CREATEDDATE] = meterReadCalendar.CreatedDate;
                Session["UtilityCompanyId"] = meterReadCalendar.UtilityId;
                Session["UtilityCompanyName"] = meterReadCalendar.UtilityCompany.UtilityCode;

                ViewBag.YearId = GetYearIdSelectList(meterReadCalendar.YearId);
                ViewBag.MonthId = GetMonthIdSelectList(meterReadCalendar.MonthId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterReadCalendar.UtilityId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterReadCalendar:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterReadCalendar));
                return View(meterReadCalendar);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                MeterReadCalendar meterReadCalendar = _db.MeterReadCalendars.Find(id);
                ViewBag.YearId = GetYearIdSelectList();
                ViewBag.MonthId = GetMonthIdSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(meterReadCalendar);
            }
        }

        //
        // POST: /MeterReadCalendar/Edit/5
        [HttpPost]
        public ActionResult Edit(MeterReadCalendar meterReadCalendar, string submitButton)
        {
            string method = string.Format("Edit(MeterReadCalendar meterReadCalendar:{0})", meterReadCalendar == null ? "NULL VALUE" : meterReadCalendar.ToString());
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
                meterReadCalendar.UtilityId = (Guid)Session["UtilityCompanyId"];
                meterReadCalendar.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                meterReadCalendar.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                meterReadCalendar.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                meterReadCalendar.LastModifiedDate = DateTime.Now;
                meterReadCalendar.ReadCycleId = meterReadCalendar.ReadCycleId.Trim();
                meterReadCalendar.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == meterReadCalendar.UtilityId).FirstOrDefault();
                if (ModelState.IsValid)
                {
                    if (meterReadCalendar.IsMeterReadCalendarValid())
                    {
                        _db.Entry(meterReadCalendar).State = EntityState.Modified;
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
                                excSave.InnerException.InnerException.Message.Contains("UQ_MeterReadCalendar"))
                            {
                                ViewBag.YearId = GetYearIdSelectList();
                                ViewBag.MonthId = GetMonthIdSelectList();
                                ViewBag.UtilityId = GetUtilityCompanyIdSelectList();
                                Session["ErrorMessage"] = "Record Already Exists!";
                                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                return View(meterReadCalendar);
                            }
                        }
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = meterReadCalendar.CreatedBy;
                    Session[Common.CREATEDDATE] = meterReadCalendar.CreatedDate;
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterReadCalendar.UtilityId.ToString());
                ViewBag.YearId = GetYearIdSelectList(meterReadCalendar.YearId);
                ViewBag.MonthId = GetMonthIdSelectList(meterReadCalendar.MonthId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterReadCalendar);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(meterReadCalendar);
            }
        }
        #endregion


        #region private and protected methods
        public Models.MeterReadCalendarModel GenerateMeterReadCalendarModel(Guid id)
        {
            Models.MeterReadCalendarModel meterReadCalendarModel = new Models.MeterReadCalendarModel();
            meterReadCalendarModel.MeterReadCalendarList = new List<Models.MeterReadCalendarListModel>();
            meterReadCalendarModel.SelectedUtilityCompanyId = id.ToString();

            var databaseData = _db.MeterReadCalendars.Where(x => x.UtilityId == id).ToList();
            foreach (MeterReadCalendar meterReadCalendar in databaseData)
            {
                meterReadCalendarModel.MeterReadCalendarList.Add(new Models.MeterReadCalendarListModel(meterReadCalendar));
            }

            return meterReadCalendarModel;
        }



        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private Models.MeterReadCalendarModel ObtainResponse()
        {
            List<MeterReadCalendar> meterReadCalendarList = _db.MeterReadCalendars.Where(x => x.UtilityCompany.Inactive == false).ToList();
            Models.MeterReadCalendarModel response = new Models.MeterReadCalendarModel();
            response.MeterReadCalendarList = new List<Models.MeterReadCalendarListModel>();
            foreach (MeterReadCalendar item in meterReadCalendarList)
            {
                Models.MeterReadCalendarListModel meterReadCalendarListModel = new Models.MeterReadCalendarListModel(item);
                response.MeterReadCalendarList.Add(meterReadCalendarListModel);
            }

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;

            return response;
        }


        private Models.MeterReadCalendarModel ObtainResponse(Guid id)
        {
            List<MeterReadCalendar> meterReadCalendarList = _db.MeterReadCalendars.Where(x => x.UtilityCompany.Inactive == false && x.UtilityId == id).ToList();
            Models.MeterReadCalendarModel response = new Models.MeterReadCalendarModel();
            response.MeterReadCalendarList = new List<Models.MeterReadCalendarListModel>();
            foreach (MeterReadCalendar item in meterReadCalendarList)
            {
                Models.MeterReadCalendarListModel meterReadCalendarListModel = new Models.MeterReadCalendarListModel(item);
                response.MeterReadCalendarList.Add(meterReadCalendarListModel);
            }

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            _logger.LogDebug(string.Format("Session[Common.SORTCOLUMNNAME].ToString():{0}", Session[Common.SORTCOLUMNNAME].ToString()));
            _logger.LogDebug(string.Format("Session[Common.SORTDIRECTION].ToString():{0}", Session[Common.SORTDIRECTION].ToString()));
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.UtilityCode).ToList();
                    }
                    break;
                case "Year":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.YearImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.Year).ToList();
                    }
                    else
                    {
                        ViewBag.YearImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.Year).ToList();
                    }
                    break;
                case "Month":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MonthImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.Month).ToList();
                    }
                    else
                    {
                        ViewBag.MonthImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.Month).ToList();
                    }
                    break;
                case "ReadCycleId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ReadCycleIdImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.ReadCycleId).ToList();
                    }
                    else
                    {
                        ViewBag.ReadCycleIdImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.ReadCycleId).ToList();
                    }
                    break;
                case "ReadDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ReadDateImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.ReadDate).ToList();
                    }
                    else
                    {
                        ViewBag.ReadDateImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.ReadDate).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.MeterReadCalendarList = response.MeterReadCalendarList.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            _logger.LogDebug("ObtainResponse END");
            return response;
        }


        protected override List<UtilityCompany> GetUtilityCompanyList()
        {
            List<UtilityCompany> utilityList = new List<UtilityCompany>();

            var allUtilityCompanies = _db.UtilityCompanies.Where(x => x.Inactive == false);
            utilityList.AddRange(allUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion

        #region public methods returning JsonResult
        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = string.Format("Index(string utilityCompanyId:{0})",utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["MeterReadCalendar_UtilityCompanyId_Set"] = utilityCompanyId;
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
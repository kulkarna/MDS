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
    public class PaymentTermController : ControllerBaseWithUtilDropDown
    {
        #region private variables and constants
        private const string NAMESPACE = "UtilityManagement.Controllers";
        private const string CLASS = "PaymentTermController";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_INDEX = "UTILITYMANAGEMENT_PAYMENTTERM_INDEX";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_CREATE = "UTILITYMANAGEMENT_PAYMENTTERM_CREATE";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_EDIT = "UTILITYMANAGEMENT_PAYMENTTERM_EDIT";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_DETAIL = "UTILITYMANAGEMENT_PAYMENTTERM_DETAIL";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_UPLD = "UTILITYMANAGEMENT_PAYMENTTERM_UPLD";
        private const string UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD = "UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD";
        #endregion

        #region public constructors
        public PaymentTermController() : base()
        {
            try
            {
                ViewBag.PageName = "PaymentTerm";
                ViewBag.IndexPageName = "PaymentTerm";
                ViewBag.PageDisplayName = "Payment Term";
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, "PaymentTermController() : base()");

            }
        }
        #endregion

        #region public methods
        public ActionResult Report()
        { 
            return View(new Models.ReportModel());
        }

        public ActionResult PaymentTermCountChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            //var builder = new PaymentTermCountChartBuilder(salesChart);
            //builder.CategoryName = "Data";
            //builder.OrderYear = 2014;
            //builder.BuildChart();

            salesChart.Titles[0].Visible = false;

            // to do: abstract this into a class or extension
            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
        }


        public override ActionResult GetBlankResponse()
        {
            return View(new Models.PaymentTermModel());
        }

        // GET: /PaymentTerm/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = string.Format("Index(utilityCompanyId:{0})",utilityCompanyId);
            Session["ErrorMessage"] = null;
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_INDEX });
                }

                Guid idTemp = Guid.Empty;
                Models.PaymentTermModel paymentTerms = new Models.PaymentTermModel();

                var item = _db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode);
                List<UtilityCompany> utilityList = new List<UtilityCompany>();
                SelectList utilityCompany = null;

                if (utilityCompanyId == null && Session["PaymentTerm_UtilityCompanyId_Set"] == null && idTemp == Guid.Empty)
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty start");
                    utilityList.Add(new UtilityCompany() { Id = Guid.Empty, UtilityCode = string.Empty });
                    utilityList.AddRange(item);
                    utilityCompany = new SelectList(utilityList, "Id", "UtilityCode");

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "utilityCompanyId == null && Session[SelectedUtilityCompanyId] == null && idTemp == Guid.Empty ending");
                }
                else
                {
                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "!(utilityCompanyId == null && Session[PaymentTerm_UtilityCompanyId_Set] == null && idTemp == Guid.Empty)");
                    utilityList.AddRange(item);
                    utilityCompanyId = utilityCompanyId ?? Session["PaymentTerm_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);

                    _logger.LogDebug(Session[Common.MESSAGEID].ToString(), "PaymentTerm = ObtainResponse(id);");

                    paymentTerms = ObtainResponse(id);

                    utilityCompany = new SelectList(utilityList, "Id", "UtilityCode", utilityCompanyId);
                    //ViewBag.UtilityCompanyid = GetUtilityCompanyIdSelectList(utilityCompanyId);

                    Session["UtilityCode"] = string.Empty;
                    if (paymentTerms != null && paymentTerms.PaymentTermList != null && paymentTerms.PaymentTermList.Count > 0 && paymentTerms.PaymentTermList[0] != null && !string.IsNullOrWhiteSpace(paymentTerms.PaymentTermList[0].UtilityCode))
                    {
                        Session["UtilityCode"] = paymentTerms.PaymentTermList[0].UtilityCode;
                    }
                    else if (id != null && id != Guid.Empty)
                    {
                        Session["UtilityCode"] = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault().UtilityCode;
                    }
                }

                ViewBag.UtilityCompanyId = utilityCompany;
                paymentTerms.SelectedUtilityCompanyId =utilityCompanyId;
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

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, paymentTerms)); 
                return View(paymentTerms);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new Models.PaymentTermModel());
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
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_PAYMENTTERM_UPLD))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_UPLD });
                }

                string path = @"Temp";

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    PaymentTermBusinessLayer paymentTermBusinessLayer = new PaymentTermBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["PaymentTerm_UtilityCompanyId_Set"].ToString());
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

                    paymentTermBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(paymentTermBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = paymentTermBusinessLayer.TabSummaryWithRowNumbersList;
                }
                Session["FirstTimeThrough"] = true;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<PaymentTerm>());
            }
        }

        //
        // GET: /PaymentTerm/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_DETAIL });
                }

                PaymentTerm paymentTerm = _db.PaymentTerms.Find(id);

                if (paymentTerm == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} paymentTerm:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, paymentTerm));
                return View(paymentTerm);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new PaymentTerm());
            }
        }

        //
        // GET: /PaymentTerm/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                PaymentTerm paymentTerm = new PaymentTerm()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now,
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(null);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} paymentTerm:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, paymentTerm));
                return View(paymentTerm);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(null);
                return View(new PaymentTerm());
            }
        }

        //
        // POST: /PaymentTerm/Create
        [HttpPost]
        public ActionResult Create(PaymentTerm paymentTerm, string submitButton)
        {
            string method = string.Format("Create(PaymentTerm paymentTerm:{0})", paymentTerm == null ? "NULL VALUE" : paymentTerm.ToString());
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
                paymentTerm.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                paymentTerm.CreatedDate = DateTime.Now;
                paymentTerm.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                paymentTerm.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    paymentTerm.Id = Guid.NewGuid();
                    if (paymentTerm.IsPaymentTermValid())
                    {
                        _db.PaymentTerms.Add(paymentTerm);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(null);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(paymentTerm);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(null);
                return View(paymentTerm);
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PaymentTermBusinessLayer paymentTermBusinessLayer = new PaymentTermBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PaymentTerm_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"{0}_PaymentTerm_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                paymentTermBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PaymentTerm");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PaymentTermBusinessLayer paymentTermBusinessLayer = new PaymentTermBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PaymentTerm_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"All_PaymentTerm_{0}{1}{2}{3}{4}{5}.xlsx", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                paymentTermBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PaymentTerm");
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_PaymentTermImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "PaymentTerm");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }

        //
        // GET: /PaymentTerm/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PAYMENTTERM_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PAYMENTTERM_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                PaymentTerm paymentTerm = _db.PaymentTerms.Find(id);
                if (paymentTerm == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = paymentTerm.CreatedBy;
                Session[Common.CREATEDDATE] = paymentTerm.CreatedDate;
                Session["UtilityCompanyId"] = paymentTerm.UtilityCompanyId;
                Session["UtilityCompanyName"] = paymentTerm.UtilityCompany.UtilityCode;

                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList(paymentTerm.BusinessAccountTypeId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(paymentTerm.BillingTypeId);
                ViewBag.MarketId = GetMarketIdSelectList(paymentTerm.MarketId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(paymentTerm.UtilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} paymentTerm:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, paymentTerm));
                return View(paymentTerm);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                PaymentTerm paymentTerm = _db.PaymentTerms.Find(id);
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(Guid.Empty);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(paymentTerm);
            }
        }

        //
        // POST: /PaymentTerm/Edit/5
        [HttpPost]
        public ActionResult Edit(PaymentTerm paymentTerm, string submitButton)
        {
            string method = string.Format("Edit(PaymentTerm paymentTerm:{0})", paymentTerm == null ? "NULL VALUE" : paymentTerm.ToString());
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
                paymentTerm.UtilityCompanyId = (Guid)Session["UtilityCompanyId"];
                paymentTerm.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                paymentTerm.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                paymentTerm.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                paymentTerm.LastModifiedDate = DateTime.Now;
                paymentTerm.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == paymentTerm.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid)
                {
                    if (paymentTerm.IsPaymentTermValid())
                    {
                        _db.Entry(paymentTerm).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = paymentTerm.CreatedBy;
                    Session[Common.CREATEDDATE] = paymentTerm.CreatedDate;
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(paymentTerm.UtilityCompanyId.ToString());
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList(paymentTerm.BusinessAccountTypeId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(paymentTerm.BillingTypeId);
                ViewBag.MarketId = GetMarketIdSelectList(paymentTerm.MarketId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(paymentTerm);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.BusinessAccountTypeId = GetAccountTypeIdSelectList();
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList();
                ViewBag.MarketId = GetMarketIdSelectList(Guid.Empty);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(paymentTerm);
            }
        }
        #endregion


        #region private and protected methods
        public Models.PaymentTermModel GeneratePaymentTermModel(Guid id)
        {
            Models.PaymentTermModel paymentTermModel = new Models.PaymentTermModel();
            paymentTermModel.PaymentTermList = new List<Models.PaymentTermListModel>();
            paymentTermModel.SelectedUtilityCompanyId = id.ToString();

            var databaseData = _db.PaymentTerms.Where(x => x.UtilityCompanyId == id).ToList();
            foreach (PaymentTerm paymentTerm in databaseData)
            {
                paymentTermModel.PaymentTermList.Add(new Models.PaymentTermListModel(paymentTerm));
            }

            return paymentTermModel;
        }



        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private Models.PaymentTermModel ObtainResponse()
        {
            List<PaymentTerm> paymentTermList = _db.PaymentTerms.Where(x => x.UtilityCompany.Inactive == false).ToList();
            Models.PaymentTermModel response = new Models.PaymentTermModel();
            response.PaymentTermList = new List<Models.PaymentTermListModel>();
            foreach (PaymentTerm item in paymentTermList)
            {
                Models.PaymentTermListModel paymentTermListModel = new Models.PaymentTermListModel(item);
                response.PaymentTermList.Add(paymentTermListModel);
            }

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;

            return response;
        }


        private Models.PaymentTermModel ObtainResponse(Guid id)
        {
            List<PaymentTerm> paymentTermList = _db.PaymentTerms.Where(x => x.UtilityCompany.Inactive == false && x.UtilityCompanyId == id).ToList();
            Models.PaymentTermModel response = new Models.PaymentTermModel();
            response.PaymentTermList = new List<Models.PaymentTermListModel>();
            foreach (PaymentTerm item in paymentTermList)
            {
                Models.PaymentTermListModel paymentTermListModel = new Models.PaymentTermListModel(item);
                response.PaymentTermList.Add(paymentTermListModel);
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
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.UtilityCode).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BusinessAccountTypeImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.BusinessAccountType).ToList();
                    }
                    else
                    {
                        ViewBag.BusinessAccountTypeImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.BusinessAccountType).ToList();
                    }
                    break;
                case "BillingType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingTypeImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.BillingType).ToList();
                    }
                    else
                    {
                        ViewBag.BillingTypeImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.BillingType).ToList();
                    }
                    break;
                case "Market":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MarketImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.Market).ToList();
                    }
                    else
                    {
                        ViewBag.MarketImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.Market).ToList();
                    }
                    break;
                case "PaymentTerm":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PaymentTermImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.PaymentTerm).ToList();
                    }
                    else
                    {
                        ViewBag.PaymentTermImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.PaymentTerm).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.PaymentTermList = response.PaymentTermList.OrderBy(x => x.LastModifiedDate).ToList();
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
                Session["PaymentTerm_UtilityCompanyId_Set"] = utilityCompanyId;
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
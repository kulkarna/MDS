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
using UtilityManagement.Models;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class PurchaseOfReceivableController : ControllerBaseWithUtilDropDown
    {
        #region private variables
        private const string CLASS = "PurchaseOfReceivableController";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_INDEX = "UTILITYMANAGEMENT_PURCHOFRECVBLE_INDEX";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_CREATE = "UTILITYMANAGEMENT_PURCHOFRECVBLE_CREATE";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_EDIT = "UTILITYMANAGEMENT_PURCHOFRECVBLE_EDIT";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_DETAIL = "UTILITYMANAGEMENT_PURCHOFRECVBLE_DETAIL";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_UPLD = "UTILITYMANAGEMENT_PURCHOFRECVBLE_UPLD";
        private const string UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD = "UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD";
        #endregion

        #region public constructors
        public PurchaseOfReceivableController()
            : base()
        {
            ViewBag.PageName = "PurchaseOfReceivable";
            ViewBag.IndexPageName = "PurchaseOfReceivable";
            ViewBag.PageDisplayName = "Purchase Of Receivable";
        }
        #endregion


        #region actions
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


        //
        // GET: /PurchaseOfReceivable/
        public override ActionResult Index(string utilityCompanyId)
        {
            string method = "Index(utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_INDEX });
                }

                Guid idTemp = Guid.Empty;
                ProcessUtilityCompanyId(ref utilityCompanyId, ref idTemp);
                Models.PurchaseOfReceivableModel PurModel = new Models.PurchaseOfReceivableModel();
                _logger.LogInfo("Initialization");
                _logger.LogInfo(string.Format("InitializationA.{0}", utilityCompanyId == null));
                _logger.LogInfo(string.Format("InitializationB.{0}", Session["PurchaseOfReceivable_UtilityCompanyId_Set"] == null));
                _logger.LogInfo(string.Format("InitializationC.{0}", idTemp == Guid.Empty));

                if (utilityCompanyId == null && Session["PurchaseOfReceivable_UtilityCompanyId_Set"] == null && idTemp == Guid.Empty)
                {
                    _logger.LogInfo("ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace(); B4");

                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace();

                    _logger.LogInfo("ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectListWithSpace(); After");
                }
                else
                {
                    _logger.LogInfo("utilityCompanyId = utilityCompanyId ");

                    utilityCompanyId = utilityCompanyId ?? Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString();
                    Guid id = new Guid(utilityCompanyId);

                    _logger.LogInfo("PurchaseOfReceivables = ObtainResponse(id);");

                    PurModel = ObtainResponse(id);

                    _logger.LogInfo("ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId);");

                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId);

                    Session["UtilityCode"] = string.Empty;
                    if (PurModel.PurchaseOfReceivableList != null && PurModel.PurchaseOfReceivableList.Count > 0 && PurModel.PurchaseOfReceivableList[0] != null && PurModel.PurchaseOfReceivableList[0].UtilityCompany != null && !string.IsNullOrWhiteSpace(PurModel.PurchaseOfReceivableList[0].UtilityCompany.UtilityCode))
                    {
                        Session["UtilityCode"] = PurModel.PurchaseOfReceivableList[0].UtilityCompany.UtilityCode;
                    }
                    else
                    {
                        Session["UtilityCode"] = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault().UtilityCode;
                    }
                }
                PurModel.SelectedUtilityCompanyId = utilityCompanyId;
                _logger.LogInfo(Session["UtilityCode"]);

                if (Session["ResultData"] != null)
                {
                    Session["ResultDataOld"] = Session["ResultData"];
                    if (!(Session["FirstTimeThrough"] != null && (bool)Session["FirstTimeThrough"] == true))
                    //{
                    //    //response.ResultData = (List<string>)Session["ResultData"];                    
                    //}
                    //else
                    {
                        Session["ResultData"] = null;
                        Session["FirstTimeThrough"] = false;
                    }
                }
                Session["FirstTimeThrough"] = false;
                _logger.LogInfo(Session["FirstTimeThrough"]);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, PurModel.PurchaseOfReceivableList));
                return View(PurModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<PurchaseOfReceivable>());
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
                Models.PurchaseOfReceivableModel PurModel = new Models.PurchaseOfReceivableModel();
                // security check
                if (!IsUserAuthorizedForThisActivity(messageId, UTILITYMANAGEMENT_PURCHOFRECVBLE_UPLD))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_UPLD });
                }

                string path = @"Temp";

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                    ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                    PurchaseOfReceivableBusinessLayer purchaseOfReceivableBusinessLayer = new PurchaseOfReceivableBusinessLayer(repository, excelWorksheetUtility, _logger);
                    VerifyMessageIdAndErrorMessageSession();
                    Guid uci = new Guid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString());
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

                    purchaseOfReceivableBusinessLayer.UploadFromExcelToDatabase(messageId, utilityCode, filePathAndName, userName);

                    // delete the file
                    System.IO.File.Delete(filePathAndName);

                    List<string> resultData = new List<string>();
                    resultData.AddRange(purchaseOfReceivableBusinessLayer.TabsSummaryList);

                    Session["ResultData"] = resultData;
                    Session["TabSummaryWithRowNumbersList"] = purchaseOfReceivableBusinessLayer.TabSummaryWithRowNumbersList;
                }
                Session["FirstTimeThrough"] = true;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return RedirectToAction(Index) {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<PurchaseOfReceivable>());
            }
        }

        #region public methods returning JsonResult
        public JsonResult IndexUtilitySelection(string utilityCompanyId)
        {
            string method = "Index(Guid utilityCompanyId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["PurchaseOfReceivable_UtilityCompanyId_Set"] = utilityCompanyId;
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

        //
        // GET: /PurchaseOfReceivable/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DETAIL });
                }

                PurchaseOfReceivable PurchaseOfReceivable = _db.PurchaseOfReceivables.Find(id);

                if (PurchaseOfReceivable == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} PurchaseOfReceivable:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, PurchaseOfReceivable));
                return View(PurchaseOfReceivable);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new PurchaseOfReceivable());
            }
        }

        [HttpPost]
        public ActionResult Details(PurchaseOfReceivable PurchaseOfReceivable, string submitButton)
        {
            string method = string.Format(" Details(PurchaseOfReceivable PurchaseOfReceivable:{0}, submitButton:{1})", PurchaseOfReceivable == null ? "NULL VALUE" : PurchaseOfReceivable.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "PurchaseOfReceivable", new { id = PurchaseOfReceivable.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new PurchaseOfReceivable());
            }
        }

        //
        // GET: /PurchaseOfReceivable/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                PurchaseOfReceivable purchaseOfReceivable = new PurchaseOfReceivable()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now,
                    PorDiscountEffectiveDate = DateTime.Now
                };
                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.RateClassId = GetRateClassSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                Session["PorDriver_LoadProfileId"] = _db.PorDrivers.Where(x => x.Name == "Load Profile").FirstOrDefault().Id;
                Session["PorDriver_RateClassId"] = _db.PorDrivers.Where(x => x.Name == "Rate Class").FirstOrDefault().Id;
                Session["PorDriver_TariffCodeId"] = _db.PorDrivers.Where(x => x.Name == "Tariff Code").FirstOrDefault().Id;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} PurchaseOfReceivable:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, purchaseOfReceivable));
                return View(purchaseOfReceivable);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                PurchaseOfReceivable purchaseOfReceivable = new PurchaseOfReceivable();
                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.RateClassId = GetRateClassSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(purchaseOfReceivable);
            }
        }

        [HttpPost]
        public JsonResult GetLoadProfileSelectListJson(Guid utilityCompanyId)
        {
            string method = string.Format("GetLoadProfileSelectListJson(utilityCompanyId:{0})", utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = GetLoadProfileSelectList(utilityCompanyId);

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
        public JsonResult GetRateClassSelectListJson(Guid utilityCompanyId)
        {
            string method = string.Format("GetRateClassSelectListJson(utilityCompanyId:{0})", utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = GetRateClassSelectList(utilityCompanyId);

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
        public JsonResult GetTariffCodeSelectListJson(Guid utilityCompanyId)
        {
            string method = string.Format("GetTariffCodeSelectListJson(utilityCompanyId:{0})", utilityCompanyId);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                jsonResult.Data = GetTariffCodeSelectListWithSpace(utilityCompanyId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
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

                _logger.LogInfo(string.Format("ViewBag==null:{0}", ViewBag == null));
                _logger.LogInfo(string.Format("ViewBag.RateClassImageUrl==null:{0}", ViewBag.RateClassImageUrl == null));

                var response = ManageSortationSession("RateClass");

                _logger.LogInfo(string.Format("response==null:{0}", response == null));

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

        public ActionResult IsPorOfferedTitleClick()
        {
            string method = "IsPorOfferedTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsPorOffered");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsPorParticipatedTitleClick()
        {
            string method = "IsPorParticipatedTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsPorParticipated");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PorRecourseTitleClick()
        {
            string method = "PorRecourseTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorRecourse");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsPorAssuranceTitleClick()
        {
            string method = "IsPorAssuranceTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsPorAssurance");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PorDiscountRateTitleClick()
        {
            string method = "PorDiscountRateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorDiscountRate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PorFlatFeeTitleClick()
        {
            string method = "PorFlatFeeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorFlatFee");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PorDiscountEffectiveDateTitleClick()
        {
            string method = "PorDiscountEffectiveDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorDiscountEffectiveDate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult PorDiscountExpirationDateTitleClick()
        {
            string method = "PorDiscountExpirationDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("PorDiscountExpirationDate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

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
        // POST: /PurchaseOfReceivable/Create
        [HttpPost]
        public ActionResult Create(PurchaseOfReceivable purchaseOfReceivable, string submitButton)
        {
            string method = string.Format("Create(PurchaseOfReceivable purchaseOfReceivable:{0})", purchaseOfReceivable == null ? "NULL VALUE" : purchaseOfReceivable.ToString());
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
                purchaseOfReceivable.Id = Guid.NewGuid();
                purchaseOfReceivable.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                purchaseOfReceivable.CreatedDate = DateTime.Now;
                purchaseOfReceivable.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                purchaseOfReceivable.LastModifiedDate = DateTime.Now;
                if (purchaseOfReceivable.IsPurchaseOfReceivableValid())
                {
                    _db.PurchaseOfReceivables.Add(purchaseOfReceivable);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                else
                {
                    purchaseOfReceivable.UtilityCompanyId = Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]);
                    purchaseOfReceivable.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    purchaseOfReceivable.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }

                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.RateClassId = GetRateClassSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(purchaseOfReceivable);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.RateClassId = GetRateClassSelectList(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.TariffCodeId = GetTariffCodeSelectListWithSpace(Common.NullSafeGuid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"]));
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(purchaseOfReceivable);
            }
        }

        //
        // GET: /PurchaseOfReceivable/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                PurchaseOfReceivable purchaseOfReceivable = _db.PurchaseOfReceivables.Find(id);
                if (purchaseOfReceivable == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = purchaseOfReceivable.CreatedBy;
                Session[Common.CREATEDDATE] = purchaseOfReceivable.CreatedDate;
                Session["UtilityCompanyId"] = purchaseOfReceivable.UtilityCompanyId;
                Session["UtilityCompanyName"] = purchaseOfReceivable.UtilityCompany.UtilityCode;

                ViewBag.PorDriverId = GetPorDriverSelectList(purchaseOfReceivable.PorDriverId);
                ViewBag.PorRecourseId = GetPorRecourseSelectList(purchaseOfReceivable.PorRecourseId);
                ViewBag.LoadProfileId = GetLoadProfileSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.LoadProfileId);
                ViewBag.RateClassId = GetRateClassSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.RateClassId);
                ViewBag.TariffCodeId = GetTariffCodeSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.TariffCodeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(purchaseOfReceivable.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} PurchaseOfReceivable:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, purchaseOfReceivable));
                return View(purchaseOfReceivable);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                PurchaseOfReceivable purchaseOfReceivable = _db.PurchaseOfReceivables.Find(id);
                ViewBag.PorDriverId = GetPorDriverSelectList(purchaseOfReceivable.PorDriverId);
                ViewBag.PorRecourseId = GetPorRecourseSelectList(purchaseOfReceivable.PorRecourseId);
                ViewBag.LoadProfileId = GetLoadProfileSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.LoadProfileId);
                ViewBag.RateClassId = GetRateClassSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.RateClassId);
                ViewBag.TariffCodeId = GetTariffCodeSelectList(purchaseOfReceivable.UtilityCompanyId, purchaseOfReceivable.TariffCodeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(purchaseOfReceivable.UtilityCompanyId.ToString());
                return View(purchaseOfReceivable);
            }
        }

        public bool IsPurchaseOfReceivableADuplicate(PurchaseOfReceivable purchaseOfReceivable)
        {
            int purchaseOfReceivablesCount = _db.PurchaseOfReceivables.Where(x => x.UtilityCompanyId == purchaseOfReceivable.UtilityCompanyId
                && x.PorDriverId == purchaseOfReceivable.PorDriverId
                &&
                (
                    (
                        x.PorDriver.Name.ToLower().Trim() == "rate class" && x.RateClassId == purchaseOfReceivable.RateClassId
                    )
                    ||
                    (
                        x.PorDriver.Name.ToLower().Trim() == "load profile" && x.LoadProfileId == purchaseOfReceivable.LoadProfileId
                    )
                    ||
                    (
                        x.PorDriver.Name.ToLower().Trim() == "tariff code" && x.RateClassId == purchaseOfReceivable.TariffCodeId
                    )
                )
                && x.Id != purchaseOfReceivable.Id
                ).Count();
            return purchaseOfReceivablesCount > 0;
        }

        //
        // POST: /PurchaseOfReceivable/Edit/5
        [HttpPost]
        public ActionResult Edit(PurchaseOfReceivable purchaseOfReceivable, string submitButton)
        {
            string method = string.Format("Edit(PurchaseOfReceivable PurchaseOfReceivable:{0})", purchaseOfReceivable == null ? "NULL VALUE" : purchaseOfReceivable.ToString());
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
                    purchaseOfReceivable.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    purchaseOfReceivable.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    purchaseOfReceivable.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])); ; // Common.GetUserName(User.Identity.Name);
                    purchaseOfReceivable.LastModifiedDate = DateTime.Now;
                    purchaseOfReceivable.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    purchaseOfReceivable.PorDriver = _db.PorDrivers.Where(x => x.Id == purchaseOfReceivable.PorDriverId).FirstOrDefault();
                    if (purchaseOfReceivable.IsPurchaseOfReceivableValid() &&
                        !IsPurchaseOfReceivableADuplicate(purchaseOfReceivable) &&
                        (purchaseOfReceivable.PorDriver.Name == "Rate Class" && purchaseOfReceivable.RateClassId != null) ||
                        (purchaseOfReceivable.PorDriver.Name == "Load Profile" && purchaseOfReceivable.LoadProfileId != null) ||
                        (purchaseOfReceivable.PorDriver.Name == "Tariff Code" && purchaseOfReceivable.TariffCodeId != null)
                        )
                    {
                        _db.Entry(purchaseOfReceivable).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    purchaseOfReceivable.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    purchaseOfReceivable.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    purchaseOfReceivable.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }

                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList();
                ViewBag.RateClassId = GetRateClassSelectList();
                ViewBag.TariffCodeId = GetTariffCodeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                purchaseOfReceivable.UtilityCompany = _db.PurchaseOfReceivables.Find(purchaseOfReceivable.Id).UtilityCompany;
                purchaseOfReceivable.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(purchaseOfReceivable);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                purchaseOfReceivable = _db.PurchaseOfReceivables.Find(purchaseOfReceivable.Id);
                ViewBag.PorDriverId = GetPorDriverSelectList();
                ViewBag.PorRecourseId = GetPorRecourseSelectList();
                ViewBag.LoadProfileId = GetLoadProfileSelectList();
                ViewBag.RateClassId = GetRateClassSelectList();
                ViewBag.TariffCodeId = GetTariffCodeSelectList();
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                return View(purchaseOfReceivable);
            }
        }

        [HttpPost]
        public JsonResult PopulateLoadProfileIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateLoadProfileIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                Guid? utilityCompanyIdGuid = null;
                if (!string.IsNullOrEmpty(utilityCompanyId))
                    utilityCompanyIdGuid = Common.NullSafeGuid(utilityCompanyId);
                jsonResult.Data = _db.usp_LoadProfile_SELECT_By_UtilityCompanyId(utilityCompanyIdGuid).ToList().OrderBy(x => x.Name);

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
        public JsonResult PopulateRateClassIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateRateClassIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                Guid? utilityCompanyIdGuid = null;
                if (!string.IsNullOrEmpty(utilityCompanyId))
                    utilityCompanyIdGuid = Common.NullSafeGuid(utilityCompanyId);
                jsonResult.Data = _db.usp_RateClass_SELECT_By_UtilityCompanyId(utilityCompanyIdGuid).ToList().OrderBy(x => x.Name);

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
        public JsonResult PopulateTariffCodeIdList(string utilityCompanyId)
        {
            string method = string.Format("PopulateTariffCodeIdList(utilityCompanyId:{0})", utilityCompanyId ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                JsonResult jsonResult = new JsonResult();
                Guid? utilityCompanyIdGuid = null;
                if (!string.IsNullOrEmpty(utilityCompanyId))
                    utilityCompanyIdGuid = Common.NullSafeGuid(utilityCompanyId);
                jsonResult.Data = _db.usp_TariffCode_SELECT_By_UtilityCompanyId(utilityCompanyIdGuid).ToList().OrderBy(x => x.Name);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} jsonResult:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, jsonResult));
                return jsonResult;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new JsonResult();
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PurchaseOfReceivableBusinessLayer purchaseOfReceivableBusinessLayer = new PurchaseOfReceivableBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"{0}_PurchaseOfReceivable_{1}{2}{3}{4}{5}{6}.xlsx", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                purchaseOfReceivableBusinessLayer.SaveFromDatabaseToExcel(messageId, utilityCode, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PurchaseOfReceivable");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", Common.NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                ErrorHandler(exc, method);
                return null;
            }
        }

        public ActionResult DownloadUndefined()
        {
            string method = "DownloadUndefined()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Utilities.Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PurchaseOfReceivableBusinessLayer purchaseOfReceivableBusinessLayer = new PurchaseOfReceivableBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"All_POR_{0}{1}{2}{3}{4}{5}.xlsx", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                purchaseOfReceivableBusinessLayer.SaveUndefinedFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PurchaseOfReceivable");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", Common.NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                ErrorHandler(exc, method);
                return null;
            }
        }

        public ActionResult DownloadAllAndUndefined()
        {
            string method = "DownloadAllAndUndefined()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                string messageId = Utilities.Common.NullSafeString(Session[Common.MESSAGEID]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PurchaseOfReceivableBusinessLayer purchaseOfReceivableBusinessLayer = new PurchaseOfReceivableBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"All_POR_{0}{1}{2}{3}{4}{5}.xlsx", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                purchaseOfReceivableBusinessLayer.SaveUndefinedAndAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PurchaseOfReceivable");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", Common.NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                ExcelLibrary.ExcelWorksheetUtility excelWorksheetUtility = new ExcelLibrary.ExcelWorksheetUtility(_logger, LicensePath);
                PurchaseOfReceivableBusinessLayer purchaseOfReceivableBusinessLayer = new PurchaseOfReceivableBusinessLayer(repository, excelWorksheetUtility, _logger);
                Guid uci = new Guid(Session["PurchaseOfReceivable_UtilityCompanyId_Set"].ToString());
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Saving File", Common.NAMESPACE, CLASS, method));
                // save file
                string fileName = string.Format(@"All_POR_{0}{1}{2}{3}{4}{5}.xlsx", DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
                string filePath = @"Temp";
                string filePathAndName = Server.MapPath(string.Format(@"\{0}\{1}", filePath, fileName));
                purchaseOfReceivableBusinessLayer.SaveAllFromDatabaseToExcel(messageId, string.Format(filePathAndName, Guid.NewGuid().ToString()));
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
                return RedirectToAction("Index", "PurchaseOfReceivable");
            }
            catch (Exception exc)
            {
                _logger.LogError(Utilities.Common.NullSafeString(Session[Common.MESSAGEID]), string.Format("{0}.{1}.{2} ERROR:{3} {4}", Common.NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
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
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_PURCHOFRECVBLE_DOWNLD });
                }

                // declare variables
                UtilityManagementRepository.IDataRepository repository = new UtilityManagementRepository.DataRepositoryEntityFramework();
                string utilityCode = Utilities.Common.NullSafeString(Session["UtilityCode"]);
                Session[Common.ISPOSTBACK] = "false";

                // save file
                string fileName = string.Format(@"{0}_PurchaseOfReceivableImportSummary_{1}{2}{3}{4}{5}{6}.txt", utilityCode, DateTime.Now.Year, DateTime.Now.Month.ToString().PadLeft(2, '0'), DateTime.Now.Day.ToString().PadLeft(2, '0'), DateTime.Now.Hour.ToString().PadLeft(2, '0'), DateTime.Now.Minute.ToString().PadLeft(2, '0'), DateTime.Now.Second.ToString().PadLeft(2, '0'));
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
                return RedirectToAction("Index", "PurchaseOfReceivable");
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

        private IQueryable<PurchaseOfReceivable> GetBaseData(Guid id)
        {
            return _db.PurchaseOfReceivables.Where(x => x.UtilityCompany.Inactive == false && x.UtilityCompanyId == id).Include(r => r.UtilityCompany).Include(r => r.PorDriver).Include(r => r.PorRecourse);
        }

        private Models.PurchaseOfReceivableModel ObtainResponse(Guid id)
        {
            _logger.LogDebug(string.Format("ObtainResponse(id:{0}) BEGIN", id.ToString()));

            List<PurchaseOfReceivable> purchaseOfReceivableList = GetBaseData(id).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            Models.PurchaseOfReceivableModel response = new Models.PurchaseOfReceivableModel();
            response.PurchaseOfReceivableList = new List<Models.PurchaseOfReceivableModelList>();
            foreach (PurchaseOfReceivable item in purchaseOfReceivableList)
            {
                Models.PurchaseOfReceivableModelList purchaseOfReceivableListModel = new Models.PurchaseOfReceivableModelList(item);
                response.PurchaseOfReceivableList.Add(purchaseOfReceivableListModel);
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
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "PorDriver":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorDriverImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.PorDriver.Name).ToList();
                    }
                    else
                    {
                        ViewBag.PorDriverImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.PorDriver.Name).ToList();
                    }
                    break;
                case "RateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.RateClass == null ? "" : x.RateClass.RateClassCode ?? "").ToList();
                    }
                    else
                    {
                        _logger.LogDebug(string.Format("ViewBag==null:{0}", ViewBag.RateClassImageUrl == null));
                        _logger.LogDebug(string.Format("ViewBag.RateClassImageUrl==null:{0}", ViewBag.RateClassImageUrl == null));
                        _logger.LogDebug(string.Format("response==null:{0}", response == null));
                        ViewBag.RateClassImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.RateClass == null ? "" : x.RateClass.RateClassCode ?? "").ToList();
                    }
                    break;
                case "LoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.LoadProfile == null ? "" : x.LoadProfile.LoadProfileCode ?? "").ToList();
                    }
                    else
                    {
                        ViewBag.LoadProfileImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.LoadProfile == null ? "" : x.LoadProfile.LoadProfileCode ?? "").ToList();
                    }
                    break;
                case "TariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.TariffCode == null ? "" : x.TariffCode.TariffCodeCode ?? "").ToList();
                    }
                    else
                    {
                        ViewBag.TariffCodeImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.TariffCode == null ? "" : x.TariffCode.TariffCodeCode ?? "").ToList();
                    }
                    break;
                case "IsPorOffered":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.IsPorOfferedImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.IsPorOffered).ToList();
                    }
                    else
                    {
                        ViewBag.IsPorOfferedImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.IsPorOffered).ToList();
                    }
                    break;
                case "IsPorParticipated":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.IsPorParticipatedImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.IsPorParticipated).ToList();
                    }
                    else
                    {
                        ViewBag.IsPorParticipatedImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.IsPorParticipated).ToList();
                    }
                    break;
                case "PorRecourse":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorRecourseImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.PorRecourse.Name).ToList();
                    }
                    else
                    {
                        ViewBag.PorRecourseImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.PorRecourse.Name).ToList();
                    }
                    break;
                case "IsPorAssurance":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.IsPorAssuranceImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.IsPorAssurance).ToList();
                    }
                    else
                    {
                        ViewBag.IsPorAssuranceImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.IsPorAssurance).ToList();
                    }
                    break;
                case "PorDiscountRate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorDiscountRateImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.DiscountRate).ToList();
                    }
                    else
                    {
                        ViewBag.PorDiscountRateImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.DiscountRate).ToList();
                    }
                    break;
                case "PorFlatFee":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorFlatFeeImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.FlatFee).ToList();
                    }
                    else
                    {
                        ViewBag.PorFlatFeeImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.FlatFee).ToList();
                    }
                    break;
                case "PorDiscountEffectiveDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorDiscountEffectiveDateImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.EffectiveDate).ToList();
                    }
                    else
                    {
                        ViewBag.PorDiscountEffectiveDateImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.EffectiveDate).ToList();
                    }
                    break;
                case "PorDiscountExpirationDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.PorDiscountExpirationDateImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.ExpirationDate).ToList();
                    }
                    else
                    {
                        ViewBag.PorDiscountExpirationDateImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.ExpirationDate).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response.PurchaseOfReceivableList = response.PurchaseOfReceivableList.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            _logger.LogDebug("ObtainResponse END");
            return response;
        }
        #endregion
    }
}
using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class DemographicDataByZipCodeRenewedController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "UtilityCompanyController";
        #endregion

        #region public constructors
        public DemographicDataByZipCodeRenewedController()
            : base()
        {
            ViewBag.PageName = "DemographicDataByZipCodeRenewed";
            ViewBag.IndexPageName = "DemographicDataByZipCodeRenewed";
            ViewBag.PageDisplayName = "Demographic Data By Zip Code Renewed";
        }
        #endregion

        #region public methods
        ////
        //// GET: /UtilityCompany/
        //public override ActionResult Index()
        //{
        //    string method = "Index()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ObtainResponse();

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
        //        return View(response.DemographicDataByZipCodeItem);
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return View(new List<UtilityManagement.Models.DemographicDataByZipCodeItem>());
        //    }
        //}

        public override string ActivityGetIndex { get { return "DemographicDataByZipCodeItem"; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<UtilityManagement.Models.DemographicDataByZipCodeItem>());
        }
        //
        // GET: /UtilityCompany/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                UtilityCompany utilitycompany = _db.UtilityCompanies.Find(id);

                if (utilitycompany == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} utilitycompany:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, utilitycompany));
                return View(utilitycompany);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new UtilityCompany());
            }
        }

        //
        // GET: /UtilityCompany/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                UtilityCompany utilitycompany = new UtilityCompany()
                {
                    EdiCapabale = true,
                    UtilityStatusId = _db.TriStateValuePendingActiveInactives.Where(x=>x.NumericValue == 0).FirstOrDefault().Id,
                    MeterNumberLength = 0,
                    AccountLength = 0,
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.IsoId = GetIsoIdSelectList(null);
                ViewBag.MarketId = GetMarketIdSelectList(null);
                ViewBag.UtilityStatusId = GetUtilityStatusIdSelectList(_db.TriStateValuePendingActiveInactives.Where(x => x.NumericValue == 0).FirstOrDefault().Id);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(utilitycompany.BillingTypeId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} utilitycompany:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, utilitycompany));
                return View(utilitycompany);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new UtilityCompany());
            }
        }

        //
        // POST: /UtilityCompany/Create
        [HttpPost]
        public ActionResult Create(UtilityCompany utilitycompany)
        {
            string method = string.Format("Create(UtilityCompany utilitycompany:{0})", utilitycompany == null ? "NULL VALUE" : utilitycompany.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                int? value = _db.UtilityCompanies.Max(u => u.UtilityIdInt);
                if (value == null)
                    value = 0;
                value++;
                if (_db.UtilityCompanies.Where(x => x.UtilityCode.ToLower().Trim() == utilitycompany.UtilityCode.ToLower().Trim()).Count() == 0)
                {
                    if (ModelState.IsValid)
                    {
                        utilitycompany.Id = Guid.NewGuid();
                        utilitycompany.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                        utilitycompany.CreatedDate = DateTime.Now;
                        utilitycompany.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                        utilitycompany.LastModifiedDate = DateTime.Now;
                        utilitycompany.UtilityIdInt = _db.UtilityCompanies.Max(u => u.UtilityIdInt) + 1;
                        utilitycompany.UtilityCode = utilitycompany.UtilityCode.ToUpper().Trim();
                        utilitycompany.Inactive = utilitycompany.UtilityStatusId == _db.TriStateValuePendingActiveInactives.Where(x => x.NumericValue == 2).FirstOrDefault().Id;
                        if (utilitycompany.IsUtilityCompanyValid())
                        {
                            _db.UtilityCompanies.Add(utilitycompany);
                            _db.SaveChanges();
                            _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                            return RedirectToAction("Index");
                        }
                    }
                }
                else
                {
                    Session["ErrorMessage"] = "Utility Code already exists.";
                }

                utilitycompany.Id = Guid.NewGuid();
                utilitycompany.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                utilitycompany.CreatedDate = DateTime.Now;
                utilitycompany.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                utilitycompany.LastModifiedDate = DateTime.Now;
                ViewBag.IsoId = GetIsoIdSelectList(utilitycompany.IsoId);
                ViewBag.MarketId = GetMarketIdSelectList(utilitycompany.MarketId);
                ViewBag.UtilityStatusId = GetUtilityStatusIdSelectList(utilitycompany.UtilityStatusId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(utilitycompany.BillingTypeId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(utilitycompany);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new UtilityCompany());
            }
        }

        //
        // GET: /UtilityCompany/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                UtilityCompany utilitycompany = _db.UtilityCompanies.Find(id);
                if (utilitycompany == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = utilitycompany.CreatedBy;
                Session[Common.CREATEDDATE] = utilitycompany.CreatedDate;
                Session["UtilityCompanyId"] = utilitycompany.Id;
                Session["UtilityCompanyName"] = utilitycompany.UtilityCode;
                Session["UtilityIdInt"] = utilitycompany.UtilityIdInt;
                ViewBag.IsoId = GetIsoIdSelectList(utilitycompany.IsoId);
                ViewBag.MarketId = GetMarketIdSelectList(utilitycompany.MarketId);
                ViewBag.UtilityStatusId = GetUtilityStatusIdSelectList(utilitycompany.UtilityStatusId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(utilitycompany.BillingTypeId);
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} utilitycompany:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, utilitycompany));
                return View(utilitycompany);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                UtilityCompany requestmodetype = _db.UtilityCompanies.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /UtilityCompany/Edit/5
        [HttpPost]
        public ActionResult Edit(UtilityCompany utilitycompany)
        {
            string method = string.Format("Edit(UtilityCompany utilitycompany:{0})", utilitycompany == null ? "NULL VALUE" : utilitycompany.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    utilitycompany.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    utilitycompany.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    utilitycompany.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    utilitycompany.LastModifiedDate = DateTime.Now;
                    utilitycompany.UtilityIdInt = (int)Session["UtilityIdInt"];
                    utilitycompany.UtilityCode = Common.NullSafeString(Session["UtilityCompanyName"]).ToUpper();
                    utilitycompany.Inactive = utilitycompany.UtilityStatusId == _db.TriStateValuePendingActiveInactives.Where(x => x.NumericValue == 2).FirstOrDefault().Id;
                    if (utilitycompany.IsUtilityCompanyValid())
                    {
                        _db.Entry(utilitycompany).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = utilitycompany.CreatedBy;
                    Session[Common.CREATEDDATE] = utilitycompany.CreatedDate;
                }
                utilitycompany.Id = new Guid(Session["UtilityCompanyId"].ToString());
                utilitycompany.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                utilitycompany.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                utilitycompany.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                utilitycompany.LastModifiedDate = DateTime.Now;
                utilitycompany.UtilityIdInt = (int)Session["UtilityIdInt"];
                utilitycompany.UtilityCode = Common.NullSafeString(Session["UtilityCompanyName"]).ToUpper();
                ViewBag.IsoId = GetIsoIdSelectList(utilitycompany.IsoId);
                ViewBag.MarketId = GetMarketIdSelectList(utilitycompany.MarketId);
                ViewBag.UtilityStatusId = GetUtilityStatusIdSelectList(utilitycompany.UtilityStatusId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(utilitycompany.BillingTypeId);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(utilitycompany);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ViewBag.IsoId = GetIsoIdSelectList(utilitycompany.IsoId);
                ViewBag.MarketId = GetMarketIdSelectList(utilitycompany.MarketId);
                ViewBag.UtilityStatusId = GetUtilityStatusIdSelectList(utilitycompany.UtilityStatusId);
                ViewBag.BillingTypeId = GetBillingTypeIdSelectList(utilitycompany.BillingTypeId);
                return View(utilitycompany);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        public override ActionResult ObtainActionResult()
        {
            UtilityManagement.Models.DemographicDataByZipCodeModel response = new Models.DemographicDataByZipCodeModel();
            List<Models.DemographicDataByZipCodeItem> demographicDataByZipCodeItems = new List<Models.DemographicDataByZipCodeItem>();


            string query = "SELECT z.ZipCode, MAX(A.CreatedDate) CreatedDate, A.NumberOfAccounts, (SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID " +
"INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and " +
"f.radius < = 1) SegmentOne, (SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentOnePercent, (SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B " +
"INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id " +
"where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentOneAccounts, (SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId " +
"INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and " +
"f.radius < = 1 ) SegmentTwo, (SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentTwoPercent," +
"( SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentTwoAccounts," +
"(SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentThree," +
"(SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1) SegmentThreePercent," +
"(SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentThreeAccounts " +
"From [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) A INNER JOIN [Lp_DemographicData].DBO.ZipCode (NOLOCK) Z 	ON A.ZipCodeId = Z.ID INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) AT ON A.ACCOUNTTYPEID = AT.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) ADT ON A.AccountDataTypeId = ADT.ID INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) K ON A.ZipCodeId = K.ZipCodeId AND A.AccountDataTypeId = K.AccountDataTypeId " +
"INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) S ON K.SegmentId = S.Id INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) R ON K.RadiusId = R.Id where timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' AND AT.ACCOUNTTYPENAME = 'RESIDENTIAL' and A.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and r.radius < = 1 group by z.id, z.ZipCode, A.NumberOfAccounts order by A.NumberOfAccounts desc";

            System.Data.DataSet dsSimilarZipCodes = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(query, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsSimilarZipCodes);
                }
            }
            if (dsSimilarZipCodes != null && dsSimilarZipCodes.Tables != null && dsSimilarZipCodes.Tables.Count > 0 && dsSimilarZipCodes.Tables[0] != null && dsSimilarZipCodes.Tables[0].Rows != null && dsSimilarZipCodes.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsSimilarZipCodes.Tables[0].Rows)
                {
                    UtilityManagement.Models.DemographicDataByZipCodeItem demographicDataByZipCodeItem = (new Models.DemographicDataByZipCodeItem()
                    {
                        ZipCode = dataRow["ZipCode"].ToString(),
                        Segment1 = dataRow["SegmentOne"].ToString(),
                        Segment1Percent = dataRow["SegmentOnePercent"].ToString(),
                        Segment1Count = dataRow["SegmentOneAccounts"].ToString(),
                        Segment2 = dataRow["SegmentTwo"].ToString(),
                        Segment2Percent = dataRow["SegmentTwoPercent"].ToString(),
                        Segment2Count = dataRow["SegmentTwoAccounts"].ToString(),
                        Segment3 = dataRow["SegmentThree"].ToString(),
                        Segment3Percent = dataRow["SegmentThreePercent"].ToString(),
                        Segment3Count = dataRow["SegmentThreeAccounts"].ToString(),
                        CustomerCountInZipCode = dataRow["NumberOfAccounts"].ToString(),
                        Date = dataRow["CreatedDate"].ToString()
                    });
                    demographicDataByZipCodeItems.Add(demographicDataByZipCodeItem);
                }
            }
            
            response.DemographicDataByZipCodeItem = demographicDataByZipCodeItems;
            return View(response);
        }


        private UtilityManagement.Models.DemographicDataByZipCodeModel ObtainResponse()
        {
            UtilityManagement.Models.DemographicDataByZipCodeModel response = new Models.DemographicDataByZipCodeModel();
            List<Models.DemographicDataByZipCodeItem> demographicDataByZipCodeItems = new List<Models.DemographicDataByZipCodeItem>();


            string query = "SELECT z.ZipCode, MAX(A.CreatedDate) CreatedDate, A.NumberOfAccounts, (SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID " +
"INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and " +
"f.radius < = 1) SegmentOne, (SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentOnePercent, (SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B " +
"INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id " +
"where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 1 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentOneAccounts, (SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId " +
"INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and " +
"f.radius < = 1 ) SegmentTwo, (SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentTwoPercent," +
"( SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 2 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentTwoAccounts," +
"(SELECT g.SegmentName FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentThree," +
"(SELECT c.HouseholdsPercent FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1) SegmentThreePercent," +
"(SELECT c.HouseholdsPercent * A.NumberOfAccounts / 100 FROM [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) B INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) c ON b.ZipCodeId = c.ZipCodeId AND b.AccountDataTypeId = c.AccountDataTypeId INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) d ON b.ACCOUNTTYPEID = d.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) e ON b.AccountDataTypeId = e.ID " +
"INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) f ON c.RadiusId = f.Id INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) g ON c.SegmentId = g.Id where b.ZipCodeId = z.id and b.timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' and c.rank = 3 AND d.ACCOUNTTYPENAME = 'RESIDENTIAL' and b.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and f.radius < = 1 ) SegmentThreeAccounts " +
"From [Lp_DemographicData].[dbo].AccountsPerZipCodeByTimeSlice (NOLOCK) A INNER JOIN [Lp_DemographicData].DBO.ZipCode (NOLOCK) Z 	ON A.ZipCodeId = Z.ID INNER JOIN [Lp_DemographicData].DBO.ACCOUNTTYPE (NOLOCK) AT ON A.ACCOUNTTYPEID = AT.ID INNER JOIN [Lp_DemographicData].DBO.[ACCOUNTDATATYPE] (NOLOCK) ADT ON A.AccountDataTypeId = ADT.ID INNER JOIN [Lp_DemographicData].dbo.[TapestrySegmentationByYearRadiusZipCodeAccountDataType] (NOLOCK) K ON A.ZipCodeId = K.ZipCodeId AND A.AccountDataTypeId = K.AccountDataTypeId " +
"INNER JOIN [Lp_DemographicData].dbo.Segment (NOLOCK) S ON K.SegmentId = S.Id INNER JOIN [Lp_DemographicData].dbo.Radius (NOLOCK) R ON K.RadiusId = R.Id where timesliceid = 'ABA0E515-B689-445A-B5FC-C6E7DD1B2B9A' AND AT.ACCOUNTTYPENAME = 'RESIDENTIAL' and A.accountdatatypeid = '17DDAFD3-CCE5-4A6A-B614-FC5C724C385F' and r.radius < = 1 group by z.id, z.ZipCode, A.NumberOfAccounts order by A.NumberOfAccounts desc";


            System.Data.DataSet dsSimilarZipCodes = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(query, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsSimilarZipCodes);
                }
            }
            if (dsSimilarZipCodes != null && dsSimilarZipCodes.Tables != null && dsSimilarZipCodes.Tables.Count > 0 && dsSimilarZipCodes.Tables[0] != null && dsSimilarZipCodes.Tables[0].Rows != null && dsSimilarZipCodes.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsSimilarZipCodes.Tables[0].Rows)
                {
                    //decimal populationDensity = 0;
                    //decimal.TryParse(dataRow["2014 Population Density"].ToString(), out populationDensity);
                    //decimal medianAge = 0;
                    //decimal.TryParse(dataRow["2014 Median Age"].ToString(), out medianAge);
                    //decimal medianNetWorth = 0;
                    //decimal.TryParse(dataRow["2014 Median Net Worth"].ToString(), out medianNetWorth);
                    //decimal medianHouseholdIncome = 0;
                    //decimal.TryParse(dataRow["2014 Median Household Income"].ToString(), out medianHouseholdIncome);
                    UtilityManagement.Models.DemographicDataByZipCodeItem demographicDataByZipCodeItem = (new Models.DemographicDataByZipCodeItem()
                    {
                        ZipCode = dataRow["ZipCode"].ToString(),
                        Segment1 = dataRow["SegmentOne"].ToString(),
                        Segment1Percent = dataRow["SegmentOnePercent"].ToString(),
                        Segment1Count = dataRow["SegmentOneAccounts"].ToString(),
                        Segment2 = dataRow["SegmentTwo"].ToString(),
                        Segment2Percent = dataRow["SegmentTwoPercent"].ToString(),
                        Segment2Count = dataRow["SegmentTwoAccounts"].ToString(),
                        Segment3 = dataRow["SegmentThree"].ToString(),
                        Segment3Percent = dataRow["SegmentThreePercent"].ToString(),
                        Segment3Count = dataRow["SegmentThreeAccounts"].ToString(),
                        CustomerCountInZipCode = dataRow["NumberOfAccounts"].ToString(),
                        Date = dataRow["CreatedDate"].ToString()
                    });
                    demographicDataByZipCodeItems.Add(demographicDataByZipCodeItem);
                }
            }
            
            //demographicDataByZipCodeItems.Add(new Models.DemographicDataByZipCodeItem()
            //{
            //    ZipCode = "11226",
            //    Segment1 = "High Rise Renters",
            //    Segment1Percent = "64",
            //    Segment1Count = "2150",
            //    Segment2 = "City Strivers",
            //    Segment2Percent = "26",
            //    Segment2Count = "873",
            //    Segment3 = "Urban Melting Pot",
            //    Segment3Percent = "9",
            //    Segment3Count = "302",
            //    CustomerCountInZipCode = "3360",
            //    Date = "2014-07-20"
            //});

            //demographicDataByZipCodeItems.Add(new Models.DemographicDataByZipCodeItem()
            //{
            //    ZipCode = "11373",
            //    Segment1 = "Urban Melting Pot",
            //    Segment1Percent = "94",
            //    Segment1Count = "2480",
            //    Segment2 = "High Rise Renters",
            //    Segment2Percent = "3",
            //    Segment2Count = "79",
            //    Segment3 = "International Marketplace",
            //    Segment3Percent = "1",
            //    Segment3Count = "26",
            //    CustomerCountInZipCode = "2638",
            //    Date = "2014-07-20"
            //});

            response.DemographicDataByZipCodeItem = demographicDataByZipCodeItems;
            return response;
        }        
        #endregion
    }
}
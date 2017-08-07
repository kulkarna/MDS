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
    public class ZipCodesWithSimilarDemographicDataController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "ZipCodesWithSimilarDemographicDataController";
        #endregion

        #region public constructors
        public ZipCodesWithSimilarDemographicDataController()
            : base()
        {
            ViewBag.PageName = "ZipCodesWithSimilarDemographicData";
            ViewBag.IndexPageName = "ZipCodesWithSimilarDemographicData";
            ViewBag.PageDisplayName = "Zip Codes With Similar Demographic Data";
        }
        #endregion

        #region public methods
        //
        // GET: /UtilityCompany/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response.ZipCodesWithSimilarDemographicDataItems);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<UtilityManagement.Models.ZipCodesWithSimilarDemographicDataItem>());
            }
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

        //private List<usp_UtilityCompany_Index_Select_Result> ObtainResponse()
        private UtilityManagement.Models.ZipCodesWithSimilarDemographicDataModel ObtainResponse()
        {
            UtilityManagement.Models.ZipCodesWithSimilarDemographicDataModel response = new Models.ZipCodesWithSimilarDemographicDataModel();
            List<Models.ZipCodesWithSimilarDemographicDataItem> zipCodesWithSimilarDemographicDataItems = new List<Models.ZipCodesWithSimilarDemographicDataItem>();
            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "CHICOPEE MA",
                ZipCode = "01013",
                MedianAge = "37",
                MedianIncome = "$35,455.00",
                MedianNetWorth = "$14,855.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "HOLYOKE MA",
                ZipCode = "01040",
                MedianAge = "35.1",
                MedianIncome = "$33,489.00",
                MedianNetWorth = "$14,154.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "NORTHAMPTON MA",
                ZipCode = "01060",
                MedianAge = "34.2",
                MedianIncome = "$43,782.00",
                MedianNetWorth = "$18,563.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "SPRINGFIELD MA",
                ZipCode = "01104",
                MedianAge = "35.5",
                MedianIncome = "$33,167.00",
                MedianNetWorth = "$19,094.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "SPRINGFIELD MA",
                ZipCode = "01108",
                MedianAge = "31.2",
                MedianIncome = "$36,254.00",
                MedianNetWorth = "$14,525.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "SPRINGFIELD MA",
                ZipCode = "01109",
                MedianAge = "28",
                MedianIncome = "$32,032.00",
                MedianNetWorth = "$14,398.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "JERSEY CITY NJ",
                ZipCode = "07307",
                MedianAge = "34",
                MedianIncome = "$37,135.00",
                MedianNetWorth = "$13,278.00"
            });

            zipCodesWithSimilarDemographicDataItems.Add(new Models.ZipCodesWithSimilarDemographicDataItem()
            {
                CityState = "JERSEY CITY NJ",
                ZipCode = "07306",
                MedianAge = "34.2",
                MedianIncome = "$40,578.00",
                MedianNetWorth = "$13,764.00"
            });

            response.ZipCodesWithSimilarDemographicDataItems = zipCodesWithSimilarDemographicDataItems;
 



            //if (Session[Common.SORTCOLUMNNAME] == null)
            //    Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            //if (Session[Common.SORTDIRECTION] == null)
            //    Session[Common.SORTDIRECTION] = Common.ASC;

            //switch (Session[Common.SORTCOLUMNNAME].ToString())
            //{
            //    case "UtilityCode":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.UtilityCode).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.UtilityCodeImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.UtilityCode).ToList();
            //        }
            //        break;
            //    case "FullName":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.FullNameImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.FullName).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.FullNameImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.FullName).ToList();
            //        }
            //        break;
            //    case "ParentCompany":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.ParentCompanyImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.ParentCompany).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.ParentCompanyImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.ParentCompany).ToList();
            //        }
            //        break;
            //    case "ISO":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.IsoImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.ISO).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.IsoImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.ISO).ToList();
            //        }
            //        break;
            //    case "Market":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.MarketImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.Market).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.MarketImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.Market).ToList();
            //        }
            //        break;
            //    case "PrimaryDunsNumber":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.PrimaryDunsNumberImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.PrimaryDunsNumber).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.PrimaryDunsNumberImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.PrimaryDunsNumber).ToList();
            //        }
            //        break;
            //    case "LpEntityId":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.LpEntityIdImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.LpEntityId).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.LpEntityIdImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.LpEntityId).ToList();
            //        }
            //        break;
            //    case "UtilityStatus":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.UtilityStatusImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.UtilityStatus).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.UtilityStatusImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.UtilityStatus).ToList();
            //        }
            //        break;
            //    case "EnrollmentLeadDays":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.EnrollmentLeadDaysImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.EnrollmentLeadDays).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.EnrollmentLeadDaysImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.EnrollmentLeadDays).ToList();
            //        }
            //        break;
            //    case "BillingType":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.BillingTypeImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.BillingType).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.BillingTypeImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.BillingType).ToList();
            //        }
            //        break;
            //    case "AccountLength":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.AccountLengthImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.AccountLength).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.AccountLengthImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.AccountLength).ToList();
            //        }
            //        break;
            //    case "AccountNumberPrefix":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.AccountNumberPrefixImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.AccountNumberPrefix).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.AccountNumberPrefixImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.AccountNumberPrefix).ToList();
            //        }
            //        break;
            //    case "PorOption":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.PorOptionImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.PorOption).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.PorOptionImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.PorOption).ToList();
            //        }
            //        break;
            //    case "MeterNumberLength":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.MeterNumberLengthImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.MeterNumberLength).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.MeterNumberLengthImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.MeterNumberLength).ToList();
            //        }
            //        break;
            //    case "MeterNumberRequired":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.MeterNumberRequiredImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.MeterNumberRequired).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.MeterNumberRequiredImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.MeterNumberRequired).ToList();
            //        }
            //        break;
            //    case "EdiCapable":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.EdiCapableImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.EdiCapable).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.EdiCapableImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.EdiCapable).ToList();
            //        }
            //        break;
            //    case "UtilityPhoneNumber":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.UtilityPhoneNumberImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.UtilityPhoneNumber).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.UtilityPhoneNumberImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.UtilityPhoneNumber).ToList();
            //        }
            //        break;
            //    case "Inactive":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.InactiveImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.Inactive).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.InactiveImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.Inactive).ToList();
            //        }
            //        break;
            //    case "CreatedBy":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.CreatedByImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.CreatedBy).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.CreatedByImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.CreatedBy).ToList();
            //        }
            //        break;
            //    case "CreatedDate":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.CreatedDate).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.CreatedDateImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.CreatedDate).ToList();
            //        }
            //        break;
            //    case "LastModifiedBy":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.LastModifiedByImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.LastModifiedBy).ToList();
            //        }
            //        break;
            //    case "LastModifiedDate":
            //        if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
            //        {
            //            ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
            //            response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
            //        }
            //        else
            //        {
            //            ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
            //            response = response.OrderBy(x => x.LastModifiedDate).ToList();
            //        }
            //        break;
            //}
            return response;
        }
        #endregion
    }
}
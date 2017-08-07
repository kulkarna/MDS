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
    public class TopSegmentsController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "UtilityCompanyController";
        #endregion

        #region public constructors
        public TopSegmentsController()
            : base()
        {
            ViewBag.PageName = "TopSegments";
            ViewBag.IndexPageName = "TopSegments";
            ViewBag.PageDisplayName = "Top Segments";
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
                return View(response.TopDemographicSegmentsItem);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<UtilityManagement.Models.TopDemographicSegmentsItem>());
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

        private UtilityManagement.Models.TopDemographicSegmentsModel ObtainResponse()
        {
            UtilityManagement.Models.TopDemographicSegmentsModel response = new Models.TopDemographicSegmentsModel();
            List<Models.TopDemographicSegmentsItem> topDemographicSegmentsItems = new List<Models.TopDemographicSegmentsItem>();
            topDemographicSegmentsItems.Add(new Models.TopDemographicSegmentsItem()
            {
                SegmentName = "Urban Melting Pot",
                SegmentPopulation = "5892",
                PercentOfSegmentPopulation = "4.72",
                IncomeClass = "Lower Middle",
                MedianAge = "37",
                MedianHouseholdIncome ="$44,349",
                MedianNetWorth = "$20,771",
                MedianHomeValue = "",
                PercentFamilyHouseholds = "45",
                PercentFamiliesWithChildren = "70",
                AverageFamilySize = "",
                TypicalResidence = "Rents",
                HomeOwnershipPercent = "",
                HousingBuiltBefore ="1950",
                TopPurchasedItems = "",
                PhoneCallTypes = "Long Distance To Overseas Relatives",
                StoresFrequented = "Macys, Warehouse/club stores (clothes and jewelry)",
                TypicallyWatches = "News Programs, Movies, Professional Sports Teams (Baseball)",
                TypicallyTypicallyReads = "",
                TypicallyListensTo = "Contemporary Hit, All News, Hispanic, Soft Rock",
                TypicallyAttends = "",
                TypicallyDrinks = "",
                AutomobileBrandPreference = "47% do not own",
                EmploymentTypes = "50% Service Industries",
                Notes = "Fashion Conscious, yet Cost Conscious",
                Hobbies = "Visit Beach, Theme Parks, Casinos, Lottery Tickets",
                GeographicClusterings = "70% New York, 16% California"
            });

            topDemographicSegmentsItems.Add(new Models.TopDemographicSegmentsItem()
            {
                SegmentName = "High Rise Renters",
                SegmentPopulation = "4716",
                PercentOfSegmentPopulation = "3.78",
                IncomeClass = "Lower Middle",
                MedianAge = "30",
                MedianHouseholdIncome = "$26,297",
                MedianNetWorth = "$11,373",
                MedianHomeValue = "$299,600",
                PercentFamilyHouseholds = "40",
                PercentFamiliesWithChildren = "",
                AverageFamilySize = "4",
                TypicalResidence = "Rent Mid to High Rise Apt Buildings (41% in 50 plus unit buildings)",
                HomeOwnershipPercent = "",
                HousingBuiltBefore = "",
                TopPurchasedItems = "",
                PhoneCallTypes = "",
                StoresFrequented = "Albertsons, Stop And Shop, Discount Housing and Apparel Stores, Macys, baby and childrens clothes",
                TypicallyWatches = "Cable TV, News, Movies, Pro Basketball",
                TypicallyTypicallyReads = "",
                TypicallyListensTo = "Hispanic, All News, Variety ",
                TypicallyAttends = "",
                TypicallyDrinks = "",
                AutomobileBrandPreference = "75% do not own",
                EmploymentTypes = "Service, Professional, Office",
                Notes = "Do not have internet access.",
                Hobbies = "",
                GeographicClusterings = "Northeast"
            });

            topDemographicSegmentsItems.Add(new Models.TopDemographicSegmentsItem()
            {
                SegmentName = "City Strivers",
                SegmentPopulation = "1847",
                PercentOfSegmentPopulation = "1.48",
                IncomeClass = "Lower Middle",
                MedianAge = "33",
                MedianHouseholdIncome = "$43,548",
                MedianNetWorth = "$18,858",
                MedianHomeValue = "$251,100",
                PercentFamilyHouseholds = "68",
                PercentFamiliesWithChildren = "",
                AverageFamilySize = "",
                TypicalResidence = "Rent Aps in Older Multiunit Buildings",
                HomeOwnershipPercent = "34",
                HousingBuiltBefore = "1960",
                TopPurchasedItems = "",
                PhoneCallTypes = "",
                StoresFrequented = "Wholesale clubs, Pathmark, Stop and Shop, White Castle, Popeyes, Checkers, Dunkin Donuts",
                TypicallyWatches = "BET, Showtime, Cinemax, Movie Channel, Encore, Courtroom Shows, Talk Shows, Comedies, Sci Fi, Boxing, Professional Wrestling",
                TypicallyTypicallyReads = "",
                TypicallyListensTo = "Urban, All-News, Jazz, Variety Radio",
                TypicallyAttends = "Pro Football, Basketball, Movies",
                TypicallyDrinks = "",
                AutomobileBrandPreference = "40% do not own",
                EmploymentTypes = "50% Service and Health, 22% Government",
                Notes = "",
                Hobbies = "Visit Atlantic City, Six Flags, Play Tennis and Basketball",
                GeographicClusterings = "New York and Chicago"
            });

            topDemographicSegmentsItems.Add(new Models.TopDemographicSegmentsItem()
            {
                SegmentName = "International Marketplace",
                SegmentPopulation = "56",
                PercentOfSegmentPopulation = "0.04",
                IncomeClass = "Middle",
                MedianAge = "30",
                MedianHouseholdIncome = "$49,076",
                MedianNetWorth = "$17,878",
                MedianHomeValue = "$261,438",
                PercentFamilyHouseholds = "70",
                PercentFamiliesWithChildren = "44",
                AverageFamilySize = "4",
                TypicalResidence = "Rents Apt in Older, Multifamily building",
                HomeOwnershipPercent = "32",
                HousingBuiltBefore = "1970",
                TopPurchasedItems = "Groceries, Diapers, Children's Clothes",
                PhoneCallTypes = "Long Distance To Overseas Relatives",
                StoresFrequented = "Marshalls, Costco",
                TypicallyWatches = "TV",
                TypicallyTypicallyReads = "",
                TypicallyListensTo = "Hispanic, Urban, Contemporary Radio",
                TypicallyAttends = "",
                TypicallyDrinks = "Domestic or Imported Beer",
                AutomobileBrandPreference = "None",
                EmploymentTypes = "",
                Notes = "",
                Hobbies = "",
                GeographicClusterings = ""
            });

            response.TopDemographicSegmentsItem = topDemographicSegmentsItems;

            return response;
        }
        #endregion
    }
}
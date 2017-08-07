using DataAccessLayerEntityFramework;
using System;
using System.IO;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using Utilities;
using UtilityManagement.Models;
using UtilityManagement.ChartHelpers;
using System.Web.UI.DataVisualization.Charting;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class AccountInfoFieldRequiredController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "AccountInfoFieldRequiredController";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_INDEX = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_INDEX";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_CREATE = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_CREATE";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_EDIT = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_EDIT";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_DETAIL = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_DETAIL";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_UPLD = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_UPLD";
        private const string UTILITYMANAGEMENT_ACCTINFOFLDRQD_DOWNLD = "UTILITYMANAGEMENT_ACCTINFOFLDRQD_DOWNLD";
        #endregion

        #region public constructors
        public AccountInfoFieldRequiredController()
            : base()
        {
            ViewBag.PageName = "AccountInfoFieldRequired";
            ViewBag.IndexPageName = "AccountInfoFieldRequired";
            ViewBag.PageDisplayName = "Account Info Required Fields";
        }
        #endregion


        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_ACCTINFOFLDRQD_INDEX; } }


        #region public methods
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
        // GET: /AccountInfoFieldRequired/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ACCTINFOFLDRQD_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ACCTINFOFLDRQD_INDEX });
                }

                List<AccountInfoFieldRequiredModel> accountInfoFieldRequiredModelList = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoFieldRequiredModelList));
                return View(accountInfoFieldRequiredModelList);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<AccountInfoFieldRequiredModel>());
            }
        }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<AccountInfoFieldRequiredModel>());
        }

        //
        // GET: /AccountInfoFieldRequired/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ACCTINFOFLDRQD_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ACCTINFOFLDRQD_EDIT });
                }

                AccountInfoFieldRequiredModel accountInfoFieldRequiredModel = GetAccountInfoFieldRequiredModel(id);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoFieldRequiredModel:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoFieldRequiredModel));
                return View(accountInfoFieldRequiredModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoFieldRequiredModel());
            }
        }

        //
        // POST: /AccountInfoFieldRequired/Edit/5
        [HttpPost]
        public ActionResult Edit(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel)
        {
            string method = string.Format("Edit(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel:{0})", accountInfoFieldRequiredModel == null ? "NULL VALUE" : accountInfoFieldRequiredModel.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";

                ProcessEditAndCreate(accountInfoFieldRequiredModel);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                accountInfoFieldRequiredModel = GetAccountInfoFieldRequiredModel(accountInfoFieldRequiredModel.UtilityCompanyId);

                return View(accountInfoFieldRequiredModel);
            }
        }

        //
        // GET: /AccountInfoField/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ACCTINFOFLDRQD_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ACCTINFOFLDRQD_DETAIL });
                }

                AccountInfoFieldRequiredModel accountInfoFieldRequiredModel = new AccountInfoFieldRequiredModel();
                var utilityCompany = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault();
                accountInfoFieldRequiredModel.UtilityCompanyId = id;
                accountInfoFieldRequiredModel.UtilityCode = utilityCompany.UtilityCode;
                var accountInfoFieldRequiredList = _db.AccountInfoFieldRequireds.Where(x => x.UtilityCompanyId == id && x.IsRequired).ToList();

                accountInfoFieldRequiredModel = SetAccountInfoFieldRequiredModelTrue(accountInfoFieldRequiredList, accountInfoFieldRequiredModel);
                if (accountInfoFieldRequiredModel == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoFieldRequiredModel:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoFieldRequiredModel));
                return View(accountInfoFieldRequiredModel);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoFieldRequiredModel());
            }
        }

        //
        // GET: /AccountInfoField/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ACCTINFOFLDRQD_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ACCTINFOFLDRQD_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                AccountInfoFieldRequiredModel accountInfoFieldRequired = new AccountInfoFieldRequiredModel();

                ViewBag.UtilityCompanyId = GetUtilityList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoField:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoFieldRequired));
                return View(accountInfoFieldRequired);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoFieldRequiredModel());
            }
        }

        //
        // POST: /AccountInfoField/Create
        [HttpPost]
        public ActionResult Create(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel)
        {
            string method = string.Format("Create(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel:{0})", accountInfoFieldRequiredModel == null ? "NULL VALUE" : accountInfoFieldRequiredModel.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";

                if (accountInfoFieldRequiredModel.UtilityCompanyId == null || accountInfoFieldRequiredModel.UtilityCompanyId == Guid.Empty)
                {
                    Session[Common.ISPOSTBACK] = "false";
                    ViewBag.UtilityCompanyId = GetUtilityList();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NULL Utility Id {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return View(accountInfoFieldRequiredModel);
                }

                ProcessEditAndCreate(accountInfoFieldRequiredModel);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoField());
            }
        }
        #endregion


        #region private and protected methods
        private void ProcessEditAndCreate(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel)
        {
            string method = string.Format("ProcessEditAndCreate(AccountInfoFieldRequiredModel accountInfoFieldRequiredModel:{0})", accountInfoFieldRequiredModel == null ? "NULL VALUE" : accountInfoFieldRequiredModel.ToString());
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string createdBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                DateTime createdDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                string lastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                DateTime lastModifiedDate = DateTime.Now;

                foreach (AccountInfoField accountInfoField in _db.AccountInfoFields.ToList())
                {
                    AccountInfoFieldRequired accountInfoFieldRequired = _db.AccountInfoFieldRequireds.Where(x => x.UtilityCompanyId == accountInfoFieldRequiredModel.UtilityCompanyId && x.AccountInfoFieldId == accountInfoField.Id).FirstOrDefault();
                    bool doesIdNotExist = accountInfoFieldRequired == null || accountInfoFieldRequired.Id == null;
                    if (doesIdNotExist)
                    {
                        accountInfoFieldRequired = new AccountInfoFieldRequired()
                        {
                            AccountInfoFieldId = accountInfoField.Id,
                            CreatedBy = createdBy,
                            CreatedDate = createdDate,
                            Id = Guid.NewGuid(),
                            Inactive = false,
                            LastModifiedBy = lastModifiedBy,
                            LastModifiedDate = lastModifiedDate,
                            UtilityCompanyId = accountInfoFieldRequiredModel.UtilityCompanyId
                        };
                    }
                    else
                    {
                        accountInfoFieldRequired.LastModifiedDate = lastModifiedDate;
                        accountInfoFieldRequired.LastModifiedBy = lastModifiedBy;
                        accountInfoFieldRequired.AccountInfoFieldId = accountInfoField.Id;
                        accountInfoFieldRequired.UtilityCompanyId = accountInfoFieldRequiredModel.UtilityCompanyId;
                    }
                    switch (accountInfoField.NameUserFriendly)
                    {
                        case "Grid":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.Grid;
                            break;
                        case "I-Cap":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.ICap;
                            break;
                        case "Lbmp Zone":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.LbmpZone;
                            break;
                        case "Load Profile":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.LoadProfile;
                            break;
                        case "Meter Owner":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.MeterOwner;
                            break;
                        case "Meter Type":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.MeterType;
                            break;
                        case "Rate Class":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.RateClass;
                            break;
                        case "Tariff Code":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.TariffCode;
                            break;
                        case "T-Cap":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.TCap;
                            break;
                        case "Voltage":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.Voltage;
                            break;
                        case "Zone":
                            accountInfoFieldRequired.IsRequired = accountInfoFieldRequiredModel.Zone;
                            break;
                    }
                    if (doesIdNotExist)
                        _db.AccountInfoFieldRequireds.Add(accountInfoFieldRequired);
                    else
                        _db.Entry(accountInfoFieldRequired).State = EntityState.Modified;
                    _db.SaveChanges();
                }
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                throw;
            }
        }


        private AccountInfoFieldRequiredModel SetAccountInfoFieldRequiredModelTrue(List<AccountInfoFieldRequired> accountInfoFieldRequiredList, AccountInfoFieldRequiredModel accountInfoFieldRequiredModel)
        {
            if (accountInfoFieldRequiredList != null)
            {
                foreach (var accountInfoFieldRequired in accountInfoFieldRequiredList)
                {
                    if (accountInfoFieldRequired != null)
                    {
                        switch (accountInfoFieldRequired.AccountInfoField.NameUserFriendly)
                        {
                            case "Grid":
                                accountInfoFieldRequiredModel.Grid = true;
                                break;
                            case "I-Cap":
                                accountInfoFieldRequiredModel.ICap = true;
                                break;
                            case "Lbmp Zone":
                                accountInfoFieldRequiredModel.LbmpZone = true;
                                break;
                            case "Load Profile":
                                accountInfoFieldRequiredModel.LoadProfile = true;
                                break;
                            case "Meter Owner":
                                accountInfoFieldRequiredModel.MeterOwner = true;
                                break;
                            case "Meter Type":
                                accountInfoFieldRequiredModel.MeterType = true;
                                break;
                            case "Rate Class":
                                accountInfoFieldRequiredModel.RateClass = true;
                                break;
                            case "Tariff Code":
                                accountInfoFieldRequiredModel.TariffCode = true;
                                break;
                            case "T-Cap":
                                accountInfoFieldRequiredModel.TCap = true;
                                break;
                            case "Voltage":
                                accountInfoFieldRequiredModel.Voltage = true;
                                break;
                            case "Zone":
                                accountInfoFieldRequiredModel.Zone = true;
                                break;
                        }
                    }
                }
            }
            return accountInfoFieldRequiredModel;
        }

        private AccountInfoFieldRequiredModel GetAccountInfoFieldRequiredModel(Guid id)
        {
            string method = string.Format("GetAccountInfoFieldRequiredModel(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                AccountInfoFieldRequiredModel accountInfoFieldRequiredModel = new AccountInfoFieldRequiredModel();
                var utilityCompany = _db.UtilityCompanies.Where(x => x.Id == id).FirstOrDefault();
                accountInfoFieldRequiredModel.UtilityCompanyId = id;
                accountInfoFieldRequiredModel.UtilityCode = utilityCompany.UtilityCode;
                var accountInfoFieldRequiredList = _db.AccountInfoFieldRequireds.Where(x => x.UtilityCompanyId == id && x.IsRequired).ToList();

                accountInfoFieldRequiredModel = SetAccountInfoFieldRequiredModelTrue(accountInfoFieldRequiredList, accountInfoFieldRequiredModel);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoFieldRequiredModel:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoFieldRequiredModel));
                return accountInfoFieldRequiredModel;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                throw;
            }
        }

        private List<AccountInfoFieldRequiredModel> ObtainResponse()
        {

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;

            var nameUserFriendlyList = _db.AccountInfoFields.OrderBy(x => x.NameUserFriendly).ToList();
            var utilityCompanyList = GetUtilityCompanyList();

            List<AccountInfoFieldRequiredModel> accountInfoFieldRequiredModelList = new List<AccountInfoFieldRequiredModel>();

            foreach (var utilityCompany in utilityCompanyList)
            {
                AccountInfoFieldRequiredModel accountInfoFieldRequiredModel = new AccountInfoFieldRequiredModel()
                {
                    UtilityCode = utilityCompany.UtilityCode,
                    UtilityCompanyId = utilityCompany.Id
                };
                var baseData = _db.AccountInfoFieldRequireds.Where(x => x.UtilityCompanyId == utilityCompany.Id && x.IsRequired && x.Inactive == false);

                foreach (var name in nameUserFriendlyList)
                {
                    bool value = baseData.Where(x => x.AccountInfoField.NameMachineUnfriendly == name.NameMachineUnfriendly).Count() > 0;
                    switch (name.NameUserFriendly)
                    {
                        case "Grid":
                            accountInfoFieldRequiredModel.Grid = value;
                            break;
                        case "I-Cap":
                            accountInfoFieldRequiredModel.ICap = value;
                            break;
                        case "Lbmp Zone":
                            accountInfoFieldRequiredModel.LbmpZone = value;
                            break;
                        case "Load Profile":
                            accountInfoFieldRequiredModel.LoadProfile = value;
                            break;
                        case "Meter Owner":
                            accountInfoFieldRequiredModel.MeterOwner = value;
                            break;
                        case "Meter Type":
                            accountInfoFieldRequiredModel.MeterType = value;
                            break;
                        case "Rate Class":
                            accountInfoFieldRequiredModel.RateClass = value;
                            break;
                        case "Tariff Code":
                            accountInfoFieldRequiredModel.TariffCode = value;
                            break;
                        case "T-Cap":
                            accountInfoFieldRequiredModel.TCap = value;
                            break;
                        case "Voltage":
                            accountInfoFieldRequiredModel.Voltage = value;
                            break;
                        case "Zone":
                            accountInfoFieldRequiredModel.Zone = value;
                            break;
                    }
                }
                accountInfoFieldRequiredModelList.Add(accountInfoFieldRequiredModel);
            }

            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.UtilityCode).ToList();
                        break;
                    }
                    ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "Grid":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.GridImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.Grid).ToList();
                        break;
                    }
                    ViewBag.GridImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.Grid).ToList();
                    break;
                case "ICap":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ICapImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.ICap).ToList();
                        break;
                    }
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.ICap).ToList();
                    ViewBag.ICapImageUrl = Common.UPARROW;
                    break;
                case "LbmpZone":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LbmpZoneImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.LbmpZone).ToList();
                        break;
                    }
                    ViewBag.LbmpZoneImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.LbmpZone).ToList();
                    break;
                case "LoadProfile":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LoadProfileImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.LoadProfile).ToList();
                        break;
                    }
                    ViewBag.LoadProfileImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.LoadProfile).ToList();
                    break;
                case "MeterOwner":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterOwnerImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.MeterOwner).ToList();
                        break;
                    }
                    ViewBag.MeterOwnerImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.MeterOwner).ToList();
                    break;
                case "MeterType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterTypeImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.MeterType).ToList();
                        break;
                    }
                    ViewBag.MeterTypeImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.MeterType).ToList();
                    break;
                case "RateClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.RateClassImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.RateClass).ToList();
                        break;
                    }
                    ViewBag.RateClassImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.RateClass).ToList();
                    break;
                case "TariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TariffCodeImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.TariffCode).ToList();
                        break;
                    }
                    ViewBag.TariffCodeImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.TariffCode).ToList();
                    break;
                case "TCap":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.TCapImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.TCap).ToList();
                        break;
                    }
                    ViewBag.TCapImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.TCap).ToList();
                    break;
                case "Voltage":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.VoltageImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.Voltage).ToList();
                        break;
                    }
                    ViewBag.VoltageImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.Voltage).ToList();
                    break;
                case "Zone":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ZoneImageUrl = Common.DOWNARROW;
                        accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderByDescending(x => x.Zone).ToList();
                        break;
                    }
                    ViewBag.ZoneImageUrl = Common.UPARROW;
                    accountInfoFieldRequiredModelList = accountInfoFieldRequiredModelList.OrderBy(x => x.Zone).ToList();
                    break;
            }

            return accountInfoFieldRequiredModelList;
        }

        private SelectList GetUtilityList()
        {
            string method = "GetUtilityList()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                List<UtilityCompany> utilityList = new List<UtilityCompany>();
                var utilityCompanyList = _db.usp_UtilityCompany_NotInAccountInfoFieldRequired().ToList();
                foreach (var utilCo in utilityCompanyList)
                {
                    UtilityCompany uc = new UtilityCompany()
                    {
                        Id = utilCo.Id,
                        UtilityCode = utilCo.UtilityCode
                    };
                    utilityList.Add(uc);
                }
                SelectList utilityCompanySelectList = new SelectList(utilityList, "Id", "UtilityCode");
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} utilityCompanySelectList:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, utilityCompanySelectList));
                return utilityCompanySelectList;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return new SelectList(new List<UtilityCompany>(), "Id", "UtilityCode");
            }
        }

        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
        #endregion
    }
}
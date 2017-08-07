using DataAccessLayerEntityFramework;
using System;
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
using System.Runtime.Caching;

namespace UtilityManagement.Controllers
{

    public class ControllerBase : Controller
    {
        private const string CLASS = "ControllerBase";
        protected Lp_UtilityManagementEntities _db;
        protected ILogger _logger;
        public string LicensePath { get; set; }
        private const string CHACHE_EXPIRATION_SECONDS = "CHACHE_EXPIRATION_SECONDS";
        private AuthorizationServiceClient _authorizationClient;

        public ControllerBase()
        {
            try
            {
                _db = new Lp_UtilityManagementEntities();
                _logger = UnityLoggerGenerator.GenerateLogger();
                _logger.LogInfo("Before");
                LicensePath = System.Web.HttpContext.Current.Server.MapPath("~/Licenses/Aspose.Cells.lic");
                _authorizationClient = new AuthorizationServiceClient();
                _logger.LogDebug(LicensePath);
                _logger.LogInfo("Leaving");
            }
            catch (Exception)
            {
                string s = string.Empty;
            }
        }

        public virtual ActionResult InactiveTitleClick()
        {
            string method = "InactiveTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Inactive");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult AccountTypeTitleClick()
        {
            string method = "AccountTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        public virtual ActionResult CapacityTresholdMaxTitleClick()
        {
            string method = "CapacityTresholdMinTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CapacityTresholdMax");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult CapacityTresholdMinTitleClick()
        {
            string method = "CapacityTresholdMinTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CapacityTresholdMin");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        public virtual ActionResult LastModifiedByTitleClick()
        {
            string method = "LastModifiedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedBy");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult LastModifiedDateTitleClick()
        {
            string method = "LastModifiedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedDate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult CreatedDateTitleClick()
        {
            string method = "CreatedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedDate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult CreatedByTitleClick()
        {
            string method = "CreatedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedBy");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public virtual ActionResult GetBlankResponse()
        {
            return View(new List<string>());
        }

        public virtual ActionResult ObtainActionResult()
        {
            return View(new List<string>());
        }


        #region AccountType
        protected SelectList GetAccountTypeSelectList(Guid accountTypeId)
        {
            List<AccountType> accountTypeList = GetAccountTypeList();
            SelectList accountType = new SelectList(accountTypeList, "Id", "Name", accountTypeId);
            return accountType;
        }

        protected SelectList GetAccountTypeSelectList()
        {
            List<AccountType> accountTypeList = GetAccountTypeList();
            SelectList accountType = new SelectList(accountTypeList, "Id", "Name");
            return accountType;
        }

        private List<AccountType> GetAccountTypeList()
        {
            List<AccountType> accountTypeList = new List<AccountType>();
            accountTypeList.AddRange(_db.AccountTypes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return accountTypeList;
        }
        #endregion

        #region Por Recourse
        protected SelectList GetPorRecourseSelectList(Guid porRecourseId)
        {
            List<PorRecourse> porRecourseList = GetPorRecourseList();
            SelectList porRecourse = new SelectList(porRecourseList, "Id", "Name", porRecourseId);
            return porRecourse;
        }

        protected SelectList GetPorRecourseSelectList()
        {
            List<PorRecourse> PorRecourseList = GetPorRecourseList();
            SelectList PorRecourse = new SelectList(PorRecourseList, "Id", "Name");
            return PorRecourse;
        }

        private List<PorRecourse> GetPorRecourseList()
        {
            List<PorRecourse> PorRecourseList = new List<PorRecourse>();
            PorRecourseList.AddRange(_db.PorRecourses.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return PorRecourseList;
        }
        #endregion

        #region ISO
        protected SelectList GetIsoIdSelectList(Guid? isoId)
        {
            List<ISO> isoList = GetIsoList();
            SelectList iso = new SelectList(isoList, "Id", "Name", isoId);
            return iso;
        }

        protected List<ISO> GetIsoList()
        {
            List<ISO> isoList = new List<ISO>();
            isoList.AddRange(_db.ISOes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return isoList;
        }
        #endregion




        #region Market
        protected SelectList GetMarketIdSelectList(Guid? marketId)
        {
            List<Market> marketList = GetMarketList();
            SelectList market = new SelectList(marketList, "Id", "Market1", marketId);
            return market;
        }

        protected List<Market> GetMarketList()
        {
            List<Market> marketList = new List<Market>();
            marketList.AddRange(_db.Markets.Where(x => x.Inactive == false).OrderBy(x => x.Market1));
            return marketList;
        }
        #endregion


        protected SelectList GetBillingTypeIdSelectList(Guid? billingTypeId)
        {
            List<BillingType> billingTypeList = GetBillingTypeList();
            SelectList billingType = new SelectList(billingTypeList, "Id", "ShortName", billingTypeId);
            return billingType;
        }

        protected SelectList GetBillingTypeIdNameSelectList(Guid? billingTypeId)
        {
            List<BillingType> billingTypeList = new List<BillingType>();
            billingTypeList.AddRange(GetBillingTypeList());
            Guid parsedBillingTypeId = Guid.Empty;
            if (billingTypeId != null)
            {
                parsedBillingTypeId = (Guid)billingTypeId;
            }
            SelectList billingType = new SelectList(billingTypeList, "Id", "Name", parsedBillingTypeId.ToString());
            return billingType;
        }

        protected List<BillingType> GetBillingTypeList()
        {
            List<BillingType> billingTypeList = new List<BillingType>();
            billingTypeList.AddRange(_db.BillingTypes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return billingTypeList;
        }





        #region UtilityStatusId
        protected SelectList GetUtilityStatusIdSelectList(Guid? utilityStatusId)
        {
            List<TriStateValuePendingActiveInactive> utilityStatusIdList = GetUtilityStatusIdList();
            SelectList utilityStatus = new SelectList(utilityStatusIdList, "Id", "Value", utilityStatusId);
            return utilityStatus;
        }

        protected List<TriStateValuePendingActiveInactive> GetUtilityStatusIdList()
        {
            List<TriStateValuePendingActiveInactive> utilityStatusIdList = new List<TriStateValuePendingActiveInactive>();
            utilityStatusIdList.AddRange(_db.TriStateValuePendingActiveInactives.Where(x => x.Inactive == false).OrderBy(x => x.Value));
            return utilityStatusIdList;
        }
        #endregion

        #region Utility Company
        protected SelectList GetUtilityCompanyIdSelectList(string utilityCompanyId)
        {
            List<UtilityCompany> utilityList = GetUtilityCompanyList();
            SelectList utilityCompany = new SelectList(utilityList, "Id", "UtilityCode", utilityCompanyId);
            return utilityCompany;
        }

        protected SelectList GetUtilityCompanyIdSelectListWithSpace()
        {
            _logger.LogDebug("GetUtilityCompanyIdSelectListWithSpace() BEGIN");
            List<UtilityCompany> utilityList = GetUtilityCompanyListWithSpace();
            _logger.LogDebug("SelectList utilityCompany = new SelectList(utilityList, 'Id', 'UtilityCode');");
            SelectList utilityCompany = new SelectList(utilityList, "Id", "UtilityCode");
            _logger.LogDebug("GetUtilityCompanyIdSelectListWithSpace() END");
            return utilityCompany;
        }

        protected SelectList GetUtilityCompanyIdSelectList()
        {
            List<UtilityCompany> utilityList = GetUtilityCompanyList();
            SelectList utilityCompany = new SelectList(utilityList, "Id", "UtilityCode");
            return utilityCompany;
        }

        protected virtual List<UtilityCompany> GetUtilityCompanyList()
        {
            List<UtilityCompany> utilityList = new List<UtilityCompany>();
            utilityList.AddRange(_db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode));
            return utilityList;
        }

        private List<UtilityCompany> GetUtilityCompanyListWithSpace()
        {
            _logger.LogDebug("GetUtilityCompanyListWithSpace() BEGIN");
            List<UtilityCompany> utilityList = new List<UtilityCompany>();
            _logger.LogDebug("GetUtilityCompanyListWithSpace() utilityList.Add(new UtilityCompany() { Id = Guid.Empty, UtilityCode = ' ' });");
            utilityList.Add(new UtilityCompany() { Id = Guid.Empty, UtilityCode = " " });
            _logger.LogDebug("GetUtilityCompanyListWithSpace() var item = _db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode);");
            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.UtilityCompanies.Where(x => x.Inactive == false).OrderBy(x => x.UtilityCode);
            _logger.LogDebug("GetUtilityCompanyListWithSpace() if (item != null)");
            if (item != null)
            {
                _logger.LogDebug("GetUtilityCompanyListWithSpace() utilityList.AddRange(item);");
                utilityList.AddRange(item);
            }
            _logger.LogDebug("GetUtilityCompanyListWithSpace() END");
            return utilityList;
        }
        #endregion

        public SelectList GetAccountIdSelectList()
        {
            _logger.LogDebug("GetAccountIdSelectList() BEGIN");

            List<CustomerAccountType> accountTypeList = new List<CustomerAccountType>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.CustomerAccountTypes.Where(x => x.Inactive == false).OrderBy(x => x.AccountType);
            _logger.LogDebug("GetAccountIdSelectList() if (item != null)");
            if (item != null)
            {
                accountTypeList.AddRange(item);
            }

            SelectList accountDetailList = new SelectList(accountTypeList, "Id", "AccountType");
            _logger.LogDebug("GetAccountIdSelectList() END");
            return accountDetailList;
        }

        public SelectList GetAccountIdSelectList(int AccountTypeId)
        {
            _logger.LogDebug("GetAccountIdSelectList() BEGIN");

            List<CustomerAccountType> accountTypeList = new List<CustomerAccountType>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.CustomerAccountTypes.Where(x => x.Inactive == false).OrderBy(x => x.AccountType);
            _logger.LogDebug("GetAccountIdSelectList() if (item != null)");
            if (item != null)
            {
                accountTypeList.AddRange(item);
            }

            SelectList accountDetailList = new SelectList(accountTypeList, "Id", "AccountType", AccountTypeId);
            _logger.LogDebug("GetAccountIdSelectList() END");
            return accountDetailList;
        }

        public SelectList GetYearIdSelectList()
        {
            _logger.LogDebug("GetYearIdSelectList() BEGIN");

            List<Year> yearList = new List<Year>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.Years.Where(x => x.Inactive == false).OrderBy(x => x.Year1);
            _logger.LogDebug("GetYearIdSelectList() if (item != null)");
            if (item != null)
            {
                yearList.AddRange(item);
            }

            SelectList year = new SelectList(yearList, "Id", "Year1");
            _logger.LogDebug("GetYearIdSelectList() END");
            return year;
        }


        public SelectList GetYearIdSelectList(Guid yearId)
        {
            _logger.LogDebug("GetYearIdSelectList() BEGIN");

            List<Year> yearList = new List<Year>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.Years.Where(x => x.Inactive == false).OrderBy(x => x.Year1);
            _logger.LogDebug("GetYearIdSelectList() if (item != null)");
            if (item != null)
            {
                yearList.AddRange(item);
            }

            SelectList year = new SelectList(yearList, "Id", "Year1", yearId);
            _logger.LogDebug("GetYearIdSelectList() END");
            return year;
        }

        public SelectList GetMonthIdSelectList()
        {
            _logger.LogDebug("GetMonthIdSelectList() BEGIN");

            List<Month> monthList = new List<Month>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.Months.Where(x => x.Inactive == false).OrderBy(x => x.Month1);
            _logger.LogDebug("GetMonthIdSelectList() if (item != null)");
            if (item != null)
            {
                monthList.AddRange(item);
            }

            SelectList month = new SelectList(monthList, "Id", "Month1");
            _logger.LogDebug("GetMonthIdSelectList() END");
            return month;
        }

        public SelectList GetMonthIdSelectList(Guid monthId)
        {
            _logger.LogDebug("GetMonthIdSelectList() BEGIN");

            List<Month> monthList = new List<Month>();

            _logger.LogDebug(string.Format("_db == null:{0}", _db == null));
            var item = _db.Months.Where(x => x.Inactive == false).OrderBy(x => x.Month1);
            _logger.LogDebug("GetMonthIdSelectList() if (item != null)");
            if (item != null)
            {
                monthList.AddRange(item);
            }

            SelectList month = new SelectList(monthList, "Id", "Month1", monthId);
            _logger.LogDebug("GetMonthIdSelectList() END");
            return month;
        }

        #region Rate Class
        protected SelectList GetRateClassSelectListRemoveTopTwoSpaces(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.RateClassCode).ToList<RateClass>();
            RateClassSelectList rateClassSelectList = new RateClassSelectList(rateClassList);
            SelectList rateClass = new SelectList(rateClassSelectList, "Id", "Name");
            return rateClass;
        }

        protected SelectList GetRateClassSelectList(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = GetRateClassList(utilityCompanyId);
            RateClassSelectList rateClassSelectList = new RateClassSelectList(rateClassList);
            SelectList rateClass = new SelectList(rateClassSelectList, "Id", "Name");
            return rateClass;
        }

        protected SelectList GetRateClassSelectListById(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = GetRateClassListById(utilityCompanyId);
            SelectList rateClass = new SelectList(rateClassList, "Id", "RateClassId");
            return rateClass;
        }

        protected SelectList GetRateClassSelectList(Guid utilityCompanyId, int rateClassId)
        {
            List<RateClass> rateClassList = GetRateClassList(utilityCompanyId);
            SelectList rateClass = new SelectList(rateClassList, "Id", "RateClassCode", rateClassId);
            return rateClass;
        }

        public SelectList GetRateClassSelectList(Guid utilityCompanyId, Guid? rateClassId)
        {
            List<RateClass> rateClassList = new List<RateClass>();
            rateClassList.Add(new RateClass() { Id = Guid.Empty, RateClassCode = " " });
            rateClassList.AddRange(GetRateClassList(utilityCompanyId));
            SelectList rateClass = new SelectList(rateClassList, "Id", "RateClassCode", rateClassId);
            return rateClass;
        }

        protected SelectList GetRateClassSelectList(Guid? rateClassId)
        {
            List<RateClass> rateClassList = GetRateClassList();
            SelectList rateClass = new SelectList(rateClassList, "Id", "RateClassCode", rateClassId);
            return rateClass;
        }

        protected SelectList GetRateClassSelectList()
        {
            List<RateClass> rateClassList = GetRateClassList();
            SelectList rateClass = new SelectList(rateClassList, "Id", "RateClassCode");
            return rateClass;
        }

        private List<RateClass> GetRateClassList(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = new List<RateClass>();
            rateClassList.Add(new RateClass() { Id = Guid.Empty, RateClassCode = " " });
            rateClassList.AddRange(_db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.RateClassCode));
            return rateClassList;
        }

        private List<RateClass> GetRateClassListById(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = new List<RateClass>();
            rateClassList.AddRange(_db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.RateClassId));
            return rateClassList;
        }

        private List<RateClass> GetRateClassList()
        {
            List<RateClass> rateClassList = new List<RateClass>();
            rateClassList.AddRange(_db.RateClasses.Where(x => x.Inactive == false).OrderBy(x => x.RateClassCode));
            return rateClassList;
        }
        #endregion


        #region Account Type
        protected SelectList GetAccountTypeIdSelectList(Guid accountTypeId)
        {
            List<BusinessAccountType> accountTypeIdList = GetAccountTypeIdList();
            SelectList accountType = new SelectList(accountTypeIdList, "Id", "Description", accountTypeId);
            return accountType;
        }

        protected SelectList GetAccountTypeIdSelectList()
        {
            List<BusinessAccountType> accountTypeIdList = GetAccountTypeIdList();
            SelectList accountType = new SelectList(accountTypeIdList, "Id", "Description");
            return accountType;
        }

        private List<BusinessAccountType> GetAccountTypeIdList()
        {
            List<BusinessAccountType> accountTypeList = new List<BusinessAccountType>();
            accountTypeList.AddRange(_db.BusinessAccountTypes.Where(x => x.Inactive == false).OrderBy(x => x.Description));
            return accountTypeList;
        }
        #endregion



        #region Billing Types
        protected SelectList GetBillingTypeIdSelectList(Guid billingTypeId)
        {
            List<BillingType> billingTypeIdList = GetBillingTypeIdList();
            SelectList billingType = new SelectList(billingTypeIdList, "Id", "Name", billingTypeId);
            return billingType;
        }

        protected SelectList GetBillingTypeIdSelectList()
        {
            List<BillingType> billingTypeIdList = GetBillingTypeIdList();
            SelectList billingType = new SelectList(billingTypeIdList, "Id", "Name");
            return billingType;
        }

        private List<BillingType> GetBillingTypeIdList()
        {
            List<BillingType> billingTypeList = new List<BillingType>();
            billingTypeList.AddRange(_db.BillingTypes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return billingTypeList;
        }
        #endregion


        #region Load Profile
        protected SelectList GetLoadProfileSelectListRemoveTopTwoSpaces(Guid utilityCompanyId)
        {
            List<LoadProfile> loadProfileList = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LoadProfileCode).ToList<LoadProfile>();
            LoadProfileSelectList loadProfileSelectList = new LoadProfileSelectList(loadProfileList);
            SelectList loadProfile = new SelectList(loadProfileSelectList, "Id", "Name");
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectList(Guid utilityCompanyId)
        {
            List<LoadProfile> loadProfileList = GetLoadProfileList(utilityCompanyId);
            LoadProfileSelectList loadProfileSelectList = new LoadProfileSelectList(loadProfileList);
            SelectList loadProfile = new SelectList(loadProfileSelectList, "Id", "Name");
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectListById(Guid utilityCompanyId)
        {
            List<LoadProfile> loadProfileList = GetLoadProfileListById(utilityCompanyId);
            SelectList loadProfile = new SelectList(loadProfileList, "Id", "LoadProfileId");
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectList(Guid utilityCompanyId, int loadProfileId)
        {
            List<LoadProfile> loadProfileList = GetLoadProfileList(utilityCompanyId);
            SelectList loadProfile = new SelectList(loadProfileList, "Id", "LoadProfileCode", loadProfileId);
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectList(Guid utilityCompanyId, Guid? loadProfileId)
        {
            List<LoadProfile> loadProfileList = new List<LoadProfile>();
            loadProfileList.Add(new LoadProfile() { Id = Guid.Empty, LoadProfileCode = " " });
            loadProfileList.AddRange(GetLoadProfileList(utilityCompanyId));
            SelectList loadProfile = new SelectList(loadProfileList, "Id", "LoadProfileCode", loadProfileId);
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectList(Guid? loadProfileId)
        {
            List<LoadProfile> loadProfileList = GetLoadProfileList();
            SelectList loadProfile = new SelectList(loadProfileList, "Id", "LoadProfileCode", loadProfileId);
            return loadProfile;
        }

        protected SelectList GetLoadProfileSelectList()
        {
            List<LoadProfile> loadProfileList = GetLoadProfileList();
            SelectList loadProfile = new SelectList(loadProfileList, "Id", "LoadProfileCode");
            return loadProfile;
        }

        private List<LoadProfile> GetLoadProfileList(Guid utilityCompanyId)
        {
            _logger.LogDebug(string.Format("GetLoadProfileList(Guid utilityCompanyId:{0}) BEGIN", utilityCompanyId.ToString()));
            List<LoadProfile> loadProfileList = new List<LoadProfile>();
            loadProfileList.Add(new LoadProfile() { Id = Guid.Empty, LoadProfileCode = " " });
            var list = _db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false && x.LoadProfileCode != null && x.LoadProfileCode.Trim() != string.Empty).OrderBy(x => x.LoadProfileCode);
            _logger.LogDebug(string.Format("list:{0}", list.Count()));
            loadProfileList.AddRange(_db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LoadProfileCode));
            _logger.LogDebug(string.Format("GetLoadProfileList(Guid utilityCompanyId:{0}) loadProfileList:{1} END", utilityCompanyId.ToString(), loadProfileList.Count));
            return loadProfileList;
        }

        private List<LoadProfile> GetLoadProfileListById(Guid utilityCompanyId)
        {
            List<LoadProfile> loadProfileList = new List<LoadProfile>();
            loadProfileList.AddRange(_db.LoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LoadProfileId));
            return loadProfileList;
        }

        private List<LoadProfile> GetLoadProfileList()
        {
            List<LoadProfile> loadProfileList = new List<LoadProfile>();
            loadProfileList.AddRange(_db.LoadProfiles.Where(x => x.Inactive == false).OrderBy(x => x.LoadProfileCode));
            return loadProfileList;
        }
        #endregion


        #region Tariff Code
        protected SelectList GetTariffCodeSelectListRemoveTopTwoSpaces(Guid utilityCompanyId)
        {
            List<RateClass> rateClassList = _db.RateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.RateClassCode).ToList<RateClass>();
            List<TariffCode> tariffCodeList = GetTariffCodeList(utilityCompanyId);
            if (tariffCodeList != null && tariffCodeList.Count > 2)
            {
                tariffCodeList.RemoveRange(0, 3);
            }
            TariffCodeSelectList tariffCodeSelectList = new TariffCodeSelectList(tariffCodeList);
            SelectList tariffCode = new SelectList(tariffCodeSelectList, "Id", "Name");
            return tariffCode;
        }

        protected SelectList GetTariffCodeSelectListWithSpace(Guid utilityCompanyId)
        {
            List<TariffCode> tariffCodeList = GetTariffCodeList(utilityCompanyId);
            TariffCodeSelectList tariffCodeSelectList = new TariffCodeSelectList(tariffCodeList);
            SelectList tariffCode = new SelectList(tariffCodeSelectList, "Id", "Name");
            return tariffCode;
        }

        protected SelectList GetTariffCodeSelectList(Guid utilityCompanyId)
        {
            List<TariffCode> TariffCodeList = GetTariffCodeList(utilityCompanyId);
            SelectList TariffCode = new SelectList(TariffCodeList, "Id", "Name");
            return TariffCode;
        }

        protected SelectList GetTariffCodeSelectListById(Guid utilityCompanyId)
        {
            List<TariffCode> TariffCodeList = GetTariffCodeListById(utilityCompanyId);
            SelectList TariffCode = new SelectList(TariffCodeList, "Id", "TariffCodeId");
            return TariffCode;
        }

        protected SelectList GetTariffCodeSelectList(Guid utilityCompanyId, int TariffCodeId)
        {
            List<TariffCode> TariffCodeList = GetTariffCodeList(utilityCompanyId);
            SelectList TariffCode = new SelectList(TariffCodeList, "Id", "TariffCodeCode", TariffCodeId);
            return TariffCode;
        }

        protected SelectList GetTariffCodeSelectList(Guid? TariffCodeId)
        {
            List<TariffCode> TariffCodeList = GetTariffCodeList();
            SelectList TariffCode = new SelectList(TariffCodeList, "Id", "TariffCodeCode", TariffCodeId);
            return TariffCode;
        }

        protected SelectList GetTariffCodeSelectList()
        {
            List<TariffCode> TariffCodeList = GetTariffCodeList();
            SelectList TariffCode = new SelectList(TariffCodeList, "Id", "TariffCodeCode");
            return TariffCode;
        }

        private List<TariffCode> GetTariffCodeListById(Guid utilityCompanyId)
        {
            List<TariffCode> TariffCodeList = new List<TariffCode>();
            TariffCodeList.AddRange(_db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.TariffCodeId));
            return TariffCodeList;
        }

        private List<TariffCode> GetTariffCodeList(Guid utilityCompanyId)
        {
            List<TariffCode> tariffCodeList = new List<TariffCode>();
            tariffCodeList.Add(new TariffCode() { Id = Guid.Empty, TariffCodeCode = " " });
            tariffCodeList.AddRange(_db.TariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.TariffCodeCode));
            return tariffCodeList;
        }

        private List<TariffCode> GetTariffCodeList()
        {
            List<TariffCode> TariffCodeList = new List<TariffCode>();
            TariffCodeList.AddRange(_db.TariffCodes.Where(x => x.Inactive == false).OrderBy(x => x.TariffCodeCode));
            return TariffCodeList;
        }

        protected SelectList GetTariffCodeSelectList(Guid utilityCompanyId, Guid? tariffCodeId)
        {
            List<TariffCode> tariffCodeList = new List<TariffCode>();
            tariffCodeList.Add(new TariffCode() { Id = Guid.Empty, TariffCodeCode = " " });
            tariffCodeList.AddRange(GetTariffCodeList(utilityCompanyId));
            SelectList tariffCode = new SelectList(tariffCodeList, "Id", "TariffCodeCode", tariffCodeId);
            return tariffCode;
        }

        #endregion

        #region Request Mode Type
        protected SelectList GetRequestModeTypeSelectList(Guid? requestModeTypeId)
        {
            List<RequestModeType> requestModeTypeList = GetRequestModeTypeList();
            SelectList requestModeType = new SelectList(requestModeTypeList, "Id", "Name", requestModeTypeId);
            return requestModeType;
        }

        protected SelectList GetRequestModeTypeSelectList()
        {
            List<RequestModeType> requestModeTypeList = GetRequestModeTypeList();
            SelectList requestModeType = new SelectList(requestModeTypeList, "Id", "Name");
            return requestModeType;
        }

        private List<RequestModeType> GetRequestModeTypeList()
        {
            List<RequestModeType> requestModeTypeList = new List<RequestModeType>();
            requestModeTypeList.AddRange(_db.RequestModeTypes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return requestModeTypeList;
        }
        #endregion

        #region Request Mode Enrollment Type
        protected SelectList GetRequestModeEnrollmentTypeSelectList(Guid? requestModeEnrollmentTypeId)
        {
            List<RequestModeEnrollmentType> requestModeEnrollmentTypeList = GetRequestModeEnrollmentTypeList();
            SelectList requestModeEnrollmentType = new SelectList(requestModeEnrollmentTypeList, "Id", "Name", requestModeEnrollmentTypeId);
            return requestModeEnrollmentType;
        }

        protected SelectList GetRequestModeEnrollmentTypeSelectList()
        {
            List<RequestModeEnrollmentType> requestModeEnrollmentTypeList = GetRequestModeEnrollmentTypeList();
            SelectList requestModeEnrollmentType = new SelectList(requestModeEnrollmentTypeList, "Id", "Name");
            return requestModeEnrollmentType;
        }

        private List<RequestModeEnrollmentType> GetRequestModeEnrollmentTypeList()
        {
            List<RequestModeEnrollmentType> requestModeEnrollmentTypeList = new List<RequestModeEnrollmentType>();
            requestModeEnrollmentTypeList.AddRange(_db.RequestModeEnrollmentTypes.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return requestModeEnrollmentTypeList;
        }
        #endregion


        #region Lp Standard Tariff Code Id
        protected SelectList GetLpStandardTariffCodesSelectList(Guid utilityCompanyId)
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = GetLpStandardTariffCodesList(utilityCompanyId);
            SelectList LpStandardTariffCodes = new SelectList(LpStandardTariffCodesList, "Id", "LpStandardTariffCodeCode");
            return LpStandardTariffCodes;
        }

        protected SelectList GetLpStandardTariffCodesSelectList(Guid utilityCompanyId, Guid LpStandardTariffCodesId)
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = GetLpStandardTariffCodesList(utilityCompanyId);
            SelectList LpStandardTariffCodes = new SelectList(LpStandardTariffCodesList, "Id", "LpStandardTariffCodeCode", LpStandardTariffCodesId);
            return LpStandardTariffCodes;
        }

        protected SelectList GetLpStandardTariffCodesSelectList(Guid? LpStandardTariffCodesId)
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = GetLpStandardTariffCodesList();
            SelectList LpStandardTariffCodes = new SelectList(LpStandardTariffCodesList, "Id", "LpStandardTariffCodeCode", LpStandardTariffCodesId);
            return LpStandardTariffCodes;
        }

        protected SelectList GetLpStandardTariffCodesSelectList()
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = GetLpStandardTariffCodesList();
            SelectList LpStandardTariffCodes = new SelectList(LpStandardTariffCodesList, "Id", "LpStandardTariffCodeCode");
            return LpStandardTariffCodes;
        }

        private List<LpStandardTariffCode> GetLpStandardTariffCodesList(Guid utilityCompanyId)
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = new List<LpStandardTariffCode>();
            LpStandardTariffCodesList.AddRange(_db.LpStandardTariffCodes.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LpStandardTariffCodeCode));
            return LpStandardTariffCodesList;
        }

        private List<LpStandardTariffCode> GetLpStandardTariffCodesList()
        {
            List<LpStandardTariffCode> LpStandardTariffCodesList = new List<LpStandardTariffCode>();
            LpStandardTariffCodesList.AddRange(_db.LpStandardTariffCodes.Where(x => x.Inactive == false).OrderBy(x => x.LpStandardTariffCodeCode));
            return LpStandardTariffCodesList;
        }
        #endregion

        #region Lp Standard Rate Class Id
        protected SelectList GetLpStandardRateClasssSelectList(Guid utilityCompanyId)
        {
            List<LpStandardRateClass> lpStandardRateClassList = GetLpStandardRateClasssList(utilityCompanyId);
            SelectList lpStandardRateClass = new SelectList(lpStandardRateClassList, "Id", "LpStandardRateClassCode");
            return lpStandardRateClass;
        }

        protected SelectList GetLpStandardRateClasssSelectList(Guid utilityCompanyId, Guid lpStandardRateClassId)
        {
            List<LpStandardRateClass> lpStandardRateClassList = GetLpStandardRateClasssList(utilityCompanyId);
            SelectList lpStandardRateClass = new SelectList(lpStandardRateClassList, "Id", "LpStandardRateClassCode", lpStandardRateClassId);
            return lpStandardRateClass;
        }

        protected SelectList GetLpStandardRateClasssSelectList(Guid? lpStandardRateClassId)
        {
            List<LpStandardRateClass> lpStandardRateClassList = GetLpStandardRateClasssList();
            SelectList lpStandardRateClass = new SelectList(lpStandardRateClassList, "Id", "LpStandardRateClassCode", lpStandardRateClassId);
            return lpStandardRateClass;
        }

        protected SelectList GetLpStandardRateClasssSelectList()
        {
            List<LpStandardRateClass> lpStandardRateClassList = GetLpStandardRateClasssList();
            SelectList lpStandardRateClass = new SelectList(lpStandardRateClassList, "Id", "LpStandardRateClassCode");
            return lpStandardRateClass;
        }

        private List<LpStandardRateClass> GetLpStandardRateClasssList(Guid utilityCompanyId)
        {
            List<LpStandardRateClass> lpStandardRateClassList = new List<LpStandardRateClass>();
            lpStandardRateClassList.AddRange(_db.LpStandardRateClasses.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LpStandardRateClassCode));
            return lpStandardRateClassList;
        }

        private List<LpStandardRateClass> GetLpStandardRateClasssList()
        {
            List<LpStandardRateClass> lpStandardRateClassList = new List<LpStandardRateClass>();
            lpStandardRateClassList.AddRange(_db.LpStandardRateClasses.Where(x => x.Inactive == false).OrderBy(x => x.LpStandardRateClassCode));
            return lpStandardRateClassList;
        }
        #endregion

        #region POR Driver Id
        protected SelectList GetPorDriverSelectList()
        {
            List<PorDriver> porDriverList = GetPorDriverList();
            SelectList porDrivers = new SelectList(porDriverList, "Id", "Name");
            return porDrivers;
        }

        protected SelectList GetPorDriverSelectList(Guid porDriverId)
        {
            List<PorDriver> porDriverList = GetPorDriverList();
            SelectList porDrivers = new SelectList(porDriverList, "Id", "Name", porDriverId);
            return porDrivers;
        }

        private List<PorDriver> GetPorDriverList()
        {
            List<PorDriver> porDriverList = new List<PorDriver>();
            porDriverList.AddRange(_db.PorDrivers.Where(x => x.Inactive == false).OrderBy(x => x.Name));
            return porDriverList;
        }
        #endregion


        #region Lp Standard Load Profile Id
        protected SelectList GetLpStandardLoadProfilesSelectList(Guid utilityCompanyId)
        {
            List<LpStandardLoadProfile> lpStandardLoadProfileList = GetLpStandardLoadProfilesList(utilityCompanyId);
            SelectList lpStandardLoadProfile = new SelectList(lpStandardLoadProfileList, "Id", "LpStandardLoadProfileCode");
            return lpStandardLoadProfile;
        }

        protected SelectList GetLpStandardLoadProfilesSelectList(Guid utilityCompanyId, Guid lpStandardLoadProfileId)
        {
            List<LpStandardLoadProfile> lpStandardLoadProfileList = GetLpStandardLoadProfilesList(utilityCompanyId);
            SelectList lpStandardLoadProfile = new SelectList(lpStandardLoadProfileList, "Id", "LpStandardLoadProfileCode", lpStandardLoadProfileId);
            return lpStandardLoadProfile;
        }

        protected SelectList GetLpStandardLoadProfilesSelectList(Guid? lpStandardLoadProfileId)
        {
            List<LpStandardLoadProfile> lpStandardLoadProfileList = GetLpStandardLoadProfilesList();
            SelectList lpStandardLoadProfile = new SelectList(lpStandardLoadProfileList, "Id", "LpStandardLoadProfileCode", lpStandardLoadProfileId);
            return lpStandardLoadProfile;
        }

        protected SelectList GetLpStandardLoadProfilesSelectList()
        {
            List<LpStandardLoadProfile> lpStandardLoadProfileList = GetLpStandardLoadProfilesList();
            SelectList lpStandardLoadProfile = new SelectList(lpStandardLoadProfileList, "Id", "LpStandardLoadProfileCode");
            return lpStandardLoadProfile;
        }

        private List<LpStandardLoadProfile> GetLpStandardLoadProfilesList(Guid utilityCompanyId)
        {
            List<LpStandardLoadProfile> lpStandardLoadProfileList = new List<LpStandardLoadProfile>();
            lpStandardLoadProfileList.AddRange(_db.LpStandardLoadProfiles.Where(x => x.UtilityCompanyId == utilityCompanyId && x.Inactive == false).OrderBy(x => x.LpStandardLoadProfileCode));
            return lpStandardLoadProfileList;
        }

        private List<LpStandardLoadProfile> GetLpStandardLoadProfilesList()
        {
            List<LpStandardLoadProfile> lpStandardLoadProfilesList = new List<LpStandardLoadProfile>();
            lpStandardLoadProfilesList.AddRange(_db.LpStandardLoadProfiles.Where(x => x.Inactive == false).OrderBy(x => x.LpStandardLoadProfileCode));
            return lpStandardLoadProfilesList;
        }
        #endregion

        public ActionResult TitleClick(string name)
        {
            string method = string.Format("TitleClick(name:{0})", name);
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession(name);

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public void VerifyMessageIdAndErrorMessageSession()
        {
            Session[Common.ERRORMESSAGE] = string.Empty;
            if (Session[Common.MESSAGEID] == null || string.IsNullOrWhiteSpace(Session[Common.MESSAGEID].ToString()))
                Session[Common.MESSAGEID] = Guid.NewGuid().ToString();
        }

        public void ErrorHandler(Exception exc, string method)
        {
            _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3} {4} {5}", Common.NAMESPACE, CLASS, method, exc.Message, exc.InnerException == null ? string.Empty : exc.InnerException.ToString(), exc.StackTrace ?? string.Empty), exc);
            _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, Common.END));
            Session[Common.ERRORMESSAGE] = exc == null ? "NULL EXCEPTION OBJECT" : exc.Message;
        }

        public ActionResult ManageSortationSession(string sortColumn)
        {
            if (Session[Common.SORTCOLUMNNAME].ToString() == sortColumn && Session[Common.SORTDIRECTION].ToString() == Common.ASC)
                Session[Common.SORTDIRECTION] = Common.DESC;
            else
                Session[Common.SORTDIRECTION] = Common.ASC;
            Session[Common.SORTCOLUMNNAME] = sortColumn;
            return RedirectToAction("Index");
        }

        public bool IsUserAuthorizedForThisActivity(string messageId, string activity)
        {
            string method = string.Format("IsUserAuthorizedForThisActivity(messageId,activity:{0})", activity);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                string userName = GetUserName(messageId);

                returnValue = IsUserAuthorizedForThisActivity(messageId, userName, activity);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} {4}", Common.NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return false;
            }
        }

        public bool IsUserAuthorizedForThisActivity(string messageId, string userName, string activity)
        {
            bool returnValue = false;
            string methodFormat = "IsUserAuthorizedForThisActivity(messageId,userName:{0},activity:{1})";
            activity = activity.ToLower();
            userName = userName.ToLower();
            string method = string.Format(methodFormat, userName, activity);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                string cacheKey = method.ToLower();
                _logger.LogDebug(messageId, string.Format("cacheKey:{0}", cacheKey));
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(cacheKey))
                {
                    _logger.LogDebug(messageId, string.Format("****************cache.Contains(cacheKey:{0})", cacheKey));
                    returnValue = (bool)cache.Get(cacheKey);
                    _logger.LogDebug(messageId, string.Format("cache.Contains(cacheKey)--returnValue:{0} = (bool)cache.Get(cacheKey:{1})", returnValue, cacheKey));
                }
                else
                {
                    _logger.LogDebug(messageId, string.Format("!cache.Contains(cacheKey:{0})", cacheKey));

                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : ConfigurationSettings.AppSettings[CHACHE_EXPIRATION_SECONDS]));
                    Dictionary<string, bool> getUserActivitiesResults = new Dictionary<string, bool>();
                    try
                    {
                        _logger.LogDebug(messageId, string.Format("Dictionary<string, bool> getUserActivitiesResults = client.GetUserActivities(messageId, userName:{0}); CALLING", userName));
                        getUserActivitiesResults = _authorizationClient.GetUserActivities(messageId, userName);
                        _logger.LogDebug(messageId, string.Format("Dictionary<string, bool> getUserActivitiesResults = client.GetUserActivities(messageId, userName:{0}); getUserActivitiesResults==null?{1}; getUserActivitiesResults.Keys.Count:{2}  CALLED", Common.NullSafeString(userName), (getUserActivitiesResults == null).ToString(), getUserActivitiesResults.Keys == null ? "0-Null" : getUserActivitiesResults.Keys.Count.ToString()));
                    }
                    catch (Exception e)
                    {
                        _logger.LogError(messageId, e.Message);
                        _logger.LogInfo(messageId, string.Format("{0} END", method));
                        return false;
                    }

                    foreach (string key in getUserActivitiesResults.Keys)
                    {
                        bool value = (bool)getUserActivitiesResults[key];
                        string keyLower = key.ToLower();
                        string cacheKeyLower = string.Format(methodFormat, userName, keyLower).ToLower();

                        if (!cache.Contains(cacheKeyLower))
                        {
                            cache.Add(cacheKeyLower, value, cacheItemPolicy);
                        }

                        if (keyLower == activity)
                        {
                            _logger.LogDebug(messageId, string.Format("*****************--***keyLower:{0} == activity:{1} -- value:{2}", Common.NullSafeString(keyLower), Common.NullSafeString(activity), Common.NullSafeString(value)));
                            returnValue = value;
                        }
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} {4}", Common.NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return false;
            }
        }

        public string GetUserName(string messageId)
        {
            string method = "GetUserName(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                string temporaryUserName = "phasselbring";
                string authenticationType = "Windows";
                string tempAuthenticationType = ConfigurationManager.AppSettings["AuthenticationType"];
                if (!string.IsNullOrWhiteSpace(tempAuthenticationType) && (tempAuthenticationType == "Windows" || tempAuthenticationType == "Config"))
                {
                    authenticationType = tempAuthenticationType;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} authenticationType:{3}", Common.NAMESPACE, CLASS, method, authenticationType));

                switch (authenticationType)
                {
                    case "Windows":
                        string userName = Request.ServerVariables["LOGON_USER"].ToString().ToLower(); //Common.NullSafeString(Session["UtilityManagement_UserName"].ToString());
                        _logger.LogInfo(string.Format("!!!!!!!!!!!!!!!userName={0}", userName));
                        if (string.IsNullOrWhiteSpace(userName))
                            return "Error-Throw To Login";
                        temporaryUserName = userName; //Common.NullSafeString(System.Security.Principal.WindowsIdentity.GetCurrent().Name);
                        break;
                    case "Config":
                        temporaryUserName = Common.NullSafeString(ConfigurationManager.AppSettings["TemporaryUserName"]);
                        break;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} temporaryUserName:{3}", Common.NAMESPACE, CLASS, method, temporaryUserName));


                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} {4}", Common.NAMESPACE, CLASS, method, temporaryUserName, Common.END));
                return temporaryUserName;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                throw;
            }
        }
    }
}
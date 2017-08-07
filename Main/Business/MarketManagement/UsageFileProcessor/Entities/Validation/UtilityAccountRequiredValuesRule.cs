using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace UsageFileProcessor.Entities.Validation
{
    public class UtilityAccountRequiredValuesRule : BusinessRule
    {
        #region Fields

        private UtilityAccount account;
        private ParserUtility utility;

        #endregion Fields

        #region Constructors

        //validate the provided account against the provided utility
        public UtilityAccountRequiredValuesRule(UtilityAccount account, ParserUtility utility)
            : base("UtilityAccountRequiredValuesRule", BrokenRuleSeverity.Error)
        {
            this.account = account;
            this.utility = utility;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            string missingFields = "";
            //	Account Number
            if (utility.Schema.IsFieldRequired("Account Number", "Accounts") == true)
                if (account.AccountNumber == null)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Account Number]";
                }

            // Market
            if (utility.Schema.IsFieldRequired("Market", "Accounts") == true)
                if (account.RetailMarketCode == null)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Market]";
                }

            // Utility
            if (utility.Schema.IsFieldRequired("Utility", "Accounts") == true)
                if (account.UtilityCode == null)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Utility]";
                }

            // Meter Number
            if (utility.Schema.IsFieldRequired("Meter Number", "Accounts") == true)
                if (account.Meters == null || account.Meters.Count == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Meter Number]";
                }

            // Street
            if (utility.Schema.IsFieldRequired("Street", "Accounts") == true)
                if (account.ServiceAddress == null || account.ServiceAddress.Street == null || account.ServiceAddress.Street.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Street]";
                }

            // City
            if (utility.Schema.IsFieldRequired("City", "Accounts") == true)
                if (account.ServiceAddress == null || account.ServiceAddress.CityName == null || account.ServiceAddress.CityName.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[City]";
                }

            // State
            if (utility.Schema.IsFieldRequired("State", "Accounts") == true)
                if (account.ServiceAddress == null || ((UsGeographicalAddress)account.ServiceAddress).StateCode == null || ((UsGeographicalAddress)account.ServiceAddress).StateCode.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[State]";
                }

            // Zip
            if (utility.Schema.IsFieldRequired("Zip", "Accounts") == true)
                if (account.ServiceAddress == null || ((UsGeographicalAddress)account.ServiceAddress).ZipCode == null || ((UsGeographicalAddress)account.ServiceAddress).ZipCode.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Zip]";
                }

            // Country
            if (utility.Schema.IsFieldRequired("Country", "Accounts") == true)
                if (account.ServiceAddress == null || ((UsGeographicalAddress)account.ServiceAddress).CountryName == null || ((UsGeographicalAddress)account.ServiceAddress).CountryName.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Country]";
                }

            // Name Key
            if (utility.Schema.IsFieldRequired("Name Key", "Accounts") == true)
                if (account.NameKey == null || account.NameKey.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Name Key]";
                }

            // Billing Account
            if (utility.Schema.IsFieldRequired("Billing Account", "Accounts") == true)
                if (account.BillingAccount == null || account.BillingAccount.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Billing Account]";
                }
            //////////////////////////////////////////////////
            // Billing Street
            if (utility.Schema.IsFieldRequired("Billing Street", "Accounts") == true)
                if (account.BillingAddress == null || account.BillingAddress.Street == null || account.BillingAddress.Street.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Billing Street]";
                }

            // Billing City
            if (utility.Schema.IsFieldRequired("Billing City", "Accounts") == true)
                if (account.BillingAddress == null || account.BillingAddress.CityName == null || account.BillingAddress.CityName.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[City]";
                }

            // Billing State
            if (utility.Schema.IsFieldRequired("Billing State", "Accounts") == true)
                if (account.BillingAddress == null || ((UsGeographicalAddress)account.BillingAddress).StateCode == null || ((UsGeographicalAddress)account.BillingAddress).StateCode.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Billing State]";
                }

            // Billing Zip
            if (utility.Schema.IsFieldRequired("Billing Zip", "Accounts") == true)
                if (account.BillingAddress == null || ((UsGeographicalAddress)account.BillingAddress).ZipCode == null || ((UsGeographicalAddress)account.BillingAddress).ZipCode.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Billing Zip]";
                }

            // Billing Country
            if (utility.Schema.IsFieldRequired("Billing Country", "Accounts") == true)
                if (account.BillingAddress == null || ((UsGeographicalAddress)account.BillingAddress).CountryName == null || ((UsGeographicalAddress)account.BillingAddress).CountryName.Trim().Length == 0)
                {
                    if (missingFields.Length != 0)
                        missingFields += ",";
                    missingFields += "[Billing Country]";
                }

            ///////////////////////////////////////////////////

            if (missingFields.Length > 0)
                this.SetException("Required value(s) not found for fields " + missingFields);

            return this.Exception == null;
        }

        #endregion Methods
    }
}
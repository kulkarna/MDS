namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    [Guid("3CFCD294-2C62-4085-9DE6-BA089C074058")]
    public class UsageRequiredValuesRule : BusinessRule
    {
        #region Fields

        private UtilityAccount account;
        private UsageCandidate usage;
        private UtilityStandIn utility;

        #endregion Fields

        #region Constructors

        //validate the provided account against the provided utility
        public UsageRequiredValuesRule(UsageCandidate usage, UtilityAccount account, UtilityStandIn utility)
            : base("UsageRequiredValuesRule", BrokenRuleSeverity.Error)
        {
            this.account = account;
            this.utility = utility;
            this.usage = usage;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            string missingUsageFields = ""; // FOR Ctpen, these are fields on the detail sheets; for all others combine these with missingAccountFields
            string missingAccountFields = "";  //FOR Ctpen, these are fields on the Accounts tab; for all others combine these with missingUsageFields

            //	Customer Name
            if (utility.Schema.IsFieldRequired("Customer Name", "Usages") == true)
                if (account.CustomerName == null)
                {
                    if (missingAccountFields.Length != 0)
                        missingAccountFields += ",";
                    missingAccountFields += "[Customer Name]";
                }

            // Rate Class
            if (utility.Schema.IsFieldRequired("Rate Class", "Usages") == true)
                if (account.RateClass == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Rate Class]";
                }

            // Metered KW
            if (utility.Schema.IsFieldRequired("Metered KW", "Usages") == true)
                if (usage.BillingDemandKw == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Metered KW]";
                }

            // Actual KWH
            if (utility.Schema.IsFieldRequired("Actual KWH", "Usages") == true)
                if (usage.TotalKwh == 0)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Actual KWH]";
                }
/*
            // TDSP Charges
            if (utility.Schema.IsFieldRequired("TDSP Charges", "Usages") == true)
                if (usage.TdspCharges == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[TDSP Charges]";
                }
*/
            // Start Date
            if (utility.Schema.IsFieldRequired("Start Date", "Usages") == true)
                if (usage.BeginDate == DateTime.MinValue)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Start Date]";
                }

            // End Date
            if (utility.Schema.IsFieldRequired("End Date", "Usages") == true)
                if (usage.EndDate == DateTime.MinValue)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[End Date]";
                }

            // Meter Read Cycle
            if (utility.Schema.IsFieldRequired("Meter Read Cycle", "Usages") == true)
                if (account.MeterReadCycleId == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Meter Read Cycle]";
                }

            // Load Profile
            if (utility.Schema.IsFieldRequired("Load Profile", "Usages") == true)
                if (account.LoadProfile == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Load Profile]";
                }

            // Service Address 1
            if (utility.Schema.IsFieldRequired("Service Address 1", "Usages") == true)
                if (account.ServiceAddress.Street == null)
                {
                    if (missingAccountFields.Length != 0)
                        missingAccountFields += ",";
                    missingAccountFields += "[Service Address 1]";
                }

            // Service Address 2
            if (utility.Schema.IsFieldRequired("Service Address 2", "Usages") == true)
                if (account.ServiceAddress.Street == null)
                {
                    if (missingUsageFields.Length != 0)
                        missingUsageFields += ",";
                    missingUsageFields += "[Service Address 2]";
                }

            // Service Address 3
            if (utility.Schema.IsFieldRequired("Service Address 3", "Usages") == true)
                if (account.ServiceAddress.CityName == null)
                {
                    if (missingAccountFields.Length != 0)
                        missingAccountFields += ",";
                    missingAccountFields += "[Service Address 3]";
                }

            string missingFields = missingAccountFields;
            if (missingFields.Length > 0)
                missingFields += ",";
            missingFields += missingUsageFields;

            if (missingFields.Length > 0)
            {
                string message = "";
                if (utility.Code.ToUpper().Trim() != "CTPEN")
                {
                    message = string.Format("Required value(s) not found for {0} in Excel row {1} ", missingFields, usage.ExcelRowNumber);
                }
                else
                {
                    message = string.Format("Required value(s) not found for {0} in  the Accounts Excel Sheet row {1} ", missingAccountFields, ((ProspectAccountCandidate)account).ExcelRow);
                    message += string.Format(" and for {0} in Excel Sheet: [{1}] row {2} ", missingUsageFields, usage.ExcelSheetName, usage.ExcelRowNumber);
                }
                this.SetException(message);
            }
            return this.Exception == null;
        }

        #endregion Methods
    }
}
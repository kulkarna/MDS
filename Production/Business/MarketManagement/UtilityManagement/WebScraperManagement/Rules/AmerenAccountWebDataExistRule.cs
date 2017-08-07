namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System.Collections.Generic;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    /// <summary>
    /// Rule to validate WebAccount data.
    /// It adds some properties of the
    /// account to be validated:
    /// 
    /// 1. Customer Name
    /// 2. Utility Code
    /// 3. Zone Code
    /// 4. Load Shape Id
    /// 5. Web Usage List
    /// </summary>
    [Guid("D578AB4B-AF34-4af4-B7C2-04F302C9BA48")]
    public abstract class AmerenAccountWebDataExistsRule : GenericCompositeDataExistsRule<WebAccount>
    {
        /// <summary>
        /// Constructor that receives the rule name,
        /// the data to be validated and its description
        /// </summary>
        /// <param name="ruleName">The name of the rule</param>
        /// <param name="target">Data to be validated</param>
        /// <param name="dataDescription">The description of tedata to be validated</param>
        public AmerenAccountWebDataExistsRule(string ruleName, WebAccount target, string dataDescription)
            : this(ruleName, BrokenRuleSeverity.Error, target, dataDescription)
        {
        }

        /// <summary>
        /// Constructor that receives the name of the rule, its severity,
        /// the data to be validated and its description
        /// </summary>
        /// <param name="ruleName">The name of the rule</param>
        /// <param name="severity">Te severity of the rule</param>
        /// <param name="account">The data to be validated</param>
        /// <param name="dataDescription">The description of the data</param>
        public AmerenAccountWebDataExistsRule(string ruleName, BrokenRuleSeverity severity, WebAccount account, string dataDescription)
            : base(ruleName, severity, account, dataDescription)
        {
            account.AccountDataExistsRule = this;

            StringDataExistsRule srule = new StringDataExistsRule(DefaultSeverity, account.CustomerName, "Customer Name");
            AddDataValidationRule(srule);

            srule = new StringDataExistsRule(BrokenRuleSeverity.Error, account.UtilityCode, "Utility Code");
            AddDataValidationRule(srule);
            srule = new StringDataExistsRule(BrokenRuleSeverity.Error, account.LoadShapeId, "Load Shape ID");
            AddDataValidationRule(srule);

            AddDataValidationRule(GetWebUsageListRule());
        }

        protected abstract BusinessRule GetWebUsageListRule();
    }
}

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to ensure that utility mapping driver(s) exist
	/// </summary>
	[Guid( "557345CA-D4E2-4e7c-9A6E-1B03D929C10B" )]
	public class UtilityMappingDriverExistsRule : BusinessRule
	{
		private UtilityAccount utilityAccount;
		private string accountNumber;
		private string utilityCode;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="utilityAccount">Utility account</param>
		public UtilityMappingDriverExistsRule( UtilityAccount utilityAccount )
			: base( "Utility Mapping Driver Exists Rule", BrokenRuleSeverity.Error )
		{
			this.utilityAccount = utilityAccount;
			this.accountNumber = this.utilityAccount.AccountNumber;
			this.utilityCode = this.utilityAccount.UtilityCode.ToUpper();
		}

		/// <summary>
		/// Validates whether utility mapping driver(s) exist for specified account
		/// </summary>
		/// <returns>Returns a boolean indicating whether utility mapping driver(s) exist for specified account.</returns>
		public override bool Validate()
		{
			UtilityClassMappingDeterminantList determinants = UtilityMappingFactory.GetUtilityClassMappingDeterminants( utilityCode );

			if( determinants.Count == 0 )
			{
				this.SetException( String.Format( "No mapping determinants were found for utility: {0}", utilityCode ) );
			}
			else
			{
				foreach( UtilityClassMappingDeterminant d in determinants )
				{
					string driver = d.Driver;
                    if (d.UtilityClassMappingResultantList != null && d.UtilityClassMappingResultantList.Count > 0)
                    {
                        switch (driver)
                        {
                            case "Grid":
                                {
                                    if (utilityAccount.Grid == null || utilityAccount.Grid.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Grid' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "LBMPZone":
                                {
                                    if (utilityAccount.LBMPZone == null || utilityAccount.LBMPZone.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'LBMP Zone' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "LoadProfileID":
                                {
                                    if (utilityAccount.LoadProfile == null || utilityAccount.LoadProfile.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Load Profile' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "LoadShapeID":
                                {
                                    if (utilityAccount.LoadShapeId == null || utilityAccount.LoadShapeId.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Load Shape Id' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "RateClassID":
                                {
                                    if (utilityAccount.RateClass == null || utilityAccount.RateClass.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Rate Class' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "ServiceClassID":
                                {
                                    if (utilityAccount.ServiceClass == null || utilityAccount.ServiceClass.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Service Class' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            case "TariffCodeID":
                                {
                                    if (utilityAccount.TariffCode == null || utilityAccount.TariffCode.Length == 0)
                                        AddException(
                                            new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                    String.Format(
                                                                        "Utility mapping driver 'Tariff Code' is missing for account number: {0} utility: {1}",
                                                                        accountNumber, utilityCode),
                                                                    BrokenRuleSeverity.Error));
                                    break;
                                }
                            default:
                                {
                                    AddException(
                                        new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
                                                                String.Format(
                                                                    "Utility mapping driver '{0}' is unknown", driver),
                                                                BrokenRuleSeverity.Error));
                                    break;
                                }
                        }
                    }
				}
			}
			return this.Exception == null;
		}

		private void AddException( BrokenRuleException ex )
		{
			if( this.Exception == null )
			{
				this.SetException( String.Format( "One or more utility mapping driver not found for utility: {0}", utilityCode ) );
			}
			this.AddDependentException( ex );
		}
	}
}

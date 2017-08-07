namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	[Guid( "6EEF668B-27CA-4cb8-895A-F71438D9C5C8" )]
	public class ValidDataForUsageConsolidationRule : BusinessRule
	{

        private decimal? _icap = null;
        private decimal? _tcap = null;
	    private decimal? _lossFactor = null;
	    private MeterType _meterType = MeterType.Unknown;

        private string _utility = "";
        private string _accountNumber = "";
        bool validateDeterminants = false;
		/// <summary>
		/// Constructor
		/// </summary>
		public ValidDataForUsageConsolidationRule()
			: base( "Valid Data For Usage Consolidation Rule", BrokenRuleSeverity.Error )
		{

		}

        /// <summary>
        /// Constructor
        /// </summary>
        public ValidDataForUsageConsolidationRule(string utility, string accountNumber, decimal ? iCap, decimal ? tcap, MeterType meterType, Decimal ? lossfactor)
            : base("Valid Data For Usage Consolidation Rule", BrokenRuleSeverity.Error)
        {
            _utility = utility;
            _accountNumber = accountNumber;
            _icap = iCap;
            _tcap = tcap;
            _lossFactor = lossfactor;
            _meterType = meterType;
            validateDeterminants = true;
        }
		/// <summary>
		/// Sets broken rule exception
		/// </summary>
		/// <param name="message">Exception message</param>
		public void SetParentException( string message )
		{
			this.SetException( message );
		}

		public void AddParentDependantException( BrokenRuleException ex )
		{
			this.AddDependentException( ex );
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool Validate()
		{
            if (validateDeterminants)
            {
                var errorMessage = "";
                if (_icap.HasValue == false || _icap == -1)
                {
                    errorMessage = string.Format("ICAP for account {0}/{1} is blank. Please specify.", _utility, _accountNumber);
                }
                if (_tcap.HasValue == false || _tcap == -1)
                {
                    if (errorMessage.Length > 0) errorMessage += "<br/> ";
                    errorMessage += string.Format("TCAP for account {0}/{1} is blank. Please specify.", _utility, _accountNumber);
                }

                if (_lossFactor.HasValue == false )
                {
                    if (errorMessage.Length > 0) errorMessage += "<br/> ";
                    errorMessage += string.Format("Loss Factor for account {0}/{1} is blank. Please specify.", _utility, _accountNumber);
                }

                if (_meterType == MeterType.Unknown || _meterType == MeterType.Unmetered)
                {
                    if (errorMessage.Length > 0) errorMessage += "<br/> ";
                    errorMessage += string.Format("Meter Type for account {0}/{1} is blank. Please specify.", _utility, _accountNumber);
                }

                if(errorMessage.Length > 0)
                    SetException(errorMessage);
            }
			return this.Exception == null;
		}
	}
}

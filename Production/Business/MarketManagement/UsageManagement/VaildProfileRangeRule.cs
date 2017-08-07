namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;

	[Guid( "51079701-13AF-4a5d-A351-512DB91B5394" )]
	public class VaildProfileRangeRule : BusinessRule
	{
		private string accountNumber;
		private string utilityCode;
		private int profileCount;
		private DateRange range;
        private string _loadShapeId;

        ///// <summary>
        ///// Verify that there are sufficient profiles for date range
        ///// </summary>
        ///// <param name="accountNumber">Account number</param>
        ///// <param name="utilityCode">Utility code</param>
        ///// <param name="profileCount">Profile count</param>
        ///// <param name="range">Date range</param>
        //public VaildProfileRangeRule( string accountNumber,
        //    string utilityCode, int profileCount, DateRange range )
        //    : base( "Vaild Profile Range Rule", BrokenRuleSeverity.Error )
        //{
        //    this.accountNumber = accountNumber;
        //    this.utilityCode = utilityCode;
        //    this.profileCount = profileCount;
        //    this.range = range;
        //    this._loadShapeId = "";
        //}

        /// <summary>
        /// Verify that there are sufficient profiles for date range
        /// </summary>
        /// <param name="accountNumber">Account number</param>
        /// <param name="utilityCode">Utility code</param>
        /// <param name="profileCount">Profile count</param>
        /// <param name="range">Date range</param>
        public VaildProfileRangeRule(string accountNumber,
            string utilityCode, int profileCount, DateRange range, string loadShapeId)
            : base("Vaild Profile Range Rule", BrokenRuleSeverity.Error)
        {
            this.accountNumber = accountNumber;
            this.utilityCode = utilityCode;
            this.profileCount = profileCount;
            this.range = range;
            this._loadShapeId = loadShapeId;
        }
		public override bool Validate()
		{
			if( profileCount < (range.EndDate - range.StartDate).Days )
			{
                string format = "";
                if(_loadShapeId.Trim().Length>0)
                {
                    format = "For Account {0} ({1}), data is missing for Load Shape ID {2}. Please upload the profile or exclude the account from the offer";
                        this.SetException( String.Format( format, accountNumber, utilityCode, _loadShapeId ) );
                }
                else
                {
                    format = "{0} ({1}) has insufficient profiles in order to fill in gaps/calculate the ratio.";
                    this.SetException( String.Format( format, accountNumber, utilityCode ) );
                }
			    
			}

			return this.Exception == null;
		}
	}
}

using System;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Rule to ensure that zone exists
	/// </summary>
	[Serializable]
	[Guid( "62ACB020-558E-48fa-9DDA-70E4D8C15D59" )]
	public class ZoneExistsRule : BusinessRule
	{
		private string accountNumber;
		private string utilityCode;
		private string zone;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="accountNumber">Identifier for account</param>
		/// <param name="zone">Zone</param>
		public ZoneExistsRule( string accountNumber, string zone )
			: base( "Zone Exists Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.zone = zone;
		}

		public ZoneExistsRule( string accountNumber, string utilityCode, string zone )
			: base( "Zone Exists Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.zone = zone;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool Validate()
		{
			if( (this.zone == null) || (this.zone.Length == 0) )
			{
				string format;
				string reason;

				if( utilityCode != null )
				{
                    format = "Zone is missing for account {0}/{1}. Please specify.";
					reason = string.Format( format, this.accountNumber, this.utilityCode );
				}
				else
				{
                    format = "Zone is missing for account {0}. Please specify.";
					reason = string.Format( format, this.accountNumber );
				}

				this.SetException( reason );
			}

			return this.Exception == null;
		}
	}
}

using System;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Rule to ensure that meter type is non-idr
	/// </summary>
	[Guid( "F25C2EC1-AC97-4f7c-803F-8CE7E01B48EB" )]
	public class AccountMeterTypeNonIdrRule : BusinessRule
	{
		private UtilityAccount account;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="account">UtilityAccount object</param>
		public AccountMeterTypeNonIdrRule( UtilityAccount account )
			: base( "Account Meter Type NonIdr Rule", BrokenRuleSeverity.Error )
		{
			this.account = account;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool Validate()
		{
			foreach( Meter meter in account.Meters )
			{
				if( meter.MeterType == MeterType.Idr )
				{
					string format = "<br/>Account {0} is an IDR account";
					string reason = string.Format( format, this.account.AccountNumber );
					this.SetException( reason );
					break;
				}
			}

			return this.Exception == null;
		}
	}
}

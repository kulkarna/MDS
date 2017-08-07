using System;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Rule to ensure that meter type is non-idr
	/// </summary>
	[Guid( "F30AA8C6-9EF5-453a-8F3D-94265A00F039" )]
	public class MeterTypeNonIdrRule : BusinessRule
	{
		private string accountNumber;
		private MeterType meterType;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="accountNumber">Identifier for account</param>
		/// <param name="meterType">Meter type</param>
		public MeterTypeNonIdrRule( string accountNumber, MeterType meterType )
			: base( "Meter Type NonIdr Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.meterType = meterType;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool Validate()
		{
			if( this.meterType == MeterType.Idr )
			{
				string format = "Account {0} is an IDR.  Please exclude this account.";
				string reason = string.Format( format, this.accountNumber );
				this.SetException( reason );
			}

			return this.Exception == null;
		}
	}
}

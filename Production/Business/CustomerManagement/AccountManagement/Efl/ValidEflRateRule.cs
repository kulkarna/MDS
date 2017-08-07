using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	[Guid( "7871A69C-4904-477d-B890-FEBEB27DAB25" )]
	public class ValidEflRateRule : BusinessRule
	{
		private decimal rate;

		public ValidEflRateRule( decimal rate )
			: base( "Valid Efl Rate Rule", BrokenRuleSeverity.Error )
        {
			this.rate = rate;
        }

		public override bool Validate()
		{
			DataSet ds = EflSql.GetEflDataRange();

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
			{
				decimal rateMin = Convert.ToDecimal( ds.Tables[0].Rows[0]["RateMin"] );
				decimal rateMax = Convert.ToDecimal( ds.Tables[0].Rows[0]["RateMax"] );

				if( rate < rateMin || rate > rateMax )
				{
					string format = "-  Invalid rate ( {0} ). Valid range: {1} - {2}.";
					this.SetException( String.Format( format, rate.ToString(), rateMin.ToString(), rateMax.ToString() ) );
				}
			}
			else
				this.SetException( "-  No validation data found for rate." );

			return this.Exception == null;
		}
	}
}

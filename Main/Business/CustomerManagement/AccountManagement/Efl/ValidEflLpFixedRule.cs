using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	[Guid( "A4992E72-AEBF-4982-960F-BDE0F6B155E7" )]
	public class ValidEflLpFixedRule : BusinessRule
	{
		private decimal lpFixed;

		public ValidEflLpFixedRule( decimal lpFixed )
			: base( "Valid Efl LpFixed Rule", BrokenRuleSeverity.Error )
		{
			this.lpFixed = lpFixed;
		}

		public override bool Validate()
		{
			DataSet ds = EflSql.GetEflDataRange();

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
			{
				decimal lpFixedMin = Convert.ToDecimal( ds.Tables[0].Rows[0]["LpFixedMin"] );
				decimal lpFixedMax = Convert.ToDecimal( ds.Tables[0].Rows[0]["LpFixedMax"] );

				if( lpFixed < lpFixedMin || lpFixed > lpFixedMax )
				{
					string format = "-  Invalid monthly service charge ( {0} ). Valid range: {1} - {2}.";
					this.SetException( String.Format( format, lpFixed.ToString(), lpFixedMin.ToString(), lpFixedMax.ToString() ) );
				}
			}
			else
				this.SetException( "-  No validation data found for monthly service charge." );

			return this.Exception == null;
		}
	}
}

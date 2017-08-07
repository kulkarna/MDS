using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	[Guid( "481898CF-04C0-4a7f-89F4-FD82DF507D04" )]
	class ProfileHas364ConsectiveDaysRule : BusinessRule
	{
		private string fileName;
		private ArrayList dates;

		/// <summary>
		/// Verify that there are at least 364 consecutive days of profiles
		/// </summary>
		/// <param name="fileName">File name</param>
		/// <param name="dates">List of dates to validate</param>
		public ProfileHas364ConsectiveDaysRule( string fileName, ArrayList dates )
			: base( "Profile Has 364 Consective Days Rule", BrokenRuleSeverity.Warning )
		{
			this.fileName = fileName;
			this.dates = dates;
		}

		public override bool Validate()
		{
			int consecutiveCount = 0;

			dates.Sort();

			DateTime previousDate = Convert.ToDateTime( dates[0] );

			foreach( DateTime date in dates )
			{
				consecutiveCount++;

				// unless on first pass, previous date should always be 
				// 1 day less than date of comparison,
				// if not, reset consecutive counter
				if( (previousDate != date) && (previousDate != date.AddDays( -1 )) )
					consecutiveCount = 0;

				previousDate = date;
			}

			if( consecutiveCount < 364 )
			{
				string format = "File {0} has less than 364 consecutive days of profiles.";
				this.SetException( String.Format( format, fileName ) );
			}

			return this.Exception == null;
		}
	}
}

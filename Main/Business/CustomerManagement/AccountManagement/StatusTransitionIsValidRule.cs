namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "AE83F9D5-A9D9-409D-8E71-E79DA07BD9B7" )]
	public class StatusTransitionIsValidRule : BusinessRule
	{
		private StatusTransition st;
		private int statusTransitionID;
		private string startDate;
		private string endDate;

		public StatusTransitionIsValidRule( StatusTransition st, int statusTransitionID, string startDate, string endDate )
			: base( "Status Transition Is Valid Rule", BrokenRuleSeverity.Error )
		{
			this.st = st;
			this.statusTransitionID = statusTransitionID;
			this.startDate = startDate;
			this.endDate = endDate;
		}

		public override bool Validate()
		{
			if( st != null )
			{
				DateTime date;

				if( statusTransitionID == 0 )
				{
					this.SetException( "Invalid status selection - NO SELECTION MADE." );
				}
				else if( st.RequiresStartDate && !DateTime.TryParse( startDate, out date ) )
				{
						this.SetException( String.Format( "Invalid start date - {0}.", startDate.Length == 0 ? "NO DATE ENTERED" : startDate ) );
				}
				else if( st.RequiresEndDate && !DateTime.TryParse( endDate, out date ) )
				{
						this.SetException( String.Format( "Invalid end date - {0}.", endDate.Length == 0 ? "NO DATE ENTERED" : endDate ) );
				}
			}
			return this.Exception == null;
		}
	}
}

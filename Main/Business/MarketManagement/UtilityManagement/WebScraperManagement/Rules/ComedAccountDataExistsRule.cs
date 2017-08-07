namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;


	[Guid( "E2EB3ACB-4CE6-4302-B998-75CBCCC93E60" )]
	public class ComedAccountDataExistsRule : BusinessRule
	{
		private Comed account;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Constructor that takes a Comed account
		/// </summary>
		/// <param name="account">Comed account</param>
		public ComedAccountDataExistsRule( Comed account )
			: base( "Account Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.account = account;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
		    return true; //Ignore all rules per Douglas and Coffer 12-02-14

			string accountNumber = account.AccountNumber;

			DataExistsRule billGroupRule = null;
			DataExistsRule capacityPLC1ValueRule = null;
			DataExistsRule capacityPLC1StartDate = null;
			DataExistsRule capacityPLC1EndDate = null;
			DataExistsRule capacityPLC2ValueRule = null;
			DataExistsRule capacityPLC2StartDate = null;
			DataExistsRule capacityPLC2EndDate = null;
			DataExistsRule networkServicePLCValueRule = null;
			DataExistsRule networkServicePLCStartDateRule = null;
			DataExistsRule networkServicePLCEndDateRule = null;
			DataExistsRule condoExceptionRule = null;
			DataExistsRule currentSupplyGroupNameRule = null;
			DataExistsRule currentSupplyGroupEffectiveDateRule = null;
			DataExistsRule pendingSupplyGroupNameRule = null;
			DataExistsRule pendingSupplyGroupEffectiveDateRule = null;
			DataExistsRule minimumStayDateRule = null;

			billGroupRule = new DataExistsRule( accountNumber, "Bill Group", account.BillGroup );

			if( account.CapacityPLC.Count > 0 )
			{
				capacityPLC1ValueRule = new DataExistsRule( accountNumber, "Capacity PLC 1 Value", (int) account.CapacityPLC[0].Value );
				capacityPLC1StartDate = new DataExistsRule( accountNumber, "Capacity PLC 1 Start Date", account.CapacityPLC[0].StartDate );
				capacityPLC1EndDate = new DataExistsRule( accountNumber, "Capacity PLC 1 End Date", account.CapacityPLC[0].EndDate );
			}
			else
			{
				capacityPLC1ValueRule = new DataExistsRule( accountNumber, "Capacity PLC 1 Value", -1 );
				capacityPLC1StartDate = new DataExistsRule( accountNumber, "Capacity PLC 1 Start Date", DateTime.MinValue );
				capacityPLC1EndDate = new DataExistsRule( accountNumber, "Capacity PLC 1 End Date", DateTime.MinValue );
			}

			if( account.CapacityPLC.Count > 1 )
			{
				capacityPLC2ValueRule = new DataExistsRule( accountNumber, "Capacity PLC 2 Value", (int) account.CapacityPLC[1].Value );
				capacityPLC2StartDate = new DataExistsRule( accountNumber, "Capacity PLC 2 Start Date", account.CapacityPLC[1].StartDate );
				capacityPLC2EndDate = new DataExistsRule( accountNumber, "Capacity PLC 2 End Date", account.CapacityPLC[1].EndDate );
			}
			else 
			{
				capacityPLC2ValueRule = new DataExistsRule( accountNumber, "Capacity PLC 2 Value", -1 );
				capacityPLC2StartDate = new DataExistsRule( accountNumber, "Capacity PLC 2 Start Date", DateTime.MinValue );
				capacityPLC2EndDate = new DataExistsRule( accountNumber, "Capacity PLC 2 End Date", DateTime.MinValue );
			}

			if( account.NetworkServicePLC.Count > 0 )
			{
				networkServicePLCValueRule = new DataExistsRule( accountNumber, "Network Service PLC Value", (int) account.NetworkServicePLC[0].Value );
				networkServicePLCStartDateRule = new DataExistsRule( accountNumber, "Network Service PLC Start Date", account.NetworkServicePLC[0].StartDate );
				networkServicePLCEndDateRule = new DataExistsRule( accountNumber, "Network Service PLC End Date", account.NetworkServicePLC[0].EndDate );
			}
			else
			{
				networkServicePLCValueRule = new DataExistsRule( accountNumber, "Network Service PLC Value", -1 );
				networkServicePLCStartDateRule = new DataExistsRule( accountNumber, "Network Service PLC Start Date", DateTime.MinValue );
				networkServicePLCEndDateRule = new DataExistsRule( accountNumber, "Network Service PLC End Date", DateTime.MinValue );
			}

			condoExceptionRule = new DataExistsRule( accountNumber, "Condo Exception", account.CondoException );

			if( account.CurrentSupplyGroup != null )
			{
				currentSupplyGroupNameRule = new DataExistsRule( accountNumber, "Current Supply Group Name", account.CurrentSupplyGroup.Name );
				currentSupplyGroupEffectiveDateRule = new DataExistsRule( accountNumber, "Current Supply Group Effective Date", account.CurrentSupplyGroup.EffectiveStartDate );
			}
			else
			{
				currentSupplyGroupNameRule = new DataExistsRule( accountNumber, "Current Supply Group Name", null );
				currentSupplyGroupEffectiveDateRule = new DataExistsRule( accountNumber, "Current Supply Group Effective Date", DateTime.MinValue );
			}

			if( account.PendingSupplyGroup != null )
			{
				pendingSupplyGroupNameRule = new DataExistsRule( accountNumber, "Pending Supply Group Name", account.PendingSupplyGroup.Name );
				pendingSupplyGroupEffectiveDateRule = new DataExistsRule( accountNumber, "Pending Supply Group Effective Date", account.PendingSupplyGroup.EffectiveStartDate );
			}
			else
			{
				pendingSupplyGroupNameRule = new DataExistsRule( accountNumber, "Pending Supply Group Name", null );
				pendingSupplyGroupEffectiveDateRule = new DataExistsRule( accountNumber, "Pending Supply Group Effective Date", DateTime.MinValue );
			}

			minimumStayDateRule = new DataExistsRule( accountNumber, "Minimum Stay Date", account.MinimumStayDate );

			if( !billGroupRule.ValidateNumber() )
				AddException( billGroupRule.Exception );

			if( !capacityPLC1ValueRule.ValidateNumber() )
				AddException( capacityPLC1ValueRule.Exception );

			if( !capacityPLC1StartDate.ValidateDate() )
				AddException( capacityPLC1StartDate.Exception );

			if( !capacityPLC1EndDate.ValidateDate() )
				AddException( capacityPLC1EndDate.Exception );

			if( !capacityPLC2ValueRule.ValidateNumber() )
				AddException( capacityPLC2ValueRule.Exception );

			if( !capacityPLC2StartDate.ValidateDate() )
				AddException( capacityPLC2StartDate.Exception );

			if( !capacityPLC2EndDate.ValidateDate() )
				AddException( capacityPLC2EndDate.Exception );

			if( !networkServicePLCValueRule.ValidateNumber() )
				AddException( networkServicePLCValueRule.Exception );

			if( !networkServicePLCStartDateRule.ValidateDate() )
				AddException( networkServicePLCStartDateRule.Exception );

			if( !networkServicePLCEndDateRule.ValidateDate() )
				AddException( networkServicePLCEndDateRule.Exception );

			if( !condoExceptionRule.Validate() )
				AddException( condoExceptionRule.Exception );

			if( !currentSupplyGroupNameRule.Validate() )
				AddException( currentSupplyGroupNameRule.Exception );

			if( !currentSupplyGroupEffectiveDateRule.ValidateDate() )
				AddException( currentSupplyGroupEffectiveDateRule.Exception );

			if( !pendingSupplyGroupNameRule.Validate() )
				AddException( pendingSupplyGroupNameRule.Exception );

			if( !pendingSupplyGroupEffectiveDateRule.ValidateDate() )
				AddException( pendingSupplyGroupEffectiveDateRule.Exception );

			if( !minimumStayDateRule.ValidateDate() )
				AddException( minimumStayDateRule.Exception );

			ComedUsageListDataExistsRule usageRule = new ComedUsageListDataExistsRule( account.AccountNumber, account.WebUsageList );

			if( !usageRule.Validate() )
				AddException( usageRule.Exception );

			account.AccountDataExistsRule = this;

			return this.Exception == null;
		}

		// ------------------------------------------------------------------------------------
		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing account data." );

			exception.Severity = BrokenRuleSeverity.Warning;
			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}
	}
}

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the generic edi file object has valid data.
	/// </summary>
	[Guid( "EF813959-166E-4dc7-93F2-28156BB8E739" )]
	public class EdiFileValidRule : BusinessRule
	{
		private EdiFile ediFile;
		private EdiAccountList accountList;

		/// <summary>
		/// Constructor that takes and Edi file object containing a generic collection of utility file data.
		/// </summary>
		/// <param name="ediFile">Edi file object</param>
		public EdiFileValidRule( EdiFile ediFile )
			: base( "Edi File Valid Rule", BrokenRuleSeverity.Information )
		{
			this.ediFile = ediFile;
			this.accountList = ediFile.EdiAccountList;
		}

		/// <summary>
		/// default constructor
		/// </summary>
		public EdiFileValidRule( )
		{
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			return false;
		}
		
		/// <summary>
		/// Validate account information
		/// </summary>
		/// <param name="account">ediAccount to validate</param>
		/// <param name="fileType">file type</param>
		/// <returns>true if account is valid</returns>
		public bool Validate( ref EdiAccount account, EdiFileType fileType )
		{
				string accountNumber = account.AccountNumber;

				AccountDataExistsRule accountRule = new AccountDataExistsRule( ref account, fileType );
				if( !accountRule.Validate() )
				{
					if( !this.DefaultSeverity.Equals( BrokenRuleSeverity.Error ) )
						this.DefaultSeverity = BrokenRuleSeverity.Warning;
					CreateException();
				}

				if( fileType == EdiFileType.EightSixSeven )
				{
					EdiUsageList usageList = account.EdiUsageList;

					UsageListDataExistsRule usageRule = new UsageListDataExistsRule( accountNumber, ref usageList );
					if( !usageRule.Validate() )
					{
						accountRule.DefaultSeverity = usageRule.DefaultSeverity;
						CreateException();
					}

					account.UsageListDataExistsRule = usageRule;
				}

			//ediFile.EdiFileValidRule = this;

			return this.Exception == null;
		}

		private void CreateException()
		{
			if( this.Exception == null )
				this.SetException( "File has one or more exceptions." );
		}
	}
}

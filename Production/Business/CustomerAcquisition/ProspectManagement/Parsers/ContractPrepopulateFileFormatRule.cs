using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Reflection;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement
{
	[Guid( "796A0FA5-DF21-4080-815F-965CBBB44F65" )]
	public class ContractPrepopulateFileFormatRule : BusinessRule
	{
		private string fileName;
		private Stream rawFile;
		private DataSet rawContent;

		public ContractPrepopulateFileFormatRule( Stream rawFile, string fileName, DataSet rawContent )
			: base( "ContractPrepopulateFileFormatRule", BrokenRuleSeverity.Error )
		{
			this.fileName = fileName;
			this.rawFile = rawFile;
			this.rawContent = rawContent;
		}

		public ContractPrepopulateFileFormatRule( Stream rawFile, string fileName )
			: base( "ContractPrepopulateFileFormatRule", BrokenRuleSeverity.Error )
		{
			this.rawFile = rawFile;
			this.fileName = fileName;
			ContractPrepopulateFileParser parser = new ContractPrepopulateFileParser( rawFile, this.fileName );
			this.rawContent = parser.ExtractFileData();
		}


		public override bool Validate()
		{
			if( this.rawContent == null )
			{
				this.SetException( "Could not validate Markup File Format." );
				return false;
			}
			ExcelSchemaFormat format = new ExcelSchemaFormat();
			//Deleted some columns in excel as mentioned in 25417
			//format.AddColumns("Sheet1", new List<string>() { "Error", "ContractGroupin", "AccountNumber", "AccountName", "ServiceStreet", "ServiceSuite", "ServiceCity", "ServiceState", "ServiceZip", "ServiceZipPlus4", "BillingStreet", "BillingSuite", "BillingCity", "BillingState", "BillingZip", "BillingZipPlus4", "ContactFirstName", "ContactLastName", "ContactPhoneNumber", "MeterNumber", "NameKey", "BillingAccount", "MDMA", "MSP", "MeterInstaller", "MeterReader", "ScheduleCoordinator", "SalesChannel", "Market", "Utility", "AccountType", "EffectiveStartDate", "ContractDate", "Term", "TransferRate", "ContractRate", "ContractType", "SalesAgent", "IDNumber", "IDType", "ProductType", "ServiceClass", "Zone", "Title", "TaxExempt", "ContractVersion", "Tier","Language","Door-to-Door","Email" });																
			format.AddColumns( "Sheet1", new List<string>() { "Error", "ContractGrouping", "AccountNumber", "AccountName", "ServiceStreet", "ServiceSuite", "ServiceCity", "ServiceState", "ServiceZip", "ServiceZipPlus4", "BillingStreet", "BillingSuite", "BillingCity", "BillingState", "BillingZip", "BillingZipPlus4", "ContactFirstName", "ContactLastName", "ContactPhoneNumber", "NameKey", "BillingAccount", "SalesChannel", "Market", "Utility", "AccountType", "EffectiveStartDate", "ContractDate", "Term", "ContractRate", "SalesAgent", "IDNumber", "IDType", "ProductType", "ServiceClass", "Zone", "Title", "TaxExempt", "Tier", "Language", "Email" } );

			ExcelSchemaRule schemaRule = new ExcelSchemaRule( this.fileName, this.rawContent, format );
			if( !schemaRule.Validate() )
			{
				this.AddDependentException( schemaRule.Exception );
				this.SetException( "could not validate  Contract Prepopulate File Format" );
			}
			return this.Exception == null;
		}
	}
}

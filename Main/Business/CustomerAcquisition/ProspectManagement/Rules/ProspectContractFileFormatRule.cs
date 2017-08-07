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
    [Guid( "0F044F21-ACCE-45b5-909E-4ECF91D7C7FE" )]
    public class ProspectContractFileFormatRule : BusinessRule
    {
        private string fileName;
        private Stream rawFile;
        private DataSet rawContent;

        public ProspectContractFileFormatRule( Stream rawFile, string fileName, DataSet rawContent )
            : base( "ProspectContractFileFormatRule", BrokenRuleSeverity.Error )
        {
            this.fileName = fileName;
            this.rawFile = rawFile;
            this.rawContent = rawContent;
        }

        public ProspectContractFileFormatRule( Stream rawFile, string fileName )
            : base( "ProspectContractFileFormatRule", BrokenRuleSeverity.Error )
        {
            this.rawFile = rawFile;
            this.fileName = fileName;
            ProspectFileParser parser = new ProspectFileParser( rawFile, this.fileName );
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
            format.AddColumns("Sheet1", new List<string>() { "Error", "ContractNumber", "AccountNumber", "AccountName", "ServiceStreet", "ServiceSuite", "ServiceCity", "ServiceState", "ServiceZip", "ServiceZipPlus4", "BillingStreet", "BillingSuite", "BillingCity", "BillingState", "BillingZip", "BillingZipPlus4", "ContactFirstName", "ContactLastName", "ContactPhoneNumber", "MeterNumber", "NameKey", "BillingAccount", "MDMA", "MSP", "MeterInstaller", "MeterReader", "ScheduleCoordinator", "SalesChannel", "Market", "Utility", "AccountType", "EffectiveStartDate", "ContractDate", "Term", "TransferRate", "ContractRate", "ContractType", "SalesAgent", "IDNumber", "IDType", "ProductType", "ServiceClass", "Zone", "Title", "TaxExempt", "ContractVersion", "Tier", "Email", "PromoCode" });																

            ExcelSchemaRule schemaRule = new ExcelSchemaRule( this.fileName, this.rawContent, format );
            if( !schemaRule.Validate() )
            {
                this.AddDependentException( schemaRule.Exception );
                this.SetException( "could not validate Prospect Contract File Format" );
            }
            return this.Exception == null;
        }
    }
}

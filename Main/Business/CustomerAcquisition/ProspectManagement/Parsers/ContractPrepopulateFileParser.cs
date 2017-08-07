using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.IO;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using System.Runtime.InteropServices;
using LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules;
using LibertyPower.Business.CustomerAcquisition.Prospects;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement
{
	[Guid( "634646F7-5509-4E70-9760-49BFFFA809E7" )]
    public class ContractPrepopulateFileParser : BaseFileParser
    {		
        public ContractPrepopulateFileParser( Stream file, string fileName )
            : base( file, fileName )
        {
        }

        public override System.Data.DataSet ExtractFileData()
        {
            DataSet dsFile = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.GetWorkbook( this.rawFile, this.fileName );
            dsFile = this.RemoveEmptyRows( dsFile, true );
            return dsFile;
        }

        public override FileParserResult ValidateFileSchema( System.Data.DataSet fileContent )
        {
            ContractPrepopulateFileFormatRule rule = new ContractPrepopulateFileFormatRule(this.rawFile, this.fileName, fileContent);
			FileParserResult result = new FileParserResult();			
			result.ItemCollection = fileContent;
			if( !rule.Validate() )
			{
				result.Exception = rule.Exception;
			}
			return result;
        }

        public override FileParserResult ValidateAndParseItems( System.Data.DataSet fileContent )
        {
			FileParserResult result = new FileParserResult();
			//// 1- First validate that the data is good:
            ContractPrepopulateDataSetValidation dsValidation = new ContractPrepopulateDataSetValidation(fileContent);
			if( !dsValidation.Validate() )
			{
				result.Exception = dsValidation.Exception;
				result.ItemCollection = null;
			}
			else
			{
				// 2 - Now if data is valid we can populate our custom objects
				List<ProspectContract> lstContracts = ProspectContractFactory.MountContractPrepopulateFromExcel( fileContent, this.UserId );
				result.ItemCollection = lstContracts;
				//BlockEnergyCurveListBusinessValidation busValidation = new BlockEnergyCurveListBusinessValidation( curve );
				//if( !busValidation.Validate() )
				//{
				//    result.Exception = busValidation.Exception;
				//    result.ItemCollection = null;
				//}
			}
			return result;
        }

        public override bool SaveParsedItems( FileParserResult parsedItems )
        {
            throw new NotImplementedException();
        }


    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;
using System.Data;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules
{
    [Guid("5C27D108-2188-4F86-8823-B441F1D7594F")]
	public class ContractPrepopulateDataSetValidation : BusinessRule
	{
		protected DataSet ds;

        public ContractPrepopulateDataSetValidation(DataSet ds)
			: base( "Contract Prepopulate DataSet Validation", BrokenRuleSeverity.Error )
		{
			this.ds = ds;			
		}


		public override bool Validate()
		{
			try
			{
                ContractPrepopulateDataTableValidation bECDataTableValidation = new ContractPrepopulateDataTableValidation(ds.Tables["Sheet1"]);

				if(!bECDataTableValidation.Validate())
				{
					//if(this.Exception != null)
					//	this.SetException( "Exception in Prospect Contract file." );

					if(bECDataTableValidation.Exception != null)
						this.AddDependentException( bECDataTableValidation.Exception );
				}

				return this.Exception == null;
			}
			catch(Exception)
			{				
				throw;
			}			
		}
	}
}

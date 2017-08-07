using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;
using System.Data;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules
{
	[Guid( "FB7A9A92-ED5F-4070-A8A8-D8AE8D0D7FA8" )]
	public class ProspectContractDataSetValidation : BusinessRule
	{
		protected DataSet ds;

		public ProspectContractDataSetValidation( DataSet ds )
			: base( "Prospect Contract DataSet Validation", BrokenRuleSeverity.Error )
		{
			this.ds = ds;			
		}


		public override bool Validate()
		{
			try
			{
				ProspectContractDataTableValidation bECDataTableValidation = new ProspectContractDataTableValidation( ds.Tables["Sheet1"] );

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

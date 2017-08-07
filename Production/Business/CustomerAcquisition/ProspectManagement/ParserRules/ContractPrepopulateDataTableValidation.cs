using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;
using System.Data;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules
{
    [Guid("DA27B050-5B2D-4310-9256-2AAE7B4A2E07")]
	public class ContractPrepopulateDataTableValidation : BusinessRule
	{
		protected DataTable dt;

        public ContractPrepopulateDataTableValidation(DataTable dt)
			: base( "Contract Prepopulate DataTable Validation", BrokenRuleSeverity.Error )
		{
			this.dt = dt;
		}

		public override bool Validate()
		{
			try
			{
				for( int i = 0; i < dt.Columns.Count; i++ )
				{
                    ContractPrepopulateDataRowValidation bECDataRowValidation = new ContractPrepopulateDataRowValidation(dt, i);

					if( !bECDataRowValidation.Validate() )
					{
						//if( this.Exception == null )
							//this.SetException( "Exception in tab Data." ); //describe the error

						if( bECDataRowValidation.Exception != null )
							this.AddDependentException( bECDataRowValidation.Exception );
					}
				}
				return this.Exception == null;
			}
			catch( Exception )
			{
				throw;
			}
		}
	}
}

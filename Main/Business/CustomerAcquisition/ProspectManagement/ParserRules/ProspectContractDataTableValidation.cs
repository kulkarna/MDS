using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;
using System.Data;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules
{
	[Guid( "69911E16-35DA-40e0-8711-34D4F9E407DB" )]
	public class ProspectContractDataTableValidation : BusinessRule
	{
		protected DataTable dt;

		public ProspectContractDataTableValidation( DataTable dt )
			: base( "Prospect Contract DataTable Validation", BrokenRuleSeverity.Error )
		{
			this.dt = dt;
		}

		public override bool Validate()
		{
			try
			{
				for( int i = 0; i < dt.Columns.Count; i++ )
				{
					ProspectContractDataRowValidation bECDataRowValidation = new ProspectContractDataRowValidation( dt, i );

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

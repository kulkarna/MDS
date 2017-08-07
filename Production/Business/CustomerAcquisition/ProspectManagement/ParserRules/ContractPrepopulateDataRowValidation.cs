using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;
using System.Data;
using LibertyPower.Business.CommonBusiness.CommonShared;

namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement.ParserRules
{
    [Guid("93E8353F-77BC-4697-93FB-520C505B66B4")]
	public class ContractPrepopulateDataRowValidation : BusinessRule
	{
		protected DataTable dt;
        protected int columnIndex;

        public ContractPrepopulateDataRowValidation(DataTable dt, int columnIndex)
			: base( "Contract PrePopulate DataRow Validation", BrokenRuleSeverity.Error )
        {
            this.dt = dt;
            this.columnIndex = columnIndex;
        }

        public override bool Validate()
        {		
            // Validate Date column
            //if( columnIndex == ProspectFileParser.DateColumnIndex )
            //Deleted some columns in excel as mentioned in 25417 so all dataset column index has been changed.
			if( columnIndex == 26 )
            {
				//for( int i = ProspectFileParser.DataRowIndex; i < dt.Rows.Count; i++ )
				for( int i = 1; i < dt.Rows.Count; i++ )
                {
                    string aux = "";
					DateTime date = new DateTime();
					DateParsing.ParseDate( dt.Rows[i][columnIndex].ToString(), out date );
                    if (date == new DateTime())
                    {
                        aux = dt.Rows[i][columnIndex].ToString();
                    }
                    else
                    {
                        aux = date.ToString();
                    }
					DataTypeRule curveDateValidator = new DataTypeRule( aux, "datetime", i + 1, "EffectiveStartDate", false );
					
                    if( !curveDateValidator.Validate() )
                    {
						//this.SetException( curveDateValidator.Exception.ToString() );

                        if( curveDateValidator.Exception != null )
                            this.AddDependentException( curveDateValidator.Exception );
                    }
                }
            }
			else if( columnIndex == 27 )
			{
				//for( int i = ProspectFileParser.DataRowIndex; i < dt.Rows.Count; i++ )
				for( int i = 1; i < dt.Rows.Count; i++ )
				{
                    string aux = "";
					DateTime date = new DateTime();
					DateParsing.ParseDate( dt.Rows[i][columnIndex].ToString(), out date );
                    if (date == new DateTime())
                    {
                        aux = dt.Rows[i][columnIndex].ToString();
                    }
                    else
                    {
                        aux = date.ToString();
                    }
					DataTypeRule curveDateValidator = new DataTypeRule( date.ToString(), "datetime", i + 1, "ContractDate", false );

					if( !curveDateValidator.Validate() )
					{
						//this.SetException( curveDateValidator.Exception.ToString() );

						if( curveDateValidator.Exception != null )
							this.AddDependentException( curveDateValidator.Exception );
					}
				}
			}
				
            return this.Exception == null;
        }
	}
}

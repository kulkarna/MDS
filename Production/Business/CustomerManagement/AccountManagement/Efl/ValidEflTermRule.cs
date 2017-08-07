using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	[Guid( "B6A91CBA-6D6C-4985-81E4-060B55DF4AE8" )]
	public class ValidEflTermRule : BusinessRule
	{
		private int term;
		private string accountType;
		private string productId;
		private string process;

		public ValidEflTermRule( int term, string accountType, string productId, string process )
			: base( "Valid Efl Term Rule", BrokenRuleSeverity.Error )
		{
			this.term = term;
			this.accountType = accountType;
			this.productId = productId;
			this.process = process;
		}

		public override bool Validate()
		{
			string format = "";
			string terms = "";
			int singleTerm = 0;
			bool hasValidSpecificTerms = false;

			DataSet ds = EflSql.GetTerms( accountType, productId, process );

			// if specified terms are found, then validate against them.
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					if( terms.Length > 0 )
						terms += ", ";
					terms += dr["Term"].ToString();
					singleTerm = Convert.ToInt32( dr["Term"] );
					if( singleTerm.Equals( term ) )
						hasValidSpecificTerms = true;
				}

				if( !hasValidSpecificTerms )
				{
					format = "-  Invalid term ( {0} ). Term(s) must be {1}";
					this.SetException( String.Format( format, term.ToString(), terms ) );
				}
			}
			else // otherwise validate term against range.
			{
				ds = EflSql.GetEflDataRange();

				if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
				{
					decimal termMin = Convert.ToDecimal( ds.Tables[0].Rows[0]["TermMin"] );
					decimal termMax = Convert.ToDecimal( ds.Tables[0].Rows[0]["TermMax"] );


					if( term < termMin || term > termMax )
					{
						format = "-  Invalid term ( {0} ). Valid range: {1} - {2}.";
						this.SetException( String.Format( format, term.ToString(), termMin.ToString(), termMax.ToString() ) );
					}
				}
				else
					this.SetException( "-  No validation data found for term." );
			}

			return this.Exception == null;
		}

		private bool IsValidDataSet( DataSet ds )
		{
			return ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
		}
	}
}

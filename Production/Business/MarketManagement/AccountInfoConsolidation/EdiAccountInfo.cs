using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class EdiAccountInfo
	{
		public string Message { get; set; }

		/// <summary>
		/// synchronize the account info like zone and profile we got from EDI with the Account table in the libertyPower DB
		/// </summary>
		/// <param name="dtProsseTime">date-time edi data was imported</param>
		/// <returns></returns>
		public bool Synchronize( DateTime dtProsseTime )
		{
			try
			{
				//get all the accounts imported since the processTime
				IEnumerable<Tuple<string, string>> accounts = GetEdiAccounts( dtProsseTime );
				foreach( Tuple<string, string> account in accounts )
				{
					var ad = new AccountData( account.Item1, account.Item2, AccountDataSource.ESource.Edi );
					if( !ad.Synchronize() )
						Message += account.Item1 + @"/" + account.Item2 + ":" + MethodBase.GetCurrentMethod().Name + " - " + ad.Message + @"\r\n";
				}
			}
			catch( Exception ex )
			{
				Message = dtProsseTime.ToString() + ":" + MethodBase.GetCurrentMethod().Name + "-" + ex.Message;
				return false;
			}
			return true;
		}

		private IEnumerable<Tuple<string, string>> GetEdiAccounts( DateTime dtProcessTime )
		{
			try
			{
				var listAccounts = new List<Tuple<string, string>>();
				DataSet ds = TransactionsSql.GetEdiAccounts( dtProcessTime );
				if( DataSetHelper.HasRow( ds ) )
				{
					listAccounts.AddRange( from DataRow dr in ds.Tables[0].Rows select new Tuple<string, string>( dr["AccountNumber"].ToString(), dr["UtilityCode"].ToString() ) );
				}

				return listAccounts;
			}
			catch( Exception )
			{
				return new List<Tuple<string, string>>();
			}

		}

	}
}

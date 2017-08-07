using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser.Mappers
{
	public class DailyControlMapper
	{
		public List<EdiDailyTransaction> MapData( string fileContent )
		{
			List<EdiDailyTransaction> ediDailyTransactionList = mountObject( fileContent );

			return ediDailyTransactionList;
		}

		private List<EdiDailyTransaction> mountObject( string fileContent )
		{
			int count;

			try
			{
				List<EdiDailyTransaction> ediDailyTransactionList = new List<EdiDailyTransaction>();
				EdiDailyTransaction ediDailyTransaction;

				var lines = Regex.Split( fileContent, "\r\n" );

				for( count = 1; count < lines.Length - 1; count++ )
				{
					var columns = Regex.Split( lines[count], "," );

					try
					{

						ediDailyTransaction = new EdiDailyTransaction();
						ediDailyTransaction.DunsNumber = columns[0];
						ediDailyTransaction.AccountNumber = columns[1];
						ediDailyTransaction.TransactionNumber = columns[2];
						ediDailyTransaction.TransactionDate = DateTime.Parse( columns[3] );
						ediDailyTransaction.RequestType = columns[4];
						ediDailyTransaction.TransactionReferenceNumber = columns[5];
						ediDailyTransaction.Direction = columns[6];
						ediDailyTransaction.Tstatus = int.Parse( columns[7] );
						ediDailyTransaction.FileName = columns[8];

						ediDailyTransactionList.Add( ediDailyTransaction );
					}
					catch( Exception )
					{

					}
				}

				return ediDailyTransactionList;
			}
			catch( Exception ex )
			{
				throw ex;
			}
		}
	}
}

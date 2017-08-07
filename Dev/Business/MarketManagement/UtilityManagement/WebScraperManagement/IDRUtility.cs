using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class IDRUtility
	{
		private string utility;

		/// <summary>
		/// create a new instance of IDRUtility for the utility type passed
		/// </summary>
		/// <param name="idrType">utility type: IDR_PECO</param>
		public IDRUtility( string idrType )
		{
			utility = idrType;
		}

		/// <summary>
		/// Ge the latest upload File data for the utility in quesion
		/// </summary>
		/// <returns>Upload date</returns>
		public DateTime GetLatestUploadedDate()
		{
			DateTime lastUploadDate = IDRSQL.IDRAccountsGetUploadDate( utility );
			return lastUploadDate;
		}
	
		/// <summary>
		/// Save the list to a temp location before deleting it from the main table while the process is still running
		/// </summary>
		/// <returns>True if the move was successful</returns>
		public bool MoveAccountsToTempLocation()
		{
			int i = IDRSQL.IDRAccountsTempMove( utility );
			if( i < 0 )
				return false;
			return true;
		}

		/// <summary>
		/// delete all the account from the table: all those deleted accounts will replaced by the new list
		/// </summary>
		/// <returns>True if delete was successfull</returns>
		public bool DeleteAllAccounts()
		{
			int i = IDRSQL.IDRAccountsDelete( utility );
			if( i < 0 )
				return false;
			return true;
		}

		/// <summary>
		/// Delete the data from the temp location (once the process is successful)
		/// </summary>
		/// <returns>True if delete was successful</returns>
		public bool DeleteTempData()
		{
			int i = IDRSQL.IDRAccountsTempDelete( utility );
			if( i < 0 )
				return false;
			return true;
		}


	}
}

using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Exception thrown from the LibertyPower.DataAccess.SqlAccess.UtilityAccountListRequiredFieldsListSql class 
	/// </summary>
	public class MarketParsingSqlException : Exception
	{
		/// <summary>
		/// Description of error
		/// </summary>
		public string ErrorMessage = "";

		/// <summary>
		///  Usage: <c> throw new UtilityAccountListRequiredFieldsListSqlException("Description of exception")</c>
		/// </summary>
		/// <param name="msg">Description of message associated with the exception</param>
		internal MarketParsingSqlException( string msg )
		{
			ErrorMessage = msg;
		}
	}
}
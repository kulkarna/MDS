using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Exception thrown from the LibertyPower.DataAccess.SqlAccess.LibertyPowerSql FileManager class 
	/// </summary>
	public class FileManagerSqlException : Exception
	{
		/// <summary>
		/// Description of error
		/// </summary>
		public string ErrorMessage = "";

		/// <summary>
		///  Usage: <c> throw new FileManagerSqlException("Description of exception")</c>
		/// </summary>
		/// <param name="msg">Description of message associated with the exception</param>
		internal FileManagerSqlException( string msg )
		{
			ErrorMessage = msg;
		}
	}
}
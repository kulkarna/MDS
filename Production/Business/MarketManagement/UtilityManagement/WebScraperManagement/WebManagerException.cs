namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	public class WebManagerException : LibertyPower.Business.BusinessException
	{
		/// <summary>
		/// Description of error
		/// </summary>
		public string ErrorMessage = "";

		/// <summary>
		///  Usage: <c> throw new FileManagerException("Description of exception")</c>
		/// </summary>
		/// <param name="msg">Description of message associated with the exception</param>
		internal WebManagerException( string msg )
		{
			ErrorMessage = msg;
		}
	}
}

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Log insert exception that inherits from Exception
	/// </summary>
	public class LogInsertException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
        public LogInsertException()
            : base()
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
        public LogInsertException(string message)
            : base(message)
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public LogInsertException( string message, Exception innerException )
            : base(message, innerException)
        {
        }
	}
}

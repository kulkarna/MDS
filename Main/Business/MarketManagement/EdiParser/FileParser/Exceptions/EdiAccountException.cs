namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi account exception that inherits from Exception
	/// </summary>
	public class EdiAccountException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
        public EdiAccountException()
            : base()
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
        public EdiAccountException(string message)
            : base(message)
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EdiAccountException( string message, Exception innerException )
            : base(message, innerException)
        {
        }
	}
}

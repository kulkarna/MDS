namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi usage exception that inherits from Exception
	/// </summary>
	public class EdiUsageException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
        public EdiUsageException()
            : base()
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
        public EdiUsageException(string message)
            : base(message)
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EdiUsageException( string message, Exception innerException )
            : base(message, innerException)
        {
        }
	}
}

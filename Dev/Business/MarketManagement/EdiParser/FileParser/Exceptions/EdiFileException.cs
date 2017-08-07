namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi file exception that inherits from Exception
	/// </summary>
	public class EdiFileException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
        public EdiFileException()
            : base()
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
        public EdiFileException(string message)
            : base(message)
        {
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EdiFileException( string message, Exception innerException )
            : base(message, innerException)
        {
        }
	}
}

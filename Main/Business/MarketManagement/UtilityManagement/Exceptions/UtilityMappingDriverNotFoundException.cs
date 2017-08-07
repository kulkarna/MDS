namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;

	public class UtilityMappingDriverNotFoundException : UsageManagementException
	{
		/// <summary>
		/// base()
		/// </summary>
		public UtilityMappingDriverNotFoundException() : base() { }
		/// <summary>
		/// string message) : base(message)
		/// </summary>
		/// <param name="message"></param>
		public UtilityMappingDriverNotFoundException( string message ) : base( message ) { }
		/// <summary>
		/// string message, Exception innerException
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public UtilityMappingDriverNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}

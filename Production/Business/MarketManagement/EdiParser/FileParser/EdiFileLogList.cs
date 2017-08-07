namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi file log list
	/// </summary>
	public class EdiFileLogList : List<EdiFileLog>
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiFileLogList() { }

		/// <summary>
		/// Constructor that takes an ordered enumerable list of edi file logs
		/// and adds them to this class.
		/// </summary>
		/// <param name="logs">Ordered enumerable list of edi file logs</param>
		public EdiFileLogList(IOrderedEnumerable<EdiFileLog> logs)
		{
			foreach( EdiFileLog log in logs )
				this.Add( log );
		}
	}
}

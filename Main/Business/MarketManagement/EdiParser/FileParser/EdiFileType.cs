namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.ComponentModel;

	/// <summary>
	/// Enum for file type
	/// </summary>
	public enum EdiFileType
	{
		/// <summary>
		/// 814
		/// </summary>
		[Description( "814" )]
		EightOneFour,

		/// <summary>
		/// 867
		/// </summary>
		[Description( "867" )]
		EightSixSeven,

		/// <summary>
		/// Status Update
		/// </summary>
		[Description( "Status Update" )]
		StatusUpdate,

		/// <summary>
		/// Daily Control File
		/// </summary>
		[Description( "Daily Control File" )]
		DailyControlFile
	}
}

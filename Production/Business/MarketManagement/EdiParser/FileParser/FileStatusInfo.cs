namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.ComponentModel;

	/// <summary>
	/// File status info enum
	/// </summary>
	public enum FileStatusInfo
	{
		/// <summary>
		/// File In Managed Storage
		/// </summary>
		[Description( "File In Managed Storage" )]
		FileInManagedStorage,

		/// <summary>
		/// File Has One Or More Errors
		/// </summary>
		[Description( "File Has One Or More Errors" )]
		FileHasOneOrMoreErrors,

		/// <summary>
		/// File Reprocessing
		/// </summary>
		[Description( "File Reprocessing" )]
		FileReprocessing,

		/// <summary>
		/// File Successfully Parsed
		/// </summary>
		[Description( "File Successfully Parsed" )]
		FileSuccessfullyParsed,

		/// <summary>
		/// 814 File
		/// </summary>
		[Description( "814 File" )]
		FileEightOneFour,

		/// <summary>
		/// Status Update File
		/// </summary>
		[Description( "Status Update File" )]
		FileStatusUpdate
	}
}

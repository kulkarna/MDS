namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Text.RegularExpressions;

	/// <summary>
	/// Determines if file is 814 or 867
	/// </summary>
	public static class FileTypeDiscoverer
	{
		/// <summary>
		/// Determines the edi file type
		/// </summary>
		/// <param name="fileContent">Content of file</param>
		/// <param name="delimiter">Character delimiter</param>
		/// <returns>Returns an edi file type enum</returns>
		public static EdiFileType GetFileType( ref string fileContent, char delimiter )
		{
			string pattern = @"ST\" + delimiter + @"814";

			Regex r = new Regex( pattern );

			// Match the pattern within the file content.
			Match m = r.Match( fileContent );

			if( m.Success )
				return EdiFileType.EightOneFour;
			else
			{
				pattern = @"BPT\" + delimiter + @"SU";

				r = new Regex( pattern );

				// Match the pattern within the file content.
				m = r.Match( fileContent );

				if( m.Success )
					return EdiFileType.StatusUpdate;
			}
			return EdiFileType.EightSixSeven;
		}
	}
}

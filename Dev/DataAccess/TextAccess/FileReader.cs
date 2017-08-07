using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace LibertyPower.DataAccess.TextAccess
{
	/// <summary>
	/// File reader
	/// </summary>
	public static class FileReader
	{
		/// <summary>
		/// Reads contents of specified file returned as a string
		/// </summary>
		/// <param name="file"></param>
		/// <returns></returns>
		public static string Read( string file )
		{
			using( StreamReader reader = new StreamReader( file ) )
			{
				string fileContents = reader.ReadToEnd();
				return fileContents;
			}
		}
	}
}

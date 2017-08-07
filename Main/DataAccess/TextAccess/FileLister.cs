namespace LibertyPower.DataAccess.TextAccess
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.IO;

	/// <summary>
	/// Class for file related methods
	/// </summary>
	public static class FileLister
	{
		/// <summary>
		/// Gets a file from specified directory.
		/// </summary>
		/// <param name="directoryPath">Directory path</param>
		/// <returns>Returns a file from specified directory.</returns>
		public static string GetFile( string directoryPath )
		{
			string[] files = Directory.GetFiles( directoryPath );
			string file = "";

			foreach( string f in files )
			{
				if( !f.Contains( ".log" ) )
				{
					file = f;
					break;
				}
			}

			return file;
		}
	}
}

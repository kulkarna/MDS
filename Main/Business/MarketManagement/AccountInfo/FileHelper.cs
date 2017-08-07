using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	internal static class FileHelper
	{
		/// <summary>
		/// Delete files from a directory
		/// </summary>
		/// <param name="dir">directory to delete the files from</param>
		/// <param name="pattern">search pattern to look up for files to be deleted</param>
		/// <returns>true if success</returns>
		internal static bool DeleteFilesFromDir( string dir, string pattern )
		{
			try
			{
				Array.ForEach( Directory.GetFiles( dir, pattern ),
						delegate( string path ) { File.Delete( path ); } );

				return true;
			}
			catch
			{
				return false;
			}
		}

		/// <summary>
		/// delete a file
		/// </summary>
		/// <param name="filePath">path of the file to be deleted</param>
		/// <returns>true if success</returns>
		internal static bool DeleteFile( string filePath )
		{
			try
			{
				if (File.Exists(filePath))
					File.Delete( filePath );
				return true;
			}
			catch
			{
				return false;
			}
		}

		/// <summary>
		/// check if a file exists
		/// </summary>
		/// <param name="filePath">file to look for </param>
		/// <returns>true if file exists</returns>
		internal static bool FileExists( string filePath )
		{
			try
			{
				return File.Exists( filePath );
			}
			catch
			{
				return false;
			}
		}

		/// <summary>
		/// Create a directory
		/// </summary>
		/// <param name="dirPath">directory path to create</param>
		internal static void DirectotyCreate( string dirPath )
		{
			DirectoryInfo d = new DirectoryInfo( dirPath );
			if( !d.Exists )
				d.Create();
		}
	}
}

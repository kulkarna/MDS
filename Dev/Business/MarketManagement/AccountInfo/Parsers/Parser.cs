using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public abstract class Parser
	{
		/// <summary>
		/// unzip path
		/// </summary>
		public string UnzipPath;

		/// <summary>
		/// extension of the unzipped files
		/// </summary>
		public string UnzipExt;

		protected Dictionary<int, ColumnTypes> dColumnTypes;
		protected DataTable dtData;

		/// <summary>
		/// parse the files
		/// </summary>
		/// <param name="fileLogs">list of the files to parse</param>
		/// <param name="Message">Error Message</param>
		public bool ParseFiles( List<FileLog> fileLogs, out string Message )
		{
			
			Message = string.Empty;
			//sort the list of the files to be sorted by the load date: older files should be parsed first
			//var sorted = from item in dFiles orderby item.Value ascending select item.Key;
			var sorted = from item in fileLogs orderby item.LoadDate ascending select item;
			if( sorted.Count().Equals( 0 ) )
			{
				Message = this.GetType().Name + ": Error parsing files: There are no files to parse";
				AccountInfoFacotry.Errors.Add( Message );
				return false;
			}

			//define columns
			DefineColumns();

			//Create dataTable
			DefineDataTable();

			//parse files
			foreach( FileLog item in sorted )
			{
				string fullName = UnzipPath + @"\" + item.FileName;
				if (!item.FileName.EndsWith(UnzipExt))
					AccountInfoFacotry.LogFileStatus(item.ID, "File is not in the correct format (" + UnzipExt + ")", 0);
				else
				{
					bool bSuccess = ParseFile(item.ID, fullName);
					if (!bSuccess)
						AccountInfoFacotry.LogFileStatus( item.ID, "System could not parse the file", 0 );
				}
				if (!FileHelper.DeleteFile( fullName ))
					AccountInfoFactory.LogFileStatus( item.ID, "Error deleting file after processing", 0 );
			}
			/*foreach( KeyValuePair<string, DateTime> item in dFiles.OrderBy( key => key.Value ) )
			{                 // do something with item.Key and item.Value      
				string sss = item.Key;
			}*/
			Message = this.GetType().Name + ": Files parsed successfully.";
			return true;
	}

		/// <summary>
		/// parse one file
		/// </summary>
		/// <param name="id">id of the file (fileLog)</param>
		/// <param name="fullFileName">full file name</param>
		/// <returns>true if successful</returns>
		protected abstract bool ParseFile( int id, string fullFileName );

		/// <summary>
		/// define the columns that needs to be parsed for each report type
		/// </summary>
		/// <returns>true if successful</returns>
		protected abstract bool DefineColumns();

		/// <summary>
		/// create the datatable that will hold the data parsed
		/// </summary>
		/// <returns>true if successful</returns>
		protected bool DefineDataTable()
		{
			dtData = new DataTable();

			DataColumn dcData;
			foreach( KeyValuePair<int, ColumnTypes> item in dColumnTypes )
			{
				ColumnTypes col = (ColumnTypes) item.Value;
				dcData = new DataColumn(col.MapTo,typeof(string));
				dcData.AllowDBNull = col.AllNulls;
				dcData.MaxLength = col.MaxLength;
				dtData.Columns.Add( dcData );
			}

			//add the file log ID
			dcData = new DataColumn( "FileLogID", typeof( int) );
			dtData.Columns.Add( dcData );

			return true;
		}
	}

}

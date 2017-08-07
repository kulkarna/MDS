namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
	using LibertyPower.DataAccess.TextAccess;

	/// <summary>
	/// Class for processing utility file data
	/// </summary>
	public static class Processor
	{
		// November 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Some Utilities come with 814's and 867's combined into 1 file
		/// </summary>
		/// <param name="original">Original Stream</param>
		/// <param name="eightSixSeven">867 Stream</param>
		/// <param name="eightOneFour">814 Strem</param>
		/// <param name="fieldDlmt">Utility field delimiter</param>
		/// <param name="rowDlmtr">Utility row delimiter</param>
		public static void breakTransactionTypes( ref string original, ref string eightSixSeven, ref string eightOneFour, char fieldDlmt, char rowDlmtr )
		{
			string[] source = original.Split( new char[] { rowDlmtr }, StringSplitOptions.None );

			var matchQuery = from word in source
							 where word.Contains( "ST" + fieldDlmt + "8" )
							 select word;

			int cnt = matchQuery.Count();

			// store tail ;-)
			original = original.Replace( "IEA*2", "IEA*1" );					// UGI
			original = original.Replace( "IEA*3", "IEA*1" );					// SD22486
			original = original.Replace( "IEA*4", "IEA*1" );
			int indx = original.IndexOf( "IEA*1" );
			int indx2 = original.IndexOf( rowDlmtr, indx );
			string tail = original.Substring( indx, indx2 - indx );

			// store header
			indx = original.IndexOf( "ST" + fieldDlmt + "8" );
			indx2 = indx;
			string header = original.Substring( 0, indx );

			// loop through records
			for( int records = 1; records <= cnt; records += 1 )
			{
				// get me the "file" type (814/867)
				string recordType = original.Substring( indx, 6 );
				indx2 = original.IndexOf( "ST" + fieldDlmt + "8", indx2 + 1 );

				if( indx2 == -1 )												// last record
					indx2 = original.IndexOf( "IEA*1", original.Length - 25 );	// some files contain 2 end-of-file markers..

				if( recordType == "ST" + fieldDlmt + "814" )
				{
					if( eightOneFour == "" )
						eightOneFour = header;

					eightOneFour += original.Substring( indx, indx2 - indx );
				}
				else
				{
					if( eightSixSeven == "" )
						eightSixSeven = header;

					eightSixSeven += original.Substring( indx, indx2 - indx );
				}

				indx = indx2;													// move pointer
			}

			if( eightOneFour != "" )
				eightOneFour += tail;

			if( eightSixSeven != "" )
				eightSixSeven += tail;

		}

			}

			}


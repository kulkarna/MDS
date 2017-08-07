using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using LumenWorks.Framework.IO.Csv;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class ParserReport : Parser
	{
		/// <summary>
		/// parse the reports depending on a third party dll that parses csv files
		/// </summary>
		/// <param name="id">id of the file to parse</param>
		/// <param name="fullFileName">name of hte file to parse</param>
		/// <returns>true if successfull</returns>
		protected override bool ParseFile( int id, string fullFileName )
		{
			int rowNumber = 0;
			int validRowNumber = 0;
			int invalidRowNumber = 0;
			const int THRESHOLD = 10000; //number of records to insert at once
			try
			{
				AccountInfoFactory.LogFileStatus( id, "Parsing", 2 );

				using( CsvReader csv = new CsvReader( new StreamReader( fullFileName ), false ) )
				{
					int fieldCount = csv.FieldCount;
					//string[] headers = csv.GetFieldHeaders();

					while( csv.ReadNextRecord() )
					{
						DataRow drData = dtData.NewRow();
						bool isValidRow = true;

						for( int i = 0; i < fieldCount; i++ )
						{
							Column col = new Column { Value = csv[i], RowNumber = csv.CurrentRecordIndex, Type = dColumnTypes[i] };
							if( col.Type.MapTo.Equals( "ESIID" ) )
							{
								if( IsDuplicateValue( col ) )
								{
									invalidRowNumber++;
									isValidRow = false;
									AccountInfoFactory.LogAccountStatus( id, "ESSIID '" + col.Value + "' already exists in the file" );
									break;
								}
							}
							col.Validate();
							if( !col.IsValid )
							{
								invalidRowNumber++;
								isValidRow = false;
								AccountInfoFactory.LogAccountStatus( id, col.Msg );
								break;
							}
							drData[col.Type.MapTo] = col.Value;
						}
						if( isValidRow )
						{
							validRowNumber++;
							//map the fileLogID
							drData["FileLogID"] = id;
							dtData.Rows.Add( drData );
						}

						rowNumber++;

						//insert the data in the DB for ever THRESHOLD records or else the insert statement will take forever to run
						if( rowNumber == THRESHOLD && validRowNumber > 0 )
						{
							if( !InsertData( id, fullFileName ) )
								return false;
							rowNumber = 0;
						}
					}
					if( rowNumber > 0 && validRowNumber > 0 )
					{
						if( !InsertData( id, fullFileName ) )
							return false;
					}
				}
			}
			catch( Exception ex )
			{
				AccountInfoFactory.LogFileStatus( id, "Parsing failed: " + ex.Message, 0 );
				AccountInfoFactory.Errors.Add( "File " + fullFileName + " (id=" + id.ToString() + ") failed to parse: " + ex.Message );
				return false;
			}
			if( invalidRowNumber > 0 )
				AccountInfoFactory.LogFileStatus( id, "Parsed successfully, but the file has " + invalidRowNumber.ToString() + " invalid rows.", 1 );
			else
				AccountInfoFactory.LogFileStatus( id, "Parsed successfully", 1 );

			return true;
		}

		private bool InsertData( int id, string fullFileName )
		{
			string msg = string.Empty;
			bool bInsert = AccountInfoFactory.InsertAccounts( dtData, out msg );
			dtData.Clear();
			if( !bInsert )
			{
				AccountInfoFactory.LogFileStatus( id, "Parsing failed: " + msg, 0 );
				AccountInfoFactory.Errors.Add( "File " + fullFileName + " (id=" + id.ToString() + ") failed to parse: " + msg );
				return false;
			}
			return true;
		}

		/// <summary>
		/// define the columns needed to be imported
		/// </summary>
		/// <returns>true if sucessful</returns>
		protected override bool DefineColumns()
		{
			dColumnTypes = new Dictionary<int, ColumnTypes>();
			dColumnTypes.Add( 0, new ColumnTypes { Index = 0, AllNulls = false, MaxLength = 100, MapTo = "ESIID" } );
			dColumnTypes.Add( 1, new ColumnTypes { Index = 1, AllNulls = false, MaxLength = 200, MapTo = "ADDRESS" } );
			dColumnTypes.Add( 2, new ColumnTypes { Index = 2, AllNulls = true, MaxLength = 100, MapTo = "ADDRESS_OVERFLOW" } );
			dColumnTypes.Add( 3, new ColumnTypes { Index = 3, AllNulls = false, MaxLength = 50, MapTo = "CITY" } );
			dColumnTypes.Add( 4, new ColumnTypes { Index = 4, AllNulls = false, MaxLength = 10, MapTo = "STATE" } );
			dColumnTypes.Add( 5, new ColumnTypes { Index = 5, AllNulls = false, MaxLength = 30, MapTo = "ZIPCODE" } );
			dColumnTypes.Add( 6, new ColumnTypes { Index = 6, AllNulls = false, MaxLength = 30, MapTo = "DUNS" } );
			dColumnTypes.Add( 7, new ColumnTypes { Index = 7, AllNulls = true, MaxLength = 30, MapTo = "METER_READ_CYCLE" } );
			dColumnTypes.Add( 8, new ColumnTypes { Index = 8, AllNulls = true, MaxLength = 30, MapTo = "STATUS" } );
			dColumnTypes.Add( 9, new ColumnTypes { Index = 9, AllNulls = true, MaxLength = 30, MapTo = "PREMISE_TYPE" } );
			dColumnTypes.Add( 10, new ColumnTypes { Index = 10, AllNulls = true, MaxLength = 30, MapTo = "POWER_REGION" } );
			dColumnTypes.Add( 11, new ColumnTypes { Index = 11, AllNulls = false, MaxLength = 64, MapTo = "STATIONCODE" } );
			dColumnTypes.Add( 12, new ColumnTypes { Index = 12, AllNulls = false, MaxLength = 64, MapTo = "STATIONNAME" } );
			dColumnTypes.Add( 13, new ColumnTypes { Index = 13, AllNulls = true, MaxLength = 10, MapTo = "METERED" } );
			dColumnTypes.Add( 14, new ColumnTypes { Index = 14, AllNulls = true, MaxLength = 2000, MapTo = "OPEN_SERVICE_ORDERS" } );
			dColumnTypes.Add( 15, new ColumnTypes { Index = 15, AllNulls = true, MaxLength = 30, MapTo = "POLR_CUSTOMER_CLASS" } );
			dColumnTypes.Add( 16, new ColumnTypes { Index = 16, AllNulls = true, MaxLength = 1, MapTo = "AMS_METER_FLAG" } );
			dColumnTypes.Add( 17, new ColumnTypes { Index = 17, AllNulls = true, MaxLength = 10, MapTo = "TDSP_AMS_INDICATOR" } );
			dColumnTypes.Add( 18, new ColumnTypes { Index = 18, AllNulls = false, MaxLength = 1, MapTo = "SWITCH_HOLD_INDICATOR" } );
			return true;
		}

		private bool IsDuplicateValue( Column col )
		{
			if( col.Type.MapTo.Equals( "ESIID" ) )
			{
				DataRow[] dups = dtData.Select( "ESIID='" + col.Value + "'" );
				if( dups.Any() )
					return true;
			}
			return false;
		}
	}
}

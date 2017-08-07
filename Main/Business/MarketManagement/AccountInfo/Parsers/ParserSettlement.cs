using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;

using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.WorkbookAccess;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class ParserSettlement : Parser
	{
		/// <summary>
		/// parse the settlemt reports
		/// </summary>
		/// <param name="id">id of the file to parsed</param>
		/// <param name="fullFileName">name of the file to be parsed</param>
		/// <returns>true if successful</returns>
		protected override bool ParseFile( int id, string fullFileName )
		{
			//settelment report is an excel file. create an OLEDB connection to parse it
			//OleDbConnection con = new OleDbConnection( "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullFileName + ";Extended Properties=Excel 8.0" );
			try
			{
				//con.Open();
				//Create Dataset and fill with imformation from the Excel Spreadsheet for easier reference
				//OleDbDataAdapter myCommand = new OleDbDataAdapter( " SELECT * FROM [" + listname + "$]", con );
				//myCommand.Fill( myDataSet );

				DataTable myDataTable = ExcelAccess.DataTableFromWorksheetEx(fullFileName, "Settlement_Points", true, true);

				AccountInfoFacotry.LogFileStatus(id, "Parsing", 2);
				if (myDataTable == null || myDataTable.Rows.Count.Equals(0))
					return false;

				DataColumnCollection dataCols = myDataTable.Columns;
				//validate the data
				int rowNumber = 0;
				foreach (DataRow dr in myDataTable.Rows)
				{
					rowNumber++;

					DataRow drData = dtData.NewRow();
					bool isValidRow = true;

					foreach (DataColumn dataCol in dataCols)
					{
						var colType = from c in dColumnTypes.Values where c.MapTo == dataCol.ColumnName select c;
									  /*select new ColumnTypes{ 
										  AllNulls = c.AllNulls, MapTo=c.MapTo, Index = c.Index, MaxLength = c.MaxLength
									  };*/
						ColumnTypes ct = null;
						foreach (ColumnTypes c in colType)
							ct = c;

						Column col = new Column {Value = dr[dataCol].ToString(), RowNumber = rowNumber, Type = ct};
						col.Validate();
						if (!col.IsValid)
						{
							isValidRow = false;
							AccountInfoFactory.LogAccountStatus( id, col.Msg );
							break;
						}
						drData[col.Type.MapTo] = col.Value;
					}
					if (isValidRow)
					{
						//map the fileLogID
						drData["FileLogID"] = id;
						dtData.Rows.Add(drData);
					}
				}
				bool bSuccess = AccountInfoFactory.InsertSettlement(dtData);
				dtData.Clear();
				if (bSuccess)
				{
					AccountInfoFacotry.LogFileStatus(id, "Parsed successfully", 1);
					return true;
				}

				AccountInfoFacotry.LogFileStatus( id, "Parsing failed", 0 );
				return false;
			}
			catch( Exception ex )
			{
				AccountInfoFactory.LogFileStatus( id, "Parsing failed: " + ex.Message, 0 );
				return false;
			}
			//finally
			//{
			//	con.Close();
			//}
		}

		/// <summary>
		/// define the columns needed to parse
		/// </summary>
		/// <returns>true if successful</returns>
		protected override bool DefineColumns()
		{
			dColumnTypes = new Dictionary<int, ColumnTypes>();
			dColumnTypes.Add( 0, new ColumnTypes { Index = 0, AllNulls = false, MaxLength = 200, MapTo = "ELECTRICAL_BUS" } );
			dColumnTypes.Add( 1, new ColumnTypes { Index = 1, AllNulls = false, MaxLength = 200, MapTo = "NODE_NAME" } );
			dColumnTypes.Add( 2, new ColumnTypes { Index = 2, AllNulls = true, MaxLength = 200, MapTo = "PSSE_BUS_NAME" } );
			dColumnTypes.Add( 3, new ColumnTypes { Index = 3, AllNulls = true, MaxLength = 200, MapTo = "VOLTAGE_LEVEL" } );
			dColumnTypes.Add( 4, new ColumnTypes { Index = 4, AllNulls = false, MaxLength = 64, MapTo = "SUBSTATION" } );
			dColumnTypes.Add( 5, new ColumnTypes { Index = 5, AllNulls = false, MaxLength = 200, MapTo = "SETTLEMENT_LOAD_ZONE" } );
			dColumnTypes.Add( 6, new ColumnTypes { Index = 6, AllNulls = true, MaxLength = 200, MapTo = "RESOURCE_NODE" } );
			dColumnTypes.Add( 7, new ColumnTypes { Index = 7, AllNulls = true, MaxLength = 200, MapTo = "HUB_BUS_NAME" } );
			dColumnTypes.Add( 8, new ColumnTypes { Index = 8, AllNulls = true, MaxLength = 200, MapTo = "HUB" } );
			dColumnTypes.Add( 9, new ColumnTypes { Index = 9, AllNulls = true, MaxLength = 200, MapTo = "PSSE_BUS_NUMBER" } );
			return true;
		}
	}
}


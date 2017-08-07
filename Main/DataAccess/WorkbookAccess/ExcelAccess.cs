namespace LibertyPower.DataAccess.WorkbookAccess
{
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using System.Data;
	using System.IO;
	using System.Linq;
	using System.Text;
	using Infragistics = Infragistics.Documents.Excel;
	using Aspose = Aspose.Cells;
	using System.Drawing.Imaging;


	/// <summary>
	/// Retrieves information and data from an Excel 8.0 file.
	/// </summary>
	public static class ExcelAccess
	{
		#region Methods

		#region Obsolete

		/// <summary>
		/// Gets data from an Excel workbook file using Infragistics.
		/// </summary>
		/// <param name="filePath">The pathname of the Excel file to read.</param>
		/// <returns>A DataSet object containing data retrieved from the
		/// Excel file specified.</returns>
		[Obsolete( "Refactor to Ex version" )]
		public static DataSet GetWorkbook( string filePath )
		{
			DataSet ds = null;

			using( FileStream fileStream = new FileStream( filePath, FileMode.Open, FileAccess.Read ) )
			{
				string fileName = System.IO.Path.GetFileName( filePath );
				ds = GetWorkbook( fileStream, fileName );
			}
			return ds;
		}

		/// <summary>
		/// Gets data from an Excel workbook file using Infragistics.
		/// </summary>
		/// <param name="stream">The stream.</param>
		/// <param name="fileName">Name of the file.</param>
		/// <returns>
		/// A DataSet object containing data retrieved from the
		/// Excel file specified.
		/// </returns>
		[Obsolete( "Refactor to Ex version" )]
		public static DataSet GetWorkbook( Stream stream, string fileName )
		{
			string fileExtension = System.IO.Path.GetExtension( fileName );
			if( CheckExtension( fileExtension ) == true )
				return DataSetFromExcel( stream );
			else
				return null;
		}

		/// <summary>
		/// Converts excel file to a dataset, inflating Excel's sparse array format to a DataSet  containing null padded datatables
		/// </summary>
		/// <param name="FileName">Name of the file.</param>
		/// <returns></returns>
		[Obsolete( "Refactor to Ex version" )]
		private static DataSet DataSetFromExcel( string FileName )
		{
			try
			{
				DataSet ds = new DataSet();

				// Deserialize the Workbook from an .XLS file.
				Infragistics.Workbook b = Infragistics.Workbook.Load( FileName );
				b.CellReferenceMode = Infragistics.CellReferenceMode.A1;

				// Parse each Worksheet into a DataTable.
				foreach( Infragistics.Worksheet w in b.Worksheets )
				{
					Int32 numberOfColumns = DetermineControllingWidth( w );
					Int32 numberOfRows = DetermineControllingHeight( w );

					//discard empty worksheets
					if( numberOfColumns > 0 && numberOfRows > 0 )
					{
						//one table per worksheet
						DataTable table = new DataTable( w.Name );
						ds.Tables.Add( table );

						// inflate table to proper 2 dimensions - width
						for( int i = 0; i < numberOfColumns; i++ )
						{
							table.Columns.Add( new DataColumn( i.ToString() ) );
						}

						// inflate table to proper 2 dimensions - height
						for( int i = 0; i < numberOfRows; i++ )
						{
							object[] cellList = new object[table.Columns.Count];
							table.Rows.Add( cellList.ToArray() );
						}

						//map worksheet values to proper cells in fully inflated data table
						foreach( Infragistics.WorksheetRow worksheetRow in w.Rows )
						{
							foreach( Infragistics.WorksheetCell cell in worksheetRow.Cells )
							{
								if( cell.Value != null )
								{
									object o = cell.Value;
									string columnName = ExcelAccess.ParseColumnName( cell.ToString() );
									Int32 columnIndex = ExcelAccess.ConvertColumnNameToInt32( columnName ) - 1;
									table.Rows[cell.RowIndex][columnIndex] = o;

								}
							}
						}
					}
				}
				// Worksheet

				return ds;
			}
			catch( Exception )
			{
				throw;
			}
		}

		/// <summary>
		/// Datas the table from worksheet.
		/// </summary>
		/// <param name="worksheet">The worksheet.</param>
		/// <returns></returns>
		[Obsolete( "Refactor to Ex version" )]
		public static DataTable DataTableFromWorksheet( Infragistics.Worksheet worksheet )
		{
			DataTable table = null;

			var numberOfColumns = DetermineControllingWidth( worksheet );
			var numberOfRows = DetermineControllingHeight( worksheet );

			//discard empty worksheets
			if( numberOfColumns > 0 && numberOfRows > 0 )
			{
				//one table per worksheet
				table = new DataTable( worksheet.Name );

				// inflate table to proper 2 dimensions - width
				for( int i = 0; i < numberOfColumns; i++ )
				{
					table.Columns.Add( new DataColumn( i.ToString() ) );
				}

				// inflate table to proper 2 dimensions - height
				for( int i = 0; i < numberOfRows; i++ )
				{
					object[] cellList = new object[table.Columns.Count];
					table.Rows.Add( cellList.ToArray() );
				}

				//map worksheet values to proper cells in fully inflated data table
				foreach( var worksheetRow in worksheet.Rows )
				{
					foreach( var cell in worksheetRow.Cells )
					{
						if( cell.Value != null )
						{
							object o = cell.Value;
							var columnName = ExcelAccess.ParseColumnName( cell.ToString() );
							var columnIndex = ExcelAccess.ConvertColumnNameToInt32( columnName ) - 1;
							table.Rows[cell.RowIndex][columnIndex] = o;
						}
					}
				}
			}

			return table;
		}

		/// <summary>
		/// Converts excel file to a dataset, inflating Excel's sparse array format to a DataSet containing null padded datatables
		/// </summary>
		/// <param name="stream">The stream.</param>
		/// <returns></returns>
		[Obsolete( "Refactor to Ex version" )]
		private static DataSet DataSetFromExcel( Stream stream )
		{
			DataSet ds = new DataSet();

			// Deserialize the Workbook from an .XLS file.
			Infragistics.Workbook b = Infragistics.Workbook.Load( stream );
			b.CellReferenceMode = Infragistics.CellReferenceMode.A1;

			// Parse each Worksheet into a DataTable.
			foreach( Infragistics.Worksheet w in b.Worksheets )
			{
				Int32 numberOfColumns = DetermineControllingWidth( w );
				Int32 numberOfRows = DetermineControllingHeight( w );

				//discard empty worksheets
				if( numberOfColumns > 0 && numberOfRows > 0 )
				{
					//one table per worksheet
					DataTable table = new DataTable( w.Name );
					ds.Tables.Add( table );

					// inflate table to proper 2 dimensions - width
					for( int i = 0; i < numberOfColumns; i++ )
					{
						table.Columns.Add( new DataColumn( i.ToString() ) );
					}

					// inflate table to proper 2 dimensions - height
					for( int i = 0; i < numberOfRows; i++ )
					{
						object[] cellList = new object[table.Columns.Count];
						table.Rows.Add( cellList.ToArray() );
					}

					//map worksheet values to proper cells in fully inflated data table
					foreach( Infragistics.WorksheetRow worksheetRow in w.Rows )
					{
						foreach( Infragistics.WorksheetCell cell in worksheetRow.Cells )
						{
							if( cell.Value != null )
							{
								object o = cell.Value;
								string columnName = ExcelAccess.ParseColumnName( cell.ToString() );
								Int32 columnIndex = ExcelAccess.ConvertColumnNameToInt32( columnName ) - 1;
								table.Rows[cell.RowIndex][columnIndex] = o;
							}
						}
					}
				}
			}
			// Worksheet

			return ds;
		}

		/// <summary>
		/// Determines the controlling height (as number of rows) of an excel worksheet
		/// </summary>
		/// <param name="ws">The ws.</param>
		/// <returns></returns>
		[Obsolete( "Refactor to Ex version" )]
		private static Int32 DetermineControllingHeight( Infragistics.Worksheet ws )
		{
			Int32 height = 0;
			for( Int32 i = 0; i < ws.Rows.Count(); i++ )
			{
				if( ws.Rows[i].Cells.Count() > 0 )
					height = i;
			}
			return height + 1;
		}

		/// <summary>
		/// Determines the width populated portion of a worksheet;  for example a worksheet with a 
		/// single value in cell Sheet1!$C$5 would have a controlling width of 3
		/// </summary>
		/// <param name="ws">The ws.</param>
		/// <returns></returns>
		/// 
		[Obsolete( "Refactor to Ex version" )]
		private static Int32 DetermineControllingWidth( Infragistics.Worksheet ws )
		{
			Int32 width = 0;
			for( Int32 i = 0; i < ws.Rows.Count(); i++ )
			{
				foreach( Infragistics.WorksheetCell cell in ws.Rows[i].Cells )
				{
					string columnName = ExcelAccess.ParseColumnName( cell.ToString() );
					int columnIndex = ExcelAccess.ConvertColumnNameToInt32( columnName );
					width = columnIndex > width && cell.Value != null ? columnIndex : width;
				}
			}
			return width;
		}

		#endregion

		#region Public

		/// <summary>
		/// Extract a region from a source DataTable and return a new DataTable with the DataColumn names equals to the header, if had it.
		/// </summary>
		/// <param name="headerInTopRow"></param>
		/// <param name="topLeftRowIndex"></param>
		/// <param name="topLeftColumnIndex"></param>
		/// <param name="bottomRightRowIndex"></param>
		/// <param name="bottomRightColumnIndex"></param>
		/// <param name="sourceDataTable"></param>
		/// <returns></returns>
		public static DataTable ExtractRegion( bool headerInTopRow, int topLeftRowIndex, int topLeftColumnIndex, int bottomRightRowIndex, int bottomRightColumnIndex, DataTable sourceDataTable )
		{
			return ExtractRegion( headerInTopRow, topLeftRowIndex, topLeftColumnIndex, bottomRightRowIndex, bottomRightColumnIndex, sourceDataTable, true );
		}

		/// <summary>
		/// Extract a region from a source DataTable and return a new DataTable with the DataColumn names equals to the header, if had it.
		/// </summary>
		/// <param name="headerInTopRow"></param>
		/// <param name="topLeftRowIndex"></param>
		/// <param name="topLeftColumnIndex"></param>
		/// <param name="bottomRightRowIndex"></param>
		/// <param name="bottomRightColumnIndex"></param>
		/// <param name="sourceDataTable"></param>
		/// <param name="stripColumnNameSpacesDashes"></param>
		/// <returns></returns>
		public static DataTable ExtractRegion( bool headerInTopRow, int topLeftRowIndex, int topLeftColumnIndex, int bottomRightRowIndex, int bottomRightColumnIndex, DataTable sourceDataTable, bool stripColumnNameSpacesDashes )
		{
			DataTable table = null;

			if( stripColumnNameSpacesDashes )
			{
				table = new DataTable( sourceDataTable.TableName.Replace( " ", "" ).Replace( "-", "" ) );
			}
			else
			{
				table = new DataTable( sourceDataTable.TableName );
			}

			Int32 numberOfRows = 0;
			Int32 numberOfColumns = 0;

			if( headerInTopRow )
			{
				#region extents

				numberOfRows = (bottomRightRowIndex - topLeftRowIndex);
				numberOfColumns = (bottomRightColumnIndex - topLeftColumnIndex) + 1;

				#endregion

				#region columns

				for( Int32 c = 0; c < numberOfColumns; c++ )
				{
					string columnName;

					int r2 = topLeftRowIndex;
					int c2 = topLeftColumnIndex + c;

					object o = null;

					if( sourceDataTable.Rows.Count > r2 && sourceDataTable.Columns.Count > c2 )
					{
						o = sourceDataTable.Rows[r2][c2];
					}

					if( o != null )
					{
						if( stripColumnNameSpacesDashes )
						{
							columnName = o.ToString().Replace( " ", "" ).Replace( "-", "" );
						}
						else
						{
							columnName = o.ToString();
						}
					}
					else
					{
						columnName = " ";
					}

					table.Columns.Add( new DataColumn( columnName ) );
				}

				#endregion

				#region rows

				for( Int32 r = 0; r < numberOfRows; r++ )
				{
					table.Rows.Add( table.NewRow() );
					for( Int32 c = 0; c < numberOfColumns; c++ )
					{
						int r2 = topLeftRowIndex + r + 1;
						int c2 = topLeftColumnIndex + c;

						object o = null;

						if( sourceDataTable.Rows.Count > r2 && sourceDataTable.Columns.Count > c2 )
							o = sourceDataTable.Rows[r2][c2];

						table.Rows[r][c] = o;
					}
				}

				#endregion

			}
			else
			{
				#region extents

				numberOfRows = (bottomRightRowIndex - topLeftRowIndex) + 1;
				numberOfColumns = (bottomRightColumnIndex - topLeftColumnIndex) + 1;

				#endregion

				#region columns

				for( Int32 c = 0; c < numberOfColumns; c++ )
					table.Columns.Add( new DataColumn() );

				#endregion

				#region rows

				for( Int32 r = 0; r < numberOfRows; r++ )
				{
					table.Rows.Add( table.NewRow() );
					for( Int32 c = 0; c < numberOfColumns; c++ )
					{
						int r2 = topLeftRowIndex + r;
						int c2 = topLeftColumnIndex + c;

						object o = null;

						if( sourceDataTable.Rows.Count > r2 && sourceDataTable.Columns.Count > c2 )
							o = sourceDataTable.Rows[r2][c2];

						table.Rows[r][c] = o;
					}
				}

				#endregion

			}

			return table;
		}

		/// <summary>
		/// Creates a Memory Stream containing an XLSX workbook representation of a DataSet.
		/// </summary>
		/// <param name="dataset">A Dataset.</param>
		/// <returns>Memory Stream containing an XLSX workbook.</returns>
		public static Stream LoadWorkbook( DataSet dataset )
		{
			// Load the workbook to a MemoryStream.
			var stream = new MemoryStream();

			return LoadWorkbook( dataset, stream );
		}

		/// <summary>
		/// Creates a Memory Stream containing an XLSX workbook representation of a DataSet.
		/// </summary>
		/// <param name="dataset">A Dataset.</param>
		/// <param name="stream">Stream to write the Excel content to. </param>
		/// <param name="tabNames">Tab names for the Excel  file</param>
		/// <returns>Memory Stream containing an XLSX workbook.</returns>
		public static Stream LoadWorkbook( DataSet dataset, Stream stream, List<string> tabNames = null )
		{
			int sheetCounter = 0;
			Infragistics.Workbook wb = new Infragistics.Workbook( Infragistics.WorkbookFormat.Excel2007 );

			foreach( DataTable table in dataset.Tables )
			{
				int rowCounter = 0;
				int columnCounter = 0;

				// Create a new worksheet for each data table.
			    var sheetName = tabNames != null && tabNames.Count > sheetCounter
			                        ? tabNames[sheetCounter]
			                        : table.TableName ?? string.Format("Sheet{0}", sheetCounter + 1);
				wb.Worksheets.Add( sheetName );
				Infragistics.Worksheet ws = wb.Worksheets.Last();

				// Set the Header column
				foreach( DataColumn column in table.Columns )
				{
					ws.Rows[rowCounter].Cells[columnCounter].Value = column.ColumnName;
					columnCounter++;
				}

				// Loop through each row in the the table
				foreach( DataRow row in table.Rows )
				{
					rowCounter++;
					for( int i = 0; i < columnCounter; i++ )
					{
						ws.Rows[rowCounter].Cells[i].Value = row[i];
					}
				}
				sheetCounter++;
			}

			// Load the workbook to a MemoryStream.
			//MemoryStream streamSaved = new MemoryStream();
			wb.Save( stream );
			stream.Position = 0;

			return stream;
		}

		/// <summary>
		/// Datas the table from worksheet.
		/// </summary>
		/// <param name="worksheet">The worksheet.</param>
		/// <returns></returns>
		public static DataTable DataTableFromWorksheetEx( Aspose.Worksheet worksheet )
		{
			DataTable table = null;

			var numberOfColumns = DetermineControllingWidthEx( worksheet );
			var numberOfRows = DetermineControllingHeightEx( worksheet );

			//discard empty worksheets
			if( numberOfColumns > 0 && numberOfRows > 0 )
			{
				//one table per worksheet
				table = new DataTable( worksheet.Name );

				// inflate table to proper 2 dimensions - width
				for( var i = 0; i < numberOfColumns; i++ )
				{
					table.Columns.Add( new DataColumn( i.ToString() ) );
				}

				// inflate table to proper 2 dimensions - height
				for( var i = 0; i < numberOfRows; i++ )
				{
					var cellList = new object[table.Columns.Count];
					table.Rows.Add( cellList.ToArray() );
				}

				//map worksheet values to proper cells in fully inflated data table
				for( var r = 0; r < numberOfRows; r++ )
				{
					for( var c = 0; c < numberOfColumns; c++ )
					{
						Aspose.Cell cell = worksheet.Cells[r, c];
						if( cell.Value != null )
						{
							object o = cell.Value;
							table.Rows[r][c] = o;
						}
					}
				}
			}

			return table;
		}

		/// <summary>
		/// Datas the table from worksheet.
		/// </summary>
		/// <param name="worksheet"></param>
		/// <param name="firstRowContainsColumnNames"></param>
		/// <returns></returns>

		/// <summary>
		/// Gets data from an Excel workbook file using Aspose.
		/// </summary>
		/// <param name="stream">The stream.</param>
		/// <param name="fileName">Name of the file.</param>
		/// <returns>
		/// A DataSet object containing data retrieved from the
		/// Excel file specified.
		/// </returns>
		public static DataSet GetWorkbookEx( Stream stream, string fileName )
		{
			string fileExtension = System.IO.Path.GetExtension( fileName );
			if( CheckExtensionEx( fileExtension ) == true )
				return DataSetFromExcelEx( stream );
			else
				return null;
		}

		/// <summary>
		///  Gets a dataset from an Excel file
		/// </summary>
		/// <param name="fileName"></param>
		/// <returns></returns>
		public static DataSet GetWorkbookEx( string fileName )
		{
			return GetWorkbookEx( fileName, false, true );
		}

		public static DataSet GetWorkbookEx( string fileName, bool allSheetsIncludeHeaderRow, bool stripColumnNameSpacesDashes )
		{
			string fileExtension = System.IO.Path.GetExtension( fileName );

			if( CheckExtensionEx( fileExtension.ToLower() ) == true )
			{
				return DataSetFromExcelEx( fileName, allSheetsIncludeHeaderRow, stripColumnNameSpacesDashes );
			}
			else
			{
				return null;
			}
		}

		/// <summary>
		/// Gets s specific sheet from an excel workbook
		/// </summary>
		/// <param name="fileName"></param>
		/// <param name="workbookName"></param>
		/// <param name="firstRowContainsColumnNames"></param>
		/// <returns></returns>
		public static DataTable DataTableFromWorksheetEx( string fileName, string workbookName, bool firstRowContainsColumnNames, bool stripColumnNameSpacesDashes )
		{
			Aspose.Workbook workbook = new Aspose.Workbook();
			workbook.LoadData( fileName ); // TODO: Aspose.Cells.Workbook.LoadData(string)' is obsolete: 'Use Workbook(string,LoadOptions) constructor method instead.

			foreach( Aspose.Worksheet sheet in workbook.Worksheets )
			{
				if( sheet.Name == workbookName )
				{
					DataTable dt = DataTableFromWorksheetEx( sheet );
					dt = ExtractRegion( true, 0, 0, dt.Rows.Count - 1, dt.Columns.Count - 1, dt, stripColumnNameSpacesDashes );
					return dt;
				}
			}

			return null;
		}

		#endregion

		#region Helpers

		private static bool CheckExtension( string strExtension )
		{
            return (strExtension.ToLower() == ".xls" || strExtension.ToLower() == ".xlsx" || strExtension.ToLower() == ".xlsm" || strExtension.ToLower() == ".csv");
		}

		/// <summary>
		/// Converts the alpha based column names to a numeric equivalent
		/// </summary>
		/// <param name="columnName"></param>
		/// <returns></returns>
		private static Int32 ConvertColumnNameToInt32( string columnName )
		{
			Int32 answer = 0;
			int len = columnName.Length;
			int n = 0;
			int[] nOrder = new int[] { 1, 26, 676 };
			for( int i = len; i > 0; i--, n++ )
			{
				char c = columnName.ToCharArray()[i - 1];
				if( c >= 'A' && c <= 'Z' )
				{
					answer += ((Int32) (c - 'A') + 1) * nOrder[n];
				}
			}
			return answer;
		}

		/// <summary>
		/// Parses the column name from the cell name in the format 'Portfolio Rates'!$E$1
		/// </summary>
		/// <param name="cellName"></param>
		/// <returns></returns>
		private static string ParseColumnName( string cellName )
		{
			string columnName = "";
			string[] parts = cellName.Split( "$".ToCharArray() );
			if( parts.Length == 3 )
			{
				columnName = parts[1];
			}
			return columnName;
		}

		/// <summary>
		/// Determines the controlling height (as number of rows) of an excel worksheet
		/// </summary>
		/// <param name="ws">The ws.</param>
		/// <returns></returns>
		private static Int32 DetermineControllingHeightEx( Aspose.Worksheet ws )
		{
			if( ws.Cells == null || ws.Cells.LastCell == null )
			{
				return 1;
			}

			Aspose.Cell lastCell = ws.Cells.LastCell;

			return lastCell.Row + 1;
		}

		/// <summary>
		/// Determines the width populated portion of a worksheet;  for example a worksheet with a 
		/// single value in cell Sheet1!$C$5 would have a controlling width of 3
		/// </summary>
		/// <param name="ws">The ws.</param>
		/// <returns></returns>
		private static Int32 DetermineControllingWidthEx( Aspose.Worksheet ws )
		{
			if( ws.Cells == null || ws.Cells.LastCell == null )
			{
				return 1;
			}

			Aspose.Cell lastCell = ws.Cells.LastCell;

			Int32 rows = DetermineControllingHeightEx( ws );

			if( rows > 100 )
				rows = 100;

			Int32 rightExtent = lastCell.Column + 1;

			for( int r = 0; r < rows; r++ )
			{

				var c = rightExtent;
				var maxNulls = 20;
				var countNulls = 0;
				while( countNulls < maxNulls )
				{
					c = rightExtent + countNulls;
					if( ws.Cells[r, c].Value != null )
						rightExtent = c + 1;
					else
						countNulls++;
				}
			}

			return rightExtent;
		}

		private static bool CheckExtensionEx( string strExtension )
		{
			return (strExtension == ".xls" || strExtension == ".xlsx" || strExtension == ".xlsm");
		}

		/// <summary>
		/// Converts excel file to a dataset, inflating Excel's sparse array format to a DataSet  containing null padded datatables
		/// </summary>
		/// <param name="fileName">Name of the file.</param>
		/// <returns></returns>
		private static DataSet DataSetFromExcelEx( string fileName )
		{
			return DataSetFromExcelEx( fileName, false, true );
		}

		private static DataSet DataSetFromExcelEx( string fileName, bool allSheetsIncludeHeaderRow, bool stripColumnNameSpacesDashesFromAllSheets )
		{
			try
			{
				DataSet ds = new DataSet();

				// Deserialize the Workbook from an .XLS file.
				Aspose.Workbook workbook = new Aspose.Workbook();
				workbook.LoadData( fileName ); // TODO: Aspose.Cells.Workbook.LoadData(string)' is obsolete: 'Use Workbook(string,LoadOptions) constructor method instead.

				// Parse each Worksheet into a DataTable.
				foreach( Aspose.Worksheet sheet in workbook.Worksheets )
				{
					DataTable dataTable = DataTableFromWorksheetEx( sheet );

					ds.Tables.Add( ExcelAccess.ExtractRegion( allSheetsIncludeHeaderRow, 0, 0, dataTable.Rows.Count - 1, dataTable.Columns.Count - 1, dataTable, stripColumnNameSpacesDashesFromAllSheets ) );
				}


				return ds;
			}
			catch( Exception )
			{
				throw;
			}
		}

		/// <summary>
		/// Converts excel file to a dataset, inflating Excel's sparse array format to a DataSet containing null padded datatables
		/// </summary>
		/// <param name="stream">The stream.</param>
		/// <returns></returns>
		public static DataSet DataSetFromExcelEx( Stream stream )
		{
			// Deserialize the Workbook from an .XLS file.
			var options = new Aspose.LoadOptions { LoadDataOnly = true };

			return DataSetFromExcelEx( stream, options );
		}

		public static DataSet DataSetFromExcelEx( Stream stream, Aspose.LoadOptions options )
		{
			var ds = new DataSet();

			var workbook = new Aspose.Workbook( stream, options );

			// Parse each Worksheet into a DataTable.
			foreach( Aspose.Worksheet sheet in workbook.Worksheets )
			{
                // Only visible sheets will be considered
			    if (sheet.IsVisible)
			    {
			        DataTable dataTable = DataTableFromWorksheetEx(sheet);
			        ds.Tables.Add(dataTable);
			    }
			}

			return ds;

		}

		public static ExcelImageList GetWorksheetImages(string fullFilePath, string rootPath)
		{
			ExcelImageList list = new ExcelImageList();
			Aspose.Workbook workbook = new Aspose.Workbook( fullFilePath );
			Aspose.Worksheet worksheet = workbook.Worksheets[0];
			foreach( Aspose.Drawing.Picture pic in worksheet.Pictures )
			{
				string guid = Guid.NewGuid().ToString();
				string fileExt = pic.ImageFormat.ToString().ToLower().Contains("png") ? "png" : "jpg";
				string fileName = String.Format( "{0}{1}.{2}", rootPath, guid, fileExt );

				int columnNum = pic.UpperLeftColumn;
				int rowNum = pic.UpperLeftRow;

				FileStream file = File.Create( fileName );
				byte[] data = pic.Data;
				file.Write( data, 0, data.Length );
				file.Close();

				list.Add( new ExcelImage( fileName, columnNum, rowNum ) );
			}
			return list;
		}

		#endregion

		#endregion Methods
	}
}

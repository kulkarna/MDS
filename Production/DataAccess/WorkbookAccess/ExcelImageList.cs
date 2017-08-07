namespace LibertyPower.DataAccess.WorkbookAccess
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class ExcelImageList : List<ExcelImage>
	{
		public string GetFileGuid( int columnNum, int rowNum )
		{
			string fileGuid = String.Empty;
			ExcelImage ei = (from i in this
							 where i.ColumnNum == columnNum
							 && i.RowNum == rowNum
							 select i).FirstOrDefault();
			if( ei != null ) { fileGuid = ei.FileGuid; }
			return fileGuid;
		}
	}
}

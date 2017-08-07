namespace LibertyPower.DataAccess.WorkbookAccess
{
	public class ExcelImage
	{
		public ExcelImage() { }

		public ExcelImage( string fileName, int columnNum, int rowNum )
		{
			this.FileName = fileName;
			this.ColumnNum = columnNum;
			this.RowNum = rowNum;
		}

		public ExcelImage(string fileName, string fileGuid, int columnNum, int rowNum)
		{
			this.FileName = fileName;
			this.FileGuid = fileGuid;
			this.ColumnNum = columnNum;
			this.RowNum = rowNum;
		}

		public string FileName
		{
			get;
			set;
		}

		public string FileGuid
		{
			get;
			set;
		}

		public int ColumnNum
		{
			get;
			set;
		}

		public int RowNum
		{
			get;
			set;
		}
	}
}

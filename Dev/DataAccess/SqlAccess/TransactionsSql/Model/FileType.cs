namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
	public enum FileType
	{
		/// <summary>
		/// Erroneus file type.
		/// </summary>
		Error = -1,

		/// <summary>
		/// CSV File Type
		/// </summary>
		Csv = 0,

		/// <summary>
		/// Excel 2003 File Type
		/// </summary>
		Excel2003 = 1,

		/// <summary>
		/// Excel 2010 File Type
		/// </summary>
		Excel2010 = 2,

		/// <summary>
		/// Text File Type
		/// </summary>
		Text = 3,

		/// <summary>
		/// Invalid File Type
		/// </summary>
		Other = 4,

		/// <summary>
		/// Zipped File
		/// </summary>
		Zip = 5,
	}
}

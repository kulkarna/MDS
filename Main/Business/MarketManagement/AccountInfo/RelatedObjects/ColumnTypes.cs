using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class ColumnTypes
	{
		/// <summary>
		/// index of the column in a row
		/// </summary>
		public int Index;

		/// <summary>
		/// max length of the column
		/// </summary>
		public int MaxLength;

		/// <summary>
		/// attributes it should map to
		/// </summary>
		public string MapTo;

		/// <summary>
		/// allow nulls or no
		/// </summary>
		public bool AllNulls;	
	}
}

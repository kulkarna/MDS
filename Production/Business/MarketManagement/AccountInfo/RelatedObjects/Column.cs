using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class Column 
	{
		/// <summary>
		/// column is valid or not
		/// </summary>
		public bool IsValid;

		/// <summary>
		/// value of the column
		/// </summary>
		public string Value;

		/// <summary>
		/// message related to the validation of the column
		/// </summary>
		public string Msg;

		/// <summary>
		/// row number of the column
		/// </summary>
		public long RowNumber;

		/// <summary>
		/// type of the column
		/// </summary>
		public ColumnTypes Type;

		/// <summary>
		/// validate the column
		/// </summary>
		public void Validate()
		{
			IsValid = true;

			if( (Value == null || Value.Trim()==string.Empty) && !Type.AllNulls )
			{
				IsValid = false;
				Msg = "The column " + Type.MapTo + ", row " + RowNumber.ToString() + ", is empty. Nulls are not allowed on this column.";
				return;
			}

			if( Value != null && Value.Length > Type.MaxLength )
			{
				IsValid = false;
				Msg = "The length of the column " + Type.MapTo + ", row " + RowNumber.ToString() + ", (" + Value.Length.ToString() + ") exceeds the maximum allowed of " + Type.MaxLength + ".";
			}
		}
	}
}


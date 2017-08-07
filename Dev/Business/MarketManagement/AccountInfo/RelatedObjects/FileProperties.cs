using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class FileProperties
	{
		/// <summary>
		/// name of the file to import
		/// </summary>
		public string Name;

		/// <summary>
		/// URL where we can download the file from
		/// </summary>
		public string URL;

		/// <summary>
		/// size of the file
		/// </summary>
		public string Size;

		/// <summary>
		/// format of the file: zip, csv
		/// </summary>
		public string Format;
	}
}

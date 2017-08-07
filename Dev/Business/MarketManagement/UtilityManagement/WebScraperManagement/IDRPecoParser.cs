namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.IO;
	using System.Xml.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class IDRPecoParser : IDRParser
	{
		const string UPLOAD_DATE_KEY = "as of ";
		const string UTILITY = "IDR_PECO";
		const string LSIT_START_POINT="ACCOUNT";
		const char DELIMITER = '\t';

		/*static IDRPecoParser instance;
		public static IDRPecoParser GetInstance(string content)
		{
			if( instance == null )
				instance = new IDRPecoParser( content );
			return instance;
		}
        */
		public IDRPecoParser( string content )
			: base( UTILITY, LSIT_START_POINT, content, DELIMITER )
		{
		}

		/// <summary>
		/// //get upload date: it is saved in the first line of the text file: PECO Interval Metered Accounts as of 1/14/2011
		/// </summary>
		/// <param name="str">first line in the text file</param>
		/// <returns></returns>
		public override void GetUploadDate(string str)
		{
			if( str != null )
			{
				int iDate = str.IndexOf( UPLOAD_DATE_KEY );
				if( iDate > -1 )
					DateTime.TryParse( str.Substring( iDate + UPLOAD_DATE_KEY.Length, str.Length - (iDate+UPLOAD_DATE_KEY.Length) ).Trim(), out uploadDate );
			}
		}
	
	}



}

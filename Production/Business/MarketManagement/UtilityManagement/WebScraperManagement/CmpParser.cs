namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Xml.Linq;
	using System.Linq;
	using System.Text;

	using HtmlAgilityPack;

	public class CmpParser
	{
		private HtmlDocument htmlDocument;
		private string[]     accountInfo;

		public CmpParser( string htmlContent )
		{
			htmlDocument = new HtmlDocument();
			htmlDocument.LoadHtml( 
				htmlContent 
					.Replace("\r", "")
					.Replace("\n", "")
					.Replace("\t", "")
					.Replace("&nbsp;", "")
				);

			accountInfo = GetAccountInfo();
		}

		public Cmp Parse()
		{
			//if the account number doesn't exist, the page will return no information therefore the accountinfo will be null
			if( accountInfo == null )
				return null;

			Cmp account = new Cmp();

			account.AccountNumber = GetAccountNumber();
			account.BillGroup     = GetBillGroup();
			account.Cycle         = GetReadCycle();
			account.WebUsageList  = GetUsageHistory();

			return account;
		}

		private string GetAccountNumber()
		{
			//Usage for account 2110042715012, Bill Cycle: 5, Read Cycle: 5
			try
			{
				string accountNumber = accountInfo[0]
											.Split( new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries )[3]
											.Trim();

				return accountNumber;
			}
			catch
			{ }

			return string.Empty;
		}

		private string GetBillGroup()
		{
			//Usage for account 2110042715012, Bill Cycle: 5, Read Cycle: 5
			try
			{
				string billGroup = accountInfo[1]
										.Split( new char[] { ':' } )[1]
										.Trim();

				return  billGroup ;
			}
			catch
			{ }

			return "-1";
		}

		private string GetReadCycle()
		{
			//Usage for account 2110042715012, Bill Cycle: 5, Read Cycle: 5
			try
			{
				string readCycle = accountInfo[2]
										.Split( new char[] { ':' } )[1]
										.Trim();

				return readCycle;
			}
			catch
			{ }

			return string.Empty;
		}

		private WebUsageList GetUsageHistory()
		{
			WebUsageList usageList = new WebUsageList();

			HtmlNode[] tableRows = htmlDocument
										.GetElementbyId( "Content" )
											.Descendants( "table" )
											.ToArray()[0]
												.Descendants( "tr" )
												.ToArray();

			HtmlNode tableHeader = tableRows[1];

			HtmlNode[] usageRows = (from row in tableRows.Skip(1)
									where row.Name.Equals("tr") && row.Descendants( "th" ).Count() == 0
									select row).ToArray();

			List<AvailableColumns> availableInfo = GetAvaliableInfo( tableHeader );

			foreach( HtmlNode row in usageRows )
				usageList.Add( HtmlToUsage( row, availableInfo ) );

			return usageList;
		}

		private string[] GetAccountInfo()
		{
			try
			{
				//if the account number doesn't exist, the page will return no information therefore set the accountinfo to null
				if( htmlDocument.GetElementbyId( "Content" ).Descendants( "table" ).ToArray().Count().Equals( 0 ) )
					return null;

				HtmlNode accountInfoNode = htmlDocument
											.GetElementbyId( "Content" )
												.Descendants( "table" )
												.ToArray()[0]
													.Descendants( "tr" )
													.ToArray()[0];

				return accountInfoNode.InnerText.Split( new char[] { ',' } );
			}
			catch
			{
				return null;
			}
		}

		private CmpUsage HtmlToUsage( HtmlNode usageRow, List<AvailableColumns> availableInfo )
		{
			CmpUsage usage = new CmpUsage();

			foreach( AvailableColumns info in availableInfo )
			{
				try
				{
					string value = usageRow.ChildNodes[info.Index].InnerText.Trim();

					switch( info.Name.ToLower() )
					{
						case "meter number":
							usage.MeterNumber = value;
							break;
						case "rate code":
							usage.RateCode = value;
							break;
						case "read date":
							usage.EndDate = Convert.ToDateTime( value );
							break;
						case "days":
							usage.Days = Convert.ToInt32( value );
							break;
						case "total energy(in kwh)":
							usage.TotalKwh = Convert.ToInt32( value );
							break;
						case "highest demand(in kw)":
							usage.HighestDemandKw = Convert.ToDecimal( value );
							break;
						case "total unmetered services":
							usage.TotalUnmeteredServices = Convert.ToInt32( value );
							break;
						case "total active unmetered services":
							usage.TotalActiveUnmeteredServices = Convert.ToInt32( value );
							break;
						case "totalunmeteredservices":
							int totServ = 0;
							int.TryParse( value, out totServ );
							usage.TotalUnmeteredServices = totServ;
							break;
						case "totalactiveunmeteredservices":
							int totAServ = 0;
							int.TryParse( value, out totAServ );
							usage.TotalActiveUnmeteredServices = totAServ;
							break;
					}
				}
				catch
				{ }
			}

			if( usage.EndDate != DateTime.MinValue )
				usage.BeginDate = usage.EndDate.AddDays( -1 * usage.Days );

			return usage;
		}

		private List<AvailableColumns> GetAvaliableInfo( HtmlNode tableHeader )
		{
			List<AvailableColumns> avaliableInfo = new List<AvailableColumns>();

			if( tableHeader.ChildNodes != null )
			{
				for( int i = 0; i < tableHeader.ChildNodes.Count; i++ )
				{
					HtmlNode column = tableHeader.ChildNodes[i];

					if( column.NodeType != HtmlNodeType.Element )
						continue;

					//in case of unmetered accounts, 2 extra clolumns are added to the table
					//and an extra empty cell is added to the table header (ONLY)!!. 
					//need to accomodate that by removing 1 from the column name index
					if( tableHeader.FirstChild.NodeType.Equals( HtmlNodeType.Element ) )
						avaliableInfo.Add( new AvailableColumns( i, column.InnerText.Trim() ) );
					else
						avaliableInfo.Add( new AvailableColumns( i - 1, column.InnerText.Trim() ) );
				}
			}

			return avaliableInfo;
		}
	}
}

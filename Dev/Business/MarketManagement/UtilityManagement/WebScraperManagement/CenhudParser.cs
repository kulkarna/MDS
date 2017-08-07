namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Linq;
	using System.Collections.Generic;

	using HtmlAgilityPack;

	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class CenhudParser
	{
		private List<HtmlNode> htmlTables;
		private List<HtmlNode> accountRows;
		private List<HtmlNode> usageRows;

		public CenhudParser( string content )
		{
			HtmlDocument htmlDoc;
			IEnumerable<HtmlNode> htmlTablesEnum;

			htmlDoc = new HtmlDocument();
			htmlDoc.LoadHtml( content );

			htmlTablesEnum = htmlDoc
								.GetElementbyId( "ElectricMeter1" )
									.Descendants( "table" );

			htmlTables = new List<HtmlNode>( htmlTablesEnum );
			accountRows = GetAccountRows();
			usageRows = GetUsageRows();
		}

		private List<HtmlNode> GetUsageRows()
		{
			HtmlNode usageTable = new List<HtmlNode>( htmlTables[0].Descendants( "table" ) )[1];

			// Excludes empty rows and header row
			var dataRows = (from row in usageTable.Descendants( "tr" )
							where row.Descendants( "th" ).Count() == 0
							   && !row.Descendants( "td" ).First().InnerText.ToLower().Contains( "total" )
							   && !row.Descendants( "td" ).First().InnerText.Trim().Equals( "&nbsp;" )
							select row);

			return new List<HtmlNode>( dataRows );
		}

		private List<HtmlNode> GetAccountRows()
		{
			HtmlNode accountTable = new List<HtmlNode>( htmlTables[0].Descendants( "table" ) )[0];

			return new List<HtmlNode>( accountTable.Descendants( "tr" ) );
		}


		public Cenhud Parse()
		{
			Cenhud account = new Cenhud()
			{
				County = GetCounty(),
				Address = GetBillingAddress(),
				Cycle = GetBillCycle(),
				BillFrequency = GetBillFrequency(),
				SalesTaxRate = GetTaxRate(),
				NextScheduledMeterRead = GetNextScheduledMeterReadDate(),
				RateCode = GetRateCode(),
				LoadZone = GetLoadZone(),
				LoadShapeId = GetLoadProfile(),
				//				ZoneCode = GetLoadZone(),
				UsageFactor = GetUsageFactor(),
				WebUsageList = GetUsageHistory()
			};



			return account;
		}

		private string GetCounty()
		{
			return GetAccountTableValueInRow( 0 );
		}

		private GeographicalAddress GetBillingAddress()
		{
			UsGeographicalAddress address = new UsGeographicalAddress();

			address.CityName = GetAccountTableValueInRow( 1 );

			return address;
		}

		private string GetAccountTableValueInRow( int rowIndex )
		{
			string value = null;

			try
			{
				List<HtmlNode> columns = new List<HtmlNode>( accountRows[rowIndex].Descendants( "td" ) );

				value = columns[1].InnerText.Trim();
			}
			catch
			{
			}

			return value;
		}

		private string GetMeterNumber()
		{
			return GetAccountTableValueInRow( 3 );
		}

		private DateTime GetNextScheduledMeterReadDate()
		{
			DateTime nextDate;

			string htmlText = GetAccountTableValueInRow( 4 );
			if( !DateTime.TryParse( htmlText, out nextDate ) )
				nextDate = DateTime.MinValue;

			return nextDate;
		}

		private string GetBillCycle()
		{
			return GetAccountTableValueInRow( 5 );
		}

		private string GetBillFrequency()
		{
			return GetAccountTableValueInRow( 6 );
		}

		private decimal GetTaxRate()
		{
			decimal taxRate;
			string htmlText = GetAccountTableValueInRow( 2 );

			if( !decimal.TryParse( htmlText, out taxRate ) )
				taxRate = -1;

			return taxRate;
		}

		private string GetRateCode()
		{
			return GetAccountTableValueInRow( 7 );
		}

		private string GetLoadZone()
		{
			string loadZone = GetAccountTableValueInRow( 8 );

			loadZone = loadZone.Replace( "LOAD ZONE = ", "" );

			return loadZone;
		}

		private string GetZoneId()
		{
			return string.Empty;
		}

		private string GetLoadProfile()
		{
			string loadProfile = string.Empty;
			string htmlText = string.Empty;

			htmlText = GetAccountTableValueInRow( 9 );

			if( !string.IsNullOrEmpty( htmlText ) )
				loadProfile = htmlText.Split( new char[] { '/' } )[0].Trim();

			return loadProfile;
		}

		private decimal GetUsageFactor()
		{
			string htmlText = GetAccountTableValueInRow( 9 );
			decimal usageFactor = -1;

			if( !string.IsNullOrEmpty( htmlText ) )
			{
                htmlText = htmlText.Split(new char[] { '/' }).Length > 1 ? htmlText.Split(new char[] { '/' })[1].Trim() : htmlText.Split(new char[] { '/' })[0].Trim();

				if( !decimal.TryParse( htmlText, out usageFactor ) )
					usageFactor = -1;
			}

			return usageFactor;
		}

		private CenhudUsage HtmlToUsage( HtmlNode usageRow )
		{

			CenhudUsage usage = new CenhudUsage()
			{
				EndDate = GetReadDate( usageRow ),
				ReadCode = GetReadCode( usageRow ),
				NumberOfMonths = GetNumberOfMonths( usageRow ),
				TotalKwh = GetTotalUsageKwh( usageRow ),
				OnPeakKwh = GetOnPeakKwh( usageRow ),
				OffPeakKwh = GetOffPeakKwh( usageRow ),
				DemandKw = GetDemandKw( usageRow ),
				TotalBilledAmount = GetTotalBilledAmount( usageRow ),
				SalesTax = GetSalesTax( usageRow )
			};

			return usage;
		}

		private int GetUsageTableIntegerValueInColumn( HtmlNode usageRow, int columnIndex )
		{
			int integerValue = -1;

			try
			{
				List<HtmlNode> columns = new List<HtmlNode>( usageRow.Descendants( "td" ) );
				string columnValue;

				columnValue = columns[columnIndex].InnerText.Trim();

				if( !int.TryParse( columnValue, out integerValue ) )
					integerValue = -1;

				return integerValue;
			}
			catch
			{
			}

			return integerValue;
		}

		private DateTime GetUsageTableDateTimeValueInColumn( HtmlNode usageRow, int columnIndex )
		{
			DateTime datetimeValue = DateTime.MinValue;

			try
			{
				List<HtmlNode> columns = new List<HtmlNode>( usageRow.Descendants( "td" ) );
				string columnValue;

				columnValue = columns[columnIndex].InnerText.Trim();

				if( !DateTime.TryParse( columnValue, out datetimeValue ) )
					datetimeValue = DateTime.MinValue;

				return datetimeValue;
			}
			catch
			{
			}

			return datetimeValue;
		}

		private decimal GetUsageTableDecimalValueInColumn( HtmlNode usageRow, int columnIndex )
		{
			decimal decimalValue = -1;

			try
			{
				List<HtmlNode> columns = new List<HtmlNode>( usageRow.Descendants( "td" ) );
				string columnValue;

				columnValue = columns[columnIndex].InnerText.Trim();

				if( !decimal.TryParse( columnValue, out decimalValue ) )
					decimalValue = -1;

				return decimalValue;
			}
			catch
			{
			}

			return decimalValue;
		}

		private string GetUsageTableStringValueInColumn( HtmlNode usageRow, int columnIndex )
		{
			string value = string.Empty;

			try
			{
				List<HtmlNode> columns = new List<HtmlNode>( usageRow.Descendants( "td" ) );

				value = columns[columnIndex].InnerText.Trim();

				return value
							.Replace( "&nbsp;", "" )
							.Replace( "\r", "" )
							.Replace( "\n", "" )
							.Replace( "\t", "" );
			}
			catch
			{
			}

			return value;
		}

		private DateTime GetReadDate( HtmlNode usageRow )
		{
			return GetUsageTableDateTimeValueInColumn( usageRow, 0 );
		}

		private string GetReadCode( HtmlNode usageRow )
		{
			return GetUsageTableStringValueInColumn( usageRow, 1 );
		}

		private decimal GetNumberOfMonths( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 2 );
		}

		private int GetTotalUsageKwh( HtmlNode usageRow )
		{
			return GetUsageTableIntegerValueInColumn( usageRow, 3 );
		}

		private decimal GetOnPeakKwh( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 4 );
		}

		private decimal GetOffPeakKwh( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 5 );
		}

		private decimal GetDemandKw( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 6 );
		}

		private decimal GetTotalBilledAmount( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 7 );
		}

		private decimal GetSalesTax( HtmlNode usageRow )
		{
			return GetUsageTableDecimalValueInColumn( usageRow, 8 );
		}

		private WebUsageList GetUsageHistory()
		{
			string meterNumber = GetMeterNumber();
			WebUsageList usageHistory = new WebUsageList();

			foreach( HtmlNode row in usageRows )
			{
				CenhudUsage usage = HtmlToUsage( row );

				usage.MeterNumber = meterNumber;

				usageHistory.Add( usage );
			}

			CalculateBeginDate( usageHistory );

			return usageHistory;
		}

		private void CalculateBeginDate( WebUsageList usageList )
		{
			for( int i = 0; i < usageList.Count; i++ )
			{
				if( i + 1 < usageList.Count )
					usageList[i].BeginDate = usageList[i + 1].EndDate;
				else
					usageList[i].BeginDate = usageList[i].EndDate.AddMonths( -1 );

				usageList[i].Days = usageList[i].EndDate.Subtract( usageList[i].BeginDate ).Days;
			}
		}
	}
}

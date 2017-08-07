namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Xml.Linq;
	using System.Web;
	using System.Linq;
	using System.Text;
	using System.Text.RegularExpressions;
	using System.IO;
	using System.Collections.Generic;
	using System;

	using HtmlAgilityPack;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class NimoParser
	{
		private XElement xmlDocument;
		public string[] accountInfo;

		public NimoParser( string htmlContent )
		{
			xmlDocument = BuildXmlDocument( htmlContent );
		}

		public Nimo Parse()
		{
			accountInfo = GetAccountInformation();				// 12 rows, company name is on 4th row, usage is on the last one..

			Nimo account = new Nimo()
			{
				CustomerName = GetCustomerName(),
				Address = GetAddress(),
				RateClass = GetRateClass(),
				RateCode = GetRateCode(),
				TaxDistrict = GetTaxDistrict(),
				Voltage = GetVoltage(),
				ZoneCode = GetZone(),
				AccountNumber = GetAccountNumber(),
				WebUsageList = GetUsageHistory(),
			};

			return account;
		}

		private string RemoveComments( string htmlContent )
		{
			Regex commentExp = new Regex( "<!--(.*?)-->" );

			return commentExp.Replace( htmlContent, "" );
		}

		private string HtmlToXml( string htmlContent )
		{
			HtmlDocument htmlDocument = new HtmlDocument();
			string content = string.Empty;

			using( StringWriter xmlWriter = new StringWriter() )
			{
				htmlDocument.LoadHtml( htmlContent );
				htmlDocument.OptionFixNestedTags = true;
				htmlDocument.OptionOutputAsXml = true;
				htmlDocument.Save( xmlWriter );					// xml formatted document (from <?xml.. to /body>)..

				content = xmlWriter.ToString();
			}

			return content;
		}

		private XElement BuildXmlDocument( string htmlContent )
		{
			string newContent;
			string xmlContent;

			newContent = RemoveInvalidContent( htmlContent );	// remove context menu (to the left)..
			newContent = RemoveComments( newContent );
			newContent = GetHtmlBody( newContent );				// removed javascript syntax..
			xmlContent = HtmlToXml( newContent );

			return XElement.Parse( xmlContent );
		}

		private string GetHtmlBody( string htmlContent )
		{
			int startIndex;
			int endIndex;

			startIndex = htmlContent.IndexOf( "<body>" );
			endIndex = htmlContent.IndexOf( "</body>" ) + "</body>".Length;

			return htmlContent.Substring( startIndex, endIndex - startIndex );
		}

		private string RemoveInvalidContent( string htmlContent )
		{
			int startIndex = htmlContent.IndexOf( "<!---HISTORY REQUESTS section----->" );
			int endIndex = htmlContent.IndexOf( "<!---INTERNAL ADMIN SECTION--->" ) +
				"<!---INTERNAL ADMIN SECTION--->".Length;

			string newContent = htmlContent.Remove( startIndex, endIndex - startIndex );

			newContent = newContent.Replace( "&nbsp;", "" );

			return newContent;
		}

		private List<AvailableColumns> GetAvailableInfo()
		{
			XElement usageTable = xmlDocument.Descendants( "table" ).ToArray()[1];
			XElement headerRow = usageTable.Descendants( "tr" ).ToArray()[0];
			List<AvailableColumns> avaliableInfo = new List<AvailableColumns>();

			int i = 0;

			foreach( XElement column in headerRow.Descendants( "td" ) )
			{
				avaliableInfo.Add( new AvailableColumns( i, column.Value.Trim().ToLower() ) );

				i++;
			}

			return avaliableInfo;
		}

		private WebUsageList GetUsageHistory()
		{
			WebUsageList usageHistory = new WebUsageList();
			List<AvailableColumns> avaliableInfo = GetAvailableInfo();

			try
			{
				var tableRows = xmlDocument.Descendants( "table" ).ToArray()[1].Descendants( "tr" ).ToArray();

				for( int i = 1; i < tableRows.Count(); i++ )
					usageHistory.Add( XmlToUsage( tableRows[i], avaliableInfo ) );
			}
			catch
			{ }

			return usageHistory;
		}

		private NimoUsage XmlToUsage( XElement usageElement, List<AvailableColumns> availableInfo )
		{
			NimoUsage nimoUsage = new NimoUsage();
			XElement[] columns = usageElement.Descendants( "td" ).ToArray();

			foreach( AvailableColumns info in availableInfo )
			{
				object value = GetInformationValue( info, columns );

				switch( info.Name.ToLower() )
				{
					case "end date":
						nimoUsage.EndDate = Convert.ToDateTime( value );
						break;

					case "bill code":
						nimoUsage.BillCode = value as string;
						break;

					case "day use":
						nimoUsage.Days = Convert.ToInt32( value );
						break;

					case "billed kwh total":
						nimoUsage.BilledKwhTotal = Convert.ToDecimal( value );
						break;

					case "metered peak kw":
						nimoUsage.MeteredPeakKw = Convert.ToDecimal( value );
						break;

					case "metered onpeak kw":
						nimoUsage.MeteredOnPeakKw = Convert.ToDecimal( value );
						break;

					case "billed peak kw":
						nimoUsage.BilledPeakKw = Convert.ToDecimal( value );
						break;

					case "billed onpeak kw":
						nimoUsage.BilledOnPeakKw = Convert.ToDecimal( value );
						break;

					case "bill detail amt":
						nimoUsage.BillDetailAmt = Convert.ToDecimal( value );
						break;

					case "billed rkva":
						nimoUsage.BilledRkva = Convert.ToDecimal( value );
						break;

					case "on-peak kwh":
						nimoUsage.OnPeakKwh = Convert.ToDecimal( value );
						break;

					case "off-peak kwh":
						nimoUsage.OffPeakKwh = Convert.ToDecimal( value );
						break;

					case "shoulder kwh":
						nimoUsage.ShoulderKwh = Convert.ToDecimal( value );
						break;

					case "off-season kwh":
						nimoUsage.OffSeasonKwh = Convert.ToDecimal( value );
						break;
				}
			}

			nimoUsage.BeginDate = nimoUsage.EndDate.AddDays( -1 * nimoUsage.Days );

			return nimoUsage;
		}

		private string GetInformationValue( AvailableColumns info, XElement[] columns )
		{
			return columns[info.Index].Value;
		}

		private string GetVoltage()
		{
			string voltageLevel = string.Empty;

			try
			{
				// 9 - (Voltage Level=X; ISO Zone=X; Tax District=XXXX)
				//string[] accountInfo = GetAccountInformation();

				voltageLevel = accountInfo[9]
									.Split( new char[] { ';' } )[0] // = { "(Voltage Level=X", "ISO Zone=X", "Tax District=XXXX)" }
									.Split( new char[] { '=' } )[1].Trim(); // = { "(Voltage Level", "X" }
			}
			catch
			{ }

			return voltageLevel;
		}

		private string GetZone()
		{
			string zone = string.Empty;

			try
			{
				// 9 - (Voltage Level=X; ISO Zone=X; Tax District=XXXX)
				//string[] accountInfo = GetAccountInformation();

				zone = accountInfo[9]
							.Split( new char[] { ';' } )[1]  // = { "(Voltage Level=X", "ISO Zone=X", "Tax District=XXXX)" }
							.Split( new char[] { '=' } )[1].Trim(); // = { "ISO Zone", "X" }
			}
			catch
			{ }

			return zone;
		}

		private string GetTaxDistrict()
		{
			string taxDistrict = string.Empty;

			try
			{
				// 9 - (Voltage Level=X; ISO Zone=X; Tax District=XXXX)
				//string[] accountInfo = GetAccountInformation();

				taxDistrict = accountInfo[9]
									.Split( new char[] { ';' } )[2]  // = { "(Voltage Level=X", "ISO Zone=X", "Tax District=XXXX)" }
									.Split( new char[] { '=' } )[1]  // = { "Tax District", "XXXX) ....." }
									.Split( new char[] { ')' } )[0].Trim(); // = { "XXXX", "....." }
			}
			catch
			{ }

			return taxDistrict;
		}

		private string GetRateCode()
		{
			string rateCode = string.Empty;

			try
			{
				// 8 - <span class="subhead2">Electric History: RateClass&#151;Large General Service</span>(RateCode)
				//string[] accountInfo = GetAccountInformation();

				rateCode = accountInfo[8]
								.Split( new string[] { "</SPAN>" }, StringSplitOptions.None )[1] // = { "...", "(RateCode)" }
								.Trim()
								.Replace( "(", "" )
								.Replace( ")", "" );
			}
			catch
			{ }

			return rateCode;
		}

		private string GetRateClass()
		{
			// 8 - <span class="subhead2">Electric History: RateClass&#151;Large General Service</span>(RateCode)
			string rateClass = string.Empty;

			try
			{
				//string[] accountInfo = GetAccountInformation();

				rateClass = accountInfo[8]
								.Split( new string[] { "&#151;" }, StringSplitOptions.None )[0] // = { "... Eletric History : RateClass", "..." }
								.Split( new char[] { ':' } )[1] // = { "... Eletric History", "RateClass" }
								.Trim();
			}
			catch
			{ }

			return rateClass;
		}

		private string GetAccountNumber()
		{
			// 6 - Account Number : XXXXXXXX
			string accountNumber = string.Empty;

			try
			{
				//string[] accountInfo = GetAccountInformation();

				accountNumber = accountInfo[6]
						.Split( new char[] { ':' } )[1].Trim(); // = { "Account Number", "XXXXXXX" } 
			}
			catch
			{ }

			return accountNumber;
		}

		private string GetCustomerName()
		{
			// 3 - Customer Name
			string customerName = string.Empty;

			try
			{
				//string[] accountInfo = GetAccountInformation();

				customerName = accountInfo[3].Trim();
			}
			catch
			{ }

			return customerName;
		}

		private GeographicalAddress GetAddress()
		{
			// 4 - Street
			// 5 - City, StateCode ZipCode
			// i.e. MARCY, NY 13403
			UsGeographicalAddress address = new UsGeographicalAddress();

			try
			{
				//string[] accountInfo = GetAccountInformation();
				string addressContent = accountInfo[5];

				address.Street = accountInfo[4].Trim();

				address.StateCode = addressContent
										.Split( new char[] { ',' } )[1].Trim() // = { [0]:"City", [1]:"StateCode ZipCode" }
										.Split( new char[] { ' ' } )[0].Trim(); // = { [0]:"StateCode", [1]:"ZipCode" }

				address.CityName = addressContent
										.Split( new char[] { ',' } )[0].Trim(); // = { [0]:"City", [1]:"StateCode ZipCode" }

				address.ZipCode = addressContent
										.Split( new char[] { ',' } )[1].Trim() // = { [0]:"City", [1]:"StateCode ZipCode" }
										.Split( new char[] { ' ' } )[1].Trim(); // = { [0]:"StateCode", [1]:"ZipCode" }
			}
			catch
			{ }

			return address;
		}

		private string[] GetAccountInformation()
		{
			// [Index]-[Information]
			//    3   - Customer Name
			//    4   - Street
			//    5   - City, StateCode ZipCode
			//    6   - Account Number: XXXXX
			//    8   - <span class="subhead2">Electric History: RateClass&#151;Large General Service</span>(RateCode)
			//    9   - (Voltage Level=X; ISO Zone=X; Tax District=XXXX)
			UsGeographicalAddress address = new UsGeographicalAddress();
			XElement addressTableNode;

			addressTableNode = (from table in xmlDocument.Descendants( "table" )
								select table).First();

			XElement firstRow = addressTableNode.Descendants( "tr" ).ToArray()[0];

			XElement accInfoColumn = (from column in firstRow.Descendants( "td" )
									  select column).ToArray()[1];

			return HttpUtility.HtmlDecode( accInfoColumn.ToString() )
						.Replace( "\r", "" )
						.Replace( "\n", "" )
						.Replace( "\t", "" )
						.ToUpper()
						.Split( new string[] { "<BR />" }, StringSplitOptions.None );
		}
	}
}

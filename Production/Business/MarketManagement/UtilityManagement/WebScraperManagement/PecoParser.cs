namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Xml.Linq;
	using System.Web;
	using System.Linq;
	using System;
	using System.Text.RegularExpressions;
	using System.IO;
	using System.Collections.Generic;
	using HtmlAgilityPack;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	// EP - July 2010
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public class PecoParser
	{
		private XElement xmlDocument;
		public string[] accountInfo;
		private int usageTableXmlDocDescendant = 5; // index for usage table in XML document

		public PecoParser( string htmlContent )
		{
			xmlDocument = BuildXmlDocument( htmlContent );
			SetUsageTableXmlDocDescendant( xmlDocument.Descendants( "table" ).ToArray()[5] );
		}

		// ------------------------------------------------------------------------------------
		public Peco Parse()
		{
			Peco account = GetHeaderInformation();

			GetIcapData( account );
			GetTcapData( account );
			account.WebUsageList = GetUsageHistory( account );

			return account;
		}

		// ------------------------------------------------------------------------------------
		private string RemoveComments( string htmlContent )
		{
			Regex commentExp = new Regex( "<!--(.*?)-->" );

			return commentExp.Replace( htmlContent, "" );
		}

		// ------------------------------------------------------------------------------------
		private string HtmlToXml( string htmlContent )
		{
			HtmlDocument htmlDocument = new HtmlDocument();
			string content = string.Empty;

			using( StringWriter xmlWriter = new StringWriter() )
			{
				htmlDocument.LoadHtml( htmlContent );
				htmlDocument.OptionFixNestedTags = true;
				htmlDocument.OptionOutputAsXml = true;
				htmlDocument.Save( xmlWriter );

				content = xmlWriter.ToString();
			}

			return content;
		}

		// ------------------------------------------------------------------------------------
		private XElement BuildXmlDocument( string htmlContent )
		{
			string newContent;
			string xmlContent;

			newContent = RemoveComments( htmlContent );
			newContent = GetHtmlBody( newContent );				// removed javascript syntax..
			xmlContent = HtmlToXml( newContent );

			return XElement.Parse( xmlContent );
		}

		// ------------------------------------------------------------------------------------
		private string GetHtmlBody( string htmlContent )
		{
			int startIndex;
			int endIndex;

			startIndex = htmlContent.IndexOf( "<body " );
			endIndex = htmlContent.IndexOf( "</body>" ) + "</body>".Length;

			return htmlContent.Substring( startIndex, endIndex - startIndex );
		}

		// ------------------------------------------------------------------------------------
		private List<AvailableColumns> GetAvailableColumns()
		{
			XElement usageTable = xmlDocument.Descendants( "table" ).ToArray()[usageTableXmlDocDescendant];

			List<AvailableColumns> avaliableColumnList = new List<AvailableColumns>();

			int i = 0;

			foreach( XElement column in usageTable.Descendants( "a" ) )
			{
				avaliableColumnList.Add( new AvailableColumns( i, column.Value.Trim().ToLower() ) );
				i++;
			}

			return avaliableColumnList;
		}

		/// <summary>
		/// As ICAP expiration nears, an extra table is displayed on web page indicating pending ICAP data.
		/// We need to check for this as the parser will incorrectly parse this table as the usage table.
		/// Just increment the index by one to obtain the usage table if this is the case.
		/// </summary>
		/// <param name="usageTable">XElement</param>
		private void SetUsageTableXmlDocDescendant( XElement usageTable )
		{
			usageTableXmlDocDescendant =
				usageTable.ToString().ToLower().Contains( "pendingcapacity" )
				|| usageTable.ToString().ToLower().Contains( "pending capacity" )
				? 6 : 5;
		}

		// ------------------------------------------------------------------------------------
		private WebUsageList GetUsageHistory( Peco peco )
		{
			WebUsageList usageHistory = new WebUsageList();
			List<AvailableColumns> ColumnList = GetAvailableColumns();

			try
			{
				var tableRows = xmlDocument.Descendants( "table" ).ToArray()[usageTableXmlDocDescendant].Descendants( "tr" ).ToArray();

				for( int i = 1; i < tableRows.Count(); i++ )
					usageHistory.Add( XmlToUsage( tableRows[i], ColumnList, peco ) );
			}
			catch
			{ }

			return usageHistory;
		}

		// ------------------------------------------------------------------------------------
		private PecoUsage XmlToUsage( XElement usageElement, List<AvailableColumns> availableInfo, Peco peco )
		{
			PecoUsage pecoUsage = new PecoUsage();
			XElement[] columns = usageElement.Descendants( "span" ).ToArray();

			foreach( AvailableColumns info in availableInfo )
			{
				object value = GetInformationValue( info, columns );

				switch( info.Name )
				{
					case "end date":
						pecoUsage.EndDate = Convert.ToDateTime( value );
						break;

					case "start date":
						pecoUsage.BeginDate = Convert.ToDateTime( value );
						break;

					case "usage (kwh)":
						pecoUsage.TotalKwh = Convert.ToInt32( value.ToString().Split( '.' )[0] );
						break;

					case "demand (kw)":
						pecoUsage.Demand = Convert.ToDecimal( value );
						break;

					case "rate code":
						peco.RateCode = (string) value;
						break;

					case "rate class":
						peco.RateClass = (string) value;
						break;

					case "strata":
						peco.StratumVariable = (string) value;
						break;
				}
			}

			return pecoUsage;
		}

		// ------------------------------------------------------------------------------------
		private string GetInformationValue( AvailableColumns info, XElement[] columns )
		{
			return columns[info.Index].Value;
		}

		// ------------------------------------------------------------------------------------
		private string GetElementValue( Int16 tablePosition, Int16 rowPosition, Int16 columnPosition, Int16 elementPosition )
		{
			XElement headerTableNode = xmlDocument.Descendants( "table" ).ToArray()[tablePosition];
			XElement Row = headerTableNode.Descendants( "tr" ).ToArray()[rowPosition];
			XElement Column = (from column in Row.Descendants( "td" ) select column).ToArray()[columnPosition];
			XElement element = (from col in Column.Descendants( "span" ) select col).ToArray()[elementPosition];

			return HttpUtility.HtmlDecode( element.Value );
		}

		// ------------------------------------------------------------------------------------
		private void GetIcapData( Peco peco )
		{
			// 3rd table, 3rd row..
			// 1 - iCap
			// 2 - iCap start date
			// 3 - iCap end date
			try
			{
				peco.Icap = Convert.ToDecimal( GetElementValue( 2, 2, 0, 0 ) );
				peco.IcapStartDate = Convert.ToDateTime( GetElementValue( 2, 2, 1, 0 ) );
				peco.IcapEndDate = Convert.ToDateTime( GetElementValue( 2, 2, 2, 0 ) );
			}
			catch
			{ }
		}

		// ------------------------------------------------------------------------------------
		private void GetTcapData( Peco peco )
		{
			// 5th table, 2nd row..
			// 1 - tCap
			// 2 - tCap start date
			// 3 - tCap end date
			try
			{
				peco.Tcap = Convert.ToDecimal( GetElementValue( 4, 1, 0, 0 ) );
				peco.TcapBeginDate = Convert.ToDateTime( GetElementValue( 4, 1, 1, 0 ) );
				peco.TcapEndDate = Convert.ToDateTime( GetElementValue( 4, 1, 2, 0 ) );
			}
			catch
			{ }
		}

		// ------------------------------------------------------------------------------------
		private Peco GetHeaderInformation()
		{
			// 2nd table, 1st row..
			// 1 - account number
			// 2 - zip code
			// 3 - bill group
			Peco peco = new Peco();

			UsGeographicalAddress address = new UsGeographicalAddress();

			try
			{
				/*
				XElement headerTableNode = xmlDocument.Descendants( "table" ).ToArray()[1];
				XElement Row = headerTableNode.Descendants( "tr" ).ToArray()[0];
				XElement accInfoColumn = (from column in Row.Descendants( "td" ) select column).ToArray()[1];
				XElement element = (from col in accInfoColumn.Descendants( "span" ) select col).ToArray()[0];
				peco.AccountNumber = HttpUtility.HtmlDecode( element.Value );
				*/

				peco.AccountNumber = GetElementValue( 1, 0, 1, 0 );

				address.ZipCode = GetElementValue( 1, 1, 1, 0 );
				peco.Address = address;

				peco.BillGroup = GetElementValue( 1, 2, 1, 0 ) ;
			}
			catch
			{
				// TODO: implement catch..
			}

			return peco;
		}

	}
}

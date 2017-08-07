namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using HtmlAgilityPack;

	public class HtmlElementValueSelector
	{
		private HtmlDocument htmlDoc;

		public HtmlElementValueSelector( string htmlContent )
		{
			htmlDoc = new HtmlDocument();
			htmlDoc.LoadHtml( htmlContent );
		}

		public string Select( string elementId )
		{
			HtmlNode element = htmlDoc.GetElementbyId( elementId );
			string   value   = string.Empty;

			if( element != null )
				value = element.Attributes["value"].Value;

			return value;
		}

		public string SelectEventValidationValue()
		{
			return Select( "__EVENTVALIDATION" );
		}

		public string SelectViewStateValue()
		{
			return Select( "__VIEWSTATE" );
		}
	}
}

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Setter for utility code property from an Ediccount instance
	/// </summary>
	public class UtilityCodeSetter : IPropertySetter
	{
		private string utilityCode;

		/// <summary>
		/// Constructor that receives an utility code as its input
		/// </summary>
		/// <param name="utilityCode"></param>
		public UtilityCodeSetter( string utilityCode )
		{
			this.utilityCode = utilityCode;
		}

		/// <summary>
		/// Setts the utility code property from an Ediccount instance
		/// </summary>
		/// <param name="target">EdiAccount instance</param>
		/// <param name="fileCellContent">FileRow containing the data</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		public void SetValue( EdiAccount target, ref string fileCellContent, char fieldDelimiter )
		{
			target.UtilityCode = utilityCode;
		}
	}
}

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Sets the value of a property from a EdiAccount instance.
	/// </summary>
	public interface IPropertySetter
	{
		/// <summary>
		/// Sets the value of the target account based in the content of the file row
		/// </summary>
		/// <param name="target">Target account instance</param>
		/// <param name="fileCellContent">FileRow containing the data</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		void SetValue( EdiAccount target, ref string fileCellContent, char fieldDelimiter );
	}
}

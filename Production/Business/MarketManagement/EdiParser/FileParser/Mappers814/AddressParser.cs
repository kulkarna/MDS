namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	/// <summary>
	/// Parses GeographicalAddress properties of a EdiAccount instance.
	/// </summary>
	public class AddressParser : StringParser
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the property that will be parsed</param>
		/// <param name="cellIndex">Index of the cell in a FileRow instance wich contains the data that will be parsed</param>
		public AddressParser( Expression<Func<EdiAccount, string>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{
		}

		/// <summary>
		/// Assigns the parsed value to the property
		/// </summary>
		/// <param name="target">EdiAccount instance</param>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		public override void SetValue( EdiAccount target, ref string fileRowCell, char fieldDelimiter )
		{
			GeographicalAddress address;

			if( string.IsNullOrEmpty( target.BillTo ) )
			{
				if( target.ServiceAddress == null )
					target.ServiceAddress = new UsGeographicalAddress();

				address = target.ServiceAddress;
			}
			else
			{
				if( target.BillingAddress == null )
					target.BillingAddress = new UsGeographicalAddress();

				address = target.BillingAddress;
			}

			Setter.SetValue( address, Parse( ref fileRowCell, fieldDelimiter ), null );
		}
	}
}

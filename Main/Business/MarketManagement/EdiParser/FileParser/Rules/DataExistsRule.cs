namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that data exists.
	/// </summary>
	[Guid( "26799CC1-A697-4d9b-899A-C39DA1EF600D" )]
	public class DataExistsRule : BusinessRule
	{
		private string accountNumber;
		private string property;
		private string data;

		/// <summary>
		/// Constructor that takes an account number, property name and data.
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="property">Property name</param>
		/// <param name="data">Property data</param>
		public DataExistsRule( string accountNumber, string property, string data )
			: base( "Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.property = property;
			this.data = data;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			if( data == null || data.Trim().Length.Equals( 0 ) )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;

				string format = "No data found for {0}, account number {1}.";
				this.SetException( String.Format( format, property, accountNumber ) );
			}

			return this.Exception == null;
		}

		/// <summary>
		/// Validates value according to its type: datetime, decimal, string
		/// </summary>
		/// <param name="objToValidate">value to validate</param>
		/// <returns>True if value is valid</returns>
		public bool ValidateByType( Object objToValidate )
		{
			if (objToValidate is System.DateTime)
				return (validateDate((DateTime)(objToValidate)));

			if( objToValidate is System.Decimal )
				return (validateDecimal( (Decimal) (objToValidate) ));

			if( objToValidate is System.Int32 )
				return (validateInt( (Int32) (objToValidate) ));

			if( objToValidate is System.Int16 )
				return (validateShort( (Int16) (objToValidate) ));
			
			if( objToValidate is System.String )
				return (validateString( (string) (objToValidate) ));

			return Validate();
		}

		private bool validateDate( DateTime valueToValidate )
		{
			if( valueToValidate == DateTime.MinValue )
				setError();
			return this.Exception == null;
		}

		private bool validateDecimal( Decimal valueToValidate )
		{
			if( valueToValidate.Equals( Convert.ToDecimal( -1 ) ) )
				setError();
			return this.Exception == null;
		}

		private bool validateInt( Int32 valueToValidate )
		{
			if( valueToValidate.Equals( Convert.ToInt32( -1 ) ) )
				setError();
			return this.Exception == null;
		}

		private bool validateShort( Int16 valueToValidate )
		{
			if( valueToValidate.Equals( Convert.ToInt16( -1 ) ) )
				setError();
			return this.Exception == null;
		}


		private bool validateString( string valueToValidate )
		{
			if( valueToValidate == null || valueToValidate.Trim().Length.Equals( 0 ) )
				setError();
			return this.Exception == null;
		}

		private void setError()
		{
			this.DefaultSeverity = BrokenRuleSeverity.Error;

			string format = "No data found for {0}, account number {1}.";
			this.SetException( String.Format( format, property, accountNumber ) );

		}
	}
}

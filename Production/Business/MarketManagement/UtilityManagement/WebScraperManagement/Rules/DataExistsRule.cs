namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that "basic" data exists.
	/// </summary>
	[Guid( "C790BE55-8EAE-4c45-9E28-8D30493B4DEA" )]
	public class DataExistsRule : BusinessRule
	{
		private string accountNumber;
		private string property;
		private string data;
		private DateTime date;
		private Int32 number;

		// ------------------------------------------------------------------------------------
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

		// ------------------------------------------------------------------------------------
		public DataExistsRule( string accountNumber, string property, DateTime date )
			: base( "Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.property = property;
			this.date = date;
		}

		// ------------------------------------------------------------------------------------
		public DataExistsRule( string accountNumber, string property, Int32 number )
			: base( "Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.property = property;
			this.number = number;
		}

		// ------------------------------------------------------------------------------------
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

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates dates
		/// </summary>
		public bool ValidateDate()
		{
			if( date == DateTime.MinValue )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;

				string format = "No date found for {0}, account number {1}.";
				this.SetException( String.Format( format, property, accountNumber ) );
			}

			return this.Exception == null;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates numbers (must cast to int32)
		/// </summary>
		public bool ValidateNumber()
		{
			if( number == -1 )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;

				string format = "No number value found for {0}, account number {1}.";
				this.SetException( String.Format( format, property, accountNumber ) );
			}

			return this.Exception == null;
		}
	}
}

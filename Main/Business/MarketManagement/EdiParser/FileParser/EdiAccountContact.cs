namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	
	/// <summary>
	/// Contains all the contact information provided by the utlities
	/// </summary>
	public class EdiAccountContact
	{
		/// <summary>
		/// Contact name
		/// </summary>
		public string Name
		{
			get;
			set;
		}

		/// <summary>
		/// Contact email address
		/// </summary>
		public string EmailAddress
		{
			get;
			set;
		}

		/// <summary>
		/// Contact fax
		/// </summary>
		public string Fax
		{
			get;
			set;
		}

		/// <summary>
		/// Contact home phone
		/// </summary>
		public string HomePhone
		{
			get;
			set;
		}

		/// <summary>
		/// Contact work phone
		/// </summary>
		public string WorkPhone
		{
			get;
			set;
		}

		/// <summary>
		/// Contat telephone
		/// </summary>
		public string Telephone
		{
			get;
			set;
		}
	}
}

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;

	public class IDRAccount
	{
		public IDRAccount(  )
		{
		}

		#region Properties

		/// <summary>
		/// Holds the utility ID the account belongs to
		/// </summary>
		public string UtilityID
		{
			get;
			set;
		}

		/// <summary>
		/// Holds the account number
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Holds the IDS date
		/// </summary>
		public DateTime IDRStartDate
		{
			get;
			set;
		}

		/// <summary>
		/// Date the file was uploaded online
		/// </summary>
		public DateTime SiteUploadDate
		{
			get;
			set;
		}

		/// <summary>
		/// Date account was added to the database
		/// </summary>
		public DateTime CreateDate
		{
			get;
			set;
		}

		/// <summary>
		/// The user who added/modified the account in the DB
		/// </summary>
		public string User
		{
			get;
			set;
		}

		#endregion Properties

		#region .Equals override

		/// <summary>
		/// Override the equals method on the AccountIDR object to compare only the account number. Equals is used by Contains, IndexOf...
		/// </summary>
		/// <param name="obj">object to be compared</param>
		/// <returns>true if a match is found</returns>
		public override bool Equals( object obj )
		{
			if( obj == null )
				return false;

			if( this.GetType() != obj.GetType() )
				return false;

			// safe because of the GetType check
			IDRAccount account = (IDRAccount) obj;

			// use this pattern to compare reference members
			if( Object.Equals( this.AccountNumber, account.AccountNumber ) )
				return true;

			return false;
		}

		public override int GetHashCode()
		{
			return base.GetHashCode();
		}
		
		#endregion .Equals override

	}
}

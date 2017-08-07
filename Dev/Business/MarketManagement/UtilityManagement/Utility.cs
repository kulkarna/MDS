namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
using System.Runtime.Serialization;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonEntity;

	[Serializable]
	[DataContract]
	public class Utility : Entity, IOrganization, IComparable
	{
		/// <summary>
		/// The association allowing integration with the IOrganization interface.
		/// </summary>
		[DataMember]
		private Organization organization = new Organization();

		/// <summary>
		/// The code that uniquely identifies this utility.
		/// </summary>
		[DataMember]
		private string code;

		/// <summary>
		/// A short description of this utility.
		/// </summary>
		[DataMember]
		private string description;

		/// <summary>
		/// The Liberty Power entity code.
		/// </summary>
		[DataMember]
		private string companyEntityCode;

		/// <summary>
		/// The Liberty Power entity code.
		/// </summary>
		[DataMember]
		private UtilityAccountDictionary utilityAccountDictionary;

		/// <summary>
		/// Dictionary of zones for utility.
		/// </summary>
		[DataMember]
		private ZoneDictionary zoneDictionary;


		/// <summary>
		/// The user who created this utility in the database.
		/// </summary>
		new private string createdBy;

		/// <summary>
		/// The correct prefix for new account numbers of this utility
		/// </summary>
		private string accountNumberPrefix;

		/// <summary>
		/// The correct length for new account numbers of this utility
		/// </summary>
		private int accountNumberLength;

		/// <summary>
		/// The retail market associated with a utility as a state abbreviation
		/// </summary>
		private string retailMarketCode;

		/// <summary>
		/// The retail market associated with a utility as an ID
		/// </summary>
		private int retailMarketID;

		/// <summary>
		/// Billing type of the utility
		/// </summary>
		private string billingType;

		/// <summary>
		/// Style of RateCode construction
		/// </summary>
		private string rateCodeFormat;


		/// <summary>
		/// Style of RateCode construction
		/// </summary>
		private string rateCodeFields;

        /// <summary>
        /// Style of RateCodeRequired construction
        /// </summary>
        private string rateCodeRequired;

		/// <summary>
		/// Informs if SSN is required for the utility
		/// </summary>
		private bool ssnIsRequired;


		/// <summary>
		/// id of the utiltiy
		/// </summary>
		[DataMember]
		private int utilityId;

		/// <summary>
		/// Wholesale Market ID for the utility
		/// </summary>
		private string iso;

		// begin ticket 19975
		/// <summary>
		/// Informs if is POR utility
		/// </summary>
		private bool isPOR;
		// end ticket 19975

		// begin ticket 19540
		/// <summary>
		/// Informs type of Historical Usage request
		/// </summary>
		private string hu_RequestType;
		// end ticket 19540

		#region IOrganization Members

		/// <summary>
		/// The utility's DUNS number.
		/// </summary>
		/// <remarks>The DunsNumber returns the value from the property
		/// of the private field named <code>organization</code>.</remarks>
		public string DunsNumber
		{
			get { return organization.DunsNumber; }
			set { organization.DunsNumber = value; }
		}

		public string TaxID
		{
			get { return organization.TaxID; }
			set { organization.TaxID = value; }
		}

		#endregion

        #region Members Used by tablet
        //PBI - 103532
        public string GasSAPrefix;

        public string EnrollmentProcessDays;
        #endregion

		/// <summary>
		/// Instantiates a new instance of the Utility class.
		/// </summary>
		/// <param name="code">The code uniquely identifying the utility.</param>
		/// <remarks>The Utility class inherits from the CommonEntity.Entity
		/// class where it is initialized as an EntityType.Organization.</remarks>
		public Utility( string code )
			: base( EntityType.Organization )
		{
			this.code = code;
		}

		public Utility()
		{
		}

		public Utility( int id, string code )
			: base( EntityType.Organization )
		{
			this.Identity = id;
			this.code = code;
		}

		public Utility( string code, string accountNumberPrefix, int accountNumberLength )
			: base( EntityType.Organization )
		{
			this.code = code;
			this.accountNumberPrefix = accountNumberPrefix;
			this.accountNumberLength = accountNumberLength;
		}

		/// <summary>
		/// The code that uniquely identifies the utility.
		/// </summary>
		[DataMember]
		public string Code
		{
			get { return this.code; }
			set { this.code = value; }
		}

		public string Iso
		{
			get { return iso; }
			set { iso = value; }
		}

		/// <summary>
		/// A short description of the utility.
		/// </summary>
		[DataMember]
		public string Description
		{
			get { return this.description; }
			set { this.description = value; }
		}

		/// <summary>
		/// Concatenation of utility code and description
		/// </summary>
		[DataMember]
		public string CodeDescription
		{
			get;
			set;
		}

		/// <summary>
		/// The Liberty Power entity code.
		/// </summary>
		public string CompanyEntityCode
		{
			get { return this.companyEntityCode; }
			set { this.companyEntityCode = value; }
		}

		/// <summary>
		/// Dictionary of UtilityAccounts.
		/// </summary>
		public UtilityAccountDictionary UtilityAccounts
		{
			get { return this.utilityAccountDictionary; }
		}

		/// <summary>
		/// Dictionary of Zones.
		/// </summary>
		[DataMember]
		public ZoneDictionary Zones
		{
			get { return this.zoneDictionary; }
			set { this.zoneDictionary = value; }
		}

		/// <summary>
		/// Default Zone ID
		/// </summary>
		public int DefaultZoneID
		{
			get;
			set;
		}

		/// <summary>
		/// The user name who created this utility in the database.
		/// </summary>
		new public string CreatedBy
		{
			get { return this.createdBy; }
			set { this.createdBy = value; }
		}

		public int CreatedByID
		{
			get { return base.createdBy; }
			set { base.createdBy = value; }
		}

		/// <summary>
		/// The correct prefix for new account numbers of this utility
		/// </summary>
		public string AccountNumberPrefix
		{
			get { return accountNumberPrefix; }
			set { accountNumberPrefix = value; }
		}

		/// <summary>
		/// The correct length for new account numbers of this utility
		/// </summary>
		public int AccountNumberLength
		{
			get { return accountNumberLength; }
			set { accountNumberLength = value; }
		}

		/// <summary>
		/// The retail market associated with a utility as a state abbreviation
		/// </summary>
		public string RetailMarketCode
		{
			get { return retailMarketCode; }
			set { retailMarketCode = value; }
		}

		/// <summary>
		/// Gets or sets the retail market ID.
		/// </summary>
		/// <value>The retail market ID.</value>
		public int RetailMarketID
		{
			get { return retailMarketID; }
			set { retailMarketID = value; }
		}

		/// <summary>
		/// Billing type of the utility
		/// </summary>
		public string BillingType
		{
			get { return billingType; }
			set { billingType = value; }
		}

		/// <summary>
		/// Style of RateCode construction
		/// </summary>
		public string RateCodeFormat
		{
			get { return rateCodeFormat; }
			set { rateCodeFormat = value; }
		}

		/// <summary>
		/// Code indicating required rate code requirements fields
		/// </summary>
		public string RateCodeFields
		{
			get { return rateCodeFields; }
			set { rateCodeFields = value; }
		}

        /// <summary>
        /// Style of RateCodeRequired construction
        /// </summary>
        public string RateCodeRequired
        {
            get { return rateCodeRequired; }
            set { rateCodeRequired = value; }
        }

		public PricingMode PricingMode { get; set; }

		/// <summary>
		/// Gets or sets a value indicating whether [SSN is required].
		/// </summary>
		/// <value><c>true</c> if [SSN is required]; otherwise, <c>false</c>.</value>
		public bool SSNIsRequired
		{
			get { return ssnIsRequired; }
			set { ssnIsRequired = value; }
		}

		// begin ticket 19975
		/// <summary>
		/// Gets or sets a value indicating whether is POR.
		/// </summary>
		/// <value><c>true</c> if is POR; otherwise, <c>false</c>.</value>
		public bool IsPOR
		{
			get { return isPOR; }
			set { isPOR = value; }
		}
		// end ticket 19975

		// begin ticket 19540
		/// <summary>
		/// Gets or sets a value indicating whether is Historical Usage Request Type
		/// </summary>
		public string HU_RequestType
		{
			get { return hu_RequestType; }
			set { hu_RequestType = value; }
		}
		// end ticket 19540

		/// <summary>
		/// Gets or sets the identity.
		/// </summary>
		/// <value>The identity.</value>
		[DataMember]
		public int Identity
		{
			get { return utilityId; }
			set { utilityId = value; }
		}

		public bool IsScrapable { get; set; }

		/// <summary>
		/// Adds a UtilityAccount to dictionary
		/// </summary>
		/// <param name="utilityAccount">UtilityAccount object containing account data. </param>
		public void AddUtilityAccount( UtilityAccount utilityAccount )
		{
			if( utilityAccountDictionary == null )
				utilityAccountDictionary = new UtilityAccountDictionary();
			if( utilityAccountDictionary.ContainsKey( utilityAccount.AccountNumber ) == false )
				utilityAccountDictionary.Add( utilityAccount.AccountNumber, utilityAccount );
		}

		/// <summary>
		/// Adds a zone to dictionary
		/// </summary>
		/// <param name="zone">Zone for utility</param>
		public void AddZone( Zone zone )
		{
			if( zoneDictionary == null )
				zoneDictionary = new ZoneDictionary();
			zoneDictionary.Add( zone.ZoneCode, zone );
		}

		/// <summary>
		/// Implements the operator !=.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator !=( Utility x, Utility y )
		{
			return !(x == y);
		}

		/// <summary>
		/// Implements the operator ==.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator ==( Utility x, Utility y )
		{
			bool areEquals = false;
			if( (object) x != null && (object) y != null ) // If neither object is null then check properties.
			{
				areEquals = (x.Identity == y.Identity &&
							x.Code == y.Code
						);
			}
			else
			{
				areEquals = ((object) x == null && (object) y == null); // If at least one object is null then compare the objects. If both null then true else false.
			}

			return areEquals;
		}

		#region Overrides to support == and !=
		/// <summary>
		/// Determines whether the specified <see cref="System.Object"/> is equal to this instance.
		/// </summary>
		/// <param name="obj">The <see cref="System.Object"/> to compare with this instance.</param>
		/// <returns>
		/// 	<c>true</c> if the specified <see cref="System.Object"/> is equal to this instance; otherwise, <c>false</c>.
		/// </returns>
		/// <exception cref="T:System.NullReferenceException">
		/// The <paramref name="obj"/> parameter is null.
		/// </exception>
		public override bool Equals( object obj )
		{
			return base.Equals( obj );
		}

		/// <summary>
		/// Returns a hash code for this instance.
		/// </summary>
		/// <returns>
		/// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
		/// </returns>
		public override int GetHashCode()
		{
			return base.GetHashCode();
		}
		#endregion

		/// <summary>
		/// Can Utility have more than one meter per account
		/// </summary>
		public bool MultipleMeters
		{
			get;
			set;
		}

		/// <summary>
		/// Gets or sets the enrollment lead days
		/// </summary>
		public int EnrollmentLeadDays
		{
			get;
			set;
		}

		public override string ToString()
		{
			return this.Code;
		}

		public int CompareTo( object obj )
		{
			var util = obj as Utility;
			if( util == null )
				return 1;
			return CompareTo( util );
		}

		public int CompareTo( Utility other )
		{
			return this.Code.CompareTo( other.Code );
		}

        public int DefaultDeliveryLocationId { get; set; }

        public int DefaultProfileId { get; set; }
	}
}

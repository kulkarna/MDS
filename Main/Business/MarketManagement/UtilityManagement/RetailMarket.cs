namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
	using System.Runtime.Serialization;
using LibertyPower.Business.CommonBusiness.CommonHelper;

	[Serializable]
	[DataContract]
	public class RetailMarket : IComparable
	{
		private int id;
		private string marketCode;
		[DataMember]
		private UtilityDictionary utilities;

		public RetailMarket() { }

		public RetailMarket( int id, string marketCode )
		{
			this.id = id;
			this.marketCode = marketCode;
		}

		public RetailMarket( int id, string marketCode, string description )
		{
			this.ID = id;
			this.marketCode = marketCode;
			this.Description = description;
			this.CodeDescription = marketCode + " - " + description;
		}

		public RetailMarket( string marketCode )
		{
			this.marketCode = marketCode;
		}

		[DataMember]
		public string Code
		{
			get { return this.marketCode; }
			set { marketCode = value; }
		}

		[DataMember]
		public string Description
		{
			get;
			set;
		}

		[DataMember]
		public string CodeDescription
		{
			get;
			set;
		}

		[DataMember]
		public UtilityDictionary Utilities
		{
			get { return this.utilities; }
			set { utilities = value; }
		}

		public void AddUtility( Utility utility )
		{
			if( this.utilities == null )
				this.utilities = new UtilityDictionary();

			this.utilities.Add( utility );
		}

		[DataMember]
		public int ID
		{
			get { return this.id; }
			set { this.id = value; }
		}

		[DataMember]
		public int WholesaleMarkedId { get; set; }
		[DataMember]
		public string PucCertificationNumber { get; set; }
		[DataMember]
		public DateTime DateCreated { get; set; }
		[DataMember]
		public string UserName { get; set; }
		[DataMember]
		public DateTime ActiveDate { get; set; }
		[DataMember]
		public bool IsInactive { get; set; }
		[DataMember]
		public bool TransferOwnershipEnabled { get; set; }
		[DataMember]
		public string WholesaleMarketCode { get; set; }
		[DataMember]
		public int ChangeStamp { get; set; }
		[DataMember]
		public bool EnableTieredPricing { get; set; }

		/// <summary>
		/// Implements the operator !=.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator !=( RetailMarket x, RetailMarket y )
		{
			return !(x == y);
		}

		/// <summary>
		/// Implements the operator ==.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator ==( RetailMarket x, RetailMarket y )
		{
			bool areEquals = false;
			if( (object) x != null && (object) y != null ) // If neither object is null then check properties.
			{
				areEquals = (x.ID == y.ID &&
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
		public int CompareTo( object obj )
		{
			var mkt = obj as RetailMarket;
			if( mkt == null )
				return 1;    
			return CompareTo( mkt );
		}

		public int CompareTo( RetailMarket other )
		{
			return this.Code.CompareTo( other.Code );
	}

        public override string ToString()
        {
            return Code.Trim();
        }
	}
}

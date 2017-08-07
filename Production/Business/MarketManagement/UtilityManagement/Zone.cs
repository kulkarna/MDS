namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.Serialization;
	using System.Collections.Generic;
	using System.Text;

	[Serializable]
	[DataContract]
	public class Zone : IComparable
	{
		public Zone() { usages = new UsageDictionary(); }

		public Zone( int id, string code )
		{
			this.Identity = id;
			this.ZoneCode = code;
		}

		private int zoneId;
		private string retailMarket;
		private string utilityCode;
		private string zone;
		private UtilityAccountDictionary utilityAccountDictionary;
		private UsageDictionary usages;

		/// <summary>
		/// Gets or sets the identity.
		/// </summary>
		/// <value>The identity.</value>
		[DataMember]
		public int Identity
		{
			get { return this.zoneId; }
			set { this.zoneId = value; }
		}

		/// <summary>
		/// Gets or sets the retail market.
		/// </summary>
		/// <value>The retail market.</value>
		[DataMember]
		public string RetailMarket
		{
			get { return this.retailMarket; }
			set { this.retailMarket = value; }
		}

		/// <summary>
		/// A unique identifier of a utility.
		/// </summary>
		[DataMember]
		public string UtilityCode
		{
			get { return this.utilityCode; }
			set { this.utilityCode = value; }
		}

		/// <summary>
		/// A utility's zone.
		/// </summary>
		[DataMember]
		public string ZoneCode
		{
			get { return this.zone; }
			set { this.zone = value; }
		}

		/// <summary>
		/// Dictionary of UtilityAccounts.
		/// </summary>
		//[DataMember]
		public UtilityAccountDictionary UtilityAccounts
		{
			get { return this.utilityAccountDictionary; }
			set { this.utilityAccountDictionary = value; }
		}

		/// <summary>
		/// Aggregated monthly peak and off peak kwh for zone.
		/// </summary>
		[DataMember]
		public UsageDictionary Usages
		{
			get { return this.usages; }
			set { this.usages = value; }
		}

		public string DisplayName
		{
			get
			{
				return String.Format( "{0} - {1}", UtilityCode, ZoneCode );
			}
		}

		/// <summary>
		/// Adds an UtilityAccount to the UtilityAccountDictionary
		/// </summary>
		/// <param name="utilityAccount">UtilityAccount object</param>
		public void AddUtilityAccount( UtilityAccount utilityAccount )
		{
			if( utilityAccountDictionary == null )
				utilityAccountDictionary = new UtilityAccountDictionary();
			utilityAccountDictionary.Add( utilityAccount.AccountNumber, utilityAccount );
		}

		/// <summary>
		/// Implements the operator !=.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator !=( Zone x, Zone y )
		{
			return !(x == y);
		}

		/// <summary>
		/// Implements the operator ==.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator ==( Zone x, Zone y )
		{
			bool areEquals = false;
			if( (object) x != null && (object) y != null ) // If neither object is null then check properties.
			{
				areEquals = (x.Identity == y.Identity &&
							x.ZoneCode == y.ZoneCode
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
			var z = obj as Zone;
			if( z == null )
				return 1;
			return CompareTo( z );
		}

		public int CompareTo( Zone other )
		{
			return this.ZoneCode.CompareTo( other.ZoneCode );
		}
	}
}

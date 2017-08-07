namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
	using System.Runtime.Serialization;

	[Serializable]
	[DataContract]
    public class ServiceClass : IComparable
    {
        #region Properties

		[DataMember]
        public string Code
        {
            get; set;
        }

		[DataMember]
        public DateTime DateCreated
        {
            get; set;
        }

		[DataMember]
        public int Identity
        {
            get; set;
        }

		[DataMember]
        public string IstaMapping
        {
            get; set;
        }

		[DataMember]
        public string MarketCode
        {
            get; set;
        }

		[DataMember]
        public string RateCodeFileMapping
        {
            get; set;
        }

		[DataMember]
        public string UtilityCode
        {
            get; set;
        }

		[DataMember]
		public string DisplayName
		{
			get;
			set;
        }

        #endregion Properties

        #region Methods
		public ServiceClass(){}

		public ServiceClass(int identity, string code) 
		{
			this.Identity = identity;
			this.Code = code;
		}

		public ServiceClass( int identity, string code, string displayName )
		{
			this.Identity = identity;
			this.Code = code;
			this.DisplayName = displayName;
		}

        /// <summary>
        /// Implements the operator !=.
        /// </summary>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        /// <returns>The result of the operator.</returns>
		public static bool operator !=( ServiceClass x, ServiceClass y )
        {
            return !(x == y);
        }

        /// <summary>
        /// Implements the operator ==.
        /// </summary>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        /// <returns>The result of the operator.</returns>
        public static bool operator ==( ServiceClass x, ServiceClass y )
        {
            bool areEquals = false;
            if( (object) x != null && (object) y != null ) // If neither object is null then check properties.
            {
                areEquals = (x.Identity == y.Identity &&
                            x.Code == y.Code &&
                            x.IstaMapping == y.IstaMapping &&
                            x.MarketCode == y.MarketCode &&
                            x.UtilityCode == y.UtilityCode &&
                            x.RateCodeFileMapping == y.RateCodeFileMapping
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
			var s = obj as ServiceClass;
			if( s == null )
				return 1;
			return CompareTo( s );
		}

		public int CompareTo( ServiceClass other )
		{
			return this.Code.CompareTo( other.Code );
		}

        #endregion Methods
    }
}
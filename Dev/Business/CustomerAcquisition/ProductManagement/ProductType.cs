namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
    using System;
	using System.Runtime.Serialization;

	/// <summary>
    /// Product Type
    /// </summary>
	[Serializable]
	[DataContract]
    public class ProductType
	{
		public ProductType() { }

		public ProductType( int id, string name )
    {
			this.Identity = id;
			this.Name = name;
		}
        #region Properties

        /// <summary>
        /// Gets or sets the date created.
        /// </summary>
        /// <value>The date created.</value>
		[DataMember]
        public DateTime DateCreated
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets the identity(ID).
        /// </summary>
        /// <value>The identity.</value>
		[DataMember]
        public int Identity
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is active.
        /// </summary>
        /// <value><c>true</c> if this instance is active; otherwise, <c>false</c>.</value>
		[DataMember]
        public bool IsActive
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>The name.</value>
		[DataMember]
        public string Name
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets the name of the created by user.
        /// </summary>
        /// <value>The name of the user.</value>
		[DataMember]
        public string UserName
        {
            get; set;
        }

        #endregion Properties

		/// <summary>
		/// Implements the operator !=.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator !=( ProductType x, ProductType y )
		{
			return !(x == y);
		}

		/// <summary>
		/// Implements the operator ==.
		/// </summary>
		/// <param name="x">The x.</param>
		/// <param name="y">The y.</param>
		/// <returns>The result of the operator.</returns>
		public static bool operator ==( ProductType x, ProductType y )
		{
			bool areEquals = false;
			if( (object) x != null && (object) y != null ) // If neither object is null then check properties.
			{
				areEquals = (
								x.Identity == y.Identity &&
								x.Name == y.Name 
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
	}
}
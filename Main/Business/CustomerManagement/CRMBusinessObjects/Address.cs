using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	[Serializable]
	[System.Runtime.Serialization.DataContract]
	public class Address : ICloneable, IValidator
	{
		#region Primary key(s)
		/// <summary>			
		/// AccountAddressID : 
		/// </summary>
		/// <remarks>Member of the primary key of the underlying table "account_address"</remarks>
		public System.Int32? AddressId { get; set; }

		#endregion

		#region Non Primary key(s)

		/// <summary>
		/// address : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Street { get; set; }

		/// <summary>
		/// suite : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Suite { get; set; }

		/// <summary>
		/// city : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String City { get; set; }

		/// <summary>
		/// state : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String State { get; set; }

		/// <summary>
		/// zip : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Zip { get; set; }

		/// <summary>
		/// county : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String County { get; set; }

		/// <summary>
		/// state_fips : 
		/// </summary>
		public System.String StateFips { get; set; }

		/// <summary>
		/// county_fips : 
		/// </summary>
		public System.String CountyFips { get; set; }

		/// <summary>
		/// Modified : 
		/// </summary>
		public System.DateTime Modified { get; set; }

		/// <summary>
		/// ModifiedBy : 
		/// </summary>
		public System.Int32 ModifiedBy { get; set; }

		/// <summary>
		/// DateCreated : 
		/// </summary>
		public System.DateTime DateCreated { get; set; }

		/// <summary>
		/// CreatedBy : 
		/// </summary>
		public System.Int32 CreatedBy { get; set; }

		#endregion

		#region Clone Method

		/// <summary>
		/// Creates a new object that is a copy of the current instance.
		/// </summary>
		/// <returns>A new object that is a copy of this instance.</returns>
		public Object Clone()
		{
			Address _tmp = new Address();

			_tmp.AddressId = this.AddressId;

			_tmp.Street = this.Street;
			_tmp.Suite = this.Suite;
			_tmp.City = this.City;
			_tmp.State = this.State;
			_tmp.Zip = this.Zip;
			_tmp.County = this.County;
			_tmp.StateFips = this.StateFips;
			_tmp.CountyFips = this.CountyFips;

			return _tmp;
		}


		#endregion

		#region IValidator Members

		public bool IsStructureValidForInsert()
		{
			return true;
		}

		public bool IsStructureValidForUpdate()
		{
			return true;
		}

		public List<GenericError> IsValidForInsert()
		{
			List<GenericError> errors = new List<GenericError>();
			errors = IsValid();
			if( errors.Count > 0 )
				return errors;

			return errors;

		}

		public List<GenericError> IsValidForUpdate()
		{
			List<GenericError> errors = new List<GenericError>();
			errors = IsValid();

			if( errors.Count > 0 )
				return errors;


			if( !this.AddressId.HasValue )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Address: AddressId must have a valid value for update" } );
			}
			return new List<GenericError>();
		}

		public List<GenericError> IsValid()
		{
			List<GenericError> errors = new List<GenericError>();

			if( string.IsNullOrEmpty( this.Street ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Address: Street must have a valid value" } );
			}

			if( string.IsNullOrEmpty( this.City ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Address: City must have a valid value" } );
			}

			if( string.IsNullOrEmpty( this.State ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Address: State must have a valid value" } );
			}

			if( string.IsNullOrEmpty( this.Zip ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Address: Zip must have a valid value" } );
			}

			if( this.ModifiedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "ModifiedBy must have a valid value" } );
			}

			if( this.CreatedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "CreatedBy must have a valid value" } );
			}

			return errors;
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			return this.Street + "<br/>" + this.Suite + "<br/>" + this.City + ", " + this.State + " " + this.Zip;
		}

		#endregion
	}
}

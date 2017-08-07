using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	[Serializable]
	[System.Runtime.Serialization.DataContract]
	public class CustomerAddress : ICloneable, IValidator
	{
		#region Primary key(s)

		public System.Int32? CustomerAddressId { get; set; }

		#endregion

		#region Non Primary key(s)

		[System.Runtime.Serialization.DataMember]
		public System.Int32? CustomerId { get; set; }

		[System.Runtime.Serialization.DataMember]
		public System.Int32? AddressId { get; set; }

		public System.DateTime Modified { get; set; }

		public System.Int32 ModifiedBy { get; set; }

		public System.DateTime DateCreated { get; set; }

		public System.Int32 CreatedBy { get; set; }

		#endregion

		#region Clone Method

		/// <summary>
		/// Creates a new object that is a copy of the current instance.
		/// </summary>
		/// <returns>A new object that is a copy of this instance.</returns>
		public Object Clone()
		{
			throw new NotImplementedException();
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
			return new List<GenericError>();
		}

		public List<GenericError> IsValid()
		{
			List<GenericError> errors = new List<GenericError>();



			return errors;
		}

		#endregion
	}
}

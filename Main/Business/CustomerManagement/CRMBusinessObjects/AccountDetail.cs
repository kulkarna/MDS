using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	[Serializable]
	[System.Runtime.Serialization.DataContract]
	public class AccountDetail : ICloneable, IValidator
	{
		#region Constructors

		public AccountDetail()
		{
			this.EnrollmentType = Enums.EnrollmentType.Standard;
		}

		#endregion

		#region Primary key(s)
		/// <summary>			
		/// AccountDetailID : 
		/// </summary>
		/// <remarks>Member of the primary key of the underlying table "AccountDetail"</remarks>
		public System.Int32? AccountDetailId { get; set; }

		#endregion

		#region Non Primary key(s)

		/// <summary>
		/// AccountID : 
		/// </summary>
		public System.Int32? AccountId { get; set; }

		private System.Int32? _enrollmentTypeId;

		/// <summary>
		/// EnrollmentTypeID : 
		/// </summary>
		public System.Int32? EnrollmentTypeId
		{
			get
			{
				return this._enrollmentTypeId;
			}

			set
			{
				Enums.EnrollmentType tempType;
				if( Enum.TryParse<Enums.EnrollmentType>( value.ToString(), out tempType ) )
				{
					this._enrollmentTypeId = value;
				}
				else
				{
                    //PBI 34095 - Set default enrolment type id=1 instead of throwing exception.
                    this._enrollmentTypeId = 1;
					//throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.EnrollmentType" );
				}
			}
		}

		/// <summary>
		/// OriginalTaxDesignation : 
		/// </summary>
		public System.Int32? OriginalTaxDesignation { get; set; }

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

		#region Entity Types

		[System.Runtime.Serialization.DataMember]
		public Enums.EnrollmentType EnrollmentType
		{
			get
			{
				return (Enums.EnrollmentType) Enum.Parse( typeof( Enums.EnrollmentType ), this._enrollmentTypeId.ToString() );
			}

			set
			{
				this._enrollmentTypeId = (int) value;
			}
		}

		#endregion Entity Types

		#region Clone Method

		/// <summary>
		/// Creates a new object that is a copy of the current instance.
		/// </summary>
		/// <returns>A new object that is a copy of this instance.</returns>
		public Object Clone()
		{
			AccountDetail _tmp = new AccountDetail();
			_tmp.AccountDetailId = this.AccountDetailId;
			_tmp.AccountId = this.AccountId;
			_tmp.EnrollmentTypeId = this.EnrollmentTypeId;
			_tmp.OriginalTaxDesignation = this.OriginalTaxDesignation;
			_tmp.Modified = this.Modified;
			_tmp.ModifiedBy = this.ModifiedBy;
			_tmp.DateCreated = this.DateCreated;
			_tmp.CreatedBy = this.CreatedBy;
			return _tmp;
		}

		#endregion Clone Method

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
			errors = this.IsValid();
			return new List<GenericError>();
		}

		public List<GenericError> IsValidForUpdate()
		{
			return new List<GenericError>();
		}

		public List<GenericError> IsValid()
		{
			List<GenericError> errors = new List<GenericError>();

			if( this.ModifiedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "AccountUsage: ModifiedBy must have a valid value" } );
			}

			if( this.CreatedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "AccountUsage: CreatedBy must have a valid value" } );
			}

			return errors;
		}
		#endregion
	}
}

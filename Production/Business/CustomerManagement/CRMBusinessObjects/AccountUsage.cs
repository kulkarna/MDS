using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	[Serializable]
	public class AccountUsage : ICloneable, IValidator
	{

		#region Fields

		#endregion

		#region Properties

		#region Primary key(s)
		/// <summary>			
		/// AccountUsageID : 
		/// </summary>
		/// <remarks>Member of the primary key of the underlying table "AccountUsage"</remarks>
		public System.Int32? AccountUsageId { get; set; }

		#endregion

		#region Non Primary key(s)

		/// <summary>
		/// AccountID : 
		/// </summary>
		public System.Int32? AccountId { get; set; }

		/// <summary>
		/// AnnualUsage : 
		/// </summary>
		public System.Int32? AnnualUsage { get; set; }

		private System.Int32 _usageReqStatusId { get; set; }

		/// <summary>
		/// UsageReqStatusID : 
		/// </summary>
		public System.Int32 UsageReqStatusId
		{
			get
			{
				return this._usageReqStatusId;
			}

			set
			{
				Enums.UsageReqStatus tempType;
				if( Enum.TryParse<Enums.UsageReqStatus>( value.ToString(), out tempType ) )
				{
					this._usageReqStatusId = value;
				}
				else
				{
					throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of UsageReqStatus type" );
				}

			}
		}

		/// <summary>
		/// EffectiveDate : 
		/// </summary>
		public System.DateTime EffectiveDate { get; set; }

		/// <summary>
		/// Modified : 
		/// </summary>
		public System.DateTime Modified { get; set; }

		/// <summary>
		/// ModifiedBy : 
		/// </summary>
		public System.Int32? ModifiedBy { get; set; }

		/// <summary>
		/// DateCreated : 
		/// </summary>
		public System.DateTime DateCreated { get; set; }

		/// <summary>
		/// CreatedBy : 
		/// </summary>
		public System.Int32? CreatedBy { get; set; }
		#endregion

		#region Entity Members

		public Enums.UsageReqStatus UsageRequestStatus
		{
			get
			{
				return (Enums.UsageReqStatus) Enum.Parse( typeof( Enums.UsageReqStatus ), this._usageReqStatusId.ToString() );
			}

			set
			{
				this._usageReqStatusId = (int) value;
			}
		}

		#endregion

		#endregion

		#region Constructors

		public AccountUsage()
		{
			this.AnnualUsage = 0;
		}

		#endregion

		#region Event Handlers

		#endregion

		#region Methods

		#region Clone Method
		/// <summary>
		/// Creates a new object that is a copy of the current instance.
		/// </summary>
		/// <returns>A new object that is a copy of this instance.</returns>
		public Object Clone()
		{
			AccountUsage _tmp = new AccountUsage();
			_tmp.AccountUsageId = this.AccountUsageId;
			_tmp.AccountId = this.AccountId;
			_tmp.AnnualUsage = this.AnnualUsage;
			_tmp.UsageReqStatusId = this.UsageReqStatusId;
			_tmp.EffectiveDate = this.EffectiveDate;
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
			errors = IsValid();
			if( errors.Count > 0 )
				return errors;

			if( !this.AccountId.HasValue || this.AccountId.Value == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "AccountUsage: AccountId must have a valid value" } );
			}

			return errors;
		}

		public List<GenericError> IsValidForUpdate()
		{
			return new List<GenericError>();
		}

		public List<GenericError> IsValid()
		{
			List<GenericError> errors = new List<GenericError>();

			// BAL level validation, data validation
			if( this.EffectiveDate == DateTime.MinValue )
			{
				errors.Add( new GenericError() { Code = 0, Message = "AccountUsage: EffectiveDate must have a valid value" } );
			}

			if( this.UsageReqStatusId == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "AccountUsage: UsageReqStatusId must have a valid value" } );
			}

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

		#endregion

	}
}

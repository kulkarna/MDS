using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class AccountInfo : ICloneable, IValidator
    {
        #region Fields

        [NonSerialized]
        private string nameKey;

        #endregion

        #region Constructors

        public AccountInfo()
        {
        }

        #endregion

        #region Primary key(s)

        //public System.Int32? AccountInfoId { get; set; }

        public string LegacyAccountId { get; set; }

        #endregion

        #region Non Primary key(s)

        [System.Runtime.Serialization.DataMember]
        public string UtilityCode { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string NameKey {
            get
            {
                return nameKey != null ? nameKey.ToUpper() : nameKey;
            }

            set
            {
                nameKey = value;
            }
        }

        [System.Runtime.Serialization.DataMember]
        public string BillingAccount { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string MeterDataMgmtAgent { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string MeterServiceProvider { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string MeterInstaller { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string MeterReader { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string MeterOwner { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string SchedulingCoordinator { get; set; }

        /// <summary>
        /// DateCreated : 
        /// </summary>
        public System.DateTime? DateCreated { get; set; }

        /// <summary>
        /// CreatedBy : 
        /// </summary>
        public System.String CreatedBy { get; set; }

        #endregion

        #region Entity Types

        #endregion Entity Types

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountInfo aInfo = new AccountInfo();
            //TODO: Finish this
            aInfo.BillingAccount = this.BillingAccount;
            aInfo.LegacyAccountId = this.LegacyAccountId;
            aInfo.MeterDataMgmtAgent = this.MeterDataMgmtAgent;
            aInfo.MeterInstaller = this.MeterInstaller;
            aInfo.MeterOwner = this.MeterOwner;
            aInfo.MeterReader = this.MeterReader;
            aInfo.MeterServiceProvider = this.MeterServiceProvider;
            aInfo.NameKey = this.NameKey;
            aInfo.SchedulingCoordinator = this.SchedulingCoordinator;
            aInfo.CreatedBy = this.CreatedBy;
            aInfo.DateCreated = this.DateCreated;
            aInfo.UtilityCode = this.UtilityCode;
            return aInfo;
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

            if( string.IsNullOrEmpty( this.UtilityCode ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountInfo: UtilityCode must have a valid value" } );
            }

            if( string.IsNullOrEmpty( this.LegacyAccountId ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountInfo: LegacyAccountId must have a valid value" } );
            }

            return errors;
        }
        #endregion
    }
}

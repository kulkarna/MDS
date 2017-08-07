using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.Text.RegularExpressions;
using System.Runtime.Serialization;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class Customer : ICloneable, IValidator
    {
        #region Constructors

        public Customer()
        {
            SetDefaultValues();
        }

        /// <summary>
        /// Sets the class' default values, it is called on object construction, but it is also used in WCF implementation
        /// </summary>
        public void SetDefaultValues()
        {
            if( !this.BusinessActivityId.HasValue )
                this.BusinessActivityId = 1;
        }

        [OnDeserialized]
        private void SetValuesOnDeserialized( StreamingContext context )
        {
            SetDefaultValues();
        }

        #endregion

        #region Primary key(s)
        /// <summary>			
        /// CustomerID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "Customer"</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? CustomerId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// NameID : 
        /// </summary>
        public System.Int32? NameId { get; set; }

        /// <summary>
        /// OwnerNameID : 
        /// </summary>
        public System.Int32? OwnerNameId { get; set; }

        /// <summary>
        /// AddressID : 
        /// </summary>
        public System.Int32? AddressId { get; set; }

        /// <summary>
        /// ContactID : 
        /// </summary>
        public System.Int32? ContactId { get; set; }

        /// <summary>
        /// CustomerPreferenceId : 
        /// </summary>
        public System.Int32? CustomerPreferenceId { get; set; }

        /// <summary>
        /// DBA : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Dba { get; set; }

        /// <summary>
        /// Duns : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Duns { get; set; }

        /// <summary>
        /// SsnClear : Use this value to change the social security, otherwise it will be ignored.
        /// When saving clear information, the save method will encrypt the ssn
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String SsnClear { get; set; }

        /// <summary>
        /// SsnEncrypted : Not exposed to the outside, only assign valid encrypted 
        /// values to this property otherwise it will give an error.
        /// 
        /// </summary>
        public System.String SsnEncrypted { get; set; }

        public System.String TaxIdEncrypted { get; set; }

        /// <summary>
        /// TaxId : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String TaxId { get; set; }

        /// <summary>
        /// EmployerId : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String EmployerId { get; set; }

        /// <summary>
        /// CreditAgencyID : 
        /// </summary>
        public System.Int32? CreditAgencyId { get; set; }

        /// <summary>
        /// CreditScoreEncrypted : 
        /// </summary>
        public System.String CreditScoreEncrypted { get; set; }

        /// <summary>
        /// BusinessTypeID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? BusinessTypeId { get; set; }

        /// <summary>
        /// BusinessActivityID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? BusinessActivityId { get; set; }

        /// <summary>
        /// ExternalNumber : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String ExternalNumber { get; set; }

        /// <summary>
        /// TaxExempt : 
        /// </summary>
        public System.Boolean? TaxExempt { get; set; }

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

        #region Entity Properties

        public string BusinessType { get; set; }

        public string BusinessActivity { get; set; }

        public string CreditAgency { get; set; }

        [System.Runtime.Serialization.DataMember]
        public Address CustomerAddress { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string CustomerName { get; set; }

        [System.Runtime.Serialization.DataMember]
        public string OwnerName { get; set; }

        [System.Runtime.Serialization.DataMember]
        public Contact Contact { get; set; }

        /// <summary>
        /// Retreives the CustomerPreference for this Customer 
        /// </summary>		
        [System.Runtime.Serialization.DataMember]
        public CustomerPreference Preferences { get; set; }

        public List<Account> Accounts { get; set; }

        #endregion Entity Properties

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            Customer _tmp = new Customer();

            _tmp.CustomerId = this.CustomerId;

            _tmp.NameId = this.NameId;
            _tmp.OwnerNameId = this.OwnerNameId;
            _tmp.AddressId = this.AddressId;
            _tmp.CustomerPreferenceId = this.CustomerPreferenceId;
            _tmp.ContactId = this.ContactId;
            _tmp.Dba = this.Dba;
            _tmp.Duns = this.Duns;
            _tmp.SsnClear = this.SsnClear;
            _tmp.SsnEncrypted = this.SsnEncrypted;
            _tmp.TaxId = this.TaxId;
            _tmp.EmployerId = this.EmployerId;
            _tmp.CreditAgencyId = this.CreditAgencyId;
            _tmp.CreditScoreEncrypted = this.CreditScoreEncrypted;
            _tmp.BusinessTypeId = this.BusinessTypeId;
            _tmp.BusinessActivityId = this.BusinessActivityId;
            _tmp.ExternalNumber = this.ExternalNumber;
            _tmp.Modified = this.Modified;
            _tmp.ModifiedBy = this.ModifiedBy;
            _tmp.DateCreated = this.DateCreated;
            _tmp.CreatedBy = this.CreatedBy;

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

            if( (!this.CustomerPreferenceId.HasValue || this.CustomerPreferenceId.Value == 0) )
            {
                errors.Add( new GenericError() { Code = 8081, Message = "Customer CustomerPreferenceId must have a valid value" } );
            }

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            // careful with this call -- Don't tell me what to do
            List<GenericError> errors = new List<GenericError>();
            errors = IsValid();

            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            // BAL level validation, data validation
            if( (!this.NameId.HasValue || this.NameId.Value == 0) && string.IsNullOrEmpty( this.CustomerName ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer Name must have a valid value" } );
            }

            if( (!this.OwnerNameId.HasValue || this.OwnerNameId.Value == 0) && string.IsNullOrEmpty( this.OwnerName ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer Owner Name must have a valid value" } );
            }

            if( (!this.AddressId.HasValue || this.AddressId.Value == 0) )
            {
                errors.Add( new GenericError() { Code = 8080, Message = "Customer AddressId must have a valid value" } );
            }

            if( (!this.ContactId.HasValue || this.ContactId.Value == 0) )
            {
                errors.Add( new GenericError() { Code = 8082, Message = "Customer ContactId must have a valid value" } );
            }

            if( !this.BusinessTypeId.HasValue || this.BusinessTypeId.Value == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer BusinessTypeId must have a valid value" } );
            }

            if( !this.BusinessActivityId.HasValue || this.BusinessActivityId.Value == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer BusinessActivityId must have a valid value" } );
            }

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Customer CreatedBy must have a valid value" } );
            }

            // Check if SSN is set when customer type is residential
            if( (this.BusinessTypeId == 7) ) // is customer type residential? 
            {
                if( String.IsNullOrEmpty( this.SsnClear ) && String.IsNullOrEmpty( this.SsnEncrypted ) )
                {
                    errors.Add( new GenericError() { Code = 0, Message = "SSN is required for Residential customers" } );
                }
                else // one of the 2 ssn has a value, but it might be incorrrect
                {
                    // encrypted value has precedence:
                    string ssnTemp = "";
                    // SSNencrypted 
                    if( !string.IsNullOrEmpty( this.SsnEncrypted ) && this.IsSSNEncryptedValid() )
                    {
                        // TODO: catch error possible value that crashes the crypt engine
                        ssnTemp = LibertyPower.Business.CommonBusiness.CommonEncryption.Crypto.Decrypt( this.SsnEncrypted );
                    }
                    else
                    {
                        ssnTemp = this.SsnClear;
                    }

                    if( !IsSSNValid( ssnTemp ) )
                    {
                        errors.Add( new GenericError() { Code = 0, Message = "SSN is not valid" } );
                    }
                    //else
                    //{
                    //    this.SsnClear = "";// clear this field since we dont need to save the exposed SSN in the DB 
                    //    this.SsnEncrypted = LibertyPower.Business.CommonBusiness.CommonEncryption.Crypto.Encrypt( ssnTemp );
                    //}
                }
            }

            return errors;
        }


        public static bool IsSSNValid( string socialSecurityNumber )
        {
            bool result = true;
            Regex re = new Regex( "^\\d{9}$|^\\d{3}-\\d{2}-\\d{4}$" );
            if( re.IsMatch( socialSecurityNumber ) )
            {
                socialSecurityNumber = socialSecurityNumber.Replace( "-", "" );
                string areaNumber = socialSecurityNumber.Substring( 0, 3 );
                if( areaNumber == "666" || areaNumber == "000" || (Convert.ToInt32( areaNumber ) >= 900 && Convert.ToInt32( areaNumber ) <= 999) )
                    result = false;
            }
            else
            {
                result = false;
            }

            return result;
        }

        public bool IsSSNEncryptedValid()
        {
            int tempValue;
            bool isInteger = int.TryParse( this.SsnEncrypted, out tempValue );
            //TODO: Make this function stronger, need to fully test that the string in the encrypted string is valid, like 128 chars or valid symbols
            return !isInteger;

        }

        #endregion

    }

}

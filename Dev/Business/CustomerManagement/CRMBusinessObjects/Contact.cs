using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class Contact : ICloneable, IValidator
    {
        #region Constructors

        public Contact()
        {

        }

        /// <summary>
        /// Sets the class' default values, it is called on object construction, but it is also used in WCF implementation
        /// </summary>
        public void SetDefaultValues()
        {
            if( this.Birthday == DateTime.MinValue )
                this.Birthday = new DateTime( 1900, 1, 1 );
            if( string.IsNullOrEmpty( this.Email ) )
                this.Email = string.Empty;
        }

        [OnDeserialized]
        private void SetValuesOnDeserialized( StreamingContext context )
        {
            SetDefaultValues();
        }

        #endregion

        #region Primary key(s)
        /// <summary>			
        /// AccountContactID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "account_contact"</remarks>
        public System.Int32? ContactId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// first_name : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String FirstName { get; set; }

        /// <summary>
        /// last_name : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String LastName { get; set; }

        /// <summary>
        /// title : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Title { get; set; }

        /// <summary>
        /// phone : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Phone { get; set; }

        /// <summary>
        /// fax : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Fax { get; set; }

        /// <summary>
        /// email : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Email { get; set; }

        /// <summary>
        /// birthday : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime Birthday { get; set; }

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
            Contact _tmp = new Contact();
            _tmp.ContactId = this.ContactId;
            _tmp.FirstName = this.FirstName;
            _tmp.LastName = this.LastName;
            _tmp.Title = this.Title;
            _tmp.Phone = this.Phone;
            _tmp.Fax = this.Fax;
            _tmp.Email = this.Email;
            _tmp.Birthday = this.Birthday;

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
            return new List<GenericError>();
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if( string.IsNullOrEmpty( this.FirstName ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contact: FirstName must have a valid value" } );
            }

            if( string.IsNullOrEmpty( this.LastName ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contact: LastName must have a valid value" } );
            }

            if( string.IsNullOrEmpty( this.Title ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Title: Title must have a valid value" } );
            }

            if( !string.IsNullOrEmpty( this.Email ) )
            {
                if( !LibertyPower.Business.CommonBusiness.CommonHelper.ValidationHelper.isEmailAddressValid( this.Email ) )
                {
                    errors.Add( new GenericError() { Code = 0, Message = "Contact: Email must be a valid email address" } );
                }
            }

            if( string.IsNullOrEmpty( this.Phone ) || (this.Phone.Length < 10) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contact: Phone must have a valid value" } );
            }

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contact: ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contact: CreatedBy must have a valid value" } );
            }

            if( this.Birthday < new DateTime( 1753, 1, 1 ) || this.Birthday > new DateTime( 9999, 12, 31 ) )
            {
                this.Birthday = new DateTime( 1900, 1, 1 );
                //errors.Add( new GenericError() { Code = 0, Message = "Contact: Birthday must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM " } );
            }

            return errors;
        }

        #endregion
    }
}

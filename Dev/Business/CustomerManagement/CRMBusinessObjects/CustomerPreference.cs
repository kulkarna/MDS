using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class CustomerPreference : ICloneable, IValidator
    {

        public CustomerPreference()
        {
            this.LanguageId = 1;
        }
        #region Primary key(s)
        /// <summary>			
        /// CustomerPreferenceID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "CustomerPreference"</remarks>
        public System.Int32? CustomerPreferenceId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// IsGoGreen : If the customer wants to receive electronic version of the statements
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Boolean IsGoGreen { get; set; }

        /// <summary>
        /// OptOutSpecialOffers : CUstomer would like to receive special offers via email/mail
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Boolean OptOutSpecialOffers { get; set; }

        /// <summary>
        /// LanguageID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32 LanguageId { get; set; }

        /// <summary>
        /// Pin : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Pin { get; set; }

        /// <summary>
        /// CustomerContactPreferenceId : The customer contact preference (phone, email, fax, etc.). Links to the CustomerContactPreference table.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32 CustomerContactPreferenceId { get; set; }

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
            CustomerPreference _tmp = new CustomerPreference();

            _tmp.CustomerPreferenceId = this.CustomerPreferenceId;

            _tmp.IsGoGreen = this.IsGoGreen;
            _tmp.OptOutSpecialOffers = this.OptOutSpecialOffers;
            _tmp.LanguageId = this.LanguageId;
            _tmp.Pin = this.Pin;
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
                errors.Add( new GenericError() { Code = 0, Message = "ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "CreatedBy must have a valid value" } );
            }
            return errors;
        }

        #endregion
    }
}


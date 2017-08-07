using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public partial class Account : IValidatableObject
    {

        //public account_name AccountName
        //{
        //    get;
        //    set;
        //}

        //public account_address BillingAddress
        //{
        //    get;
        //    set;
        //}

        //public account_contact BillingContact
        //{
        //    get;
        //    set;
        //}

        //public account_address ServiceAddress
        //{
        //    get;
        //    set;
        //}



        #region IValidatableObject Members

        public IEnumerable<ValidationResult> Validate( ValidationContext validationContext )
        {

            if( !this.AccountNameID.HasValue || this.AccountNameID.Value == 0 )
            {
                yield return new ValidationResult( "AccountNameID must have a valid value", new[] { "AccountNameID" } );
            }

            if( !this.BillingAddressID.HasValue || this.BillingAddressID.Value == 0 )
            {
                yield return new ValidationResult( "BillingAddressID must have a valid value", new[] { "BillingAddressID" } );
            }

            if( !this.BillingContactID.HasValue || this.BillingContactID.Value == 0 )
            {
                yield return new ValidationResult( "BillingContactID must have a valid value", new[] { "BillingContactID" } );
            }

            if( !this.ServiceAddressID.HasValue || this.ServiceAddressID.Value == 0 )
            {
                yield return new ValidationResult( "ServiceAddressID must have a valid value", new[] { "ServiceAddressID" } );
            }

        }

        #endregion


    }
}

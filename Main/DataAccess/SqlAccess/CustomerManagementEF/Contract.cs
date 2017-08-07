using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public partial class Contract : IValidatableObject
    {

        public int Terms
        {
            get
            {
                if( this.EndDate > this.StartDate )
                {
                    int months = (this.EndDate.Year - this.StartDate.Year) * 12;
                    months = months + (this.EndDate.Month - this.StartDate.Month);
                    return months;
                }
                else
                {
                    return 0;
                }
            }

        }


        public int TotalAccounts
        {
            get
            {
                return this.AccountContracts.Count;
            }
        }

        public AccountContractRate FirstAccountContractRate
        {
            get
            {
                return this.AccountContracts.First().AccountContractRates.First();
            }
        }

        public Customer FirstCustomer
        {
            get
            {
                return this.AccountContracts.First().Account.Customer;
            }
        }



        #region IValidatableObject Members

        public IEnumerable<ValidationResult> Validate( ValidationContext validationContext )
        {

            if( this.StartDate > this.EndDate )
            {
                yield return new ValidationResult( "Contract start date must be at least a day before end date", new[] { "StartDate", "EndDate" } );
            }


            if( string.IsNullOrEmpty( this.Number ) || this.Number.Trim().Length <= 0 )
            {
                yield return new ValidationResult( "Contract number must be supplied", new[] { "Number" } );
            }

        }

        #endregion


    }
}

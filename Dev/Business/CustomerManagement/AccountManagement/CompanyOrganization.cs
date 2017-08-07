using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonEntity;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class CompanyOrganization : CompanyCustomer, IOrganization
    {
        public CompanyOrganization() 
            : base(EntityType.Organization) { }

        #region IOrganization Members

        public string DunsNumber
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public string TaxID
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        #endregion
    }
}

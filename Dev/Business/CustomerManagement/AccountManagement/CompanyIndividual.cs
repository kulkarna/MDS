using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonEntity;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class CompanyIndividual : CompanyCustomer, IIndividual
    {

        public CompanyIndividual()
            : base(EntityType.Individual) { }

        #region IIndividual Members

        public string FirstName
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

        public string LastName
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

        public char? MiddleInitial
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

        public string MiddleName
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

        public string Title
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

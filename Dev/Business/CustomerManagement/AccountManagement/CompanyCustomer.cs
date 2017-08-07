using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.CommonBusiness.CommonEntity;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class CompanyCustomer : ProspectCustomer
    {
        public CompanyCustomer(EntityType entityType)
            : base(entityType)
        { }

    }
}

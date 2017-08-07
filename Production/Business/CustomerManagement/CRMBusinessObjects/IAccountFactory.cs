using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BALEntity = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public interface IAccountFactory
    {

          BALEntity.AccountDetail GetAccountDetail( DALEntity.AccountDetail accountDetail );
          DALEntity.AccountDetail GetAccountDetail( BALEntity.AccountDetail accountDetail );

          BALEntity.Account GetAccount( DALEntity.Account account );

          DALEntity.Account GetAccount( BALEntity.Account account );

          DALEntity.AccountUsage GetAccountUsage( BALEntity.AccountUsage balUsage );

          BALEntity.AccountUsage GetAccountUsage( DALEntity.AccountUsage dalUsage );

    }
}

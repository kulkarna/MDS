using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects {
    public static class AccountTypeFactory {
        public static AccountType GetAccountType(int accountTypeId) {
            AccountType accountType = null;
            DataSet ds = CRMLibertyPowerSql.GetAccountType(accountTypeId);

            if (LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow(ds)) {
                accountType = new AccountType();
                MapDataRowToAccountType(ds.Tables[0].Rows[0], accountType);
            }

            return accountType;
        }

		//Added to get the product Account TypeId for a given AccountTypeID
		//June 27 2014 Bug 43313
		public static int? GetProductAccountTypeId( int accountTypeId )
		{
			AccountType accountType = null;
			DataSet ds = CRMLibertyPowerSql.GetAccountType( accountTypeId );

			if( LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ) )
			{
				accountType = new AccountType();
				MapDataRowToAccountType( ds.Tables[0].Rows[0], accountType );
			}

			return accountType.ProductAccountTypeID;
		}

        private static void MapDataRowToAccountType(DataRow dataRow, AccountType accountType) {
            accountType.ID = dataRow.Field<int>("ID");
            accountType.AccountType1 = dataRow.Field<string>("AccountType");
            accountType.Description = dataRow.Field<string>("Description");
            accountType.AccountGroup = dataRow.Field<string>("AccountGroup");
            accountType.DateCreated = dataRow.Field<DateTime>("DateCreated");
            accountType.ProductAccountTypeID = dataRow.Field<int?>("ProductAccountTypeID");
        }
    }
}

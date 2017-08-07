using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
    public class AccountDataAmeren : AccountData
    {
        public AccountDataAmeren(string accountNumber, string utilityCode)
            : base(accountNumber, utilityCode)
        {
        }

        internal override bool GetProperties()
        {
            try
            {
                DataSet ds = TransactionsSql.GetAmerenAccountLatestWithServicePoint(AccountNumber);
                if (DataSetHelper.HasRow(ds))
                {
                    bool bFirst = true;
                    double icap = 0.0;
                    string servicePoint = string.Empty;
                    double d = 0.0;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {

                        if (bFirst)
                        {
                            BillingCycle = GetCleanBillingValue(dr["BillGroup"]);
                            Profile = GetStringValue(dr["ProfileClass"]);
                            ServiceClass = GetStringValue(dr["ServiceClass"]);
                            bFirst = false;
                        }


                        if (dr["EffectivePLC"] != DBNull.Value)
                            double.TryParse(dr["EffectivePLC"].ToString(), out d);
                        if (GetStringValue(dr["ServicePoint"]) != servicePoint)
                            icap += d;
                        servicePoint = GetStringValue(dr["ServicePoint"]);
                    }

                    Icap = GetCleanCapValue(icap);
                    return true;
                }
                Message = "Account number " + AccountNumber + " was not found.";
                return false;
            }
            catch (Exception ex)
            {
                Message = AccountNumber + @"/" + UtilityCode + ":" + MethodBase.GetCurrentMethod().Name + "-" + ex.Message;
                return false;
            }
        }
    }
}

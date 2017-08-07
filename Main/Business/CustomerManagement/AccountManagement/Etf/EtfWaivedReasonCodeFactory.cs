using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public static class EtfWaivedReasonCodeFactory
    {

        public static EtfWaivedReasonCodeList GetCodes()
        {

            EtfWaivedReasonCodeList etfReasonCodeList = new EtfWaivedReasonCodeList();

            DataSet ds = EtfSql.GetEtfWaivedReasonCodes();

            if (ds == null || ds.Tables[0] == null)
            {
                throw new Exception("ETF Reason Codes could not be retrieved.");
            }

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                int id = Helper.ConvertFromDB<int>(dr["EtfWaivedReasonCodeID"]);
                string code = Helper.ConvertFromDB<string>(dr["Reason"]);
                EtfWaivedReasonCode etfReasonCode = new EtfWaivedReasonCode(id, code);
                etfReasonCodeList.Add(etfReasonCode);
            }

            return etfReasonCodeList;

        }
    
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using System.Data;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    [Serializable]
    public static class TaxTemplateFactory
    {
        public static List<TaxTemplate> Select(string utilityCode)
        {
            var ds = TaxTemplateSql.Select(utilityCode);
           return BuildTaxTemplate(ds);
        }

        public static List<TaxTemplate> Select(int  utilityId)
        {
            var ds = TaxTemplateSql.Select(utilityId);
            return BuildTaxTemplate(ds);
        }

        private static List<TaxTemplate> BuildTaxTemplate(DataSet ds)
        {
             var taxTemplateList = new List<TaxTemplate>();
        
            if (DataSetHelper.HasRow(ds))
            {
                taxTemplateList.AddRange(ds.Tables[0].Rows.Cast<DataRow>().Select(data => 
                    new TaxTemplate
                    {
                        UtilityId = data["UtilityId"] == DBNull.Value ? -1 : Convert.ToInt32(data["UtilityId"]), 
                        Template = data["Template"] == DBNull.Value ? "-1" : data["Template"].ToString(), 
                        TypeOfTax = data["TypeOfTax"] == DBNull.Value ? "-1" : data["TypeOfTax"].ToString(), 
                        TaxTypeId = data["TaxTypeID"] == DBNull.Value ? -1 : Convert.ToInt32(data["TaxTypeID"]), 
                        PercentTaxable = data["PercentTaxable"] == DBNull.Value ? -1 : Convert.ToInt32(data["PercentTaxable"]), 
                        TaxTemplateId = data["TaxTemplateID"] == DBNull.Value ? -1 : Convert.ToInt32(data["TaxTemplateID"])
                    }));
            }
            return taxTemplateList;
        }

        public static bool Update(int taxTemplateId, int percentTaxable, out string msg)
        {
            msg = string.Empty;
            try
            {
                TaxTemplateSql.Update(taxTemplateId, percentTaxable);
                msg = "Record Updated";
                return true;
            }
            catch (Exception ex)
            {
                msg = "Error Updating record: " + ex.Message;
                return false;
            }

        }

    }
}

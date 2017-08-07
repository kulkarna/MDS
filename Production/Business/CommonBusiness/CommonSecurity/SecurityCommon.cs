using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public static class SecurityCommon
    {
        /// <summary>
        /// Validate a dataset, checking it is has a table and rows.
        /// </summary>
        /// <param name="ds"></param>
        /// <returns>true or false..True means it has valid data</returns>
        public static bool IsValidDataset(DataSet ds)
        {
            if (ds == null || ds.Tables == null || ds.Tables[0].Rows.Count == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}

using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class LibertyPowerBillingTypeModel
    {
        public List<LibertyPowerBillingTypeListModel> LpBillingTypeList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }

        public LibertyPowerBillingTypeModel()
        {
        }

        //public LibertyPowerBillingTypeModel(DataTable dataTable)
        //{
        //    LpBillingTypeList = new List<LibertyPowerBillingTypeListModel>();
        //    if (dataTable != null && dataTable.Rows != null && dataTable.Rows.Count > 0)
        //    {
        //        foreach (DataRow dataRow in dataTable.Rows) 
        //        {
        //            LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel = new LibertyPowerBillingTypeListModel(dataRow);
        //            SelectedUtilityCompanyId = libertyPowerBillingTypeListModel.SelectedUtilityCompanyId;
        //            LpBillingTypeList.Add(libertyPowerBillingTypeListModel);
        //        }
        //    }
        //}

        //public LibertyPowerBillingTypeModel(System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_LibertyPowerBillingType_SELECT_ByUtilityCompanyId_Result> data)
        //{
        //    LpBillingTypeList = new List<LibertyPowerBillingTypeListModel>();
        //    if (data != null)
        //    {
        //        foreach (DataAccessLayerEntityFramework.usp_LibertyPowerBillingType_SELECT_ByUtilityCompanyId_Result item in data)
        //        {
        //            LibertyPowerBillingTypeListModel libertyPowerBillingTypeListModel = new LibertyPowerBillingTypeListModel(item);
        //            SelectedUtilityCompanyId = libertyPowerBillingTypeListModel.SelectedUtilityCompanyId;
        //            LpBillingTypeList.Add(libertyPowerBillingTypeListModel);
        //        }
        //    }
        //}


    }
}
using System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class CampaignFulfillmentFactory
    {
        private static void MapDataRowToFulfillment(DataRow dataRow, CampaignFulfillment Fulfillment)
        {
            Fulfillment.CampaignFulfillmentId = dataRow.Field<int>("CampaignFulfillmentId");
            Fulfillment.CampaignId = dataRow.Field<int>("CampaignId");
            Fulfillment.TriggerTypeId = dataRow.Field<int?>("TriggerTypeId");
            Fulfillment.EligibilityPeriod = dataRow.Field<int?>("EligibilityPeriod");
            Fulfillment.CreatedBy = dataRow.Field<int?>("CreatedBy");
            Fulfillment.CreatedDate = dataRow.Field<DateTime?>("CreatedDate");
            Fulfillment.ModifiedBy = dataRow.Field<int?>("ModifiedBy");
            Fulfillment.ModifiedDate = dataRow.Field<DateTime?>("ModifiedDate");

        }
        private static void MapDataRowToTriggerType(DataRow dataRow, TriggerTypeList TriggerType)
        {
            TriggerType.TriggerTypeId = dataRow.Field<int>("TriggerTypeId");
            TriggerType.TriggerType = dataRow.Field<string>("TriggerType");
            TriggerType.CreatedBy = dataRow.Field<int>("CreatedBy");
            TriggerType.CreatedDate = dataRow.Field<DateTime>("CreatedDate");

        }


        public static List<TriggerTypeList> GetTriggerTypeList()
        {
            List<TriggerTypeList> TriggerTypeResultset = new List<TriggerTypeList>();
            DataSet ds = PromotionQualifierSQL.GetTriggerTypeList();

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TriggerTypeList TriggerTypeDetail = new TriggerTypeList();

                    MapDataRowToTriggerType(dr, TriggerTypeDetail);
                    TriggerTypeResultset.Add(TriggerTypeDetail);
                }
            }
            return TriggerTypeResultset;
        }

        public static CampaignFulfillment GetFulfillmentDetails(CampaignCode Campaigncode)
        {
            CampaignFulfillment FulfillmentDetail = new CampaignFulfillment();
            DataSet ds = PromotionQualifierSQL.GetFulfillmentList(Campaigncode.CampaignId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                MapDataRowToFulfillment(ds.Tables[0].Rows[0], FulfillmentDetail);
            }
            return FulfillmentDetail;
        }

        /// <summary>
        /// This method is used to insert new Campaign Code.
        /// </summary>


        public static CampaignFulfillment InsertUpdateFulfillment(CampaignFulfillment Fulfillment)
        {
            List<GenericError> errors = new List<GenericError>();
            CampaignFulfillment FulfillmentResult = new CampaignFulfillment();
            errors = Fulfillment.IsValidForInsert();

            if (errors.Count > 0)
            {
                return FulfillmentResult;
            }

            else
            {
                DataSet ds = PromotionQualifierSQL.InsertUpdateFulfillment(Fulfillment.CampaignId, Fulfillment.TriggerTypeId, Fulfillment.EligibilityPeriod, Fulfillment.CreatedBy);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {

                    MapDataRowToFulfillment(ds.Tables[0].Rows[0], FulfillmentResult);
                }
            }
            return FulfillmentResult;
        }

    }

    public class TriggerTypeList
    {
        public System.Int32 TriggerTypeId { get; set; }
        public System.String TriggerType { get; set; }
        public System.DateTime? CreatedDate { get; set; }
        public System.Int32 CreatedBy { get; set; }
    }

    
}

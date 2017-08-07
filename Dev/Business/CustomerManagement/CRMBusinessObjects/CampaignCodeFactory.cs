using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class CampaignCodeFactory
    {
        private static void MapDataRowToCampaignCode(DataRow dataRow, CampaignCode CampaignCode)
        {
            CampaignCode.CampaignId = dataRow.Field<int>("CampaignId");
            CampaignCode.Code = dataRow.Field<String>("Code");
            CampaignCode.Description = dataRow.Field<String>("Description");
            CampaignCode.StartDate = dataRow.Field<DateTime>("StartDate");
            CampaignCode.EndDate = dataRow.Field<DateTime>("EndDate");
            CampaignCode.MaxEligible = dataRow.Field<int?>("MaxEligible");
            CampaignCode.CreatedBy = dataRow.Field<int?>("CreatedBy");
            CampaignCode.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            CampaignCode.InActive = dataRow.Field<bool?>("InActive");
        }
        private static void MapDataRowToCampaignCodeList(DataRow dataRow, CampaignCodeList CampaignCode)
        {
            CampaignCode.CampaignId = dataRow.Field<int>("CampaignId");
            CampaignCode.Code = dataRow.Field<String>("Code");
            CampaignCode.Description = dataRow.Field<String>("Description");
            CampaignCode.StartDate = dataRow.Field<DateTime>("StartDate");
            CampaignCode.EndDate = dataRow.Field<DateTime>("EndDate");
            CampaignCode.MaxEligible = dataRow.Field<int?>("MaxEligible");
            CampaignCode.CreatedBy = dataRow.Field<String>("CreatedBy");
            CampaignCode.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            CampaignCode.Inactive = dataRow.Field<String>("InActive");
            CampaignCode.QualifierCampaignId = dataRow.Field<int?>("QualifierCampaignId");
        }
        /// <summary>
        /// This method is used to get the Campaign code list by using the CampaignCode.
        /// </summary>

        public static List<CampaignCodeList> GetCampaignCodeList(CampaignCode CampaignCode)
        {
            List<CampaignCodeList> CampaignCodeResultset = new List<CampaignCodeList>();
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeList(CampaignCode.Code, CampaignCode.InActive);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
                {
                    CampaignCodeList CampaignCodeDetail = new CampaignCodeList();
                    MapDataRowToCampaignCodeList(ds.Tables[0].Rows[iCount], CampaignCodeDetail);
                    CampaignCodeResultset.Add(CampaignCodeDetail);
                }
            }
            return CampaignCodeResultset;

        }

        
        /// <summary>
        /// This method is used to insert new Campaign Code.
        /// </summary>


        public static CampaignCode InsertCampaignCode(CampaignCode CampaignCode)
        {
            List<GenericError> errors = new List<GenericError>();
            CampaignCode CampaignCodeResult = new CampaignCode();
            errors = CampaignCode.IsValidForInsert();

            if (errors.Count > 0)
            {
                return CampaignCodeResult;
            }
           
           else
            {
                DataSet ds = PromotionQualifierSQL.InsertCampaignCode(CampaignCode.Code, CampaignCode.Description, CampaignCode.StartDate, CampaignCode.EndDate, CampaignCode.MaxEligible, CampaignCode.CreatedBy, CampaignCode.InActive);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                   
                    MapDataRowToCampaignCode(ds.Tables[0].Rows[0], CampaignCodeResult);
                    return CampaignCodeResult;
                }
            }
            return CampaignCodeResult;
        }

        /// <summary>
        /// This method is used to update Campaign Code.
        /// </summary>
        public static bool UpdateCampaignCode(CampaignCode CampaignCode)
        {
            List<GenericError> errors = new List<GenericError>();

            errors = CampaignCode.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }
            DataSet ds = PromotionQualifierSQL.UpdateCampaignCode(CampaignCode.CampaignId, CampaignCode.Code, CampaignCode.Description, CampaignCode.StartDate, CampaignCode.EndDate, CampaignCode.MaxEligible,CampaignCode.InActive);
            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// This method is used to get the campaign code details by using the campaign id
        /// <param name="CampaignCode">Campaign Code.</param>
        /// <returns>CampaignCode<see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.CampaignCode"/> Object</returns>
        public static CampaignCode GetCampaignCodeDetailsbyId(int CampaignId)
        {
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeDetailsbyId(CampaignId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                CampaignCode CampaignCode = new CampaignCode();
                MapDataRowToCampaignCode(ds.Tables[0].Rows[0], CampaignCode);
                return CampaignCode;
            }

            return null;

        }

        public static CampaignCode GetCampaignCodeDetailsbyId(int CampaignId, Boolean LoadSubTypes)
        {
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeDetailsbyId(CampaignId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                CampaignCode campaignCode = new CampaignCode();
                MapDataRowToCampaignCode(ds.Tables[0].Rows[0], campaignCode);
                if (LoadSubTypes)
                {
                    campaignCode.CampaignFulfillmentDetails = CampaignFulfillmentFactory.GetFulfillmentDetails(campaignCode);
                }

                return campaignCode;
            }

            return null;

        }

        /// <summary>
        /// This method is used to get the campaign code details by using the campaign.
        /// </summary>
        /// <param name="CampaignCode">Campaign Code.</param>
        /// <returns>CampaignCode<see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.CampaignCode"/> Object</returns>
        public static CampaignCode GetCampaignCodeDetailsByCode(string CampaignCode)
        {
            CampaignCode campaignCode = new CampaignCode();
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeDetailsbyCode(CampaignCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                MapDataRowToCampaignCode(ds.Tables[0].Rows[0], campaignCode);
            }

            return campaignCode;
        }

        /// <summary>
        /// This method is used to check if the campaign code already exists.
        /// </summary>
        /// <param name="CampaignCode">Campaign Code.</param>
        /// <returns>bool</returns>
        public static bool IsCampaignCodeExists(string CampaignCode)
        {
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeDetailsbyCode(CampaignCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }

        /// <summary>
        /// This method is used to check if the campaign code already exists if any existing Campaign code is updated.
        /// </summary>
        /// <param name="CampaignCode">Campaign Code.</param>
        /// <returns>bool</returns>
        public static bool IsCampaignCodeExists(int CampaignId, string CampaignCode)
        {
            DataSet ds = PromotionQualifierSQL.GetCampaignCodeDetailsbyCodeAndId(CampaignId, CampaignCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }
       
        /// <summary>
        /// Checks if campaign code is in use
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static bool IsCampaignCodeEditable(int CampaignId)
        {
            DataSet ds = PromotionQualifierSQL.GetQualifierByCampaignCodeId(CampaignId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }
        /// <summary>
        /// Checks if qualifier is in use and Campaign Filter is editable
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static bool IsCampaignFulfillmentEditable(int CampaignId)
        {
            DataSet ds = PromotionQualifierSQL.IsCampaignQualifierExist(CampaignId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return false;
            }

            return true;

        }
        /// <summary>
        /// Deletes Campaign Code for specified campaign code id
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static void DeleteCampaignCode(int CampaignId)
        {
            PromotionQualifierSQL.DeleteCampaignCode(CampaignId);
        }

		/// <summary>
		/// This method is used to get all the  Campaign codes.
		/// </summary>

		public static List<CampaignCode> GetAllCampaignCode(bool? Active)
		{
			List<CampaignCode> CampaignCodeResultset = new List<CampaignCode>();
			DataSet ds = PromotionQualifierSQL.GetAllCampaignCode( Active );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				for( int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount )
				{
					CampaignCode CampaignCodeDetail = new CampaignCode();
					MapDataRowToCampaignCode( ds.Tables[0].Rows[iCount], CampaignCodeDetail );
					CampaignCodeResultset.Add( CampaignCodeDetail );
				}
			}
			return CampaignCodeResultset;

		}

    }
    public class CampaignCodeList
    {
        public System.Int32 CampaignId { get; set; }
        public System.String Code { get; set; }
        public System.String Description { get; set; }
        public System.Int32? MaxEligible { get; set; }
        public System.String Inactive { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public System.String CreatedBy { get; set; }
        public System.Int32? QualifierCampaignId { get; set; }
    }
}

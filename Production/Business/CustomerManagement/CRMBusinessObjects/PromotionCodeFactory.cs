using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class PromotionCodeFactory
    {
        private static void MapDataRowToPromotionCode(DataRow dataRow, PromotionCode PromotionCode)
        {
            PromotionCode.PromotionCodeId = dataRow.Field<int>("PromotionCodeId");
            PromotionCode.Code = dataRow.Field<String>("Code");
            PromotionCode.Description = dataRow.Field<String>("Description");
            PromotionCode.CreatedBy = dataRow.Field<int?>("CreatedBy");
            PromotionCode.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            PromotionCode.PromotionTypeId = dataRow.Field<int?>("PromotionTypeId");
            PromotionCode.MarketingDescription = dataRow.Field<String>("MarketingDescription");
            PromotionCode.LegalDescription = dataRow.Field<String>("LegalDescription");
            PromotionCode.CreatedBy = dataRow.Field<int?>("CreatedBy");
            PromotionCode.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            PromotionCode.InActive = dataRow.Field<bool?>("InActive");

        }
        private static void MapDataRowToPromotionCode(DataRow dataRow, PromotionCodeList PromotionCode)
        {
            PromotionCode.PromotionCodeId = dataRow.Field<int>("PromotionCodeId");
            PromotionCode.Code = dataRow.Field<String>("Code");
            PromotionCode.Description = dataRow.Field<String>("Description");
            PromotionCode.CreatedBy = dataRow.Field<String>("CreatedBy");
            PromotionCode.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            PromotionCode.PromotionType = dataRow.Field<String>("PromotionType");
            PromotionCode.MarketingDescription = dataRow.Field<String>("MarketingDescription");
            PromotionCode.LegalDescription = dataRow.Field<String>("LegalDescription");
            PromotionCode.InActive = dataRow.Field<String>("InActive");
            PromotionCode.QualifierPromoId = dataRow.Field<int?>("QualifierPromoId");

        }
        
        /// <summary>
        /// This method is used to get the promotion code list by using the promocode.
        /// </summary>
       
        public static List<PromotionCodeList> GetPromotionCodeList(PromotionCode PromotionCode,string orderBy)
        {
            List<PromotionCodeList> PromotionCodeResult = new List<PromotionCodeList>();
            DataSet ds = PromotionQualifierSQL.GetPromotionCodeList(PromotionCode.Code, orderBy, PromotionCode.InActive);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
                {
                    PromotionCodeList PromotionCodeList = new PromotionCodeList();
                    MapDataRowToPromotionCode(ds.Tables[0].Rows[iCount], PromotionCodeList);
                    PromotionCodeResult.Add(PromotionCodeList);
                }
            }
            return PromotionCodeResult;

        }

        /// <summary>
        /// This method is used to get the promotion type list.
        /// </summary>

        public static List<PromotionType> GetAllPromotionType()
        {
            List<PromotionType> PromotionTypeResult = new List<PromotionType>();
            DataSet ds = PromotionQualifierSQL.GetAllPromotionType();

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
                {
                    PromotionType PromotionTypeList = new PromotionType();
                    PromotionTypeList.PromotionTypeId = Convert.ToInt32(ds.Tables[0].Rows[iCount][0].ToString());
                    PromotionTypeList.Code = ds.Tables[0].Rows[iCount][1].ToString();
                    PromotionTypeResult.Add(PromotionTypeList);
                }
            }
            return PromotionTypeResult;

        }

        /// <summary>
        /// This method is used to get all valid promotion code list.
        /// </summary>
		//Added to get the list of Active and inactive list
        public static List<PromotionCode> GetAllPromotionCode(bool? Active)
        {

            List<PromotionCode> PromotionCodeResult = new List<PromotionCode>();
			//Added to get the list of Active and inactive list

			DataSet ds = PromotionQualifierSQL.GetAllPromotionCodes( Active );

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
                {
                    PromotionCode PromotionCode = new PromotionCode();
                    PromotionCode.PromotionCodeId = Convert.ToInt32(ds.Tables[0].Rows[iCount][0].ToString());
                    PromotionCode.Code = ds.Tables[0].Rows[iCount][1].ToString();
                    PromotionCodeResult.Add(PromotionCode);
                }
            }
            return PromotionCodeResult;

        }

        /// <summary>
        /// This method is used to insert new Promotion Code.
        /// </summary>

        public static bool InsertPromotionCode(PromotionCode PromotionCode)
        {
            List<GenericError> errors = new List<GenericError>();
           
            errors = PromotionCode.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }
            DataSet ds = PromotionQualifierSQL.InsertPromotionCode(PromotionCode.Code, PromotionCode.Description, PromotionCode.MarketingDescription, PromotionCode.LegalDescription, PromotionCode.PromotionTypeId, PromotionCode.CreatedBy, PromotionCode.InActive);
            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// This method is used to update Promotion Code.
        /// </summary>
        public static bool UpdatePromotionCode(PromotionCode PromotionCode)
        {
            List<GenericError> errors = new List<GenericError>();

            errors = PromotionCode.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }
            DataSet ds = PromotionQualifierSQL.UpdatePromotionCode(PromotionCode.PromotionCodeId, PromotionCode.Code, PromotionCode.Description, PromotionCode.MarketingDescription, PromotionCode.LegalDescription, PromotionCode.PromotionTypeId, PromotionCode.InActive);
            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// This method is used to get the promotion code details by using the promocode id
        /// <param name="PromotionCode">Promotion Code.</param>
        /// <returns>PromoCode<see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.PromotionCode"/> Object</returns>
        public static PromotionCode GetPromotionCodeDetailsbyId(int PromotionCodeId)
        {
            DataSet ds = PromotionQualifierSQL.GetPromotionCodeDetailsbyId(PromotionCodeId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                PromotionCode promotionCode = new PromotionCode();
                MapDataRowToPromotionCode(ds.Tables[0].Rows[0], promotionCode);
                return promotionCode;
            }

            return null;

        }

        /// <summary>
        /// This method is used to get the promotion code details by using the promocode.
        /// </summary>
        /// <param name="PromotionCode">Promotion Code.</param>
        /// <returns>PromoCode<see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.PromotionCode"/> Object</returns>
        public static PromotionCode GetPromoCodeDetailsByCode(string PromotionCode)
        {
            PromotionCode promotionCode = new PromotionCode();
            DataSet ds = PromotionQualifierSQL.GetPromotionCodeDetailsbyCode(PromotionCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                MapDataRowToPromotionCode(ds.Tables[0].Rows[0], promotionCode);
            }

            return promotionCode;
        }

        /// <summary>
        /// Returns promotion codes by contract-account numbers.
        /// </summary>
        public static DataSet GetPromotionCodesByContractNumberAccountNumber(string contractNumber, string accountNumber)
        {
            var result = new List<Tuple<PromotionCode, PromotionStatus>>();
            var ds = PromotionQualifierSQL.GetPromotionCodesByContractNumberAccountNumber(contractNumber, accountNumber);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return ds;
            }

            return null;
        }

        public static bool IsPromotionCodeExists(string PromotionCode)
        {
            DataSet ds = PromotionQualifierSQL.GetPromotionCodeDetailsbyCode(PromotionCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }

        public static bool IsPromotionCodeExists(int PromotionId, string PromotionCode)
        {
            DataSet ds = PromotionQualifierSQL.GetPromotionCodeDetailsbyCodeAndId(PromotionId, PromotionCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }

        //22918:Create a new web service to send a list of valid promo codes for the day to the tablet --Oct 25 2013
		//Get all valid PromotionCodes as of Today 
        public static List<PromotionCode> GetAllValidPromotionCodesforToday(int? SalesChannelId= null)
        {
			//List<PromotionCode> PromotionCodeList = new List<PromotionCode>();
			//List<Qualifier> QualifierList = new List<Qualifier>();
			//QualifierList = QualifierFactory.GetAllValidQualifiersandPromoCodeforToday();			
			//foreach (Qualifier qualifieritem  in QualifierList)
			//{
			//	if(!PromotionCodeList.Any( PromoCode => PromoCode.PromotionCodeId == qualifieritem.PromotionCode.PromotionCodeId ) )
			//	{
			//	 PromotionCodeList.Add(qualifieritem.PromotionCode);
			//	}
                   
			//}		
			//return PromotionCodeList; 
			List<PromotionCode> PromotionCodeResult = new List<PromotionCode>();
			DataSet ds = PromotionQualifierSQL.GetAllValidPromotionCodesnotreachedMaxLimitforToday( SalesChannelId );
			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				for( int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount )
				{
					PromotionCode PromotionCode = new PromotionCode();
					MapDataRowToPromotionCode( ds.Tables[0].Rows[iCount], PromotionCode );
					PromotionCodeResult.Add( PromotionCode );
				}
			}
			return PromotionCodeResult;

        }
	
        /// <summary>
        /// Checks if promotion code is in use
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static bool IsPromotionCodeEditable(int PromotionCodeId)
        {
            DataSet ds = PromotionQualifierSQL.GetQualifierByPromotionCodeId(PromotionCodeId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                return true;
            }

            return false;

        }

        /// <summary>
        /// Deletes promotion code for specified promotion code id
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static void DeletePromotionCode(int PromotionCodeId)
        {
            PromotionQualifierSQL.DeletePromotionCode(PromotionCodeId);
        }
    }

    public class PromotionCodeList
    {

        public System.Int32 PromotionCodeId { get; set; }
        public System.String Code { get; set; }
        public System.String PromotionType { get; set; }
        public System.String Description { get; set; }
        public System.String MarketingDescription { get; set; }
        public System.String LegalDescription { get; set; }
        public System.String CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public System.String InActive { get; set; }
        public System.Int32? QualifierPromoId { get; set; }
    }
}

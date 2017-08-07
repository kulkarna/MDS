using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public static class PromotionQualifierSQL
    {
        #region "Promotions, Qualifiers and Campaign"

        public static DataSet GetPromotionCodesByContractNumberAccountNumber(string contractNumber, string accountNumber)
        {
            var ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionCodesByContractNumberAndAccountNumberSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_contractNumber", contractNumber));
                    cmd.Parameters.Add(new SqlParameter("@p_accountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        /// <summary>
        /// Added for promotion Code Sept 23 2013
        /// Based on the promotionCode entered this method is used to identify the valid qualifiers 
        /// </summary>
        /// <param name="PromotionCode"></param>
        /// <param name="SignDate"></param>
        /// <param name="SalesChannelId"></param>
        /// <param name="MarketId"></param>
        /// <param name="UtilityId"></param>
        /// <param name="AccountTypeId"></param>
        /// <param name="Terms"></param>
        /// <param name="ProductTypeId"></param>
        /// <param name="PriceTierId"></param>
        /// <param name="ContractStartDate"></param>
        /// <returns> a list of valid qualifiers</returns>
        public static DataSet GetQualifiersByPromotionCodeandDeterminents(string PromotionCode, DateTime SignDate, int? SalesChannelId, int? MarketId, int? UtilityId, int? AccountTypeId, int? Terms, int? ProductBrandId, int? PriceTierId, DateTime? ContractStartDate, int? AccountAnnualUsage)
        {
            //28372: Change ProductType to Product Brand
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_QualifierByPromoCodeandDeterminentsSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_SignDate", SignDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SalesChannelId", SalesChannelId));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketId", MarketId));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityId", UtilityId));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountTypeId", AccountTypeId));
                    cmd.Parameters.Add(new SqlParameter("@p_Term", Terms));
                    cmd.Parameters.Add(new SqlParameter("@p_ProductBrandId", ProductBrandId));
                    cmd.Parameters.Add(new SqlParameter("@p_PriceTier", PriceTierId));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractStartDate", ContractStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountAnnualUsage", AccountAnnualUsage));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetPromotionCodeList(string PromotionCode, string orderBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_orderby", orderBy));
                    cmd.CommandText = "[usp_PromoCodelist]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetAllPromotionType()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllPromotionType";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet GetPromotionCodeList(string PromotionCode, string orderBy, bool? InActive)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_orderby", orderBy));
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));
                    cmd.CommandText = "[usp_PromoCodelist]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetPromotionCodeDetailsbyId(int PromotionCodeId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionCodebyIDSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetPromotionCodeDetailsbyCode(string PromotionCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionCodebyCodeSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetPromotionCodeDetailsbyCodeAndId(int PromotionId, string PromotionCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_PromotionCodebyCodeAndIdSelect]";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionID", PromotionId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        ////27419-create and manage a promo campaign code through an administration screen.

        public static DataSet GetCampaignCodeList(string CampaignCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));

                    cmd.CommandText = "[usp_campaignCode_list]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetQualifierByCampaignIdList(int CampaignId, string PromotionCode, DateTime SignStartDate,
            DateTime SignEndDate, int AllItems, int PageNumber, int PageSize,
            string ChannelIds = "0", string MarketId = "0", int? UtilityId = 0)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignID", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ChannelID", ChannelIds));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketID", MarketId));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityID", UtilityId));

                    if (AllItems == 0)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_AllItems", AllItems));
                        cmd.Parameters.Add(new SqlParameter("@p_ItemsPerPage", PageSize));
                        cmd.Parameters.Add(new SqlParameter("@p_Page", PageNumber));

                    }
                    cmd.CommandTimeout = 300;
                    cmd.CommandText = "[usp_qualifierListbyCampaignIdSelect]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetCampaignCodeDetailsbyId(int CampaignId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_campaignCodebyIdSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.CommandTimeout = 600; // Set the command time out 10 minutes to avoid the timeout issue
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetCampaignCodeDetailsbyCodeAndId(int CampaignId, string CampaignCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_campaignCodebyCodeAndIdSelect]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignID", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet InsertCampaignCode(string CampaignCode, string Desc, DateTime? StartDate, DateTime? EndDate, int? MaxEligible, int? CreatedBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_campaigncode_ins";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_StartDate", StartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_EndDate", EndDate));
                    if (!MaxEligible.HasValue)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", DBNull.Value));
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", MaxEligible));
                    }
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedBy", CreatedBy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet UpdateCampaignCode(int CampaignId, string CampaignCode, string Desc, DateTime? StartDate, DateTime? EndDate, int? MaxEligible)
        {

            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_campaigncode_update";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_StartDate", StartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_EndDate", EndDate));
                    if (!MaxEligible.HasValue)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", DBNull.Value));
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", MaxEligible));
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet GetQualifierByPromotionCodeId(int PromotionCodeId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_QualifierByPromotionCodeIdSelect]";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeID", PromotionCodeId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet HasPromoCodeOverlappingEffectivePeriod(int CampaignId, int PromotionCodeId, DateTime SignStartDate, DateTime SignEndDate)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_QualifierPromoCodeStartEndDateValidation";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /*  Last Modified on:     13 Jul 2015
           Last Modified by:     Manish Pandey 
           Discription:    added @p_IsDateOnlyChanged pararameter to procedure for Checking is there any changes in contract date or signed date.
       */
        public static DataSet IsQualifierAlreadyUsed(int CampaignId, int PromotionCodeId, int? GroupBy, int? IsDateOnlyChanged)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_QualifierInUse";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_GroupBy", GroupBy));
                    cmd.Parameters.Add(new SqlParameter("@p_IsDateOnlyChanged", IsDateOnlyChanged));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet IsCampaignQualifierExist(int CampaignId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_CampaignQualifierInUse]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet IsQualifierBetweenCampaignStartEndDate(int CampaignId, DateTime SignStartDate, DateTime SignEndDate)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_QualifierCampaignStartEndDateValidation";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet InsertQualifier(int CampaignCodeId, int PromotionCodeId, string SalesChannelIds, string MarketIds, string UtilityIds, string AccountTypeIds, int? Term, string ProductBrandIds, DateTime SignStartDate, DateTime SignEndDate, DateTime? ContractStartDate, DateTime? ContractEndDate, string PriceTierIds, int? CreatedBy, int? AccountAnnualUsage)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_qualifier_ins";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCodeId", CampaignCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_salesChannelIds", SalesChannelIds));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketIds", MarketIds));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityIds", UtilityIds));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountTypeIds", AccountTypeIds));
                    cmd.Parameters.Add(new SqlParameter("@p_Term", Term));
                    cmd.Parameters.Add(new SqlParameter("@p_ProductBrandIds", ProductBrandIds));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractStartDate", ContractStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractEndDate", ContractEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_PriceTierIds", PriceTierIds));
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedBy", CreatedBy));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountAnnualUsage", AccountAnnualUsage));
                    cmd.CommandTimeout = 600; // Set the command time out 10 minutes to avoid the timeout issue
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        /*  Last Modified on:     13 Jul 2015
           Last Modified by:     Manish Pandey
           Discription:    added @p_IsDateOnlyChanged pararameter to procedure for Checking is there any changes in contract date or signed date.
       */
        public static DataSet UpdateQualifier(int CampaignCodeId, int PromotionCodeId, string SalesChannelIds, string MarketIds,
            string UtilityIds, string AccountTypeIds, int? Term, string ProductBrandIds,
            DateTime SignStartDate, DateTime SignEndDate, DateTime? ContractStartDate, DateTime? ContractEndDate,
            string PriceTierIds, int? CreatedBy, int? GroupBy, int? IsDateOnlyChanged, int? AccountAnnualUsage)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_qualifier_update";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCodeId", CampaignCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_salesChannelIds", SalesChannelIds));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketIds", MarketIds));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityIds", UtilityIds));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountTypeIds", AccountTypeIds));
                    cmd.Parameters.Add(new SqlParameter("@p_Term", Term));
                    cmd.Parameters.Add(new SqlParameter("@p_ProductBrandIds", ProductBrandIds));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractStartDate", ContractStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractEndDate", ContractEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_PriceTierIds", PriceTierIds));
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedBy", CreatedBy));
                    cmd.Parameters.Add(new SqlParameter("@p_GroupBy", GroupBy));
                    cmd.Parameters.Add(new SqlParameter("@p_AccountAnnualUsage", AccountAnnualUsage));
                    cmd.CommandTimeout = 600; // Set the command time out 10 minutes to avoid the timeout issue
                    cmd.Parameters.Add(new SqlParameter("@p_IsDateOnlyChanged", IsDateOnlyChanged));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        /// <summary>
        /// Delete qualifier based on campaignId and group by 
        /// </summary>
        /// <param name="CampaignId"></param>
        /// <param name="GroupBy"></param>
        /// <returns>Details qualifier </returns>
        /// 
        public static void DeleteQualifier(int CampaignId, int GroupById)
        {
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_QualifierDelete]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_GroupById", GroupById));
                    cmd.ExecuteNonQuery();
                }
                cn.Close();
            }
        }

        /// <summary>
        /// Get the details about qualifier based on campaign and group by 
        /// </summary>
        /// <param name="CampaignId"></param>
        /// <param name="GroupBy"></param>
        /// <returns>Details about qualifier</returns>
        public static DataSet GetQualifiersDetails(int CampaignId, int GroupBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_qualifierDetailsSelect]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignID", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_GroupBy", GroupBy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        //Added to get the list of Active and inactive list of CampaignCodes

        public static DataSet GetAllCampaignCode(bool? Active)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Active", Active));
                    cmd.CommandText = "[usp_CampaignCodeSelect]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        //Added to get the list of Fulfillment/ Promotion Status
        public static DataSet GetAllFulfillmentStatus()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_FulfillmentStatusSelect]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        ////27419-create and manage a promo campaign code through an administration screen.

        public static DataSet GetCampaignCodeList(string CampaignCode, bool? InActive)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));
                    cmd.CommandText = "[usp_campaignCode_list]";
                    cmd.CommandTimeout = 300;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetCampaignCodeDetailsbyCode(string CampaignCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_CampaignCodebyCodeSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetQualifierByCampaignCodeId(int CampaignId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_QualifierByCampaignIdSelect]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet InsertCampaignCode(string CampaignCode, string Desc, DateTime? StartDate, DateTime? EndDate, int? MaxEligible, int? CreatedBy, bool? InActive)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_campaigncode_ins";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_StartDate", StartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_EndDate", EndDate));
                    if (!MaxEligible.HasValue)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", DBNull.Value));
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", MaxEligible));
                    }
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedBy", CreatedBy));
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet UpdateCampaignCode(int CampaignId, string CampaignCode, string Desc, DateTime? StartDate, DateTime? EndDate, int? MaxEligible, bool? InActive)
        {

            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_campaigncode_update";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignCode", CampaignCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_StartDate", StartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_EndDate", EndDate));

                    if (!MaxEligible.HasValue)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", DBNull.Value));
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_MaxEligible", MaxEligible));
                    }
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        public static void DeleteCampaignCode(int CampaignId)
        {
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_CampaignCodeDelete]";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.ExecuteNonQuery();
                }
                cn.Close();
            }
        }

        ////
        //CRMLibertyPowerSql.InsertContractQualifier(contractQualifier.ContractId, contractQualifier.AccountId,contractQualifier.QualifierId,contractQualifier.PromotionStatusID,
        //                  contractQualifier.Comment,contractQualifier.CreatedBy, contractQualifier.CreatedDate, contractQualifier.ModifiedBy, contractQualifier.ModifiedDate);

        public static DataSet InsertContractQualifier(int ContractId, int? AccountId, int QualifierId, int PromotionStatusID, string Comment, int CreatedBy, DateTime CreatedDate,
            int ModifiedBy, DateTime ModifiedDate)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ContractQualifierInsert";

                    cmd.Parameters.Add(new SqlParameter("@ContractID", ContractId));
                    cmd.Parameters.Add(new SqlParameter("@AccountID", AccountId));
                    cmd.Parameters.Add(new SqlParameter("@QualifierId", QualifierId));
                    cmd.Parameters.Add(new SqlParameter("@PromotionStatusID", PromotionStatusID));
                    cmd.Parameters.Add(new SqlParameter("@Comment", Comment));
                    cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
                    cmd.Parameters.Add(new SqlParameter("@CreatedDate", CreatedDate));
                    cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
                    cmd.Parameters.Add(new SqlParameter("@ModifiedDate", ModifiedDate));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }



        public static DataSet InsertPromotionCode(string PromotionCode, string Desc, string MarketingDesc, string LegalDesc, int? PromotionTypeID, int? CreatedBy, bool? InActive)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_promocode_ins";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketingDesc", MarketingDesc));
                    cmd.Parameters.Add(new SqlParameter("@p_LegalDesc", LegalDesc));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionTypeId", PromotionTypeID));
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedBy", CreatedBy));
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet UpdatePromotionCode(int PromotionId, string PromotionCode, string Desc, string MarketingDesc, string LegalDesc, int? PromotionTypeID, bool? InActive)
        {

            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_promocode_update";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionId", PromotionId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_Desc", Desc));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketingDesc", MarketingDesc));
                    cmd.Parameters.Add(new SqlParameter("@p_LegalDesc", LegalDesc));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionTypeId", PromotionTypeID));
                    cmd.Parameters.Add(new SqlParameter("@p_InActive", InActive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }


        public static void DeletePromotionCode(int PromotionCodeId)
        {
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_PromotionCodeDelete]";
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCodeId", PromotionCodeId));
                    cmd.ExecuteNonQuery();
                }
                cn.Close();
            }
        }

        public static DataSet GetAllValidQualifiersandPromoCodeforToday()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllValidQualifiersandPromoCodeforToday";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        //22918:Create a new web service to send a list of valid promo codes for the day to the tablet --Oct 25 2013

        public static DataSet GetAllPromotionCodes(bool? Active)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AllPromotionCodelist";
                    if (Active.HasValue)
                    {
                        cmd.Parameters.Add(new SqlParameter("@Active", Active));
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetAllValidQualifiersforToday()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllValidQualifiersforToday";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetAllValidPromotionCodesforToday()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllValidPromotionCodesforToday";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet HasCampaignReachedMaxLimit(int QualifierId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_HasCampaignReachedMaxLimit";
                    cmd.Parameters.Add(new SqlParameter("@p_QualifierId", QualifierId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        #endregion

        #region "Fulfillment"

        public static DataSet GetFulfillmentList(int CampaignId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.CommandText = "[usp_CampaignFulfillment_list]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetTriggerTypeList()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_TriggerType_list]";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet InsertUpdateFulfillment(int CampaignId, int? TriggerDateOption, int? EligibilityPeriod, int? CreatedOrModifiedBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_CampaignFulfillment_InsertUpdate";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_TriggerTypeId", TriggerDateOption));
                    cmd.Parameters.Add(new SqlParameter("@p_EligibilityPeriod", EligibilityPeriod));
                    cmd.Parameters.Add(new SqlParameter("@p_CreatedOrModifiedBy", CreatedOrModifiedBy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        public static DataSet GetQualifierFulfillmentList(string AccountNumber, string ContractNumber, string CustomerName, string AccountStatusId, int? FulfillmentStatusId, int? CampaignId, int? PromotionCodeId, int? MarketId, string orderBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_account_number_filter", AccountNumber));
                    cmd.Parameters.Add(new SqlParameter("@p_contract_nbr_filter", ContractNumber));
                    cmd.Parameters.Add(new SqlParameter("@p_customername_filter", CustomerName));
                    cmd.Parameters.Add(new SqlParameter("@p_fulfillment_status_id_filter", FulfillmentStatusId));
                    cmd.Parameters.Add(new SqlParameter("@p_account_status_id_filter", AccountStatusId));
                    cmd.Parameters.Add(new SqlParameter("@p_camapaign_id_filter", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_promotioncode_id_filter", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("@p_market_id_filter", MarketId));
                    cmd.Parameters.Add(new SqlParameter("@p_order_by", orderBy));
                    cmd.CommandText = "[usp_QualifyingContractAccountFulfillmentList]";
                    cmd.CommandTimeout = 360;		//time out set for 6 mins= 6* 60= 360 secs
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        #endregion


        #region Contract Qualifiers

        public static DataSet DeleteContractQualifier(int contractQualifierId)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_DeleteContractQualifier";

                    cmd.Parameters.Add(new SqlParameter("p_contractQualifierId", contractQualifierId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        //Added to get the list of ContractQualifiers and the fulfillment status
        /*  
           Created on:     17 Aug 2015
           Modified by:    Manish Pandey
           Discription:    Added new parameter ChannelIds.
      */
        public static DataSet GetAllContractQualifierFulfillmentDetails(string CampaignID, string marketId,
            string contractNumber, string accountnumber, string promotionCode,
            string Customername, string fulfillmentStatus, string accountstatus, string orderby, int gridpageSize,
            int gridCurrentpageIndex, string ChannelIds, string UtilityId)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetContractQualifierFulfillmentDetails";
                    cmd.Parameters.Add(new SqlParameter("@p_camapaign_id_filter", CampaignID));
                    cmd.Parameters.Add(new SqlParameter("@p_market_id_filter", marketId));
                    cmd.Parameters.Add(new SqlParameter("@p_contract_nbr_filter", contractNumber));
                    cmd.Parameters.Add(new SqlParameter("@p_account_number_filter", accountnumber));
                    cmd.Parameters.Add(new SqlParameter("@p_promotioncode_id_filter", promotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_customername_filter", Customername));
                    cmd.Parameters.Add(new SqlParameter("@p_fulfillment_status_id_filter", fulfillmentStatus));
                    cmd.Parameters.Add(new SqlParameter("@p_account_status_id_filter", accountstatus));
                    cmd.Parameters.Add(new SqlParameter("@p_order_by", orderby));
                    cmd.Parameters.Add(new SqlParameter("@p_pagesize", gridpageSize));
                    cmd.Parameters.Add(new SqlParameter("@p_currentpageIndex", gridCurrentpageIndex));

                    cmd.Parameters.Add(new SqlParameter("@p_channel_id_filter", ChannelIds));
                    cmd.Parameters.Add(new SqlParameter("@p_utility_id_filter", UtilityId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }


        public static DataSet GetAllAccountDetailsforFulfillment(string ContractID)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAccountContractDetailsForFulfillment";
                    cmd.Parameters.Add(new SqlParameter("@p_ContractID", ContractID));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet UpdateContractQualifierFulfillmentStatus(string ContractIdList, string Status, string Comment, int UserID)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UpdateContractQualifierFulfillmentStatus";

                    cmd.Parameters.Add(new SqlParameter("@p_ContractIDList", ContractIdList));
                    cmd.Parameters.Add(new SqlParameter("@p_StatusId", Status));
                    cmd.Parameters.Add(new SqlParameter("@p_Comments", Comment));
                    cmd.Parameters.Add(new SqlParameter("@p_UserID", UserID));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetAllValidPromotionCodesnotreachedMaxLimitforToday(int? SalesChannelId = null)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllValidPromotionCodenotReachedMaxLimitforToday";
                    cmd.Parameters.Add(new SqlParameter("@SalesChannelID", SalesChannelId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }



        public static DataSet GetAllValidQualifiersnotreachedMaxLimitforToday(int? SalesChannelId = null)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAllValidQualifiersNotReachedMaxLimitforToday";
                    cmd.Parameters.Add(new SqlParameter("@SalesChannelID", SalesChannelId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }



        /*  Created on:     8 Oct 2015
          Created by:     Manish Pandey
          Discription:    To to get All Channel for promo campaign code.
      */
        public static DataSet GetAllSalesChannels(DateTime? channelGroupDate, int? CampaignId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelsAllSelect";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        #endregion

        #region"Helpers for getting the description details of SalesChannel,market,Utility, AccountType and priceTier"

        public static DataSet GetSalesChannelNamefromID(int salesChannelId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetSalesChannelName";
                    cmd.Parameters.Add(new SqlParameter("@p_salesChannelId", salesChannelId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        public static DataSet GetMarketCodefromID(int marketId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetMarketCode";
                    cmd.Parameters.Add(new SqlParameter("@p_marketId", marketId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetUtilityCodefromID(int UtilityId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetUtilityCode";
                    cmd.Parameters.Add(new SqlParameter("@p_utlityId", UtilityId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet GetAccountTypeDescriptionfromProductAccountTypeID(int ProductAccountTypeId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAccountTypeDescriptionforproductAccountTypeId";
                    cmd.Parameters.Add(new SqlParameter("@p_AccountTypeId", ProductAccountTypeId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        public static DataSet GetAccountTypeDescriptionfromID(int AccountTypeId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetAccountTypeDescription";
                    cmd.Parameters.Add(new SqlParameter("@p_AccountTypeId", AccountTypeId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetProductBrandDescriptionfromID(int ProductBrandID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetproductBrandDescription";
                    cmd.Parameters.Add(new SqlParameter("@p_ProductBrandId", ProductBrandID));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetpriceTierDescriptionfromID(int PriceTierId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetPriceTierDescription";
                    cmd.Parameters.Add(new SqlParameter("@p_PriceTierId", PriceTierId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        /*  
            Created on:     22 Jul 2015
            Created by:     Manish Pandey
            Discription:    get data from Database and export quilifier into excel.
       */
        public static DataSet GetQualifierExportToExcelList(int CampaignId, string PromotionCode,
            DateTime SignStartDate, DateTime SignEndDate, string ChannelIds, string MarketId, int? UtilityId = 0)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignID", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_PromotionCode", PromotionCode));
                    cmd.Parameters.Add(new SqlParameter("@p_SignStartDate", SignStartDate));
                    cmd.Parameters.Add(new SqlParameter("@p_SignEndDate", SignEndDate));
                    cmd.Parameters.Add(new SqlParameter("@p_ChannelID", ChannelIds));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketID", MarketId));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityID", UtilityId));
                    cmd.CommandText = "[usp_QualifierList_ExportToExcel]";
                    cmd.CommandTimeout = 360; //time out set for 6 mins= 6* 60= 360 secs
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        #endregion

        #region PromoCode Email
        public static DataSet InsertPromotionEmailTemplate(int PromotionCodeId, int PromotionStatusId, string EmailSubject, string EmailBody, string User)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionStatusEmailTemplateInsert";

                    cmd.Parameters.Add(new SqlParameter("PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("PromotionStatusId", PromotionStatusId));
                    cmd.Parameters.Add(new SqlParameter("EmailSubject", EmailSubject));
                    cmd.Parameters.Add(new SqlParameter("EmailBody", EmailBody));
                    cmd.Parameters.Add(new SqlParameter("User", User));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet UpdatePromotionEmailTemplate(int PromotionCodeId, int PromotionStatusId, string EmailSubject, string EmailBody, string User, int IsInactive)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionStatusEmailTemplateUpdate";

                    cmd.Parameters.Add(new SqlParameter("PromotionCodeId", PromotionCodeId));
                    cmd.Parameters.Add(new SqlParameter("PromotionStatusId", PromotionStatusId));
                    cmd.Parameters.Add(new SqlParameter("EmailSubject", EmailSubject));
                    cmd.Parameters.Add(new SqlParameter("EmailBody", EmailBody));
                    cmd.Parameters.Add(new SqlParameter("JustInactive", IsInactive));
                    cmd.Parameters.Add(new SqlParameter("User", User));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet SelectPromotionEmailTemplates(int PromotionCodeId, int PromotionStatusId, bool IsInactive, bool GetAllRows, string PromotionCode = "")
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PromotionStatusEmailTemplateSelect";
                    if (String.IsNullOrWhiteSpace(PromotionCode))
                    {
                        cmd.Parameters.Add(new SqlParameter("PromotionCodeId", PromotionCodeId));
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("PromotionCode", PromotionCode));
                    }
                    cmd.Parameters.Add(new SqlParameter("PromotionStatusId", PromotionStatusId));
                    cmd.Parameters.Add(new SqlParameter("Inactive", IsInactive));
                    cmd.Parameters.Add(new SqlParameter("AllRows", GetAllRows));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet EmailContractQualifierInsertUpdate(string ContractNumber, bool EmailSent, string EmailErrorMessage, int EmailPromoCodeStatusId, int SentBy)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_EmailContractQualifierInsertUpdate";
                    cmd.Parameters.Add(new SqlParameter("ContractNumber", ContractNumber));
                    cmd.Parameters.Add(new SqlParameter("EmailSent", EmailSent));
                    cmd.Parameters.Add(new SqlParameter("EmailErrorMessage", EmailErrorMessage));
                    cmd.Parameters.Add(new SqlParameter("EmailPromoCodeStatusId", EmailPromoCodeStatusId));
                    cmd.Parameters.Add(new SqlParameter("SentBy", SentBy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        #endregion
        #region Import Excel
        /*  
            Created on  :   19 Oct 2015
            Created by  :   Manish Pandey
            Discription :   Get Fulfillment Status Details from Database and export quilifier into excel.
            PBI         :   54503
       */
        public static DataSet GetFulFillmentStatusDetails(DataTable FulfillmentStatusDetails, string CampaignId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetContractQualifierFulfillmentDetails_Upload";
                    cmd.Parameters.Add(new SqlParameter("@p_FulfillmentStatusDetails", FulfillmentStatusDetails));
                    cmd.Parameters.Add(new SqlParameter("@CampaignId", CampaignId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /*  
           Created on  :   19 Oct 2015
           Created by  :   Manish Pandey
           Discription :   Update Fulfillment Status Details from Database and export quilifier into excel.
           PBI         :   54503
      */
        public static bool UpdateFulFillmentStatusDetails(DataTable FulfillmentStatusDetails, string CampaignId, string Comment, int UserID)
        {
            DataSet ds = new DataSet();
            bool IsSuccess = false;
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UpdateFulfillmentStatusDetailData";
                    cmd.Parameters.Add(new SqlParameter("@p_FulfillmentStatusDetailsData", FulfillmentStatusDetails));
                    cmd.Parameters.Add(new SqlParameter("@CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_Comment", Comment));
                    cmd.Parameters.Add(new SqlParameter("@p_UserID", UserID));

                    cmd.Parameters.Add("@IsSuccess", SqlDbType.Bit, 30);
                    cmd.Parameters["@IsSuccess"].Direction = ParameterDirection.Output;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                        IsSuccess = (bool)cmd.Parameters["@IsSuccess"].Value;
                    }
                }
            }
            return IsSuccess;
        }
        #endregion
        #region Fulfillment Status History
        /*  
            Created on  :   4 Nov 2015
            Created by  :   Manish Pandey
            Discription :   Get Fulfillment Status History.
            PBI         :   84517
       */
        public static DataSet GetFulfillmentStatusHistory(string CampaignId, string ContractId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetFulfillmentStatusHistory";
                    cmd.Parameters.Add(new SqlParameter("@p_CampaignId", CampaignId));
                    cmd.Parameters.Add(new SqlParameter("@p_ContractId", ContractId));
                    //cmd.Parameters.Add(new SqlParameter("@p_pagesize", PageSize));
                    //cmd.Parameters.Add(new SqlParameter("@p_currentpageIndex", CurrentPageIndex));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        #endregion
    }
}

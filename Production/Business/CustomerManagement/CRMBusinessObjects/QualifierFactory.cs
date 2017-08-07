using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using LibertyPower.Business.CustomerAcquisition;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class QualifierFactory 
    {
        //public static bool InsertQualifier(Qualifier qualifier, out List<GenericError> errors)
        //{
        //}
        //28372: Change ProductType to Product Brand
        private static void MapDataRowToQualifier(DataRow dataRow, Qualifier qualifier)
        {
            qualifier.QualifierId = dataRow.Field<int>("QualifierId");
            qualifier.CampaignId = dataRow.Field<int>("CampaignId");
            qualifier.PromotionCodeId = dataRow.Field<int>("PromotionCodeId");
            qualifier.SalesChannelId = dataRow.Field<int?>("SalesChannelId");
            qualifier.MarketId = dataRow.Field<int?>("MarketId");
            qualifier.UtilityId = dataRow.Field<int?>("UtilityId");
            qualifier.AccountTypeId = dataRow.Field<int?>("AccountTypeId");
            qualifier.Term = dataRow.Field<int?>("Term");
            qualifier.AccountAnnualUsage = dataRow.Field<int?>("AccountAnnualUsage"); //1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
            qualifier.ProductBrandId = dataRow.Field<int?>("ProductBrandId");
            qualifier.SignStartDate = dataRow.Field<DateTime>("SignStartDate");
            qualifier.SignEndDate = dataRow.Field<DateTime>("SignEndDate");
            qualifier.ContractEffecStartPeriodStartDate = dataRow.Field<DateTime?>("ContractEffecStartPeriodStartDate");
            qualifier.ContractEffecStartPeriodLastDate = dataRow.Field<DateTime?>("ContractEffecStartPeriodLastDate");
            qualifier.PriceTierId = dataRow.Field<int?>("PriceTierId");
            qualifier.CreatedBy = dataRow.Field<int?>("CreatedBy");
            qualifier.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
			qualifier.AutoApply = dataRow.Field<Boolean>( "AutoApply" );

        }
        private static void MapDataRowToQualifierResultSet(DataRow dataRow, QualifierDetails qualifier)
        {
            qualifier.CampaignId = dataRow.Field<int>("CampaignId");
            qualifier.PromotionCodeId = dataRow.Field<int>("PromotionCodeId");
            qualifier.Code = dataRow.Field<String>("Code");
            qualifier.SalesChannels = dataRow.Field<String>("SalesChannels");
            qualifier.Markets = dataRow.Field<String>("Markets");
            qualifier.Utilities = dataRow.Field<String>("Utilities");
            qualifier.Accounttypes = dataRow.Field<String>("Accounttypes");
            qualifier.Term = dataRow.Field<int?>("Term");
            qualifier.AccountAnnualUsage = dataRow.Field<int?>("AccountAnnualUsage"); //1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
            qualifier.ProductBrands = dataRow.Field<String>("ProductBrands");
            qualifier.SignStartDate = dataRow.Field<DateTime>("SignStartDate");
            qualifier.SignEndDate = dataRow.Field<DateTime>("SignEndDate");
            qualifier.ContractEffecStartPeriodStartDate = dataRow.Field<DateTime?>("ContractEffecStartPeriodStartDate");
            qualifier.ContractEffecStartPeriodLastDate = dataRow.Field<DateTime?>("ContractEffecStartPeriodLastDate");
            qualifier.PriceTiers = dataRow.Field<String>("PriceTiers");
            qualifier.GroupBy = dataRow.Field<int?>("GroupBy");
            qualifier.DeleteQualifierGroupId = dataRow.Field<int?>("DeleteQualifierGroupId");
            qualifier.IsAssignedToContract = dataRow.Field<int?>("IsAssignedToContract");


        }
        /// <summary>
        /// This method is used to get the Qualifier List list by  CampaignId.
        /// </summary>
        //Last Modified by Manish
        //Added new parameter SalesChannelId
        public static List<QualifierDetails> GetQualifierByCampaignIdList(Qualifier Qualifier, int AllItems, int PageNumber, int PageSize, out int totalLines)
        {
            totalLines = 0;
            List<QualifierDetails> QualifierResultset = new List<QualifierDetails>();
            DataSet ds = PromotionQualifierSQL.GetQualifierByCampaignIdList(Qualifier.CampaignId, Qualifier.PromotionCode.Code, 
                Qualifier.SignStartDate, Qualifier.SignEndDate, AllItems, PageNumber, PageSize,
                Qualifier.SalesChannelIds, Qualifier.MarketIds, Qualifier.UtilityId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                totalLines = Convert.ToInt16(ds.Tables[0].Rows[0][1].ToString());
                for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
                {
                    QualifierDetails QualifierDetail = new QualifierDetails();
                    MapDataRowToQualifierResultSet(ds.Tables[0].Rows[iCount], QualifierDetail);
                    QualifierResultset.Add(QualifierDetail);
                }
            }
            return QualifierResultset;
           
        }
        public static List<Qualifier> GetQualifiersByPromotionCodeandDeterminents
            (string PromotionCode, DateTime SignDate, int? SalesChannelId, int? MarketId,
            int? UtilityId, int? AccountTypeId, int? Terms, int? ProductBrandId,
            int? PriceTierId, DateTime? ContractStartDate, int? AccountAnnualUsage)
        {
            List<Qualifier> QualifierList = new List<Qualifier>();
            DataSet ds = PromotionQualifierSQL.GetQualifiersByPromotionCodeandDeterminents
                (PromotionCode, SignDate, SalesChannelId, MarketId, UtilityId,
                AccountTypeId, Terms, ProductBrandId, PriceTierId, ContractStartDate, AccountAnnualUsage);
            
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Dictionary<int, PromotionCode> promoCodeLocalCache = new Dictionary<int, PromotionCode>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Qualifier qualifier = new Qualifier();
					MapDataRowToQualifier( dr, qualifier );

                    if (!promoCodeLocalCache.ContainsKey(qualifier.PromotionCodeId))
                    {
                        qualifier.PromotionCode = PromotionCodeFactory.GetPromotionCodeDetailsbyId(qualifier.PromotionCodeId);
                        promoCodeLocalCache.Add(qualifier.PromotionCodeId, qualifier.PromotionCode);
                    }
                    else
                    {
                        qualifier.PromotionCode = promoCodeLocalCache[qualifier.PromotionCodeId];
                    }

                    QualifierList.Add(qualifier);
                }
             
                return QualifierList;
            }

            return null;

        }

        //Get all valid Qualifiers as of Today and load the subtypes too
        public static List<Qualifier> GetAllValidQualifiersandPromoCodeforToday()
        {
            List<Qualifier> QualifierList = new List<Qualifier>();
            DataSet Qualifierds = PromotionQualifierSQL.GetAllValidQualifiersandPromoCodeforToday();

	
			var campaignIdList= (from DataRow resultdata in Qualifierds.Tables[0].Rows
								select new{  col1 = resultdata["CampaignId"]}).Distinct().ToList();

		

			//if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
			//{
			//	foreach (DataRow dr in ds.Tables[0].Rows)
			//	{
			//		if( !HasCampaignMaxLimitReached( dr.Field<int>( "QualifierId" ) ) )
			//		{
			//			Qualifier qualifier = new Qualifier();
			//			MapDataRowToQualifier( dr, qualifier );
			//			QualifierList.Add( qualifier );
			//			qualifier.PromotionCode = PromotionCodeFactory.GetPromotionCodeDetailsbyId( qualifier.PromotionCodeId );
			//		}

			//	}
			//	return QualifierList;
			//}

            return null;

        }
        //22918:Create a new web service to send a list of valid promo codes for the day to the tablet --Oct 25 2013
        //Get all valid Qualifiers as of Today 
        public static List<Qualifier> GetAllValidQualifiersforToday(int ? SalesChannelId= null)
        {
			List<Qualifier> QualifierList = new List<Qualifier>();
			DataSet ds = PromotionQualifierSQL.GetAllValidQualifiersnotreachedMaxLimitforToday( SalesChannelId );
			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				for( int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount )
				{
					Qualifier qualifier = new Qualifier();
					MapDataRowToQualifier( ds.Tables[0].Rows[iCount], qualifier );
					QualifierList.Add( qualifier );
				}
			}
			return QualifierList;

			//List<Qualifier> QualifierList = new List<Qualifier>();
			//DataSet ds = PromotionQualifierSQL.GetAllValidQualifiersforToday();
			//if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
			//{
			//	foreach (DataRow dr in ds.Tables[0].Rows)
			//	{
			//		if( ! HasCampaignMaxLimitReached( dr.Field<int>("QualifierId") ) )
			//		{
			//			Qualifier qualifier = new Qualifier();
			//			MapDataRowToQualifier( dr, qualifier );
			//			QualifierList.Add( qualifier );
			//		}                 

			//	}
			//	return QualifierList;
			//}
			//return null;

        }
        /// <summary>
        /// Gets qualifier details
        /// </summary>
        /// <param name="CampaignId"></param>
        ///  <param name="GroupBy"></param>
        /// <returns>Dataset</returns>
        public static QualifierDetails GetQualifiersDetails(int CampaignId, int GroupBy)
        {
            DataSet ds = PromotionQualifierSQL.GetQualifiersDetails(CampaignId, GroupBy);
            QualifierDetails Qualifier = new QualifierDetails();
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                    MapDataRowToQualifierResultSet(ds.Tables[0].Rows[0], Qualifier);
            }
            return Qualifier;


        }

        /// <summary>
        /// This method is used to insert new qualifier.
        /// </summary>

        public static bool InsertQualifier(Qualifier Qualifier, string SalesChannelIds, string MarketIds, string UtilityIds, string AccountTypeIds, string ProductBrandIds, string PriceTierIds)
        {
            List<GenericError> errors = new List<GenericError>();

            errors = Qualifier.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }
            DataSet ds = PromotionQualifierSQL.InsertQualifier(Qualifier.CampaignId, Qualifier.PromotionCodeId, SalesChannelIds, MarketIds, UtilityIds, AccountTypeIds, Qualifier.Term, ProductBrandIds, Qualifier.SignStartDate, Qualifier.SignEndDate, Qualifier.ContractEffecStartPeriodStartDate, Qualifier.ContractEffecStartPeriodLastDate, PriceTierIds, Qualifier.CreatedBy, Qualifier.AccountAnnualUsage);
            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }
            return false;
        }


        /// <summary>
        /// This method is used to update the qualifier.
        /// </summary>

        public static bool UpdateQualifier(Qualifier Qualifier, string SalesChannelIds, string MarketIds, string UtilityIds, string AccountTypeIds, string ProductBrandIds, string PriceTierIds)
        {
            List<GenericError> errors = new List<GenericError>();

            errors = Qualifier.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }
            //Code added by Manish Pandey-Passed IsDateOnlyChanged parameter. 
            DataSet ds = PromotionQualifierSQL.UpdateQualifier(Qualifier.CampaignId, Qualifier.PromotionCodeId, SalesChannelIds, MarketIds, UtilityIds, 
                AccountTypeIds, Qualifier.Term, ProductBrandIds, Qualifier.SignStartDate, Qualifier.SignEndDate, 
                Qualifier.ContractEffecStartPeriodStartDate, Qualifier.ContractEffecStartPeriodLastDate, PriceTierIds,
                Qualifier.CreatedBy, Qualifier.GroupBy, Qualifier.IsDateOnlyChanged, Qualifier.AccountAnnualUsage);
            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// Deletes Qualifier for specified campaign code id and group by
        /// </summary>
        /// <param name="identity">Record identifier</param>
        public static void DeleteQualifier(int CampaignId, int GroupById)
        {
            PromotionQualifierSQL.DeleteQualifier(CampaignId, GroupById);
        }

        /// <summary>
        /// This method is used to get all the  Campaign codes.
        /// </summary>
        /// <summary>
        /// HasCampaign Max Limit reached for given qualifierList
        /// </summary>
        public static bool HasCampaignMaxLimitReached(List<Qualifier> QualifierList)
        {
            var QualifierIds = (from t in QualifierList
                                     select t.QualifierId).Distinct();

            foreach (int QualifierId in QualifierIds)
            {                  
                if ( HasCampaignMaxLimitReached(QualifierId))
                return true;                    
            }
            return false;

        }

        /// <summary>
        ///HasCampaign Max Limit reached for given qualifierList
        /// <summary>
        public static bool HasCampaignMaxLimitReached(int QualifierId)
        {
            DataSet ds = PromotionQualifierSQL.HasCampaignReachedMaxLimit(QualifierId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0][0].ToString() == "True")
                {
                    return true;
                }

                return false;
            }
            return false;
        }
        // To validate if Promo Code is not assigned to another Campaign which has an overlapping effective period
        public static bool HasPromoCodeOverlappingEffectivePeriod(Qualifier Qualifier, out String OverlappingCampaign)
        {
            StringBuilder CampaignCodes = new StringBuilder();
            OverlappingCampaign = "";
            DataSet ds = PromotionQualifierSQL.HasPromoCodeOverlappingEffectivePeriod(Qualifier.CampaignId, Qualifier.PromotionCodeId, Qualifier.SignStartDate, Qualifier.SignEndDate);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CampaignCodes.Append(dr.Field<String>("Code").Trim());
                    if(dr!=ds.Tables[0].Rows[ds.Tables[0].Rows.Count-1])
                        CampaignCodes.Append("; ");
                }
                OverlappingCampaign = CampaignCodes.ToString();
                return true;
            }
            return false;
        }

        // To validate if Qualifier is already in use.
        public static bool IsQualifierAlreadyUsed(Qualifier Qualifier)
        {
            //Code added by Manish Pandey-Passed IsDateOnlyChanged parameter.
            DataSet ds = PromotionQualifierSQL.IsQualifierAlreadyUsed(Qualifier.CampaignId, Qualifier.PromotionCodeId, Qualifier.GroupBy, Qualifier.IsDateOnlyChanged);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return true;
            }
            return false;
        }

        // To validate qualifier sign start and end date is between campaign start and end date
        public static bool IsQualifierBetweenCampaignStartEndDate(Qualifier Qualifier)
        {
            DataSet ds = PromotionQualifierSQL.IsQualifierBetweenCampaignStartEndDate(Qualifier.CampaignId, Qualifier.SignStartDate, Qualifier.SignEndDate);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return true;
            }
            return false;
        }
		//Added on Dec 23 2013
		/// <summary>
		/// Function to validate if the entered PromoCode is Active and is valid(i.e. Not reached the max campaign limit)
		/// Pass in the Promotion Code and the qualifiers, The function will validate the following steps
		/// Step1: Does the PromoCode exists
		/// Step2: Does the Qualifiers Exists
		/// Step3: Has PromoCode Campaign Max limit reached
		/// </summary>
		/// <param name="PromotionCode"></param>
		/// <param name="SignDate"></param>
		/// <param name="SalesChannelId"></param>
		/// <param name="MarketId"></param>
		/// <param name="UtilityId"></param>
		/// <param name="AccountTypeId"></param>
		/// <param name="Terms"></param>
		/// <param name="ProductBrandId"></param>
		/// <param name="PriceTierId"></param>
		/// <param name="ContractStartDate"></param>
		/// <returns>returns If IsValid(bool) and the Info(string: the error message or the promotion code description)</returns>
		public static QualifierResultSet ValidatePromotionCodeandQualifiers( string PromotionCode, DateTime SignDate, int? SalesChannelId, int? MarketId,
			int? UtilityId, int? AccountTypeId, int? Terms, int? ProductBrandId,
			int? PriceTierId, DateTime? ContractStartDate, int? AccountAnnualUsage )
		{

			//Step1: Does the PromoCode exists
			//Step2: Does the Qualifiers Exists
			//Step3: Has PromoCode Campaign Max limit reached

			QualifierResultSet returnResult = new QualifierResultSet();
			if( PromotionCodeFactory.IsPromotionCodeExists( PromotionCode ) )
			{
				 List<Qualifier> qualifierlist = new List<Qualifier>();
                 qualifierlist = QualifierFactory.GetQualifiersByPromotionCodeandDeterminents(PromotionCode, SignDate, SalesChannelId, MarketId, UtilityId, AccountTypeId, Terms, ProductBrandId, PriceTierId, ContractStartDate, AccountAnnualUsage);

				if( qualifierlist != null && qualifierlist.Count > 0 )
				{
					if( HasCampaignMaxLimitReached( qualifierlist ) )
					{
						returnResult.IsValid = false;
						returnResult.Info = "The campaign has reached the maximum limit.";
					}
					
					else
					{
						returnResult.IsValid = true;
						PromotionCode Code = PromotionCodeFactory.GetPromoCodeDetailsByCode( PromotionCode );
						returnResult.Info = Code.Description;
                        returnResult.QualifiersMatch = qualifierlist;
					}	
				}
				else
				{
					returnResult.IsValid = false;
					returnResult.Info = "The promotion code is not valid. Please verify the qualifying rules.";
				}
			}

			else
			{
				returnResult.IsValid = false;
				returnResult.Info = "The promotion code does not exist.";
			}
			return returnResult;
		}


		public static List<QualifierResultSetforTablet> GetAllValidQualifiersforToday_Tablet()
		{
			List<QualifierResultSetforTablet> QualifierResultList = new List<QualifierResultSetforTablet>();

			List<Qualifier> QualifierList = new List<Qualifier>();
			QualifierList = GetAllValidQualifiersforToday();

			foreach( Qualifier QualifierItem in QualifierList )
			{
				QualifierResultSetforTablet QualifierResult = new QualifierResultSetforTablet();
				QualifierResult.PromotionCodeId = QualifierItem.PromotionCodeId;
				if( QualifierItem.SalesChannelId.HasValue )
					QualifierResult.SalesChannelName = GetSalesChannelNameFromID( QualifierItem.SalesChannelId.Value );
				else
					QualifierResult.SalesChannelName = String.Empty;
				if( QualifierItem.MarketId.HasValue )
					QualifierResult.MarketName = GetMarketCodeFromID( QualifierItem.MarketId.Value );
				else
					QualifierResult.MarketName = String.Empty;
				if( QualifierItem.UtilityId.HasValue )
					QualifierResult.UtilityName = GetUtilityCodeFromID( QualifierItem.UtilityId .Value);
				else
					QualifierResult.UtilityName = String.Empty;
				if( QualifierItem.AccountTypeId.HasValue )
					QualifierResult.AccountTypeDesc = GetAccountTypeDescFromProductAccountTypeID( QualifierItem.AccountTypeId.Value );
				else
					QualifierResult.AccountTypeDesc = String.Empty;
				if( QualifierItem.ProductBrandId.HasValue )
					QualifierResult.BrandDescription = GetProductBrandDescFromID( QualifierItem.ProductBrandId.Value );
				else
					QualifierResult.BrandDescription = String.Empty;
				if( QualifierItem.PriceTierId.HasValue )
					QualifierResult.PriceTierDescription = GetPriceTierDescFromID( QualifierItem.PriceTierId.Value );
				else
					QualifierResult.PriceTierDescription = String.Empty;

				QualifierResult.ContractTerm = QualifierItem.Term;
				QualifierResult.SignStartDate = QualifierItem.SignStartDate;
				QualifierResult.SignEndDate = QualifierItem.SignEndDate;
				QualifierResult.ContractEffecStartPeriodStartDate = QualifierItem.ContractEffecStartPeriodStartDate;
				QualifierResult.ContractEffecStartPeriodLastDate = QualifierItem.ContractEffecStartPeriodLastDate;
				QualifierResult.AutoApply = QualifierItem.AutoApply;
				QualifierResultList.Add( QualifierResult );
			}
			return QualifierResultList;
		}

        /*  Created on:     22 Jul 2015
            Created by:     Manish Pandey
            Discription:    To export quilifier into excel and get data from Database.
        */
        public static DataSet GetQualifierExportToExcelList(Qualifier Qualifier)
        {
            List<QualifierDetails_Export> QualifierResultset = new List<QualifierDetails_Export>();
            DataSet ds = PromotionQualifierSQL.GetQualifierExportToExcelList(Qualifier.CampaignId, Qualifier.PromotionCode.Code,
                Qualifier.SignStartDate, Qualifier.SignEndDate, Qualifier.SalesChannelIds, Qualifier.MarketIds, Qualifier.UtilityId);

            //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //{
                
            //    for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
            //    {
            //        QualifierDetails_Export QualifierDetail = new QualifierDetails_Export();
            //        MapDataRowToQualifierExportToExcelResultSet(ds.Tables[0].Rows[iCount], QualifierDetail);
            //        QualifierResultset.Add(QualifierDetail);
            //    }
            //}
            //return QualifierResultset;
            return ds;

        }



        /*  Created on:     22 Jul 2015
            Created by:     Manish Pandey
            Discription:    To export quilifier into excel and get data from Database assign to class object.
        */
        private static void MapDataRowToQualifierExportToExcelResultSet(DataRow dataRow, QualifierDetails_Export qualifier)
        {
            qualifier.PromotionCode = dataRow.Field<String>("PromotionCode");
            qualifier.SalesChannels = dataRow.Field<String>("SalesChannels");
            qualifier.Markets = dataRow.Field<String>("Markets");
            qualifier.Utilities = dataRow.Field<String>("Utilities");
            qualifier.Accounttypes = dataRow.Field<String>("Accounttypes");
            qualifier.Term = dataRow.Field<String>("Term");
            qualifier.ProductBrands = dataRow.Field<String>("ProductBrands");
            qualifier.SignStartDate = dataRow.Field<String>("SignStartDate");
            qualifier.SignEndDate = dataRow.Field<String>("SignEndDate");
            qualifier.ContractEffecStartPeriodStartDate = dataRow.Field<String>("ContractEffecStartPeriodStartDate");
            qualifier.ContractEffecStartPeriodLastDate = dataRow.Field<String>("ContractEffecStartPeriodLastDate");
            qualifier.PriceTiers = dataRow.Field<String>("PriceTiers");
            qualifier.AccountAnnualUsage = dataRow.Field<String>("AccountAnnualUsage");
            
        }

		#region "helpers for getting the desc details SalesChannel,market,utility,AccountType,priceTier"
		
		public static string GetSalesChannelNameFromID(int salesChannelID)
		{
			String SalesChannelName="";

			DataSet ds = PromotionQualifierSQL.GetSalesChannelNamefromID( salesChannelID );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				SalesChannelName = ds.Tables[0].Rows[0][0].ToString();
			}
			return SalesChannelName;
		}

		public static string GetMarketCodeFromID(int MarketId)
		{
			String MarketCode="";

			DataSet ds = PromotionQualifierSQL.GetMarketCodefromID( MarketId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				MarketCode = ds.Tables[0].Rows[0][0].ToString();
			}
			return MarketCode;
		}

		public static string GetUtilityCodeFromID(int UtilityID)
		{
			String UtilityCode="";

			DataSet ds = PromotionQualifierSQL.GetUtilityCodefromID( UtilityID );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				UtilityCode = ds.Tables[0].Rows[0][0].ToString();
			}
			return UtilityCode;
		}

		public static string GetAccountTypeDescFromID( int AccountTypeID )
		{
			String AccountTypeDesc = "";

			DataSet ds = PromotionQualifierSQL.GetAccountTypeDescriptionfromID( AccountTypeID );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				AccountTypeDesc = ds.Tables[0].Rows[0][0].ToString();
			}
			return AccountTypeDesc;
		}

		public static string GetAccountTypeDescFromProductAccountTypeID( int ProductAccountTypeID )
		{
			String AccountTypeDesc = "";

			DataSet ds = PromotionQualifierSQL.GetAccountTypeDescriptionfromProductAccountTypeID( ProductAccountTypeID );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				AccountTypeDesc = ds.Tables[0].Rows[0][0].ToString();
			}
			return AccountTypeDesc;
		}



		public static string GetProductBrandDescFromID( int ProductBrandId )
		{
			String ProductBrandDesc = "";

			DataSet ds = PromotionQualifierSQL.GetProductBrandDescriptionfromID( ProductBrandId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				ProductBrandDesc = ds.Tables[0].Rows[0][0].ToString();
			}
			return ProductBrandDesc;
		}

		public static string GetPriceTierDescFromID( int ProceTierId )
		{
			String PriceTierDesc = "";

			DataSet ds = PromotionQualifierSQL.GetpriceTierDescriptionfromID( ProceTierId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				PriceTierDesc = ds.Tables[0].Rows[0][0].ToString();
			}
			return PriceTierDesc;
		}

        /// <summary>
        /// Gets a list of sales channels for campaign
        /// <returns>Dataset.</returns>
        public static SalesChannelList GetSalesChannelsForCampaign()
        {
            SalesChannelList SalesChannelList = new SalesChannelList();
            SalesChannelList = SalesChannelFactory.GetActiveSalesChannels();
                
            //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //{
            //    for (int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount)
            //    {
            //        SalesChannel SalesChannel = new SalesChannel();
            //        SalesChannel.ChannelID = Convert.ToInt32(ds.Tables[0].Rows[iCount][0]);
            //        SalesChannel.ChannelName = ds.Tables[0].Rows[iCount][1].ToString();
            //        SalesChannelList.Add(SalesChannel);
            //    }
            //}
            return SalesChannelList;
        }

        /// <summary>
        /// Return a Market list dataset
        /// </summary>
        /// <param name="salesChannelIds">Sales Channels Ids</param>
        /// <returns>Dataset</returns>
        public static List<RetailMarket> GetMarketBySalesChannelIds(string salesChannelIds)
        {
            List<RetailMarket> Markets = new List<RetailMarket>();
            DataSet dsMarket = MarketSql.GetSalesChannelsMarketList(salesChannelIds);
            if (dsMarket != null && dsMarket.Tables.Count > 0)
            {
                foreach (DataRow dr in dsMarket.Tables[0].Rows)
                {
                    RetailMarket Market = new RetailMarket();
                    Market.ID = Convert.ToInt32(dr["ID"]);
                    Market.Description = dr["MarketDesc"].ToString() ;
                    Markets.Add(Market);
                }
            }

            return Markets;
        }

        /// <summary>
        /// Gets utilities by market Ids
        /// </summary>
        /// <param name="marketIds"></param>
        /// <returns>Dataset</returns>
        public static UtilityList GetUtilitiesByMarketIds(string marketIds)
        {
            UtilityList Utilities = new UtilityList();
            DataSet dsUtility = UtilitySql.GetMarketUtilities(marketIds);
            if (dsUtility != null && dsUtility.Tables.Count > 0)
            {
                foreach (DataRow dr in dsUtility.Tables[0].Rows)
                {
                    LibertyPower.Business.MarketManagement.UtilityManagement.Utility Utility = new LibertyPower.Business.MarketManagement.UtilityManagement.Utility();
                    Utility.Identity= Convert.ToInt32(dr["ID"]);
                    Utility.Description = dr["UtilityDesc"].ToString();
                    Utilities.Add(Utility);
                }
            }
            return Utilities;
        }

        //Get all account types 
        public static AccountTypeList GetAllAccountType()
        {
            AccountTypeList AccountTypeList = new AccountTypeList();
            DataSet dsAccountType = LibertyPowerSql.GetAllProductAccountType();
            if (dsAccountType != null && dsAccountType.Tables.Count > 0)
            {
                foreach (DataRow dr in dsAccountType.Tables[0].Rows)
                {
                    
                    LibertyPower.Business.CustomerManagement.AccountManagement.AccountType AccountType = new LibertyPower.Business.CustomerManagement.AccountManagement.AccountType();
                    AccountType.Id = Convert.ToInt32(dr["ID"]);
                    AccountType.Description = dr["AccountType"].ToString();
                    AccountTypeList.Add(AccountType);
                }
            }
            return AccountTypeList;
        }

        //Get all product brand 
        public static List<ProductBrand> GetAllProductBrand()
        {

            List<ProductBrand> ProductBrandList = new List<ProductBrand>();
            DataSet dsProcuctBrand = LibertyPowerSql.GetAllProductBrand();
            if (dsProcuctBrand != null && dsProcuctBrand.Tables.Count > 0)
            {
                foreach (DataRow dr in dsProcuctBrand.Tables[0].Rows)
                {

                    ProductBrand ProductBrand = new ProductBrand();
                    ProductBrand.ProductBrandID = Convert.ToInt32(dr["ProductBrandID"]);
                    ProductBrand.Name = dr["Name"].ToString();
                    ProductBrandList.Add(ProductBrand);
                }
            }
            return ProductBrandList;
        }


       

        /*  Created on:     8 Oct 2015
            Created by:     Manish Pandey
            Discription:    To to get All Channel for promo campaign code.
        */
        public static List<SalesChannelAll> GetSalesChannelsAllForCampaign(int? CampaignId)
        {
            List<SalesChannelAll> list = new List<SalesChannelAll>();
            DataSet ds = PromotionQualifierSQL.GetAllSalesChannels(null, CampaignId);
            if (ds != null && ds.Tables.Count > 0)
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(GetSalesChannel(dr));

            return list;
        }
        /*  Created on:     8 Oct 2015
            Created by:     Manish Pandey
            Discription:    To to get All Channel for promo campaign code.
        */
        public static SalesChannelAll GetSalesChannel(DataRow dr)
        {

            SalesChannelAll sc = new SalesChannelAll();
            sc.ChannelName = Convert.ToString(dr["ChannelName"]);
            sc.ChannelID = Convert.ToInt32(dr["ChannelID"]);
            return sc;
        }
		#endregion
	}
    public class SalesChannelAll
    {
        public System.Int32 ChannelID { get; set; }
        public System.String ChannelName { get; set; }
    }
    public class SalesChannelIds
    {
        public System.Int32 SalesChannelId { get; set; }

    }
    public class MarketIds
    {
        public System.Int32 MarketId { get; set; }

    }
    /*  Created on:     22 Jul 2015
        Created by:     Manish Pandey
        Discription:    To export quilifier into excel and get data from Database.
    */
    public class QualifierDetails_Export
    {
        public System.String PromotionCode { get; set; }
        public System.String SalesChannels { get; set; }
        public System.String Markets { get; set; }
        public System.String Utilities { get; set; }
        public System.String Accounttypes { get; set; }
        public System.String Term { get; set; }
        public System.String AccountAnnualUsage { get; set; }
        public System.String ProductBrands { get; set; }
        public System.String SignStartDate { get; set; }
        public System.String SignEndDate { get; set; }
        public System.String ContractEffecStartPeriodStartDate { get; set; }
        public System.String ContractEffecStartPeriodLastDate { get; set; }
        public System.String PriceTiers { get; set; }
    }
	public class QualifierResultSet
	{
		public bool IsValid { get; set; }
		
		public string Info { get; set; }

        public List<Qualifier> QualifiersMatch { get; set; }

		public QualifierResultSet()
        {
            SetDefaultValues();
        }

		public void SetDefaultValues()
		{
			this.IsValid = false;
			this.Info = "The PromotionCode does not exist";
            this.QualifiersMatch = null;
		}

	}

   
	public class QualifierResultSetforTablet
	{
	 
        public System.Int32 PromotionCodeId { get; set; }
		public System.String SalesChannelName { get; set; }        
        public System.String MarketName { get; set; }       
        public System.String AccountTypeDesc { get; set; }      
        public System.String UtilityName { get; set; }      
        public System.Int32? ContractTerm { get; set; }
        public System.String BrandDescription { get; set; }  
        public System.DateTime SignStartDate { get; set; }
        public System.DateTime SignEndDate { get; set; } 
        public System.DateTime? ContractEffecStartPeriodStartDate { get; set; }        
        public System.DateTime? ContractEffecStartPeriodLastDate { get; set; }   
        public System.String PriceTierDescription { get; set; }
		public System.Boolean? AutoApply { get; set; }
	}

    public class QualifierDetails
    {
        public System.Int32 PromotionCodeId { get; set; }
        public System.String Code { get; set; }
        public System.Int32 CampaignId { get; set; }
        public System.String SalesChannels { get; set; }
        public System.String Markets { get; set; }
        public System.String Accounttypes { get; set; }
        public System.String Utilities { get; set; }
        public System.Int32? Term { get; set; }
        public System.String ProductBrands { get; set; }
        public System.DateTime SignStartDate { get; set; }
        public System.DateTime SignEndDate { get; set; }
        public System.DateTime? ContractEffecStartPeriodStartDate { get; set; }
        public System.DateTime? ContractEffecStartPeriodLastDate { get; set; }
        public System.String PriceTiers { get; set; }
        public System.Int32? GroupBy { get; set; }
        public System.Int32? DeleteQualifierGroupId { get; set; }
        //Field added by Manish Pandey-Added field IsAssignedToContract.
        public System.Int32? IsAssignedToContract { get; set; }
        public System.Int32? AccountAnnualUsage { get; set; }//1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
    }
}

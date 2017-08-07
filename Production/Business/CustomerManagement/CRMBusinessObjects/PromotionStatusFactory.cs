using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	 public static class PromotionStatusFactory
	{
		 private static void MapDataRowToPromotionStatus( DataRow dataRow, PromotionStatus promotionstatus )
		 {
			 promotionstatus.PromotionStatusId = dataRow.Field<int>( "PromotionStatusId" );
			 promotionstatus.Code = dataRow.Field<String>( "Code" );
			 promotionstatus.Description = dataRow.Field<String>( "Description" );
			 promotionstatus.CreatedBy = dataRow.Field<int?>( "CreatedBy" );
			 promotionstatus.CreatedDate = dataRow.Field<DateTime>( "CreatedDate" );
		 }

		 public static List<PromotionStatus> GetAllPromotion_FulfillmentStatus()
		 {
			 List<PromotionStatus> promotionStatuslist = new List<PromotionStatus>();
			 DataSet ds = PromotionQualifierSQL.GetAllFulfillmentStatus();

			 if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			 {
				 for( int iCount = 0; ds.Tables[0].Rows.Count > iCount; ++iCount )
				 {
					 PromotionStatus promotionstatus = new PromotionStatus();
					 MapDataRowToPromotionStatus( ds.Tables[0].Rows[iCount], promotionstatus );
					 promotionStatuslist.Add( promotionstatus );
				 }
			 }
			 return promotionStatuslist;

		 }

		 public static DataTable GetAllAccountStatus(string p_view)
		 {
			 DataTable dtAccountStatus = AccountDal.GetAllAccountStatus( p_view );
			 return dtAccountStatus;
		 }
	}
}
 
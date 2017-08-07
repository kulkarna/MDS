namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.DataAccess.SqlAccess.AccountSql;
	using LibertyPower.DataAccess.SqlAccess.EnrollmentSql;

	public static class EnrollmentFactory
	{
		public static StatusTransition GetStatusTransition( StatusTransitionList list, int ID )
		{
			return (from s in list
					where s.ID == ID
					select s).FirstOrDefault<StatusTransition>();
		}

		public static Status GetStatus( StatusList list, string status, string substatus )
		{
			return (from s in list
					where s.StatusNum == status
					&& s.SubStatusNum == substatus
					select s).FirstOrDefault<Status>();
		}

		public static StatusTransitionList GetStatusTransitions( string status, string substatus )
		{
			StatusTransitionList list = new StatusTransitionList();

			DataSet ds = EnrollmentSql.GetStatusTransitions( status, substatus );
			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildStatusTransition( dr ) );
			}
			return list;
		}

		private static StatusTransition BuildStatusTransition( DataRow dr )
		{
			int ID = Convert.ToInt32( dr["ID"] );
			string oldStatus = dr["OldStatus"].ToString().Trim();
			string oldSubStatus = dr["OldSubStatus"].ToString().Trim();
			string newStatus = dr["NewStatus"].ToString().Trim();
			string newSubStatus = dr["NewSubStatus"].ToString().Trim();
			string newStatusDescription = dr["NewStatusDesc"].ToString();
			string newSubStatusDescription = dr["NewSubStatusDesc"].ToString();
			bool requiresStartDate = Convert.ToBoolean( dr["RequiresStartDate"] );
			bool requiresEndDate = Convert.ToBoolean( dr["RequiresEndDate"] );
			DateTime dateCreated = Convert.ToDateTime( dr["DateCreated"] );

			return new StatusTransition( ID, oldStatus, oldSubStatus, newStatus, newSubStatus, newStatusDescription,
				newSubStatusDescription, requiresStartDate, requiresEndDate, dateCreated );
		}

		public static StatusList GetStatusList()
		{
			StatusList list = new StatusList();

			DataSet ds = AccountSql.GetStatus();
			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildStatus( dr ) );
			}
			return list;
		}

		private static Status BuildStatus( DataRow dr )
		{
			string status = dr["status"].ToString().Trim();
			string statusDesc = dr["status_descp"].ToString().Trim();
			string subStatus = dr["sub_status"].ToString().Trim();
			string subStatusDesc = dr["sub_status_descp"].ToString().Trim();

			return new Status( status, statusDesc, subStatus, subStatusDesc );
		}

		public static StatusTransitionsReasonCodeList GetStatusTransitionsReasonCodes()
		{
			StatusTransitionsReasonCodeList list = new StatusTransitionsReasonCodeList();

			DataSet ds = EnrollmentSql.GetStatusTransitionsReasonCodes();
			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildStatusTransitionsReasonCode( dr ) );
			}
			return list;
		}

		private static StatusTransitionsReasonCode BuildStatusTransitionsReasonCode( DataRow dr )
		{
			int ID = Convert.ToInt32( dr["ID"] );
			string reason = dr["Reason"].ToString();

			return new StatusTransitionsReasonCode( ID, reason );
		}

		public static int InsertStatusTransitionsReason( string accountIdLegacy, int reasonCodeID, int statusTransitionsID, DateTime dateCreated )
		{
			int ID = 0;
			DataSet ds = EnrollmentSql.InsertStatusTransitionsReason( accountIdLegacy, reasonCodeID, statusTransitionsID, dateCreated );
			if( DataSetHelper.HasRow( ds ) )
			{
				ID = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
			}
			return ID;
		}

		public static void InsertStatusTransitionsReasonOther( int reasonID, string reason )
		{
			EnrollmentSql.InsertStatusTransitionsReasonOther( reasonID, reason );
		}

		public static void UpdateAccountService( string accountIdLegacy, string status, DateTime startDate, DateTime endDate )
		{
			EnrollmentSql.UpdateAccountService( accountIdLegacy, status, startDate, endDate );
		}
	}
}

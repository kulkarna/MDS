using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class SalesChannelUserSql
    {
        public static DataSet GetLowerHierarchy(int userID, int channelID)
        {

            string SQL = "usp_SalesChannelUserGetHierarchy";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@UserID", userID);
                SqlParameter p2 = new SqlParameter("@ChannelID", channelID);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.Fill(ds);
            }


            return ds;
        }

        public static DataSet CreateSalesChannelUser(int UserID, int ChannelID, int createdBy, int EntityID, int reportsTo)
        {
            string SQL = "usp_SalesChannelUserInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@UserID", UserID);
                SqlParameter p2 = new SqlParameter("@ChannelID", ChannelID);
                SqlParameter p3 = new SqlParameter("@createdBy", createdBy);
                SqlParameter p4 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p5 = new SqlParameter("@ReportsTo", reportsTo);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);

                da.Fill(ds);
            }
            return ds;

        }

		public static DataSet CreateSalesChannelUser( string userName, string firstname, string lastname, string password, string email, int ChannelID, int createdBy, int reportsTo )
        {
            string SQL = "usp_UpdateUserToSalesRepBySalesChannel";

            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@Uname", userName);
                SqlParameter p2 = new SqlParameter("@FName", firstname);
                SqlParameter p3 = new SqlParameter("@LName", lastname);
                SqlParameter p4 = new SqlParameter("@Pwd", password);
                SqlParameter p5 = new SqlParameter("@UEmail", email);
                SqlParameter p6 = new SqlParameter("@ChannelParentId", ChannelID);
                //SqlParameter p5 = new SqlParameter("@ChannelId", ChannelID);
                SqlParameter p7 = new SqlParameter("@CreatedById", createdBy);
                
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                da.SelectCommand.Parameters.Add(p7);

                da.Fill(ds);
            }
            return ds;

        }
        public static DataSet CreateSalesChannelSalesAgent(string userName, string firstname, string lastname, string password, string email, int ChannelID, int createdBy, bool isActive)
        {
            string SQL = "usp_InsertSalesRepforSalesChannel";
            char isActiveChar = (isActive) ? 'Y' : 'N';
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@Uname", userName);
                SqlParameter p2 = new SqlParameter("@FName", firstname);
                SqlParameter p3 = new SqlParameter("@LName", lastname);
                SqlParameter p4 = new SqlParameter("@Pwd", password);
                SqlParameter p5 = new SqlParameter("@UEmail", email);
                SqlParameter p6 = new SqlParameter("@ChannelParentId", ChannelID);
                //SqlParameter p5 = new SqlParameter("@ChannelId", ChannelID);
                SqlParameter p7 = new SqlParameter("@CreatedById", createdBy);
                SqlParameter p8 = new SqlParameter("@IsActive", isActiveChar);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                da.SelectCommand.Parameters.Add(p7);
                da.SelectCommand.Parameters.Add(p8);

                da.Fill(ds);
            }
            return ds;

        }

        public static DataSet GetSalesChannelUser(string UserGuid)
        {
            string SQL = "usp_SalesChannelUserGetUser";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@UserGuid", UserGuid);


                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet GetSalesChannelUserByUserID(int UserID)
        {

            string SQL = "usp_SalesChannelUserGetUser";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@UserID", UserID);


                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet GetSalesChannelUserByChannelID(int ChannelID)
        {

            string SQL = "usp_SalesChannelUserGetByChannelID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet GetSalesChannelUserByChannelID(int ChannelID, bool includeInactive)
        {

            string SQL = "usp_SalesChannelUserGetByChannelID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                SqlParameter p2 = new SqlParameter("@IncludeInactive", (includeInactive));
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.Fill(ds);
            }
            return ds;
        }

        // Enhancement-13533
        public static DataSet GetSalesChannelRepresentativeByChannelID(int ChannelID)
        {

            string SQL = "usp_SalesChannelRepresentativesGetByChannelID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet GetSalesChannelInternalUsers()
        {

            string SQL = "usp_SalesChannelUserGetInternalUsers";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet SalesChannelUsersGetForSearch(int userID, string roleName)
        {

            string SQL = "usp_SalesChannelUsersGetForSearch";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@CurrentUserID", userID);
                SqlParameter p2 = new SqlParameter("@RoleName", roleName);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.Fill(ds);
            }


            return ds;
        }

		public static DataSet UpdateSalesChannelUser(int ChannelID, int UserID, int ReportsTo)
		{
			return UpdateSalesChannelUser(ChannelID, UserID, ReportsTo, -1);
		}


        public static DataSet UpdateSalesChannelUser(int ChannelID, int UserID, int ReportsTo, int ModifiedBy)
        {
            string SQL = "usp_SalesChannelUserUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                SqlParameter p2 = new SqlParameter("@ReportsTo", ReportsTo);
                SqlParameter p3 = new SqlParameter("@UserID", UserID);
				SqlParameter p4 = new SqlParameter("@ModifiedBy", ModifiedBy);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
				da.SelectCommand.Parameters.Add(p4);

                da.Fill(ds);
            }
            return ds;
        }

    }
}

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class SalesChannelProspectSql
    {
 
        public static DataSet CreateSalesChannelProspect(int ChannelID, int ProspectID, int AssignedTo, int CreatedBy)
        {


            string SQL = "usp_SalesChannelProspectInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@ChannelID", ChannelID);
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p2 = new SqlParameter("@AssignedTo", AssignedTo);
                SqlParameter p3 = new SqlParameter("@CreatedBy", CreatedBy);

                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);

                da.Fill(ds);
            }

            return ds;

        }

        public static DataSet ChangeOwnerSalesChannelProspect(int ChannelID, int ProspectID, int @ChannelProspectID, int NewAssignedTo, int ModifiedBy)
        {


            string SQL = "usp_SalesChannelProspectChangeOwner";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@ChannelID", ChannelID);
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p2 = new SqlParameter("@NewAssignedTo", NewAssignedTo);
                SqlParameter p3 = new SqlParameter("@ChannelProspectID", ChannelProspectID);
                SqlParameter p4 = new SqlParameter("@ModifiedBy", ModifiedBy);

                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);

                da.Fill(ds);
            }

            return ds;

        }
        public static DataSet GetSalesChannelProspecListByChannelID(int ChannelID)
        {
            
            string SQL = "usp_SalesChannelProspectGetByChannelID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@ChannelID", ChannelID);
                da.SelectCommand.Parameters.Add(p0);
                da.Fill(ds);
            }

            return ds;
        }
        public static DataSet GetSalesChannelProspectByProspectAndAssignedTo(int ProspectID, int AssignedTo)
        {

            string SQL = "usp_SalesChannelProspectGetByProspectAssignedTo";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p1 = new SqlParameter("@UserID", AssignedTo);
                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet GetSalesChannelProspectByProspectAndChannelID(int ProspectID, int ChannelID)
        {

            string SQL = "usp_SalesChannelProspectGetByProspectChannelID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }
        public static DataSet GetSalesChannelProspectListByUserID(int UserID)
        {
            

            string SQL = "usp_SalesChannelProspectGetByUserID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@UserID", UserID);
                da.SelectCommand.Parameters.Add(p0);
                da.Fill(ds);
            }

            return ds;
        }

    }
}

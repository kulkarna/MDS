using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
   public static class MailListSql
    {
        public static DataSet MailingListGetByChannelID(int ChannelID) {
          
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MailingListGet";

                    cmd.Parameters.Add(new SqlParameter("@ChannelID", ChannelID));
                                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
       }

        public static DataSet MailingListInsertUser(int ChannelID, int UserID)
        {
           
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MailingListInsert";

                    cmd.Parameters.Add(new SqlParameter("@ChannelID", ChannelID));
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;

        }
        public static DataSet MailingListRemoveUser(int ChannelID, int UserID)
        {
            
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MailingListDelete";

                    cmd.Parameters.Add(new SqlParameter("@ChannelID", ChannelID));
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                        da.Fill(ds);
                }
            }
            return ds;

        }
        public static DataSet MailingListGetAll()
        {
          
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MailingListGetAll";
                                        
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;

        }
    }
}

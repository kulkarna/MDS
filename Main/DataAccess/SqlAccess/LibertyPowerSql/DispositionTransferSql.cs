using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class DispositionTransferSql
    {
        /// <summary>
        /// Gets all transfer topics
        /// </summary>
        /// <returns></returns>
        public static DataSet GetTransferTopics()
        {
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = con;
                    command.CommandType = CommandType.Text;
                    command.CommandText = "SELECT TransferTopicId, Description FROM TransferTopic";

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        da.Fill(ds);                        
                    }
                }
            }

            return ds;
        }

        /// <summary>
        /// Gets all transfer dispositions
        /// </summary>
        /// <returns></returns>
        public static DataSet GetTransferDispositions()
        {
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = con;
                    command.CommandType = CommandType.Text;
                    command.CommandText = "SELECT TransferDispositionId, Description FROM TransferDisposition";

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

       /// <summary>
       /// Inserts a log entry of a transfer
       /// </summary>
       /// <param name="accountId"></param>
       /// <param name="transferTopicId"></param>
       /// <param name="transferDispositionId"></param>
       /// <returns>The date and time of the creation of the entry</returns>
        public static DateTime TransferLogInsert(int accountId, int transferTopicId, int transferDispositionId)
        {
            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = con;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "TransferLogInsert";

                    command.Parameters.AddWithValue("@AccountID", accountId);
                    command.Parameters.AddWithValue("@TransferTopicID", transferTopicId);
                    command.Parameters.AddWithValue("@TransferDispositionID", transferDispositionId);

                    con.Open();
                    DateTime dateTimeCrated = (DateTime)command.ExecuteScalar();
                    con.Close();

                    return dateTimeCrated;
                }
            }
        }
    }
}

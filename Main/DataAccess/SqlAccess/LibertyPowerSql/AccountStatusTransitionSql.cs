using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class AccountStatusTransitionSql
    {
        /// <summary>
        /// Get a list of possible status transitions according to oldStatusID.
        /// By default, it will not retrieve inactive status transitions.
        /// </summary>
        /// <param name="oldStatusID"></param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataSet GetAccountStatusTransitionList(int oldStatusID, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusTransitionSelectByOldStatusID";

                    command.Parameters.Add(new SqlParameter("@OldStatusID", oldStatusID));
                    command.Parameters.Add(new SqlParameter("@IncludeInactive", includeInactive));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Get a list of possible status transitions according to oldStatus and oldSubStatus.
        /// </summary>
        /// <param name="oldStatus"></param>
        /// <param name="oldSubStatus"></param>
        /// <returns></returns>
        public static DataSet GetAccountStatusTransitionList(string oldStatus, string oldSubStatus)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusTransitionSelectByOldStatusSubStatus";

                    command.Parameters.Add(new SqlParameter("@OldStatus", oldStatus));
                    command.Parameters.Add(new SqlParameter("@OldSubStatus", oldSubStatus));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Updates "isActive" Status.
        /// </summary>
        /// <param name="transitionID"></param>
        /// <param name="isActive"></param>
        /// <param name="username"></param>
        public static void UpdateStatusTransitionIsActive(int transitionID, bool isActive, string username)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusTransitionUpdateIsActive";

                    command.Parameters.Add(new SqlParameter("@TransitionID", transitionID));
                    command.Parameters.Add(new SqlParameter("@IsActive", isActive));
                    command.Parameters.Add(new SqlParameter("@Username", username));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Insert a new status transition into database.
        /// </summary>
        /// <param name="oldStatusID"></param>
        /// <param name="newStatusID"></param>
        /// <param name="startDateRequired"></param>
        /// <param name="endDateRequired"></param>
        /// <param name="username"></param>
        public static void CreateAccountStatusTransition(int oldStatusID, int newStatusID, bool startDateRequired, bool endDateRequired, string username)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusTransitionInsert";

                    command.Parameters.Add(new SqlParameter("@OldStatusID", oldStatusID));
                    command.Parameters.Add(new SqlParameter("@NewStatusID", newStatusID));
                    command.Parameters.Add(new SqlParameter("@StartDateRequired", startDateRequired));
                    command.Parameters.Add(new SqlParameter("@EndDateRequired", endDateRequired));
                    command.Parameters.Add(new SqlParameter("@Username", username));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Get status changes informations.
        /// </summary>
        /// <returns></returns>
        public static DataSet GetAccountStatusChangeMetrics()
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusChangeMetrics";

                    connection.Open();
                    command.ExecuteNonQuery();

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Update Account Status Transition Metrics using transitionID and username
        /// </summary>
        /// <param name="transitionID"></param>
        /// <param name="username"></param>
        public static void UpdateAccountStatusTransitionMetrics(int transitionID, string username)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusTransitionMetricsUpdate";

                    command.Parameters.Add(new SqlParameter("@AccountStatusTransitionID", transitionID));
                    command.Parameters.Add(new SqlParameter("@Username", username));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}

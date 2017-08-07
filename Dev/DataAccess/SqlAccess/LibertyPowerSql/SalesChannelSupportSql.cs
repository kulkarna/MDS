using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class SalesChannelSupportSql
    {
        public static DataSet UpdateSalesChannelSupport( int salesChannelSupportID, int? channelID, int? supportUserID, int? managerUserID, DateTime? expirationDate, bool? sendEmail )
        {
            return SalesChannelSupportInsertUpdate( salesChannelSupportID, channelID, supportUserID, managerUserID, expirationDate, sendEmail );
        }

        public static DataSet InsertSalesChannelSupport( int? channelID, int? supportUserID, int? managerUserID, DateTime? expirationDate, bool sendEmail )
        {
            return SalesChannelSupportInsertUpdate( null, channelID, supportUserID, managerUserID, expirationDate, sendEmail );
        }

        private static DataSet SalesChannelSupportInsertUpdate( int? salesChannelSupportID, int? channelID, int? supportUserID, int? managerUserID, DateTime? expirationDate, bool? sendEmail )
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportInsertUpdate";
                    command.Parameters.Add( new SqlParameter( "@SalesChannelSupportID", salesChannelSupportID ) );
                    command.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
                    command.Parameters.Add( new SqlParameter( "@SupportUserID", supportUserID ) );
                    command.Parameters.Add( new SqlParameter( "@ManagerUserID", managerUserID ) );
                    command.Parameters.Add( new SqlParameter( "@ExpirationDate", expirationDate ) );
                    command.Parameters.Add( new SqlParameter( "@SendEmail", sendEmail ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( command ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        public static bool DeleteSalesChannelSupport( int salesChannelSupportID )
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportDelete";
                    command.Parameters.Add( new SqlParameter( "@SalesChannelSupportID", salesChannelSupportID ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( command ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return true;
        }

        public static bool DeleteExpiredSalesChannelSupport()
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportDeleteExpired";
                    command.ExecuteNonQuery();
                }
            }
            return true;
        }

        /// <summary>
        /// Gets one user support record
        /// </summary>
        /// <param name="salesChannelSupportID"></param>
        /// <returns></returns>
        public static DataSet GetSalesChannelSupportByID( int salesChannelSupportID )
        {
            return GetSalesChannelSupport( salesChannelSupportID, null );
        }

        /// <summary>
        /// Get all support users for the specified manager
        /// </summary>
        /// <param name="managerUserID"></param>
        /// <returns></returns>
        public static DataSet GetSalesChannelSupportByManagerUserID( int managerUserID )
        {
            return GetSalesChannelSupport( null, managerUserID );
        }

        /// <summary>
        /// Get users for manager from specific channel
        /// </summary>
        /// <param name="managerUserID">Manager user id</param>
        /// <param name="channelID">if null bring users that support all channels</param>
        /// <returns></returns>
        public static DataSet GetSalesChannelsSupportByManagerAndChannel( int managerUserID, int? channelID )
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportSelectByManagerId";
                    command.Parameters.Add( new SqlParameter( "@ManagerUserID", managerUserID ) );
                    command.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( command ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        public static DataSet GetSalesChannelsSupportByChannelId( int? channelID )
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportSelectByChannelId";
                    command.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( command ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Base for other calls, can get 1 records or all support users attached to manager
        /// </summary>
        /// <param name="salesChannelSupportID"></param>
        /// <param name="managerUserID"></param>
        /// <returns></returns>
        private static DataSet GetSalesChannelSupport( int? salesChannelSupportID, int? managerUserID )
        {
            DataSet ds = new DataSet();
            using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand command = new SqlCommand() )
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_SalesChannelSupportSelect";
                    command.Parameters.Add( new SqlParameter( "@SalesChannelSupportID", salesChannelSupportID ) );
                    command.Parameters.Add( new SqlParameter( "@ManagerUserID", managerUserID ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( command ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

    }
}

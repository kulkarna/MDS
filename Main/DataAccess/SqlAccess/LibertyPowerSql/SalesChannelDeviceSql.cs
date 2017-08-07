using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class SalesChannelDeviceSql
    {
        //Get sales channel device list by sales channel
        public static DataSet GetSalesChannelDeviceList( int ChannelId )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_DeviceDispositioningListBySalesChannel";
                    if (ChannelId != 0)
                        cmd.Parameters.Add( new SqlParameter( "@p_sales_channel_id", ChannelId ) );
                    using (SqlDataAdapter da = new SqlDataAdapter( cmd ))
                        da.Fill( ds );
                }
            }
            return ds;
        }

        //Get sales channel device list by device id
        public static DataSet GetSalesChannelDeviceByDeviceId( string DeviceId )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelDeviceByDeviceId";
                    cmd.Parameters.Add( new SqlParameter( "@p_device_id", DeviceId ) );
                    using (SqlDataAdapter da = new SqlDataAdapter( cmd ))
                        da.Fill( ds );
                }
            }
            return ds;
        }

        //Validate and add new application key and return ClientSubApplicationKeyId
        public static int GetSalesChannelDeviceApplicationKey( Guid ApplicationKey )
        {
            int ClientSubApplicationKeyId;
            using (SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ValidateAndAddApplicationKey";
                    cmd.Parameters.Add( new SqlParameter( "@p_ApplicationKey", ApplicationKey ) );
                    SqlParameter ApplicationKeyId = new SqlParameter( "@p_ClientSubApplicationKeyId", SqlDbType.Int );
                    ApplicationKeyId.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add( ApplicationKeyId );
                    cmd.ExecuteNonQuery();
                    ClientSubApplicationKeyId = Convert.ToInt32( ApplicationKeyId.Value );
                    conn.Close();

                }
            }
            return ClientSubApplicationKeyId;
        }

        //Insert sales channel assigned device 
        public static DataSet InsSalesChannelDevice( int ChannelId, string DeviceId, int? ClientSubApplicationKeyId, bool IsActive, int CreatedBy )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelDeviceAssignmentInsert";
                    cmd.Parameters.Add( new SqlParameter( "@p_sales_channel_id", ChannelId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_device_id", DeviceId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_ClientSubApplicationKeyId", ClientSubApplicationKeyId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_active", IsActive ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_CreatedBy", CreatedBy ) );
                    using (SqlDataAdapter da = new SqlDataAdapter( cmd ))
                        da.Fill( ds );
                }
            }
            return ds;
        }

        //Update sales channel assigned device 
        public static DataSet UpdateSalesChannelDevice( int AssignmentId, int ChannelId, string DeviceId, int? ClientSubApplicationKeyId, bool IsActive, int ModifiedBy )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelDeviceAssignmentUpdate";
                    cmd.Parameters.Add( new SqlParameter( "@p_assignment_id", AssignmentId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_sales_channel_id", ChannelId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_device_id", DeviceId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_ClientSubApplicationKeyId", ClientSubApplicationKeyId ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_active", IsActive ) );
                    cmd.Parameters.Add( new SqlParameter( "@p_ModifiedBy", ModifiedBy ) );
                    using (SqlDataAdapter da = new SqlDataAdapter( cmd ))
                        da.Fill( ds );
                }
            }
            return ds;
        }
    }
}

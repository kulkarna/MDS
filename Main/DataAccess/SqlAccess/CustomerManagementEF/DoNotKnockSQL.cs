using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;


namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public static class DoNotKnockSQL
    {
        /*  
           Created on:     24 Dec 2015
           Modified by:    Manish Pandey
           Discription:    Get Do Not Knock List.
      */
        public static DataSet GetDoNotKnockList(string FirstName, string LastName,
                string Company, string TelephoneNumber, string State, string ZipCode, string ActiveInactive,
                string OrderBY, int pageSize, int CurrentpageIndex, int? IsImport = 0, string DoNotKnockID = "")
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnock_list";
                    cmd.Parameters.Add(new SqlParameter("@p_FirstName", FirstName));
                    cmd.Parameters.Add(new SqlParameter("@p_LastName", LastName));
                    cmd.Parameters.Add(new SqlParameter("@p_Company", Company));
                    cmd.Parameters.Add(new SqlParameter("@p_TelephoneNumber", TelephoneNumber));
                    cmd.Parameters.Add(new SqlParameter("@p_State", State));
                    cmd.Parameters.Add(new SqlParameter("@p_ZipCode", ZipCode));
                    cmd.Parameters.Add(new SqlParameter("@p_ActiveInactive", ActiveInactive));
                    cmd.Parameters.Add(new SqlParameter("@p_order_by", OrderBY));
                    cmd.Parameters.Add(new SqlParameter("@p_pagesize", pageSize));
                    cmd.Parameters.Add(new SqlParameter("@p_currentpageIndex", CurrentpageIndex));
                    cmd.Parameters.Add(new SqlParameter("@p_IsImport", IsImport));
                    cmd.Parameters.Add(new SqlParameter("@p_DoNotKnockID", DoNotKnockID));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get Company List.
        */
        public static DataSet GetCompanyData(string Company)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnockCompany_list";
                    cmd.Parameters.Add(new SqlParameter("@p_Company", Company));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get State List.
        */
        public static DataSet GetStateData(string State)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnockState_list";
                    cmd.Parameters.Add(new SqlParameter("@p_State", State));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get Zip Code List.
        */
        public static DataSet GetZipCodeData(string ZipCode)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnockZipCode_list";
                    cmd.Parameters.Add(new SqlParameter("@p_ZipCode", ZipCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Update Do Not Knock List.
        */
        public static int SaveDoNotKnockList(DataTable dt, out DataTable DoNotKnockDt, bool? ValidationRequired = true, int? ErrorCode = 0)
        {
            DataSet ds = new DataSet();
            int IsSuccess = 0;

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_DoNotKnock_insert";
                    cmd.Parameters.Add(new SqlParameter("@p_DoNotKnockListDt", dt));
                    cmd.Parameters.Add(new SqlParameter("@p_ValidationRequired", ValidationRequired));
                    cmd.Parameters.Add(new SqlParameter("@p_ErrorCode", ErrorCode));
                    cmd.Parameters.Add("@IsSuccess", SqlDbType.Int);
                    cmd.Parameters["@IsSuccess"].Direction = ParameterDirection.Output;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                        IsSuccess = (int)cmd.Parameters["@IsSuccess"].Value;
                    }
                }

            }
            DoNotKnockDt = ds.Tables[0];
            return IsSuccess;

        }
        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Insert in to Do Not Knock List.
        */
        public static int InsertDoNotKnockList(DataTable dt, out DataTable DoNotKnockDt, bool? ValidationRequired = true, int? ErrorCode = 0)
        {
            DataSet ds = new DataSet();
            int IsSuccess = 0;

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_DoNotKnock_insert";
                    cmd.Parameters.Add(new SqlParameter("@p_DoNotKnockListDt", dt));
                    cmd.Parameters.Add(new SqlParameter("@p_ValidationRequired", ValidationRequired));
                    cmd.Parameters.Add(new SqlParameter("@p_ErrorCode", ErrorCode));
                    cmd.Parameters.Add("@IsSuccess", SqlDbType.Int);
                    cmd.Parameters["@IsSuccess"].Direction = ParameterDirection.Output;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                        IsSuccess = (int)cmd.Parameters["@IsSuccess"].Value;
                    }
                }

            }
            DoNotKnockDt = ds.Tables[0];
            return IsSuccess;

        }

        /*  
           Created on:     10 Jan 2015
           Modified by:    Manish Pandey
           Discription:    To Import Do Not Knock List.
        */
        public static int GetDoNotKnockDetails(DataTable FulfillmentStatusDetails, out DataTable DoNotKnockDt)
        {
            DataSet ds = new DataSet();
            int IsSuccess = 0;
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnockDetails_Upload";
                    cmd.Parameters.Add(new SqlParameter("@p_DoNotKnockListDt", FulfillmentStatusDetails));
                    cmd.Parameters.Add("@IsSuccess", SqlDbType.Int);
                    cmd.Parameters["@IsSuccess"].Direction = ParameterDirection.Output;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                        IsSuccess = (int)cmd.Parameters["@IsSuccess"].Value;
                    }
                }
            }
            DoNotKnockDt = ds.Tables[0];
            return IsSuccess;
        }

        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get Do Not Knock History List.
        */
        public static DataSet GetDoNotKnockHistory(string DoNotKnockID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnockHistory";
                    cmd.Parameters.Add(new SqlParameter("@p_DoNotKnockID", DoNotKnockID));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetDoNotKnockListWithAuthorizedMarkets(int salesChannelId, string lastModifiedDate = null)
        {

            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 720; // Set the command time out 6 minutes to avoid the timeout 
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetDoNotKnock_marketSelected_list";
                    cmd.Parameters.Add(new SqlParameter("@p_SalesChannelId", salesChannelId));
                    if (lastModifiedDate != null)
                    {
                        cmd.Parameters.Add(new SqlParameter("@p_LastModifiedDate", Convert.ToDateTime(lastModifiedDate)));
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }
    }
}

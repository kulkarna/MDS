using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public class TabletMarketMaterialsSql 
    {
        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-08-20
        //-- Description:	Get data Market Material Document from TabletDocuments for given filters.
        public static DataSet GetMarketMaterialList(int pageSize, int CurrentpageIndex)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_TabletDocuments_list";
                    cmd.Parameters.Add(new SqlParameter("@p_pageSize", pageSize));
                    cmd.Parameters.Add(new SqlParameter("@p_CurrentpageIndex", CurrentpageIndex));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-09-2
        //-- Description:	Get data Document Type from Lp_documents..document_type for given filters.
        public static DataSet GetDocumentTypeDetails()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.DocumentsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_document_type_sel_by_code";
                    cmd.Parameters.Add(new SqlParameter("@p_document_type_code", "CF"));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-09-2
        //-- Description:	Insert Market Material Document Into TabletDocuments for given filters.
        public static bool InsertUploadedDocuments(string DocumentPath, string DocumentName, string Description, DateTime? StartDate, DateTime? EndDate,
            int UserID, DateTime? CurrentDate, int DocumentTypeID, string MarketId, string UtilityId, string FileType, string FileSize, string ContentType)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UploadedDocuments_ins";
                    cmd.Parameters.Add(new SqlParameter("@p_DocumentPath", DocumentPath));
                    cmd.Parameters.Add(new SqlParameter("@p_DocumentName", DocumentName));
                    cmd.Parameters.Add(new SqlParameter("@p_Description", Description));
                    if (StartDate!=null)
                        cmd.Parameters.Add(new SqlParameter("@p_StartDate", StartDate));
                    else
                        cmd.Parameters.Add(new SqlParameter("@p_StartDate", DBNull.Value));

                    if (StartDate != null)
                        cmd.Parameters.Add(new SqlParameter("@p_EndDate", EndDate));
                    else
                        cmd.Parameters.Add(new SqlParameter("@p_EndDate", DBNull.Value));
    
                    cmd.Parameters.Add(new SqlParameter("@p_UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@p_CurrentDate", CurrentDate));
                    cmd.Parameters.Add(new SqlParameter("@p_DocumentTypeID", DocumentTypeID));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketId", MarketId));
                    cmd.Parameters.Add(new SqlParameter("@p_UtilityId", UtilityId));
                    cmd.Parameters.Add(new SqlParameter("@p_FileType", FileType));
                    cmd.Parameters.Add(new SqlParameter("@p_FileSize", FileSize));
                    cmd.Parameters.Add(new SqlParameter("@p_ContentType", ContentType));
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            return true;
        }

        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-09-2
        //-- Description:	Delete Market Material Document from TabletDocuments for given filters.
        public static DataSet DeleteSelectedDocuments(int? TabletDocumentID)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_DeleteSelectedDocuments_del";
                    cmd.Parameters.Add(new SqlParameter("@p_TabletDocumentID", TabletDocumentID));
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-09-2
        //-- Description:	Update Market Material Document from TabletDocuments for given filters.
        public static bool UpdateSelectedDocuments(DataTable TabletMarketMaterialDt)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UpdateSelectedDocuments_update";
                    cmd.Parameters.Add(new SqlParameter("@p_TabletMarketMaterialDt", TabletMarketMaterialDt));
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            return true;
        }


        ////-- Author:		Manish
        ////-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        ////-- Create Date:   2015-08-20
        ////-- Description:	Get data Market Material Document from TabletDocuments for given filters.
        //public static DataSet GetMarketMaterialListByChannelID(int? ChannelId)
        //{
        //    DataSet ds = new DataSet();
        //    using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand())
        //        {
        //            conn.Open();
        //            cmd.Connection = conn;
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.CommandText = "usp_TabletDocumentsByChannelId_list";
        //            cmd.Parameters.Add(new SqlParameter("@p_ChannelId", ChannelId));
        //            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        //                da.Fill(ds);
        //        }
        //    }
        //    return ds;
        //}

        //-- Author:		Manish
        //-- PBI 84268:     New Marketing Materials tab is required in Tablet Admin Tool 
        //-- Create Date:   2015-09-2
        //-- Description:	Update Market Material Document from TabletDocuments for given filters.
        public static DataSet GetMarketData(int TabletDocumentID)
        {
            DataSet ds=new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetTabletDocumentMaketData";
                    cmd.Parameters.Add(new SqlParameter("@p_TabletDocumentID", TabletDocumentID));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        public static DataSet GetUtilityData(int TabletDocumentID, string MarketIds)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetTabletDocumentUtilityData";
                    cmd.Parameters.Add(new SqlParameter("@p_TabletDocumentID", TabletDocumentID));
                    cmd.Parameters.Add(new SqlParameter("@p_MarketIds", MarketIds));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        public static DataTable GetSelectedDoccumentDetails(string TabletDocumentID)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetTabletDocumentDetailByID";
                    cmd.Parameters.Add(new SqlParameter("@p_TabletDocumentID", TabletDocumentID));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds.Tables[0];
        }
    }
}
       
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;



namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class OrganizationSql
    {
        public static DataSet OrganizationInsert(string DunsNumber, string CustomerName, string taxID,
                                                DateTime? startDate, int createdBy, string Tag)
        {
            string SQL = "usp_EntityOrganizationInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@CustomerName", CustomerName);
				SqlParameter p1 = new SqlParameter("@TaxID", taxID != null ? (object)taxID : DBNull.Value);
				SqlParameter p2 = new SqlParameter("@StartDate", startDate != null ? (object)startDate : DBNull.Value);
                SqlParameter p3 = new SqlParameter("@CreatedBy", createdBy);
				SqlParameter p4 = new SqlParameter("@DunsNumber", DunsNumber != null ? (object)DunsNumber : DBNull.Value);
				SqlParameter p5 = new SqlParameter("@Tag", Tag != null ? (object)Tag : DBNull.Value);

                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);

                da.Fill(ds);
            }
            return ds;
        }

        public static DataSet GetOrganization(int EntityID)
        {
            
            string SQL = "usp_EntityOrganizationGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@EntityID", EntityID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }
            return ds;


        }
        public static DataSet OrganizationUpdate(int entityid,string dunsnumber,
                                                string customername, string taxid, 
                                                DateTime? startdate, int modifiedby,
                                                string Tag)
        {


            string SQL = "usp_EntityOrganizationUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@CustomerName", customername);
				SqlParameter p1 = new SqlParameter("@TaxID", (taxid != null) ? (object)taxid : DBNull.Value);
                SqlParameter p2 = new SqlParameter("@StartDate", startdate== null ? DBNull.Value: (object) startdate);
                SqlParameter p3 = new SqlParameter("@ModifiedBy", modifiedby);
				SqlParameter p4 = new SqlParameter("@DunsNumber", (dunsnumber != null) ? (object)dunsnumber : DBNull.Value);
                SqlParameter p5 = new SqlParameter("@EntityID", entityid);
                SqlParameter p6 = new SqlParameter("@Tag", Tag);

                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                

                da.Fill(ds);
            }

            return ds;
        }
    }
}

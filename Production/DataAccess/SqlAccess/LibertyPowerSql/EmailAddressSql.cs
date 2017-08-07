using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class EmailAddressSql
    {
        public static DataSet SaveEmailAddress(int EntityID, string Domain, string Address, int CreatedBy, string Tag)
        {


            string SQL = "usp_EntityEmailAddressInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p1 = new SqlParameter("@Domain", Domain);
                SqlParameter p2 = new SqlParameter("@Address", Address);
                SqlParameter p3 = new SqlParameter("@CreatedBy", CreatedBy);
                SqlParameter p4 = new SqlParameter("@Tag", Tag);


                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.Fill(ds);
            }

            return ds;
        }
        public static DataSet UpdateEmailAddress(int LinkID, string Domain, string Address, int ModifiedBy, string Tag)
        {


            string SQL = "usp_EntityEmailAddressUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@Domain", Domain);
                SqlParameter p2 = new SqlParameter("@Address", Address);
                SqlParameter p3 = new SqlParameter("@LinkID", LinkID);
                SqlParameter p4 = new SqlParameter("@ModifiedBy", ModifiedBy);
                SqlParameter p5 = new SqlParameter("@Tag", Tag);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet GetEmailAddress(int LinkID)
        {


            string SQL = "usp_EntityEmailAddressGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@LinkID", LinkID);
                da.SelectCommand.Parameters.Add(p1);

                da.Fill(ds);
            }

            return ds;
        }
        public static DataSet GetEmailAddressByEntityID(int EntityID)
        {


            string SQL = "usp_EntityEmailAddressGetByEntityID";
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
    }
}

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class GeographicalAddressSql
    {
        //TODO:add code to retrieve multiple addresses by entityID

        public static DataSet USAddressInsert(int EntityID, string Street, string CityName, string stateCode, string zipcode, int createdBy, string tag)
        {


            string SQL = "usp_EntityAddressInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p1 = new SqlParameter("@Street", Street);
                SqlParameter p2 = new SqlParameter("@CityName", CityName);
                SqlParameter p3 = new SqlParameter("@ProvinceCode", stateCode);
                SqlParameter p4 = new SqlParameter("@PostalCode", zipcode);
                SqlParameter p5 = new SqlParameter("@CountryName", "USA");
                SqlParameter p6 = new SqlParameter("@CreatedBy", createdBy);
                SqlParameter p7 = new SqlParameter("@Tag", tag);



                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                da.SelectCommand.Parameters.Add(p7);


                da.Fill(ds);
            }
            return ds;

        }

        public static DataSet USAddressUpdate(int LinkID, int EntityID, string Street, string CityName, string stateCode, string zipcode, int modifiedBy, string tag)
        {


            string SQL = "usp_EntityAddressUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p1 = new SqlParameter("@Street", Street);
                SqlParameter p2 = new SqlParameter("@CityName", CityName);
                SqlParameter p3 = new SqlParameter("@ProvinceCode", stateCode);
                SqlParameter p4 = new SqlParameter("@PostalCode", zipcode);
                SqlParameter p5 = new SqlParameter("@CountryName", "");
                SqlParameter p6 = new SqlParameter("@ModifiedBy", modifiedBy);
                SqlParameter p7 = new SqlParameter("@LinkID", LinkID);
                SqlParameter p8 = new SqlParameter("@Tag", tag);


                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                da.SelectCommand.Parameters.Add(p7);
                da.SelectCommand.Parameters.Add(p8);


                da.Fill(ds);
            }
            return ds;

        }

        public static DataSet USAddressGet(int LinkID)
        {


            string SQL = "usp_EntityAddressGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@LinkID", LinkID);
                da.SelectCommand.Parameters.Add(p0);
                da.Fill(ds);
            }
            return ds;

        }

        public static DataSet USAddressGetByEntityID(int EntityID)
        {


            string SQL = "usp_EntityAddressGetByEntityID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", EntityID);
                da.SelectCommand.Parameters.Add(p0);
                da.Fill(ds);
            }
            return ds;

        }
        

    }
}

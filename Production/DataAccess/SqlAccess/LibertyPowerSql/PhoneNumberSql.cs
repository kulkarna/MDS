using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class PhoneNumberSql
    {

        public static DataSet CreatePhoneNumber(string CountryCode, string CountryPrefix, string areaCode, string number, int PhoneTypeValue, int EntityID, int CreatedBy, string tag)
        {


            string SQL = "usp_EntityPhoneNumberInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@CountryPrefix", CountryPrefix);
                SqlParameter p1 = new SqlParameter("@AreaCode", areaCode);
                SqlParameter p2 = new SqlParameter("@Number", number);
                SqlParameter p3 = new SqlParameter("@PhoneType", PhoneTypeValue);
                SqlParameter p4 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p5 = new SqlParameter("@CountryCode", CountryCode);
                SqlParameter p6 = new SqlParameter("@CreatedBy", CreatedBy);
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


        public static DataSet UpdatePhoneNumber(int LinkID, string CountryCode, string CountryPrefix, string areaCode, string number, int PhoneTypeValue, int ModifiedBy, string Tag)
        {


            string SQL = "usp_EntityPhoneNumberUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@CountryPrefix", CountryPrefix);
                SqlParameter p1 = new SqlParameter("@AreaCode", areaCode);
                SqlParameter p2 = new SqlParameter("@Number", number);
                SqlParameter p3 = new SqlParameter("@PhoneType", PhoneTypeValue);
                SqlParameter p4 = new SqlParameter("@CountryCode", CountryCode);
                SqlParameter p5 = new SqlParameter("@LinkID", LinkID);
                SqlParameter p6 = new SqlParameter("@ModifiedBy", ModifiedBy);
                SqlParameter p7 = new SqlParameter("@Tag", Tag);
               

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

        public static DataSet GetPhoneNumber(int LinkID)
        {


            string SQL = "usp_EntityPhoneNumberGet";
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
        public static DataSet GetPhoneNumberByEntityID(int EntityID)
        {


            string SQL = "usp_EntityPhoneNumberGetByEntityID";
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

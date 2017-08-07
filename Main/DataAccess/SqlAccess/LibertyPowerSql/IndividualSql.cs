using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class IndividualSql
    {
        public static DataSet CreateIndividual(string Firstname,
                             string Lastname, char? MiddleInitial, string MiddleName,
                             string SocialSecurityNumber, string Title,
                            int CreatedBy, string Tag,DateTime? BirthDate)
        {

            string SQL = "usp_EntityIndividualInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
			{


				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter("@EntityType", "I");
				SqlParameter p1 = new SqlParameter("@FirstName", Firstname == null ? DBNull.Value : (object)Firstname);
				SqlParameter p2 = new SqlParameter("@LastName", Lastname == null ? DBNull.Value : (object)Lastname);
				SqlParameter p3 = new SqlParameter("@MiddleName", MiddleName == null ? DBNull.Value : (object)MiddleName);
				SqlParameter p4 = new SqlParameter("@MiddleInitial", MiddleInitial == null ? DBNull.Value : (object)MiddleInitial);
				SqlParameter p5 = new SqlParameter("@Title", Title == null ? DBNull.Value : (object)Title);
				SqlParameter p6 = new SqlParameter("@SocialSecurityNumber", SocialSecurityNumber == null ? DBNull.Value : (object)SocialSecurityNumber);
				SqlParameter p7 = new SqlParameter("@CreatedBy", CreatedBy);
				SqlParameter p8 = new SqlParameter("@Tag", Tag == null ? DBNull.Value : (object)Tag);
				SqlParameter p9 = new SqlParameter("@BirthDate", BirthDate == null ? DBNull.Value : (object)BirthDate);

				da.SelectCommand.Parameters.Add(p0);
				da.SelectCommand.Parameters.Add(p1);
				da.SelectCommand.Parameters.Add(p2);
				da.SelectCommand.Parameters.Add(p3);
				da.SelectCommand.Parameters.Add(p4);
				da.SelectCommand.Parameters.Add(p5);
				da.SelectCommand.Parameters.Add(p6);
				da.SelectCommand.Parameters.Add(p7);
				da.SelectCommand.Parameters.Add(p8);
				da.SelectCommand.Parameters.Add(p9);

				da.Fill(ds);
			}



            return ds;

        }

        public static DataSet GetIndividual(int entityID)
        {
            string SQL = "usp_EntityIndividualGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", entityID);
                da.SelectCommand.Parameters.Add(p0);
                da.Fill(ds);
            }
            return ds;

        }
        public static DataSet UpdateIndividual(int entityID, string Firstname,
                            string Lastname, char? MiddleInitial, string MiddleName,
                            string SocialSecurityNumber, string Title, int ModifiedBy,
                            string Tag,DateTime? BirthDate)
        {
            string SQL = "usp_EntityIndividualUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                

                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p0 = new SqlParameter("@EntityID", entityID);
                SqlParameter p1 = new SqlParameter("@FirstName", Firstname);
                SqlParameter p2 = new SqlParameter("@LastName", Lastname);
                SqlParameter p3 = new SqlParameter("@MiddleName", MiddleName);
                SqlParameter p4 = new SqlParameter("@MiddleInitial", MiddleInitial == null ? DBNull.Value : (object)MiddleInitial);
                SqlParameter p5 = new SqlParameter("@Title", Title);
                SqlParameter p6 = new SqlParameter("@SocialSecurityNumber", SocialSecurityNumber);
                SqlParameter p7 = new SqlParameter("@ModifiedBy", ModifiedBy);
                SqlParameter p8 = new SqlParameter("@Tag", Tag);
                SqlParameter p9 = new SqlParameter("@BirthDate", BirthDate == null ? DBNull.Value : (object)BirthDate);

                da.SelectCommand.Parameters.Add(p0);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.SelectCommand.Parameters.Add(p6);
                da.SelectCommand.Parameters.Add(p7);
                da.SelectCommand.Parameters.Add(p8);
                da.SelectCommand.Parameters.Add(p9);

                da.Fill(ds);
            }
            return ds;

        }
    }


}

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class EmailTemplateSql
    {

        public static DataSet GetEmailTemplateByCode(string code)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_EmailTemplateSelectByCode";

                    command.Parameters.Add(new SqlParameter("Code", code));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }
            return ds;
        }

        public static int InsertEmailTemplate(string code, string description, int fromMailAddressID, string subject, string body, bool isHtml, int userID)
        {
            int emailTemplateID;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_EmailTemplateInsert";

                    command.Parameters.Add(new SqlParameter("Code", code));
                    command.Parameters.Add(new SqlParameter("Description", description));
                    command.Parameters.Add(new SqlParameter("DefaultFromAddressID", fromMailAddressID));
                    command.Parameters.Add(new SqlParameter("Subject", subject));
                    command.Parameters.Add(new SqlParameter("Body", body));
                    command.Parameters.Add(new SqlParameter("IsHtml", isHtml));
                    command.Parameters.Add(new SqlParameter("UserID", userID));

                    connection.Open();
                    emailTemplateID = int.Parse(command.ExecuteScalar().ToString());
                }
            }
            return emailTemplateID;
        }


        public static int UpdateEmailTemplate(int emailTemplateID, string code, string description, int fromMailAddressID, string subject, string body, bool isHtml, int userID)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_EmailTemplateUpdate";

                    command.Parameters.Add(new SqlParameter("EmailTemplateID", emailTemplateID));
                    command.Parameters.Add(new SqlParameter("Code", code));
                    command.Parameters.Add(new SqlParameter("Description", description));
                    command.Parameters.Add(new SqlParameter("DefaultFromAddressID", fromMailAddressID));
                    command.Parameters.Add(new SqlParameter("Subject", subject));
                    command.Parameters.Add(new SqlParameter("Body", body));
                    command.Parameters.Add(new SqlParameter("IsHtml", isHtml));
                    command.Parameters.Add(new SqlParameter("UserID", userID));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            return emailTemplateID;
        }

        public static void DeleteEmailTemplate(int emailTemplateID)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_EmailTemplateDelete";

                    command.Parameters.Add(new SqlParameter("EmailTemplateID", emailTemplateID));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

    }
}

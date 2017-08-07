using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EdiFileRetriever
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Starting application...");

            string connStr = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            string destFolder = ConfigurationManager.AppSettings["DestinationDirectory"];
            string pathColumnName = ConfigurationManager.AppSettings["FullPathColumnName"];
            string strSql = ConfigurationManager.AppSettings["SelectSQL"];

            Console.WriteLine("Executing SQL to fetch list of EDI files.");

            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strSql;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                try
                {
                    string source = (string)row[pathColumnName];
                    string fileName = Path.GetFileName(source);

                    // Extra step to remove the GUID from the front of the file name
                    if (fileName.IndexOf("_") > 0)
                        fileName = fileName.Substring(fileName.IndexOf("_") + 1);

                    string finalPath = Path.Combine(destFolder, fileName);
                    File.Copy(source, finalPath, true);
                    
                }
                catch (Exception ex)
                {
                     Console.WriteLine("Error in getting copying file: " + ex.InnerException);
                }
            }
            Console.WriteLine("Finished");        
        }
    }
}

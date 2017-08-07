using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using BulkAnnualUsageCalculator.UsageSvc;
using System.Configuration;

namespace BulkAnnualUsageCalculator
{
    public class UsageObj
    {
        public int ID;
        public  decimal AnnualUsage;
        public DateTime UsageDate;
    }

    class Program
    {
        static void Main(string[] args)
        {
            UsageSvc.UsageClient uc = new UsageClient();
            UsageSvc.ScraperUsageRequest sr = new ScraperUsageRequest();

            string tableName = ConfigurationManager.AppSettings["TableName"].ToString();

            Console.WriteLine("Starting application");

            string connStr = ConfigurationManager.ConnectionStrings["WSConnectionString"].ConnectionString;
            string strSql = "select id, AccountNumber, UtilityID from " + tableName + " where isnull(ReturnValue, '') = ''";

            List<UsageObj> oList = new List<UsageObj>();

            Console.WriteLine("Obtaining list of accounts from the " + tableName + " table");

            DataSet ds = new DataSet();
            using (SqlConnection conn1 = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn1;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strSql;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            Console.WriteLine("Running scraper for each account");

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                try
                {
                    sr.AccountNumber = (string)row["AccountNumber"];
                    sr.UtilityId = (int)row["UtilityID"];
                    int id = (int)row["ID"];
                    
                    // Invoke the GetAnnualUsage                    
                    //int usage = uc.GetAnnualUsage(ar);
                    string retValue = uc.RunScraper(sr);

                    if (!string.IsNullOrEmpty(retValue))
                    {

                        Console.WriteLine(string.Format("Writing return value from Scraper for: Account: {0}, UtilityId: {1}", sr.AccountNumber, sr.UtilityId));
                        string strUpdSql = string.Format("update " + tableName + " set ReturnValue = {0} where id = {1}", retValue, id);
                        SqlCommand cmdUpd = new SqlCommand(strUpdSql, conn);
                        cmdUpd.ExecuteNonQuery();

                    }
                    
                }
                catch (Exception ex)
                {
                     Console.WriteLine("Error in running scraper: " + ex.InnerException);
                }
            }

            conn.Close();
            conn.Dispose();
            Console.WriteLine("Finished");
        }
    }
}

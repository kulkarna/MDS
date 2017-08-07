using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using BulkAnnualUsageCalculator.AnnUsage;
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
            AnnUsage.UsageClient uc = new UsageClient();
            AnnUsage.AnnualUsageRequest ar = new AnnualUsageRequest();
            AnnUsage.UsageDateRequest udr = new UsageDateRequest();
            //ar.AccountNumber = "2942270881";
            //ar.UtilityId = 13;

            string tableName = ConfigurationManager.AppSettings["TableName"].ToString();

            Console.WriteLine("Starting application");

            string connStr = ConfigurationManager.ConnectionStrings["WSConnectionString"].ConnectionString;
            string strSql = "select id, AccountNumber, UtilityID from " + tableName + " where isnull(annualusage, 0) = 0";

            //Dictionary<int, decimal> au = new Dictionary<int, decimal>();
            //Dictionary<int, DateTime> ad = new Dictionary<int, DateTime>();
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

            Console.WriteLine("Getting annual usage for each account");

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                try
                {
                    ar.AccountNumber = (string)row["AccountNumber"];
                    ar.UtilityId = (int)row["UtilityID"];
                    int id = (int)row["ID"];
                    
                    // Invoke the GetAnnualUsage                    
                    int usage = uc.GetAnnualUsage(ar);

                    udr.AccountNumber = (string)row["AccountNumber"];
                    udr.UtilityId = (int)row["UtilityID"];

                    DateTime dt = uc.GetUsageDate(udr);

                    if (usage >= 0)
                    {
                        //au.Add(id, usage);
                        //ad.Add(id, dt);

                        //UsageObj o = new UsageObj();
                        //o.ID = id;
                        //o.AnnualUsage = usage;
                        //o.UsageDate = dt;

                        //oList.Add(o);

                        Console.WriteLine(string.Format("Writing annual usage for: Account: {0}, UtilityId: {1}", ar.AccountNumber, ar.UtilityId));
                        string strUpdSql = string.Format("update " + tableName + " set AnnualUsage = {0}, UsageDate = '{1}' where id = {2}", usage, dt, id);
                        SqlCommand cmdUpd = new SqlCommand(strUpdSql, conn);
                        cmdUpd.ExecuteNonQuery();

                    }
                    
                }
                catch (Exception ex)
                {
                     Console.WriteLine("Error in getting annual usage: " + ex.InnerException);
                }
            }

            conn.Close();
            conn.Dispose();

            //Console.WriteLine("Writing annual usage back to the AbhiCalcAnnualUsage table");

            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            //    conn.Open();

            //    try
            //    {
            //        //foreach (KeyValuePair<int, decimal> entry in au)
            //        foreach (UsageObj obj in oList)
            //        {
            //            string strUpdSql = string.Format("update AbhiCalcAnnualUsage set AnnualUsage = {0}, UsageDate = '{1}' where id = {2}", obj.AnnualUsage, obj.UsageDate, obj.ID);
            //            SqlCommand cmd = new SqlCommand(strUpdSql, conn);
            //            cmd.ExecuteNonQuery();
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        Console.WriteLine("Error in writing annual usage: " + ex.InnerException);
            //    }
            //}

            Console.WriteLine("Finished");
        }
    }
}

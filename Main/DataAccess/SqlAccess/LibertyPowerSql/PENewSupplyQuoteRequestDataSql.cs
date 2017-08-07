using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
   [Serializable]
	public static class PENewSupplyQuoteRequestDataSql
   {

       /// <summary>
       /// Selects a NewSupplyQuoteRequestData
       /// </summary>
       /// <param name=NewSupplyQuoteRequestDataId></param>
       /// <returns>A dataset with all attributes</returns>
       public static DataSet SelectNewSupplyQuoteRequestData(Int32 newSupplyQuoteRequestDataId, String marketZone, DateTime flowStart, Int32 term, Int32 month, DateTime date, Decimal peakMw, Decimal offPeakMw, Decimal aveP1, Decimal aveOp1, Decimal aveP4, Decimal aveOp4  )       {
           DataSet ds = new DataSet();
           using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
           {
               using (SqlCommand cmd = new SqlCommand())
               {
                   cmd.Connection = conn;
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.CommandText = "usp_PENewSupplyQuoteRequestDataSelect";

                   cmd.Parameters.Add(new SqlParameter("@NewSupplyQuoteRequestDataId", newSupplyQuoteRequestDataId));
                   cmd.Parameters.Add(new SqlParameter("@MarketZone", marketZone));
                   cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                   cmd.Parameters.Add(new SqlParameter("@Term", term));
                   cmd.Parameters.Add(new SqlParameter("@Month", month));
                   cmd.Parameters.Add(new SqlParameter("@Date", date));
                   cmd.Parameters.Add(new SqlParameter("@PeakMw", peakMw));
                   cmd.Parameters.Add(new SqlParameter("@OffPeakMw", offPeakMw));
                   cmd.Parameters.Add(new SqlParameter("@AveP1", aveP1));
                   cmd.Parameters.Add(new SqlParameter("@AveOp1", aveOp1));
                   cmd.Parameters.Add(new SqlParameter("@AveP4", aveP4));
                   cmd.Parameters.Add(new SqlParameter("@AveOp4", aveOp4));
                    

                   using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                   {
                       da.Fill(ds);
                   }
               }
       }
       return ds;
   }
       /// <summary>
       /// Inserts a NewSupplyQuoteRequestData
       /// </summary>
       /// <param name=NewSupplyQuoteRequestData></param>
       public static int InsertNewSupplyQuoteRequestData(String marketZone, DateTime flowStart, Int32 term, Int32 month, DateTime date, Decimal peakMw, Decimal offPeakMw, Decimal aveP1, Decimal aveOp1, Decimal aveP4, Decimal aveOp4  )       {
           DataSet ds = new DataSet();
           using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
       	{
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "usp_PENewSupplyQuoteRequestDataInsert";

                cmd.Parameters.Add(new SqlParameter("@MarketZone", marketZone));
                cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                cmd.Parameters.Add(new SqlParameter("@Term", term));
                cmd.Parameters.Add(new SqlParameter("@Month", month));
                cmd.Parameters.Add(new SqlParameter("@Date", date));
                cmd.Parameters.Add(new SqlParameter("@PeakMw", peakMw));
                cmd.Parameters.Add(new SqlParameter("@OffPeakMw", offPeakMw));
                cmd.Parameters.Add(new SqlParameter("@AveP1", aveP1));
                cmd.Parameters.Add(new SqlParameter("@AveOp1", aveOp1));
                cmd.Parameters.Add(new SqlParameter("@AveP4", aveP4));
                cmd.Parameters.Add(new SqlParameter("@AveOp4", aveOp4));
                 
                conn.Open();
                return Convert.ToInt32( cmd.ExecuteScalar() );

            }
           }
       }
   }
}


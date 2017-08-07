using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
  public static  class ResourceIdentifierSql
    {
      public static DataSet SaveEntityResourceIdentifier(int EntityID, string Address,int CreatedBy, string Tag) {
          string SQL = "usp_EntityResourceIdentifierInsert";
          string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
          DataSet ds = new DataSet();
          using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
          {
              da.SelectCommand.CommandType = CommandType.StoredProcedure;
              SqlParameter p0 = new SqlParameter("@EntityID", EntityID);
              SqlParameter p1 = new SqlParameter("@Address", Address);
              SqlParameter p2 = new SqlParameter("@CreatedBy", CreatedBy);
              SqlParameter p3 = new SqlParameter("@Tag", Tag);

              
              da.SelectCommand.Parameters.Add(p0);
              da.SelectCommand.Parameters.Add(p1);
              da.SelectCommand.Parameters.Add(p2);
              da.SelectCommand.Parameters.Add(p3);
              da.Fill(ds);
          }
          return ds;
      }

      public static DataSet UpdateEntityResourceIdentifier(int linkID, string Address, int ModifiedBy, string Tag)
      {
          string SQL = "usp_EntityResourceIdentifierUpdate";
          string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
          DataSet ds = new DataSet();
          using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
          {
              da.SelectCommand.CommandType = CommandType.StoredProcedure;
              SqlParameter p0 = new SqlParameter("@LinkID", linkID);
              SqlParameter p1 = new SqlParameter("@Address", Address);
              SqlParameter p2 = new SqlParameter("@ModifiedBy", ModifiedBy);
              SqlParameter p3 = new SqlParameter("@Tag", Tag);
              
              
              da.SelectCommand.Parameters.Add(p0);
              da.SelectCommand.Parameters.Add(p1);
              da.SelectCommand.Parameters.Add(p2);
              da.SelectCommand.Parameters.Add(p3);
              da.Fill(ds);
          }
          return ds;
      }

      public static DataSet GetEntityResourceIdentifier(int LinkID)
      {


          string SQL = "usp_EntityResourceIdentifierGet";
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
      public static DataSet GetEntityResourceIdentifierByEntityID(int EntityID)
      {


          string SQL = "usp_EntityResourceIdentifierGetByEntityID";
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

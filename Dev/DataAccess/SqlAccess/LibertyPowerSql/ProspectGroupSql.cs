using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class ProspectGroupSql
    {
        
        public static DataSet GetProspectOrganization(int ProspectID)
        {

            string SQL = "usp_ProspectOrganizationGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }
        public static DataSet InsertProspectGroup(int ProspectID, int ParentID, int EntityID)
        {


            string SQL = "usp_ProspectGroupInsert";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p2 = new SqlParameter("@ParentID", ParentID);
                SqlParameter p3 = new SqlParameter("@EntityID", EntityID);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);

                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet GetProspectGroup(int ProspectID)
        {

            string SQL = "usp_ProspectGroupGet";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet AddEntityToProspectGroup(int ProspectID, int EntityID)
        {

            string SQL = "usp_ProspectGroupAddChildToRoot";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ProspectID", ProspectID);
                SqlParameter p2 = new SqlParameter("@EntityID", EntityID);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);

                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet AddChildToEntityNode(int ParentID, int EntityID)
        {

            string SQL = "usp_ProspectGroupAddChildToNode";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p2 = new SqlParameter("@ParentID", ParentID);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);


                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet RemoveProspectGroupNode(int ProspectID, int EntityID)
        {

            string SQL = "usp_ProspectGroupRemoveNode";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p2 = new SqlParameter("@ProspectID", ProspectID);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);

                da.Fill(ds);


            }

            return ds;
        }
        public static DataSet MoveProspectGroupNode(int EntityID, int NewParentID)
        {

            string SQL = "usp_ProspectGroupMoveNode";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@EntityID", EntityID);
                SqlParameter p2 = new SqlParameter("@NewParentID", NewParentID);

                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);

                da.Fill(ds);


            }

            return ds;
        }

    }

}

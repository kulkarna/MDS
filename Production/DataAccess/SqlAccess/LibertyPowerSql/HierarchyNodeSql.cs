using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class HierarchyNodeSql
	{
		private static string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
		/// <summary>
		/// Gets the Node.
		/// </summary>
		/// <param name="nodeId">The node id.</param>
		/// <returns></returns>
		public static DataSet GetByNodeId(int nodeId)
		{
			//string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			string sqlString = "usp_HierarchyNodeGetByNodeId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@NodeId", SqlDbType.Int).Value = nodeId;

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Gets the Root Node by hierarchyTemplateId.
		/// </summary>
		/// <param name="hierarchyTemplateId">HierarchyTemplateId</param>
		/// <returns></returns>
		public static DataSet GetRootByHierarchyTemplateId(int hierarchyTemplateId)
		{
			//string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			string sqlString = "usp_HierarchyNodeGetRootByHierarchyTemplateId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;

				da.Fill(ds);
			}
			return ds;
		}

		public static DataSet GetByValueAndHierarchyTemplateId(string nodeValue, int hierarchyTemplateId)
		{
			//string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			string sqlString = "usp_HierarchyNodeGetByValueAndHierarchyTemplateId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@NodeValue", SqlDbType.NVarChar).Value = nodeValue;
				da.SelectCommand.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Gets Nodes by parent node id.
		/// </summary>
		/// <param name="parentNodeId">The parent node id.</param>
		/// <returns></returns>
		public static DataSet GetByParentId(int parentId)
		{
			string sqlString = "usp_HierarchyNodeGetByParentId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@ParentNodeId", SqlDbType.Int).Value = parentId;

				da.Fill(ds);
			}
			return ds;
		}

		public static DataSet GetByNodeLevelId(int nodeLevelId)
		{
			string sqlString = "usp_HierarchyNodeGetByNodeLevelId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@NodeLevelId", SqlDbType.Int).Value = nodeLevelId;

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Get Nodes by hierarchyTemplateId.
		/// </summary>
		/// <param name="hierarchyTemplateId">hierarchyTemplateId</param>
		/// <returns></returns>
		public static DataSet GetByHierarchyTemplateId(int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyNodeGetByHierarchyTemplateId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;

				da.Fill(ds);
			}
			return ds;
		}
		/// <summary>
		/// Inserts the node.
		/// </summary>
		/// <param name="nodeLevelId">The node level id.</param>
		/// <param name="parentId">The parent id.</param>
		/// <param name="value">The value.</param>
		/// <param name="description">The description.</param>
		/// <returns>The new record's NodeId </returns>
		public static int Insert(int nodeLevelId, int parentId, string value, string description)
		{
			int newNodeId = -1;
			string sqlString = "usp_HierarchyNodeInsert";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeLevelId", SqlDbType.Int).Value = nodeLevelId;
				cmd.Parameters.Add("@ParentId", SqlDbType.Int).Value = parentId;
				cmd.Parameters.Add("@Value", SqlDbType.NVarChar).Value = value;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = (description != null) ? (object)description : (object)DBNull.Value;

				conn.Open();
				int.TryParse(cmd.ExecuteScalar().ToString(), out newNodeId);
				conn.Close();
			}
			return newNodeId;
		}

		/// <summary>
		/// Updates the Node
		/// </summary>
		/// <param name="nodeId">The node id.</param>
		/// <param name="nodeLevelId">The node level id.</param>
		/// <param name="parentId">The parent id.</param>
		/// <param name="value">The value.</param>
		/// <param name="description">The description.</param>
		public static void Update(int nodeId, int nodeLevelId, int parentId, string value, string description)
		{
			string sqlString = "usp_HierarchyNodeUpdate";
			//string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeId", SqlDbType.Int).Value = nodeId;
				cmd.Parameters.Add("@NodeLevelId", SqlDbType.Int).Value = nodeLevelId;
				cmd.Parameters.Add("@ParentId", SqlDbType.Int).Value = parentId;
				cmd.Parameters.Add("@Value", SqlDbType.NVarChar).Value = value;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = description;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}

		public static void DeleteByNodeId(int nodeId)
		{
			string sqlString = "usp_HierarchyNodeDelete";
			//string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeId", SqlDbType.Int).Value = nodeId;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}
	}
}

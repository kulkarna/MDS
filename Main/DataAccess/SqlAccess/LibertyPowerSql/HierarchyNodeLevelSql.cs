using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class HierarchyNodeLevelSql
	{
		private static string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;

		/// <summary>
		/// Gets the NodeLevel.
		/// </summary>
		/// <param name="nodeId">NodeLevelId.</param>
		/// <returns></returns>
		public static DataSet GetByNodeLevelId(int nodeLevelId)
		{
			string sqlString = "usp_HierarchyNodeLevelGetByNodeLevelId";
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
		/// Gets Nodes by parent node id.
		/// </summary>
		/// <param name="parentNodeId">ParentId.</param>
		/// <returns></returns>
		public static DataSet GetByParentId(int parentId)
		{
			string sqlString = "usp_HierarchyNodeLevelGetByParentId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@ParentNodeId", SqlDbType.Int).Value = parentId;

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Gets all.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetAll()
		{
			string sqlString = "usp_HierarchyNodeLevelGetAll";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				da.Fill(ds);
			}
			return ds;
		}
		/// <summary>
		/// Gets Nodes by template id.
		/// </summary>
		/// <param name="hierarchyTemplateId">templateId.</param>
		/// <returns></returns>
		public static DataSet GetByHierarchyTemplateId(int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyNodeLevelGetByHierarchyTemplateId";
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
		/// Gets the root NodeLevel by HierarchyTemplateId.
		/// </summary>
		/// <param name="hierarchyTemplateId">hierarchyTemplateId</param>
		/// <returns></returns>
		public static DataSet GetRootByHierarchyTemplateId(int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyNodeLevelRootGetByHierarchyTemplateId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;

				da.Fill(ds);
			}
			return ds;
		}

		public static DataSet GetByNameAndHierarchyTemplateId(string nodeLevelName, int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyNodeLevelGetByNameAndHierarchyTemplateId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;
				da.SelectCommand.Parameters.Add("@NodeLevel", SqlDbType.NVarChar).Value = nodeLevelName;

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Inserts the NodeLevel.
		/// </summary>
		/// <param name="hierarchyTemplateId">The template id.</param>
		/// <param name="parentId">The parent id.</param>
		/// <param name="nodeTypeId">The node type id.</param>
		/// <param name="nodeName">Name of the node.</param>
		/// <param name="nodeLookupId">The node lookup id.</param>
		/// <returns>The new record's NodeLevelId </returns>
		public static int Insert(int hierarchyTemplateId, int parentId, int nodeTypeId, string nodeLevelName, int? nodeLookupId)
		{
			int newNodeLevelId = -1;

			string sqlString = "usp_HierarchyNodeLevelInsert";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;
				cmd.Parameters.Add("@ParentId", SqlDbType.Int).Value = parentId;
				cmd.Parameters.Add("@NodeTypeId", SqlDbType.Int).Value = nodeTypeId;
				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = nodeLevelName;
				if (nodeLookupId != null)
					cmd.Parameters.Add("@NodeLookupId", SqlDbType.Int).Value = nodeLookupId;

				conn.Open();
				int.TryParse(cmd.ExecuteScalar().ToString(), out newNodeLevelId);
				conn.Close();
			}
			return newNodeLevelId;
		}

		/// <summary>
		/// Updates the NodeLevel.
		/// </summary>
		/// <param name="nodeLevelId">The node level id.</param>
		/// <param name="hierarchyTemplateId">The template id.</param>
		/// <param name="parentId">The parent id.</param>
		/// <param name="nodeTypeId">The node type id.</param>
		/// <param name="nodeName">Name of the node.</param>
		/// <param name="nodeLookupId">The node lookup id.</param>
		public static void Update(int nodeLevelId, int hierarchyTemplateId, int parentId, int nodeTypeId, string nodeName, int? nodeLookupId)
		{
			string sqlString = "usp_HierarchyNodeLevelUpdate";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeLevelId", SqlDbType.Int).Value = nodeLevelId;
				cmd.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;
				cmd.Parameters.Add("@ParentId", SqlDbType.Int).Value = parentId;
				cmd.Parameters.Add("@NodeTypeId", SqlDbType.Int).Value = nodeTypeId;
				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = nodeName;
				if (nodeLookupId != null)
					cmd.Parameters.Add("@NodeLookupId", SqlDbType.Int).Value = nodeLookupId;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}

		public static void Delete(int nodeLevelId)
		{
			string sqlString = "usp_HierarchyNodeLevelDelete";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeLevelId", SqlDbType.Int).Value = nodeLevelId;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}

		}
	}
}

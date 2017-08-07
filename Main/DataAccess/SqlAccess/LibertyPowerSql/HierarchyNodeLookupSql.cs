using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class HierarchyNodeLookupSql
	{
		private static string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;

		/// <summary>
		/// Gets the by node lookup id.
		/// </summary>
		/// <param name="nodeLookupId">NodeLookupId.</param>
		/// <returns></returns>
		public static DataSet GetByNodeLookupId(int nodeLookupId)
		{
			string sqlString = "usp_HierarchyNodeLookupGetByNodeLookupId";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add("@NodeLookupId", SqlDbType.Int).Value = nodeLookupId;

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
			string sqlString = "usp_HierarchyNodeLookupGetAll";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				da.Fill(ds);
			}
			return ds;
		}

		public static DataSet GetLookupValues(string lookupQuery)
		{
			string sqlString = lookupQuery;
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.Text;
				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Inserts a new record.
		/// </summary>
		/// <param name="name">The name.</param>
		/// <param name="description">The description.</param>
		/// <param name="lookupQuery">The lookup query.</param>
		/// <returns>The new record's NodeLookupId </returns>
		public static int Insert(string name, string description, string lookupQuery)
		{
			int newNodeLookupId = -1;

			string sqlString = "usp_HierarchyNodeLookupInsert";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = description;
				cmd.Parameters.Add("@LookupQuery", SqlDbType.VarChar).Value = lookupQuery;

				conn.Open();
				int.TryParse(cmd.ExecuteScalar().ToString(), out newNodeLookupId);
				conn.Close();
			}
			return newNodeLookupId;
		}

		/// <summary>
		/// Updates the specified record
		/// </summary>
		/// <param name="nodeLookupId">The node lookup id.</param>
		/// <param name="name">The name.</param>
		/// <param name="description">The description.</param>
		/// <param name="lookupQuery">The lookup query.</param>
		public static void Update(int nodeLookupId, string name, string description, string lookupQuery)
		{
			string sqlString = "usp_HierarchyNodeLookupUpdate";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@NodeLookupId", SqlDbType.Int).Value = nodeLookupId;
				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = description;
				cmd.Parameters.Add("@LookupQuery", SqlDbType.VarChar).Value = lookupQuery;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}
	}
}

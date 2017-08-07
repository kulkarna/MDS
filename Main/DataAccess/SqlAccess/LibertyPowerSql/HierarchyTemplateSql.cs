using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class HierarchyTemplateSql
	{
		private static string HierarchyConnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;

		/// <summary>
		/// Gets the HierarchyTemplate.
		/// </summary>
		/// <param name="hierarchyTemplateId">The HierarchyTemplate id.</param>
		/// <returns></returns>
		public static DataSet GetHierarchyTemplate(int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyTemplateGetByTemplateId";
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
		/// Gets all.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetAll()
		{
			string sqlString = "usp_HierarchyTemplateGetAll";
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(sqlString, HierarchyConnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Inserts the HierarchyTemplate.
		/// </summary>
		/// <param name="name">The name.</param>
		/// <param name="description">The description.</param>
		/// <returns>The new record's HierarchyTemplateId </returns>
		public static int Insert(string name, string description)
		{
			int newHierarchyTemplateId = -1;

			string sqlString = "usp_HierarchyTemplateInsert";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;

				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = description;

				conn.Open();
				int.TryParse(cmd.ExecuteScalar().ToString(), out newHierarchyTemplateId);
				conn.Close();
			}
			return newHierarchyTemplateId;
		}

		/// <summary>
		/// Updates the HierarchyTemplate.
		/// </summary>
		/// <param name="templateId">The template id.</param>
		/// <param name="name">The name.</param>
		/// <param name="description">The description.</param>
		public static void Update(int hierarchyTemplateId, string name, string description)
		{
			string sqlString = "usp_HierarchyTemplateUpdate";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;
				cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
				cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = description;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}

		/// <summary>
		/// Deletes the specified HierarchyTemplate.
		/// </summary>
		/// <param name="hierarchyTemplateId">The hierarchy template id.</param>
		public static void Delete(int hierarchyTemplateId)
		{
			string sqlString = "usp_HierarchyTemplateDelete";
			using (SqlConnection conn = new SqlConnection(HierarchyConnString))
			{
				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlString;
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Connection = conn;
				cmd.Parameters.Add("@HierarchyTemplateId", SqlDbType.Int).Value = hierarchyTemplateId;

				conn.Open();
				cmd.ExecuteNonQuery();
				conn.Close();
			}
		}
	}
}

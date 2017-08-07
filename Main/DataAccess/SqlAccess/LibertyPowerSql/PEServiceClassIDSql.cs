using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEServiceClassIDSql
    {

        /// <summary>
        /// Selects a ServiceClassID
        /// </summary>
        /// <param name=ServiceClassIDId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectServiceClassID( int serviceClassIDId )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEServiceClassIDSelect";

                    cmd.Parameters.Add(new SqlParameter("@ServiceClassIDId", serviceClassIDId));
                    
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

		/// <summary>
		/// Selects a list of ServiceClassID
		/// </summary>
		/// <param name=ServiceClassIDId></param>
		/// <returns>A dataset with all attributes</returns>
		public static DataSet SelectServiceClassIdList()
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEServiceClassIdSelectList";						

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}
        /// <summary>
        /// Inserts a ServiceClassID
        /// </summary>
        /// <param name=ServiceClassID></param>
        public static int InsertServiceClassID( string serviceClassIdentifier, string utilityCode, string serviceClass, char activeFlag )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEServiceClassIDInsert";

                    cmd.Parameters.Add( new SqlParameter( "@ServiceClassIdentifier", serviceClassIdentifier ) );
                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@ServiceClass", serviceClass ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        public static DataSet SelectServiceClassList(string utilityDescription) 
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEServiceClassSelectList";

                    cmd.Parameters.Add( new SqlParameter( "@utilityId", utilityDescription ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }


        public static void UpdateServiceClass( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEServiceClassIdUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@ServiceClassIDId", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }


		/// <summary>
		/// Selects Service Class ID based on Service Class Identifier.
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <returns>Returns a dataset containing the Service Class ID based on Service Class Identifier.</returns>
		public static DataSet SelectServiceClassID( string serviceClassIdentifier )
		{
			DataSet ds = new DataSet();

			using(SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEServiceClassIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@ServiceClassIdentifier", serviceClassIdentifier ) );

					using(SqlDataAdapter da = new SqlDataAdapter( cmd ))
						da.Fill( ds );
				}
			}
			return ds;
		}
    }
}


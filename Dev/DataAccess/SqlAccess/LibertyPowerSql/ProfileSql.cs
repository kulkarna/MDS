using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Handles profile related data
	/// </summary>
	public static class ProfileSql
	{
		/// <summary>
		/// Inserts profile header data
		/// </summary>
		/// <param name="iso">ISO or market identifier</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="loadShapeId">Load shape ID for utility</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="fileName">File name that data is extracted from</param>
		/// <param name="createdBy">User</param>
		/// <returns>ID used for relationship in DailyProfileDetail</returns>
		public static Int64 InsertDailyProfileHeader( string iso, string utilityCode, 
			string loadShapeId, string zone, string fileName, string createdBy )
		{
			Int64 dailyProfileId = 0;

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyProfileHeaderInsert";

					SqlParameter Id = new SqlParameter( "@DailyProfileId", SqlDbType.BigInt );
					Id.Direction = ParameterDirection.Output;
					Id.Value = 0;

					cmd.Parameters.Add( new SqlParameter( "ISO", iso.Trim().ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode.Trim().ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "LoadShapeID", loadShapeId.Trim().ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "Zone", zone.Trim().ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "FileName", fileName.Trim().ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "CreatedBy", createdBy.Trim().ToUpper() ) );
					cmd.Parameters.Add( Id );

					conn.Open();
					cmd.ExecuteNonQuery();

					dailyProfileId = Convert.ToInt64( Id.Value );
				}
			}
			return dailyProfileId;
		}

		/// <summary>
		/// Inserts profile detail data
		/// </summary>
		/// <param name="dailyProfileId">Profile ID associated with header record</param>
		/// <param name="dateProfile">Date of profile</param>
		/// <param name="peakValue">Peak Value</param>
		/// <param name="offPeakValue">Off peak Value</param>
		/// <param name="dailyValue">Daily value</param>
		/// <param name="peakRatio">Peak Value percentage</param>
		public static void InsertDailyProfileDetail( Int64 dailyProfileId, DateTime dateProfile,
			decimal peakValue, decimal offPeakValue, decimal dailyValue, decimal peakRatio )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyProfileDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "DailyProfileId", dailyProfileId ) );
					cmd.Parameters.Add( new SqlParameter( "DateProfile", dateProfile ) );
					cmd.Parameters.Add( new SqlParameter( "PeakValue", peakValue ) );
					cmd.Parameters.Add( new SqlParameter( "OffPeakValue", offPeakValue ) );
					cmd.Parameters.Add( new SqlParameter( "DailyValue", dailyValue ) );
					cmd.Parameters.Add( new SqlParameter( "PeakRatio", peakRatio ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Selects profile data for specified date range
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="loadShapeId">Load shape ID for utility</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="beginDate">Begin date of profiles requested</param>
		/// <param name="endDate">End date of profiles requested</param>
		/// <returns>DataSet containing daily profiles for specified date range</returns>
		public static DataSet SelectDailyProfile( string utilityCode,
			string loadShapeId, string zone, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyProfileSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "LoadShapeID", loadShapeId ) );
					cmd.Parameters.Add( new SqlParameter( "Zone", zone ) );
					cmd.Parameters.Add( new SqlParameter( "BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertOfferIntoProfilingQueue(string offerID, string owner)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueInsert";

					cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
					cmd.Parameters.Add(new SqlParameter("Owner", owner));

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}
		
		public static DataSet RetrieveProfilingQueue()
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueSelect";

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateProfilingQueueStatus(int queueID, int status, string user)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueStatusUpdate";

					cmd.Parameters.Add(new SqlParameter("QueueID", queueID));
					cmd.Parameters.Add(new SqlParameter("QueueStatus", status));
					cmd.Parameters.Add(new SqlParameter("User", user));

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		public static void UpdateProfilingQueueDecrementRemainingProgress(int queueID)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueDecrementRemainingProgressUpdate";
					cmd.Parameters.Add(new SqlParameter("QueueID", queueID));
					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet UpdateProfilingQueueProgress(int queueID, int numberOfAccountsTotal, int numberOfAccountsRemaining)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueProgressUpdate";

					cmd.Parameters.Add(new SqlParameter("QueueID", queueID));
					cmd.Parameters.Add(new SqlParameter("NumberOfAccountsTotal", numberOfAccountsTotal));
					cmd.Parameters.Add(new SqlParameter("NumberOfAccountsRemaining", numberOfAccountsRemaining));

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateProfilingQueueStatus(int queueID, int status, string user, string result)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingQueueStatusUpdate";

					cmd.Parameters.Add(new SqlParameter("QueueID", queueID));
					cmd.Parameters.Add(new SqlParameter("QueueStatus", status));
					cmd.Parameters.Add(new SqlParameter("User", user));
					cmd.Parameters.Add(new SqlParameter("ResultOutput", result));

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateProfileQueueHedgeBlock(int queueID, string hedgeBlockFileName, string hedgeBlockContents )
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingHedgeBlockInsert";

					cmd.Parameters.Add(new SqlParameter("@ProfilingQueueID", queueID));
					cmd.Parameters.Add(new SqlParameter("@HedgeBlockFileName", hedgeBlockFileName));
					cmd.Parameters.Add(new SqlParameter("@HedgeBlockContents", hedgeBlockContents));

					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		public static DataSet RetrieveHedgeBlocks(int queueID)
		{
			var ds = new DataSet();

			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProfilingHedgeBlockSelect";
					cmd.Parameters.Add(new SqlParameter("ProfilingQueueID", queueID));
					using (var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}
	}
}

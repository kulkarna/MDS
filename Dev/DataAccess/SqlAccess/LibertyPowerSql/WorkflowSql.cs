using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class WorkflowSql
	{
		#region Workflow methods
		public static DataSet GetWorkflow( int WorkflowID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", WorkflowID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetWorkflows()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetWorkflowByTaskID( int? WorkflowTaskID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static void UpdateWorkflow( int WorkflowID, string Name, string Description, bool IsActive, string Version, bool IsRevisionOfRecord, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", WorkflowID ) );
					cmd.Parameters.Add( new SqlParameter( "@Name", Name ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", Description ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", IsActive ) );
					cmd.Parameters.Add( new SqlParameter( "@Version", Version ) );
					cmd.Parameters.Add( new SqlParameter( "@IsRevisionOfRecord", IsRevisionOfRecord ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static int InsertWorkflow( string Name, string Description, bool IsActive, string Version, bool IsRevisionOfRecord, string Username, DateTime DateCreated )
		{
			int id = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Name", Name ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", Description ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", IsActive ) );
					cmd.Parameters.Add( new SqlParameter( "@Version", Version ) );
					cmd.Parameters.Add( new SqlParameter( "@IsRevisionOfRecord", IsRevisionOfRecord ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", DateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();

					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static void DeleteWorkflow( int WorkflowID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowDelete";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", WorkflowID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDeleted", true ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
		#endregion


		#region Workflow Task methods
		public static DataSet GetWorkflowTasks( int WorkflowID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkFlowID", WorkflowID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetWorkflowTask( int WorkflowTaskID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void UpdateWorkflowTask( int WorkflowID, int WorkflowTaskID, int TaskSequence, int TaskTypeId, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", WorkflowID ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@TaskSequence", TaskSequence ) );
					cmd.Parameters.Add( new SqlParameter( "@TaskTypeId", TaskTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void DeleteWorkflowTask( int WorkflowTaskID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskDelete";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDeleted", true ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static int InsertWorkflowTask( int WorkflowID, int TaskSequence, int TaskTypeId, string Username, DateTime DateCreated )
		{
			int id = 0;
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", WorkflowID ) );
					cmd.Parameters.Add( new SqlParameter( "@TaskSequence", TaskSequence ) );
					cmd.Parameters.Add( new SqlParameter( "@TaskTypeId", TaskTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", DateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();
					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}
		#endregion


		#region Task Type methods
		public static DataSet GetTaskTypes( bool? IsActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TaskTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@IsActive", (IsActive == null) ? DBNull.Value : (object) IsActive ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static int InsertTaskType( string TaskName, bool IsActive, string Username, DateTime DateCreated )
		{
			int id = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TaskTypeInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@TaskName", TaskName ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", IsActive ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", DateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();

					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static void UpdateTaskType( int TaskTypeID, string TaskName, bool IsActive, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TaskTypeInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@TaskTypeID", TaskTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@TaskName", TaskName ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", IsActive ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void DeleteTaskType( int TaskTypeID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TaskTypeDelete";

					cmd.Parameters.Add( new SqlParameter( "@TaskTypeID", TaskTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDeleted", true ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
		#endregion


		#region Workflow Task Logic methods
		public static DataSet GetWorkflowTaskLogics( int WorkflowTaskID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskLogicSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static int InsertWorkflowTaskLogic( int WorkflowTaskID, string LogicParam, int LogicCondition, bool IsAutomated, string Username, DateTime DateCreated )
		{
			int id = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskLogicInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@LogicParam", LogicParam ) );
					cmd.Parameters.Add( new SqlParameter( "@LogicCondition", LogicCondition ) );
					cmd.Parameters.Add( new SqlParameter( "@IsAutomated", IsAutomated ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", DateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();

					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}


		public static void UpdateWorkflowTaskLogic( int WorkflowTaskLogicID, int WorkflowTaskID, string LogicParam, int LogicCondition, bool IsAutomated, string Username, DateTime DateCreated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskLogicInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskLogicID", WorkflowTaskLogicID ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@LogicParam", LogicParam ) );
					cmd.Parameters.Add( new SqlParameter( "@LogicCondition", LogicCondition ) );
					cmd.Parameters.Add( new SqlParameter( "@IsAutomated", IsAutomated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		public static void DeleteWorkflowTaskLogic( int WorkflowTaskLogicID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskLogicDelete";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskLogicID", WorkflowTaskLogicID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDeleted", true ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		public static int WorkflowTaskHasLogic( int WorkflowTaskID )
		{
			int LogicCount = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowTaskHasLogicCheck";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cn.Open();

					LogicCount = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return LogicCount;
		}
		#endregion


		#region Task Status methods
		public static DataSet GetTaskStatus( bool? IsActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TaskStatusSelect";

					cmd.Parameters.Add( new SqlParameter( "@IsActive", (IsActive == null) ? DBNull.Value : (object) IsActive ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
		#endregion


		#region Workflow Path Logic methods
		public static DataSet GetWorkflowPathLogics( int WorkflowTaskID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowPathLogicSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static int InsertWorkflowPathLogic( int WorkflowTaskID, int WorkflowTaskIDRequired, int ConditionTaskStatusID, string Username, DateTime DateCreated )
		{
			int id = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowPathLogicInsertUpdate";
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskIDRequired", WorkflowTaskIDRequired ) );
					cmd.Parameters.Add( new SqlParameter( "@ConditionTaskStatusID", ConditionTaskStatusID ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", DateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateCreated ) );

					cn.Open();

					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static void UpdateWorkflowPathLogic( int WorkflowPathLogicID, int WorkflowTaskID, int WorkflowTaskIDRequired, int ConditionTaskStatusID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowPathLogicInsertUpdate";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowPathLogicID", WorkflowPathLogicID ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskID", WorkflowTaskID ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkflowTaskIDRequired", WorkflowTaskIDRequired ) );
					cmd.Parameters.Add( new SqlParameter( "@ConditionTaskStatusID", ConditionTaskStatusID ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		public static void DeleteWorkflowPathLogic( int WorkflowPathLogicID, string Username, DateTime DateUpdated )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowPathLogicDelete";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowPathLogicID", WorkflowPathLogicID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDeleted", true ) );
					cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateUpdated", DateUpdated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
		#endregion


		#region Workflow Assignment methods (that could have been automatically created by EF in 2 seconds)
		/// <summary>
		/// Returns a loosely-typed collection of all WorkflowAssignments for a specified workflowId
		/// </summary>
		/// <param name="workflowId">The workflow tied to the assignments</param>
		/// <returns>A DataSet with one table containly WorkflowAssignment records</returns>
		public static DataSet GetWorkflowAssignments( int? workflowId )
		{
			var ds = new DataSet();

			using( var cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowAssignmentsSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowID", workflowId ) );

					using( var da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}


		/// <summary>
		/// Inserts a new Workflow Assignment
		/// </summary>
		/// <param name="workflowId">Assigned workflowId</param>
		/// <param name="marketId">Assigned market</param>
		/// <param name="utilityId">Assigned utility</param>
		/// <param name="contractTypeId">Assigned contract type</param>
		/// <param name="contractDealTypeId">Assigned contract deal type</param>
		/// <param name="contractTemplateTypeId">Assigned contract template type</param>
		/// <param name="createdBy">User that created the assignment</param>
		/// <returns>int PK workflowAssignmentId if sucessful, error message if failed</returns>
		public static string InsertWorkflowAssignment( int workflowId, int? marketId, int? utilityId, int contractTypeId, int contractDealTypeId, int contractTemplateTypeId, string createdBy )
		{
			string newId = InsertUpdateWorkflowAssignment( null, workflowId, marketId, utilityId, contractTypeId, contractDealTypeId, contractTemplateTypeId, createdBy, null );
			return newId;
		}


		/// <summary>
		/// Updates a Workflow Assignment
		/// </summary>
		/// <param name="workflowAssignmentId">The Primary Key for the record to be deleted</param>
		/// <param name="workflowId">Assigned workflowId</param>
		/// <param name="marketId">Assigned market</param>
		/// <param name="utilityId">Assigned utility</param>
		/// <param name="contractTypeId">Assigned contract type</param>
		/// <param name="contractDealTypeId">Assigned contract deal type</param>
		/// <param name="contractTemplateTypeId">Assigned contract template type</param>
		/// <param name="updatedBy">User that made the change</param>
		/// <returns>Same workflowAssignmentId if sucessful, error message if failed</returns>
		public static string UpdateWorkflowAssignment( int workflowAssignmentId, int workflowId, int? marketId, int? utilityId, int contractTypeId,
													int contractDealTypeId, int contractTemplateTypeId, string updatedBy )
		{
			string returnId = InsertUpdateWorkflowAssignment( workflowAssignmentId, workflowId, marketId, utilityId, contractTypeId, contractDealTypeId, contractTemplateTypeId, null, updatedBy );
			return returnId;
		}


		/// <summary>
		/// Permanently deletes a Workflow Assignment
		/// </summary>
		/// <param name="workflowAssignmentId">Primary Key for the record to be deleted</param>
		public static void DeleteWorkflowAssignment( int workflowAssignmentId )
		{
			using( var connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = connection;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowAssignmentDelete";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowAssignmentId", workflowAssignmentId ) );

					connection.Open();
					cmd.ExecuteScalar();
				}
			}
		}


		/// <summary>
		/// Calls the SQL stored proc to insert or update a WorkflowAssignment record
		/// </summary>
		/// <returns>int PK workflowAssignmentId if sucessful, error message if failed</returns>
		private static string InsertUpdateWorkflowAssignment( int? workflowAssignmentId, int workflowId, int? marketId, int? utilityId, int contractTypeId,
															int contractDealTypeId, int contractTemplateTypeId, string createdBy, string updatedBy )
		{
			using( var connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = connection;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowAssignmentInsertUpdate";					//Returns int PK Id of assignment if sucessful, error message if failed

					cmd.Parameters.Add( new SqlParameter( "@WorkflowId", workflowId ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketId", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractTypeId", contractTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractDealTypeId", contractDealTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractTemplateTypeId", contractTemplateTypeId ) );

					if( workflowAssignmentId > 0 )
					{	//Update
						cmd.Parameters.Add( new SqlParameter( "@WorkflowAssignmentId", workflowAssignmentId ) );
						cmd.Parameters.Add( new SqlParameter( "@UpdatedBy", updatedBy ) );
					}
					else
					{	//Insert
						cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					}

					connection.Open();

					//return int.Parse( cmd.ExecuteScalar().ToString() );
					return cmd.ExecuteScalar().ToString();
				}
			}
		}

		#endregion

	}
}

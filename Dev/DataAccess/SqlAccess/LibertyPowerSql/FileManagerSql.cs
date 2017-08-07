using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Data Access Layer supporting FileManager and FileContext classes
	/// </summary>
	public static class FileManagerSql
	{

		/// <summary>
		/// Retrieves a DataSet containing the specified FileContext
		/// </summary>
		/// <param name="guid">string guid of the FileContext to retrieve</param>
		/// <returns></returns>
		public static DataSet GetFileContextByGuid( Guid guid )
		{

			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetFileContextByGuid";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "FileGuid", SqlDbType.UniqueIdentifier, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = guid;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Deletes a FileContext record based on the specified FileGuid
		/// </summary>
		/// <param name="guid">string guid of the FileContext to retrieve</param>
		/// <returns>number of rows effected</returns>
		public static int DeleteFileContextByGuid( Guid guid )
		{

			int rows = 0;
			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrDeleteFileContextByGuid";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "FileGuid", SqlDbType.UniqueIdentifier, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = guid;
					command.Parameters.Add( param1 );
					
					connection.Open();
					rows = command.ExecuteNonQuery();
				}
			}
			return rows;
		}

		public static void DeleteManagedFile( string path )
		{
			if(File.Exists(path))
				File.Delete(path);
		}

		/// <summary>
		/// Retrieves a dataset with all FileContext's for a given FileManager
		/// </summary>
		/// <param name="contextKey">identifies the given FileManager</param>
		/// <returns></returns>
		public static DataSet GetFullFileContextCollection( string contextKey )
		{
			if( contextKey.Length > 50 )
				throw new FileManagerSqlException( "parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileContexts";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Returns a DataSet containing all FileContext items for a specified FileManager
		/// </summary>
		/// <param name="contextKey">uniquely identifies the FileManager</param>
		/// <returns></returns>
		public static DataSet GetAllFileContextsByContextKey( string contextKey )
		{
			if( contextKey.Length > 50 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileContexts";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Returns a DataSet containing all FileContext items for a specified ManagedBin
		/// </summary>
		/// <param name="contextKey"></param>
		/// <param name="root"></param>
		/// <param name="relativePath"></param>
		/// <returns></returns>
		public static DataSet GetAllFileContextsByRelativePath( string contextKey, string root, string relativePath )
		{
			if( contextKey.Length > 50 || root.Length > 512 || relativePath.Length > 1024 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileContextsByRelativePath";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = root;
					command.Parameters.Add( param2 );

					SqlParameter param3 = new SqlParameter( "RelativePath", SqlDbType.VarChar, 1024 );
					param3.Direction = ParameterDirection.Input;
					param3.Value = relativePath;
					command.Parameters.Add( param3 );


					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Returns a DataSet containing all FileContext items for a specified ManagerRoot
		/// </summary>
		/// <param name="contextKey"></param>
		/// <param name="root"></param>
		/// <returns></returns>
		public static DataSet GetAllFileContextsByRoot( string contextKey, string root )
		{
			if( contextKey.Length > 50 || root.Length > 512 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileContextsByRoot";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = root;
					command.Parameters.Add( param2 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Inserts a ManagedBin record
		/// </summary>
		/// <param name="contextKey"></param>
		/// <param name="root"></param>
		/// <param name="relativePath"></param>
		/// <param name="userID"></param>
		/// <returns></returns>
		public static DataSet InsertManagedBin( string contextKey, string root, string relativePath, int userID )
		{
			if( contextKey.Length > 50 || root.Length > 500 || relativePath.Length > 256 )
				throw new FileManagerSqlException( "parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrInsertManagedBin";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = root;
					command.Parameters.Add( param2 );

					SqlParameter param3 = new SqlParameter( "RelativePath", SqlDbType.VarChar, 256 );
					param3.Direction = ParameterDirection.Input;
					param3.Value = relativePath;
					command.Parameters.Add( param3 );

					SqlParameter param4 = new SqlParameter( "UserID", SqlDbType.Int, 4 );
					param4.Direction = ParameterDirection.Input;
					param4.Value = userID;
					command.Parameters.Add( param4 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Retrieves a DataSet with the item count for the specified relativePath
		/// </summary>
		/// <param name="contextKey">uniquly identifies a FileManager</param>
		/// <param name="root">uniquly identifies a ManagerRoot</param>
		/// <returns>DataSet of ManagedBins for the selected ManagerRoot, sorted by ItemCount asc, ID desc</returns>
		public static DataSet GetManagedBinsSortedByItemCount( string contextKey, string root )
		{
			if( contextKey.Length > 50 || root.Length > 500 )
				throw new FileManagerSqlException( "parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetManagedBinSortedByItemCount";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = root;
					command.Parameters.Add( param2 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Retrieves the active root for new file writes; logic is based on the most recent creation time
		/// </summary>
		public static DataSet GetActiveRoot( string contextKey )
		{
			if( contextKey.Length > 50 )
				throw new FileManagerSqlException( "parameter exceeds allowed size" );


			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetActiveRoot";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Sets the ActiveRootDirectory for new file writes in the FileManager
		/// </summary>
		/// <param name="contextKey">string identifying the FileManager</param>
		/// <param name="activeRoot">path of the root to make active (must already exist) </param>
		/// <returns></returns>
		public static DataSet SetActiveRoot( string contextKey, string activeRoot )
		{

			if( contextKey.Length > 50 || activeRoot.Length > 512 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{

					command.Connection = connection;
					command.CommandText = "usp_FileMgrSetRootActive";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = activeRoot;
					command.Parameters.Add( param2 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds2 = new DataSet();
						int nRows = da.Fill( ds2 );
						return ds2;
					}
				}
			}

		}

		/// <summary>
		/// Retrieves all FileManagers in the active database
		/// </summary>
		/// <returns></returns>
		public static DataSet GetAllFileManagers()
		{
			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileMgrContexts";
					command.CommandType = CommandType.StoredProcedure;

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Retrieves all Root directories for the specified FileManager
		/// </summary>
		/// <param name="contextKey">uniquely identifies the FileManager</param>
		/// <returns></returns>
		public static DataSet GetAllRoots( string contextKey )
		{
			if( contextKey.Length > 50 )
				throw new FileManagerSqlException( "parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrGetAllFileMgrRoots";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		public static DataSet GetFileManager( string contextKey )
		{
			if( contextKey.Length > 50)
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrSelectFileMgr";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Inserts a new FileManager
		/// </summary>
		/// <param name="contextKey">string identifying the FileManager</param>
		/// <param name="root">ManagerRoot path for new FileManager</param>
		/// <param name="userID">logged in user</param>
		/// <returns>DataSet containing the FileManager</returns>
		public static DataSet InsertFileManager( string contextKey, string root, int userID )
		{
			return InsertFileManager( contextKey, "", root, userID );
		}

		/// <summary>
		/// Create the specified FileManager if the contextKey  does not already exist
		/// </summary>
		public static DataSet InsertFileManager( string contextKey, string businessPurpose, string root, int userID )
		{
			if( contextKey.Length > 50 || businessPurpose.Length > 128 || root.Length > 512 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrInsertFileMgr";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "BusinessPurpose", SqlDbType.VarChar, 128 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = businessPurpose;
					command.Parameters.Add( param2 );

					SqlParameter param3 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param3.Direction = ParameterDirection.Input;
					param3.Value = root;
					command.Parameters.Add( param3 );

					SqlParameter param4 = new SqlParameter( "UserID", SqlDbType.Int, 4 );
					param4.Direction = ParameterDirection.Input;
					param4.Value = userID;
					command.Parameters.Add( param4 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Add a root directory to the specified FileManager; FileManager must not already exist
		/// </summary>
		public static DataSet InsertFileManagerRoot( string contextKey, string path, bool isActive, int userID )
		{
			if( contextKey.Length > 50 || path.Length > 512 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrInsertRoot";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "Root", SqlDbType.VarChar, 512 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = path;
					command.Parameters.Add( param2 );

					SqlParameter param3 = new SqlParameter( "IsActive", SqlDbType.Bit, 50 );
					param3.Direction = ParameterDirection.Input;
					param3.Value = isActive;
					command.Parameters.Add( param3 );

					SqlParameter param4 = new SqlParameter( "UserID", SqlDbType.Int, 4 );
					param4.Direction = ParameterDirection.Input;
					param4.Value = userID;
					command.Parameters.Add( param4 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds = new DataSet();
						int nRows = da.Fill( ds );
						return ds;
					}
				}
			}
		}

		/// <summary>
		/// Creates a new file mapping
		/// </summary>
		public static DataSet InsertFileContext( string contextKey, Guid guid, string relativePath, string originalFileName, string fileName, int userID )
		{
			DataSet ds = FileManagerSql.GetActiveRoot( contextKey );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
				throw new FileManagerSqlException( "Cannot determine active root from contextKey" );

			string root = ds.Tables[0].Rows[0]["Root"].ToString();

			originalFileName = originalFileName.Replace( guid + "_", "" );
			if( root.Length > 512 || contextKey.Length > 50 || relativePath.Length > 1024 || originalFileName.Length > 256 || fileName.Length > 512 )
				throw new FileManagerSqlException( "Parameter exceeds allowed size" );

			string connStr = Helper.ConnectionString;
			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_FileMgrInsertFileContext";
					command.CommandType = CommandType.StoredProcedure;

					SqlParameter param1 = new SqlParameter( "ContextKey", SqlDbType.VarChar, 50 );
					param1.Direction = ParameterDirection.Input;
					param1.Value = contextKey;
					command.Parameters.Add( param1 );

					SqlParameter param2 = new SqlParameter( "FileGuid", SqlDbType.UniqueIdentifier, 256 );
					param2.Direction = ParameterDirection.Input;
					param2.Value = guid;
					command.Parameters.Add( param2 );

					SqlParameter param3 = new SqlParameter( "RelativePath", SqlDbType.VarChar, 1024 );
					param3.Direction = ParameterDirection.Input;
					param3.Value = relativePath;
					command.Parameters.Add( param3 );

					SqlParameter param4 = new SqlParameter( "OriginalFileName", SqlDbType.VarChar, 256 );
					param4.Direction = ParameterDirection.Input;
					param4.Value = originalFileName;
					command.Parameters.Add( param4 );

					SqlParameter param5 = new SqlParameter( "FileName", SqlDbType.VarChar, 256 );
					param5.Direction = ParameterDirection.Input;
					param5.Value = fileName;
					command.Parameters.Add( param5 );

					SqlParameter param6 = new SqlParameter( "UserID", SqlDbType.Int, 4 );
					param6.Direction = ParameterDirection.Input;
					param6.Value = userID;
					command.Parameters.Add( param6 );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						DataSet ds2 = new DataSet();
						int nRows = da.Fill( ds2 );
						return ds2;
					}
				}
			}
		}

		/// <summary>
		/// Retrieves a populated FileStream for the specified path
		/// </summary>
		public static Stream ReadFile( string path )
		{
			StreamReader streamReader = new StreamReader( path );
			string contents = streamReader.ReadToEnd();
			streamReader.BaseStream.Position = 0;
			//Copy bytes to a new stream
			MemoryStream stream = new MemoryStream();
			for( int i = 0; i < streamReader.BaseStream.Length; i++ )
			{
				byte b = (byte) streamReader.BaseStream.ReadByte();
				stream.WriteByte( b );
			}
			stream.Position = 0;
			streamReader.Close();
			return stream;
		}

		/// <summary>
		/// Writes the provided FileStream to the specified path
		/// </summary>
		public static void WriteFile( Stream stream, string path )
		{
			#region ensure path exist
			string fileName = System.IO.Path.GetFileName(path);
			string dir = path.Replace(fileName, "");
			if( System.IO.Directory.Exists( dir ) == false )
				System.IO.Directory.CreateDirectory( dir );
			#endregion

			using( Stream output = new FileStream( path, FileMode.Create ) )
			{
				stream.Position = 0; //reset position to copy entire file
				byte[] buffer = new byte[32 * 1024];
				int read;

				while( (read = stream.Read( buffer, 0, buffer.Length )) > 0 )
				{
					output.Write( buffer, 0, read );
				}
				output.Flush();
				output.Close();
			}
		}
	}
}

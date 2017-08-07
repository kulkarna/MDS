using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PEUploadedCurveFileSql
	{
		/// <summary>
		/// Inserts an UploadedCurveFiles
		/// </summary>
		/// <param name=UploadedCurveFiles></param>
		[Obsolete( "Use file manager instead" )]
		public static int InsertUploadedCurveFile( Guid fileGuid, String fileName, String fileDeterminant, Int32 curveId, DateTime fileEffectiveDate, DateTime fileTimeStamp, String curveComments, DateTime uploadDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEUploadedCurveFilesInsert";

					cmd.Parameters.Add( new SqlParameter( "@Identifier", fileGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@FileName", fileName ) );
					cmd.Parameters.Add( new SqlParameter( "@FileDeterminant", fileDeterminant ) );
					cmd.Parameters.Add( new SqlParameter( "@CurveId", curveId ) );
					cmd.Parameters.Add( new SqlParameter( "@FileEffectiveDate", fileEffectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@FileTimeStamp", fileTimeStamp ) );
					cmd.Parameters.Add( new SqlParameter( "@CurveComments", curveComments ) );
					cmd.Parameters.Add( new SqlParameter( "@UploadDate", uploadDate ) );
					conn.Open();

					return Convert.ToInt32( cmd.ExecuteScalar() );
				}
			}
		}
	}
}


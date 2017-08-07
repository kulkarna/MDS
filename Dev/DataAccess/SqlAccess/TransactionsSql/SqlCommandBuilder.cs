namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Collections.Generic;
	using System.Data;
	using System.Linq;
	using System.Text;
	using System.Data.SqlClient;

	public class SqlCommandBuilder
	{
		private SqlConnection connection;
		private SqlCommand command;

		public SqlCommandBuilder( SqlConnection connection, string procedureName )
		{
			this.connection = connection;

			command = connection.CreateCommand();
			command.CommandText = procedureName;
			command.CommandType = CommandType.StoredProcedure;
		}

		public void AddParameter( string name, object value )
		{
			SqlParameter newParameter = new SqlParameter( "@" + name, value );

			command.Parameters.Add( newParameter );
		}

		public SqlCommand Build()
		{
			return command;
		}
	}
}

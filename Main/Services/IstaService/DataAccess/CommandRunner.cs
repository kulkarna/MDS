using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.DataAccess
{
    /// <summary>
    /// Executes databases commands or queries.
    /// </summary>
    interface ICommandRunner
    {
        /// <summary>
        /// Executes the procedure returning its results.
        /// </summary>
        /// <param name="procedure">The name of the procedure to execute.</param>
        /// <param name="parameter">The parameter of the procedure.</param>
        /// <returns>The results of the execution.</returns>
        DataSet ExecuteProcedure(string procedure, SqlParameter parameter);
    }

    sealed class CommandRunner : ICommandRunner
    {
        private readonly IDataAccessSettings settings;

        public CommandRunner(IDataAccessSettings settings = null)
        {
            this.settings = settings ?? new DataAccessSettings();
        }

        public DataSet ExecuteProcedure(string procedure, SqlParameter parameter)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(settings.GetLibertyPowerConnectionString()))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = procedure;

                    if (parameter != null)
                        command.Parameters.Add(parameter);

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }
    }
}

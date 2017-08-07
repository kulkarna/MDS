using System.Data.SqlClient;
using System.Threading;
using Core.Extensions.Data.SqlClient;
using System.Data;
using LibertyPower.RepositoryManagement.Core.Instrumentation;

namespace LibertyPower.RepositoryManagement.Data
{
    public class TracingRepository : ITracingRepository
    {
        public TracingRepository(string connectionString)
        {
            this.connectionString = connectionString;
        }

        private readonly string connectionString = string.Empty;
        private string AsyncConnectionString
        {
            get
            {
                var cb = new SqlConnectionStringBuilder(connectionString) { AsynchronousProcessing = true };
                return cb.ConnectionString;
            }
        }

        public void LogServiceTrace(ServiceCallTrace trace)
        {
            LogServiceCall(trace, connectionString);
        }

        public void LogServiceTraceAsync(ServiceCallTrace trace)
        {
            ThreadPool.QueueUserWorkItem(x => LogServiceCall(trace, AsyncConnectionString));
        }

        private void LogServiceCall(ServiceCallTrace serviceCall, string cstr)
        {
            var message = serviceCall.Message;
            serviceCall.Message = null;
            using (var cmd = new SqlCommandWrapper<int>("usp_LogServiceCall", cstr))
            {
                cmd.SetCommandType(CommandType.StoredProcedure)
                    .AddXml("@p_description", serviceCall.ToXml())
                    .AddXml("@p_message", message)
                    .AsNonQuery();
            }
        }
    }
}
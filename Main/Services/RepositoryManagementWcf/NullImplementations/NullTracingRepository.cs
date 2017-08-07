using LibertyPower.RepositoryManagement.Data;

namespace LibertyPower.RepositoryManagement.Web.NullImplementations
{
    public class NullTracingRepository : ITracingRepository
    {
        public NullTracingRepository(string connectionString)
        {
        }
        public void LogServiceTrace(Core.Instrumentation.ServiceCallTrace trace)
        {
            //throw new NotImplementedException();
        }
        public void LogServiceTraceAsync(Core.Instrumentation.ServiceCallTrace trace)
        {
            //throw new NotImplementedException();
        }
    }
}
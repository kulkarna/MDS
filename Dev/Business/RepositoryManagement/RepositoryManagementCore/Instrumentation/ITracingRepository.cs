using LibertyPower.RepositoryManagement.Core.Instrumentation;

namespace LibertyPower.RepositoryManagement.Data
{
    public interface ITracingRepository
    {
        void LogServiceTrace(ServiceCallTrace trace);
        void LogServiceTraceAsync(ServiceCallTrace trace);
    }
}
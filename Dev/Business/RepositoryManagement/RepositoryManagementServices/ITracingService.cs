using LibertyPower.RepositoryManagement.Core.Instrumentation;

namespace LibertyPower.RepositoryManagement.Services
{
    public interface ITracingService
    {
        void Log(ServiceCallTrace trace);
    }
}
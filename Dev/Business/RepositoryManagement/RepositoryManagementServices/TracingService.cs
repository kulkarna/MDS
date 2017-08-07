using System;
using LibertyPower.RepositoryManagement.Core.Instrumentation;
using LibertyPower.RepositoryManagement.Data;

namespace LibertyPower.RepositoryManagement.Services
{
    public class TracingService : ITracingService
    {
        readonly private ITracingRepository repository;
        public TracingService(ITracingRepository repository)
        {
            this.repository = repository;
        }

        public void Log(ServiceCallTrace trace)
        {
            try
            {
                repository.LogServiceTraceAsync(trace);
            }
            catch (Exception)
            {
                //TODO: will be executed on separate thread, do we need this
            }
        }
    }
}
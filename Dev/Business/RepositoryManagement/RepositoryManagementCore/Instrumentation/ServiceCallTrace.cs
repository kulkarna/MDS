using System;

namespace LibertyPower.RepositoryManagement.Core.Instrumentation
{
    public class ServiceCallTrace
    {
        public Guid Guid { get; set; }
        public string Action { get; set; }
        public string Ip { get; set; }
        public DateTime Timestamp { get; set; }
        public string Message { get; set; }
    }
}

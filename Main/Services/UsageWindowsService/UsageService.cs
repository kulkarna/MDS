using System;
using System.Reflection;
using Common.Logging;
using NLog.Config;

namespace UsageWindowsService
{
    public class UsageService : IService
    {
        private static ILog Log;

        public void Start()
        {
            try
            {
                ConfigurationItemFactory.Default.Targets.RegisterDefinition("UsageEvents", typeof(Helpers.NlogUsageEventsTarget));
                UsageEventAggregator.BootStrap.Run(Assembly.GetExecutingAssembly());

                Log = LogManager.GetCurrentClassLogger();
                Log.Info("Usage Windows Service Started on " + Environment.MachineName);
            }
            catch (Exception ex)
            {
                Log.Error("Service start exception: " + ex.GetBaseException(), ex);
                throw;
            }

        }

        public void Stop()
        {
            Log.Info("Usage Windows Service Stopped on " + Environment.MachineName);
        }
    }
}
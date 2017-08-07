using System.Reflection;
using UsageEventAggregator.Helpers;

namespace UsageEventAggregator
{
    public static class BootStrap
    {
         public static void Run(Assembly assemblyBeingCalledFrom)
         {
             Locator.Current.RegisterDIContainer(assemblyBeingCalledFrom);
             Locator.Current.GetAggregator();
         }
    }
}
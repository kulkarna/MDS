using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ninject;
using UsageResponseImportProcessor.Ioc;
using UsageResponseImportProcessor.Business;
using UsageResponseImportProcessor.DataAccess;

namespace UsageResponseImportProcessor
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Processing...");

            // Trigger the Missing Rate Report process.

            try
            {
                Bindings.Ioc.Get<IUsageResponseProcessor>().Start();
            }
            catch (Exception ex)
            {
                Bindings.Ioc.Get<IUsageResponseDao>().Log(ex);
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Topshelf;

namespace UsageWindowsService
{
    class Program
    {
        static void Main(string[] args)
        {
            HostFactory.Run(x =>
            {
                x.Service<UsageService>(s =>
                {
                    s.ConstructUsing(name => new UsageService());
                    s.WhenStarted(tc => tc.Start());
                    s.WhenStopped(tc => tc.Stop());
                });
                x.RunAsLocalSystem();

                x.SetDescription("Handles Usage Management requests for data acquisition.");
                x.SetDisplayName("Usage Management Service");
                x.SetServiceName("UsageManagementService");
            }); 
        }
    }
}

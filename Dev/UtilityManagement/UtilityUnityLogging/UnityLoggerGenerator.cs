using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityLogging;

namespace UtilityUnityLogging
{
    /// <summary>
    /// Class UnityLoggerGenerator.
    /// </summary>
    public static class UnityLoggerGenerator
    {
        /// <summary>
        /// Generates the logger.
        /// </summary>
        /// <returns>ILogger.</returns>
        public static ILogger GenerateLogger()
        {
            //IUnityContainer container = new UnityContainer();
            //container.LoadConfiguration();
            ILogger logger = new Logger();
            return logger;
        }
    }
}
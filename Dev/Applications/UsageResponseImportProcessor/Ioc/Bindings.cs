using UsageResponseImportProcessor.Business;
using UsageResponseImportProcessor.DataAccess;
using UsageResponseImportProcessor.Transport;
using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DailyBillingImportProcessor.Business;
using UsageResponseImportProcessor.DataAccess.Base;

namespace UsageResponseImportProcessor.Ioc
{
    /// <summary>
    /// Injection dependency container class
    /// </summary>
    public class Bindings
    {
        /// <summary>
        /// Map the project injectable dependencies.
        /// </summary>
        public void Load()
        {
            var kernel = new StandardKernel();

            #region Business

            kernel.Bind<IUsageResponseBo>().To<UsageResponseBo>();
            kernel.Bind<IUsageResponseFileParser>().To<UsageResponseFileParser>();
            kernel.Bind<IUsageResponseProcessor>().To<UsageResponseProcessor>();

            #endregion
            
            #region Dao

            #region Base

            kernel.Bind<ISqlConnector>().To<SqlConnector>();
            kernel.Bind<ISqlRunner>().To<SqlRunner>();
            kernel.Bind<ISqlSettings>().To<SqlSettings>();

            #endregion

            kernel.Bind<IUsageResponseDao>().To<UsageResponseDao>();

            #endregion
            
            #region Transport

            kernel.Bind<IFileManager>().To<FileManager>();
            kernel.Bind<IFtp>().To<Ftp>();
            kernel.Bind<ITransportSettings>().To<TransportSettings>();

            #endregion

            Ioc = kernel;
        }

        /// <summary>
        /// Dependency container Injection.
        /// </summary>
        private static IKernel _Ioc;

        /// <summary>
        /// Verifies if the dependency injection container is fulfilled.
        /// If not, then the Load method is called to map the dependencies,
        /// otherwise returns the container.
        /// </summary>
        public static IKernel Ioc
        {
            get
            {
                if ( _Ioc == null )
                    new Bindings().Load();

                return _Ioc;
            }

            private set { _Ioc = value; }
        }
    }
}

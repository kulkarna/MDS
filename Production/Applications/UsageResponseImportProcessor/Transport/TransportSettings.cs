using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Settings used for transporting files by the application.
    /// </summary>
    public class TransportSettings : ITransportSettings
    {
        /// <summary>
        /// Gets URI location of the ftp.
        /// </summary>
        /// <returns>Ftp URI location.</returns>
        public string GetFtpUri()
        {
            return ConfigurationManager.AppSettings["FtpUri"];
        }

        /// <summary>
        /// Gets the ftp user.
        /// </summary>
        /// <returns>Ftp user.</returns>
        public string GetFtpUser()
        {
            return ConfigurationManager.AppSettings["FtpUser"];
        }

        /// <summary>
        /// Gets the ftp password.
        /// </summary>
        /// <returns>Ftp password.</returns>
        public string GetFtpPassword()
        {
            return ConfigurationManager.AppSettings["FtpPassword"];
        }

        /// <summary>
        /// Gets ftp files destination.
        /// </summary>
        /// <returns>Destination of the files.</returns>
        public string GetFtpDestination()
        {
            return ConfigurationManager.AppSettings["FtpDestination"];
        }

        /// <summary>
        /// Gets the content type of the files to be handled.
        /// </summary>
        /// <returns>Content type of the files.</returns>
        public string GetFilesContetnType()
        {
            return ConfigurationManager.AppSettings["FilesContetnType"];
        }

        /// <summary>
        /// Gets bad files destination.
        /// </summary>
        /// <returns>Destination of the bad files.</returns>
        public string GetBadFilesDestination()
        {
            return ConfigurationManager.AppSettings["BadFilesLocation"];
        }
    }
}

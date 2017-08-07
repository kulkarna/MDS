using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Abstract the transport settings to retrieve information.
    /// </summary>
    public interface ITransportSettings
    {
        /// <summary>
        /// Gets URI location of the ftp.
        /// </summary>
        /// <returns>Ftp URI location.</returns>
        string GetFtpUri();

        /// <summary>
        /// Gets the ftp user.
        /// </summary>
        /// <returns>Ftp user.</returns>
        string GetFtpUser();

        /// <summary>
        /// Gets the ftp password.
        /// </summary>
        /// <returns>Ftp password.</returns>
        string GetFtpPassword();

        /// <summary>
        /// Gets ftp files destination.
        /// </summary>
        /// <returns>Destination of the files.</returns>
        string GetFtpDestination();

        /// <summary>
        /// Gets the content type of the files to be handled.
        /// </summary>
        /// <returns>Content type of the files.</returns>
        string GetFilesContetnType();

        /// <summary>
        /// Gets bad files destination.
        /// </summary>
        /// <returns>Destination of the bad files.</returns>
        string GetBadFilesDestination();
    }
}

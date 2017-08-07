using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Abstracts the ftp files transportation.
    /// </summary>
    public interface IFtp
    {
        /// <summary>
        /// Transport files from ftp origin to local folder
        /// </summary>
        void TransportFiles();
    }
}

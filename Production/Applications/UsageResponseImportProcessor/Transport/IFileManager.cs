using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Abstracts the local file handling.
    /// </summary>
    public interface IFileManager
    {
        /// <summary>
        /// Get files from the configured location.
        /// </summary>
        /// <returns>Files from the folder.</returns>
        List<File> GetFiles();

        /// <summary>
        /// Deletes the file passed as parameter from the configured location.
        /// </summary>
        void RemoveFile(string fileName);

        /// <summary>
        /// Moves file to bad files location.
        /// </summary>
        /// <param name="fileName">Name of the file to be moved to bad files location.</param>
        void MoveToBadFile(string fileName);
    }
}

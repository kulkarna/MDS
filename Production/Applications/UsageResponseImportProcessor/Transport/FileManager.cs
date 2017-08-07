using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Handles local file management.
    /// </summary>
    public class FileManager : IFileManager
    {
        #region Constructor

        /// <summary>
        /// Instantiates a file manager object.
        /// </summary>
        /// <param name="transportSettings">Transport settings used by the report</param>
        public FileManager(ITransportSettings transportSettings)
        {
            this.transportSettings = transportSettings;
        }

        #endregion

        #region Private Members

        /// <summary>
        /// Transport settings used by the report.
        /// </summary>
        private readonly ITransportSettings transportSettings;
        
        #endregion

        #region Behavior

        /// <summary>
        /// Get files from local Libertypower folder.
        /// </summary>
        /// <returns>Files from the folder.</returns>
        public List<Transport.File> GetFiles()
        {
            return System.IO.Directory
                    .GetFiles(this.transportSettings.GetFtpDestination())
                    .Select(path => this.GetFile(path))
                    .ToList();
        }

        /// <summary>
        /// Deletes the files from the configured location.
        /// </summary>
        /// <param name="fileName">Name of the file to be removed.</param>
        public void RemoveFile(string fileName)
        {
            System.IO.File.Delete(System.IO.Path.Combine(this.transportSettings.GetFtpDestination(), fileName));
        }

        /// <summary>
        /// Moves file to bad files location.
        /// </summary>
        /// <param name="fileName">Name of the file to be moved to bad files location.</param>
        public void MoveToBadFile(string fileName)
        {
            var source = System.IO.Path.Combine(this.transportSettings.GetFtpDestination(), fileName);
            var destination = System.IO.Path.Combine(this.transportSettings.GetBadFilesDestination(), fileName);

            if (System.IO.File.Exists(destination))
                System.IO.File.Delete(destination);

            System.IO.File.Move(source, destination);
        }

        #endregion

        #region MyRegion

        /// <summary>
        /// Get the file by the path and parses it into an current application know file.
        /// </summary>
        /// <param name="path">Path of the file.</param>
        /// <returns>Resulting file.</returns>
        private Transport.File GetFile(string path)
        {
            var file = new Transport.File();

            var lines = System.IO.File.ReadAllLines(path);

            file.Name = Path.GetFileName(path);
            file.ContentType = this.transportSettings.GetFilesContetnType();
            file.Header = lines[0];
            file.Rows = lines.Skip(1);
            file.MemoryStream = new MemoryStream(System.IO.File.ReadAllBytes(path));

            return file;
        }

        #endregion
    }
}

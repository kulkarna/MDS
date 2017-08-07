using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Handles FTP transactions.
    /// </summary>
    public class Ftp : IFtp
    {
        #region Constructor

        /// <summary>
        /// Instantiates a ftp object.
        /// </summary>
        /// <param name="transportSettings">Transport settings used by the report</param>
        public Ftp(ITransportSettings transportSettings)
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
        /// Get the files from ESG ftp location and download it to Libertypower local folder.
        /// After download the files, the files are deleted from ftp location.
        /// </summary>
        public void TransportFiles()
        {
            var filesNames = GetFilesNames();

            filesNames
                .ToList()
                .ForEach(x => DownloadFile(x));
        
            filesNames
                .ToList()
                .ForEach(x => DeleteFile(x));
        }

        #endregion

        #region Auxiliary

        /// <summary>
        /// Executes a ftp request in the gibe URI using the given method.
        /// </summary>
        /// <param name="uri">URI Ftp location.</param>
        /// <param name="method">Requested method.</param>
        /// <returns>Resulting stream of the request.</returns>
        private Stream ExecuteRequest(string uri, string method)
        {
            var request = (FtpWebRequest) WebRequest.Create(uri);
            request.Method = method;
            request.Credentials = new NetworkCredential(this.transportSettings.GetFtpUser(), this.transportSettings.GetFtpPassword());

            var response = (FtpWebResponse) request.GetResponse();

            return response.GetResponseStream();
        }

        /// <summary>
        /// Lists the files of the ftp location directory.
        /// </summary>
        /// <returns>List of the file in the ftp location.</returns>
        private IEnumerable<string> GetFilesNames()
        {
            var stream = ExecuteRequest(this.transportSettings.GetFtpUri(), WebRequestMethods.Ftp.ListDirectory);
            var reader = new StreamReader(stream);
            var str = reader.ReadToEnd();
            var filesNames = str.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None)
                                .Where(x => !string.IsNullOrEmpty(x));

            return filesNames;
        }

        /// <summary>
        /// Downloads the file from ftp location to local LibertyPower folder.
        /// </summary>
        /// <param name="fileName">Name of the file to be downloaded.</param>
        private void DownloadFile(string fileName)
        {
            var stream = ExecuteRequest(string.Format("{0}{1}", this.transportSettings.GetFtpUri(), fileName), WebRequestMethods.Ftp.DownloadFile);

            var memoryStream = new MemoryStream();
            CopyStream(stream, memoryStream);

            var file = new FileStream(string.Format("{0}{1}", this.transportSettings.GetFtpDestination(), fileName), FileMode.Create, FileAccess.Write);
            memoryStream.WriteTo(file);
            file.Close();
            memoryStream.Close();
        }

        /// <summary>
        /// Deletes the file from ftp location to local LibertyPower folder.
        /// </summary>
        /// <param name="fileName">Name of the file to be deleted.</param>
        private void DeleteFile(string fileName)
        {
            var stream = ExecuteRequest(string.Format("{0}{1}", this.transportSettings.GetFtpUri(), fileName), WebRequestMethods.Ftp.DeleteFile);
            var reader = new StreamReader(stream);
            var str = reader.ReadToEnd();
        }

        /// <summary>
        /// Copies the bytes of the input stream into the output stream.
        /// </summary>
        /// <param name="input">Stream to be copied.</param>
        /// <param name="output">Copy of the input stream.</param>
        public void CopyStream(Stream input, Stream output)
        {
            byte[] buffer = new byte[16 * 1024];
            int read;
            while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, read);
            }
        }

        #endregion
    }
}

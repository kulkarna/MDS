using System;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using FtpLib;
using System.Linq;

using LibertyPower.Business.MarketManagement.EdiParser.FileParser;

namespace Libertypower.FtpFileGrabber
{
    public class Program
    {
        private static FtpConnection ftp;
        private static string ftpServer = ConfigurationManager.AppSettings["FtpServer"];
        private static string ftpUsername = ConfigurationManager.AppSettings["FtpUsername"];
        private static string ftpPassword = ConfigurationManager.AppSettings["FtpPassword"];
        private static string ftpDirectoryIsta = ConfigurationManager.AppSettings["FtpDirectoryIsta"];
        private static string ftpDirectoryESG = ConfigurationManager.AppSettings["FtpDirectoryESG"];
        private static string ftpDirectory2 = ConfigurationManager.AppSettings["FtpDirectory2"];	// daily control files
        private static bool connectToFtp = Convert.ToBoolean(ConfigurationManager.AppSettings["ConnectToFtp"]);
        private static string tempDirectoryIsta = ConfigurationManager.AppSettings["TempDirectoryIsta"];
        private static string tempDirectoryESG = ConfigurationManager.AppSettings["TempDirectoryESG"];
        private static string nonParserEDIFilesDirectory = ConfigurationManager.AppSettings["NonParserEDIFilesDirectory"];
        //private static string destinationDirectory = ConfigurationManager.AppSettings["DestinationDirectory"];
        private static string fileMask = ConfigurationManager.AppSettings["FileMask"];
        private static IList<string> files;

        static void Main(string[] args)
        {
            RunProcess();
        }

        private static void RunProcess()
        {
            string dir = "";
            DateTime dtProcessTime = DateTime.Now;
            try
            {
                // The following block can be commented out after ISTA stops sending us files and we start 
                // receiving files exclusively from ESG
                //-----------------------------------------ISTA BEGIN---------------------------------------------------//
                if (connectToFtp)
                {
                    dir = ftpDirectoryIsta;
                    Connect(dir);
                    DownloadFilesSentByISTA();
                    VerifyLocalAndRemoveRemoteFilesIsta();
                    Disconnect();

                    //// get daily control files - 1-7490383
                    //dir = ftpDirectory2;
                    //Connect(dir);
                    //DownloadFilesSentByISTA();
                    //VerifyLocalAndRemoveRemoteFilesIsta();
                    //Disconnect();

                    
                }
                // Process files dropped by ISTA
                FileController.ProcessFiles(tempDirectoryIsta);

                //-----------------------------------------ISTA END---------------------------------------------------//

                if (connectToFtp)
                {
                    // PBI #126249
                    // Abhi Kulkarni (06/17/2016) - Unlike ISTA, ESG will provide the Edi type in the file name but also dump all types of files in the FTP folder                    
                    // Therefore, we must use a separate method to only download 814/867 files from the FTP location.                    
                    dir = ftpDirectoryESG;
                    Connect(dir);
                    DownloadFilesSentByESG();
                    VerifyLocalAndRemoveRemoteFilesESG();
                    Disconnect();
                }
                // Process files dropped by ESG
                FileController.ProcessFiles(tempDirectoryESG);                
            }
            catch (Exception ex)
            {
                Logger.LogError(ex.ToString() + " while downnloading from ftp directory " + dir);
            }
            finally
            {
                Disconnect();
            }
        }

        // PBI #126249
        //Modified by Vikas Sharma For Invalid Characters.
        private static void DownloadFilesSentByESG()
        {
            string fileName = string.Empty;
            string currentFile = string.Empty;

            try
            {
                files = ftp.List(fileMask);
                int index = 0;
                foreach (string file in files)
                {
                    fileName = file;

                    // Abhi Kulkarni - Bug #134101
                    index = fileName.IndexOf(".txt", StringComparison.CurrentCultureIgnoreCase);
                    if (index > 0)
                    {
                        fileName = fileName.Substring(0, index + 4);
                    }

                    index = fileName.IndexOf(".X12", StringComparison.CurrentCultureIgnoreCase);
                    if (index > 0)
                    {
                        fileName = fileName.Substring(0, index + 4);
                    }

                    // Additional cleanup
                    fileName = fileName.Replace("\0t", string.Empty);
                    fileName = fileName.Replace("\0", string.Empty);

                    // Make sure that the file name starts with 814 or 867
                    currentFile = string.Empty;

                    if (file.StartsWith("814") == true || (file.StartsWith("867") == true))
                        currentFile = Path.Combine(tempDirectoryESG, fileName);
                    else
                        currentFile = Path.Combine(nonParserEDIFilesDirectory, fileName);

                    if (!File.Exists(currentFile))
                        ftp.GetFile(fileName, currentFile, true);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError("Error when downloading file " + fileName + ". Message: " + ex.InnerException.ToString());
                throw;
            }
        }
        private static void DownloadFilesSentByISTA()
        {
            try
            {
                files = ftp.List(fileMask);

                foreach (string file in files)
                {
                    string currentFile = Path.Combine(tempDirectoryIsta, file);
                    if (!File.Exists(currentFile))
                        ftp.GetFile(file, currentFile, true);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex.InnerException.ToString());
                throw;
            }
        }
        //126249
        // Modified by Vikas Sharma
        private static void VerifyLocalAndRemoveRemoteFilesESG()
        {
            int index = 0;
            foreach (string file in files)
            {
                string fileName = string.Empty;

                // This  section is Added suppose we have filename.txt\0.txt then we will put first of them.

                index = file.IndexOf(".txt");
                if (index > 0)
                    fileName = file.Substring(0, index + 4);

                // It may be that all the \0 is removed but suppose we have filenam\0e.txt then it will replace from middle.

                if (!string.IsNullOrEmpty(fileName))
                    fileName = fileName.Replace("\0t", string.Empty);
                else
                    fileName = file.Replace("\0t", string.Empty);
                string currentFile = Path.Combine(tempDirectoryESG, fileName);

                if (File.Exists(currentFile))
                {
                    ftp.RemoveFile(fileName);
                }
                currentFile = Path.Combine(nonParserEDIFilesDirectory, fileName);

                if (File.Exists(currentFile))
                {
                    ftp.RemoveFile(fileName);
                }
                Logger.LogFileTransfer(fileName);

            }
        }

        private static void VerifyLocalAndRemoveRemoteFilesIsta()
        {
            foreach (string file in files)
            {
                string currentFile = Path.Combine(tempDirectoryIsta, file);
                if (File.Exists(currentFile))
                {
                    ftp.RemoveFile(file);
                }
                Logger.LogFileTransfer(file);
            }
        }
        private static void Connect(string folder)
        {
            ftp = new FtpConnection(ftpServer);
            ftp.Open();
            ftp.Login(ftpUsername, ftpPassword);
            ftp.SetCurrentDirectory(folder);
        }

        private static void Disconnect()
        {
            if (ftp != null)
                ftp.Close();
        }

        /// <summary>
        /// This method compensates for the differences in linux versus windows.
        /// </summary>
        /// <param name="files">IList of files</param>
        /// <returns>Returns a clean list of file names</returns>
        private static IList<string> CleanFileNames(IList<string> files)
        {
            IList<string> cleanNames = new List<string>();

            // gets the substring by parsing the string to the first file extension
            foreach (string file in files)
            {
                int fileLength = file.IndexOf(Convert.ToChar(".")) + 4;
                cleanNames.Add(file.Substring(0, fileLength));

            }

            return cleanNames;
        }
    }
}
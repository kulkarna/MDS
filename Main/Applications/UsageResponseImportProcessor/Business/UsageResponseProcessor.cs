using DailyBillingImportProcessor.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UsageResponseImportProcessor.DataAccess;
using UsageResponseImportProcessor.Entities;
using UsageResponseImportProcessor.Transport;

namespace UsageResponseImportProcessor.Business
{
    public class UsageResponseProcessor : IUsageResponseProcessor
    {
        #region Constructor

        public UsageResponseProcessor(IFtp ftp,
                                      IFileManager fileManager,
                                      IUsageResponseFileParser sageResponseFileParser,
                                      IUsageResponseBo usageResponseBo,
                                      IUsageResponseDao usageResponseDao)
        {
            this.ftp = ftp;
            this.fileManager = fileManager;
            this.usageResponseFileParser = sageResponseFileParser;
            this.usageResponseBo = usageResponseBo;
            this.usageResponseDao = usageResponseDao;
        }

        #endregion

        #region Private Members

        /// <summary>
        /// Common object used for ftp process.
        /// </summary>
        private readonly IFtp ftp;
        
        /// <summary>
        /// Common object used for IO file handling.
        /// </summary>
        private readonly IFileManager fileManager;

        /// <summary>
        /// Usage response file parser.
        /// </summary>
        private readonly IUsageResponseFileParser usageResponseFileParser;

        /// <summary>
        /// Usage response business object.
        /// </summary>
        private readonly IUsageResponseBo usageResponseBo;

        /// <summary>
        /// Usage response data access object.
        /// </summary>
        private readonly IUsageResponseDao usageResponseDao;

        #endregion

        #region Process

        /// <summary>
        /// Starts the usage response report process.
        /// </summary>
        public void Start()
        {
            #region 1º Step - Transport Files From FTP to Local Folder

            // Transports the files from provider ftp location to local LibertyPower folder.
            // After the transport, the files from provider ftp location are deleted.

            this.ftp.TransportFiles();

            #endregion

            #region 2º Step - Process And Store usage response (Deduplicate and Combine)
            
            this.fileManager
                .GetFiles()
                .ForEach(
                file =>
                {
                    try
                    {
                        if (!this.usageResponseBo.HeaderIsValid(file.Header))
                            throw new FormatException("Input file header has a invalid format.");

                        var usageResponseFile = this.usageResponseFileParser.Parse(file);

                        this.usageResponseBo.SetUsageResponseFile(usageResponseFile);

                        this.usageResponseBo.ValidateRows();

                        this.usageResponseBo.SaveEdiTransactions();

                        this.usageResponseBo.SaveFile();

                        if (this.usageResponseBo.HasInvalidData() || this.usageResponseBo.HasUnexpectedError())
                            this.fileManager.MoveToBadFile(file.Name);
                        else
                            this.fileManager.RemoveFile(file.Name);
                    }
                    catch (Exception exception)
                    {
                        this.usageResponseDao.Log(exception, file.Name);

                        this.fileManager.MoveToBadFile(file.Name);

                        if (exception is FormatException)
                            this.usageResponseDao.Save(new UsageResponseFile { FileName = file.Name, Status = "Invalid file format" });
                        else
                            this.usageResponseDao.Save(new UsageResponseFile { FileName = file.Name });
                    }
                });

            #endregion
        }

        #endregion
    }
}

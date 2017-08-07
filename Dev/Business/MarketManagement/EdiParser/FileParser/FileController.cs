namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using LibertyPower.Business.CommonBusiness.CommonHelper;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using System.Text.RegularExpressions;

    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
    using System.Data;

    /// <summary>
    /// Entry point for file processing.
    ///  Processes one file at a time. Places file in managed storage and then
    ///   passes responsibility to edi file manager for process flow.
    /// </summary>
    public static class FileController
    {
        //static string fileContent;

        //static System.Diagnostics.PerformanceCounter cpuCounter;
        //static System.Diagnostics.PerformanceCounter ramCounter;
        /// <summary>
        /// Process files from directory
        /// </summary>
        /// <param name="directoryPath">File directory</param>
        public static void ProcessFiles(string directoryPath)
        {
            /*cpuCounter = new System.Diagnostics.PerformanceCounter();
            cpuCounter.CategoryName = "Processor";
            cpuCounter.CounterName = "% Processor Time";
            cpuCounter.InstanceName = "_Total";
            ramCounter = new System.Diagnostics.PerformanceCounter( "Memory", "Available MBytes" ); */

            string[] files = System.IO.Directory.GetFiles(directoryPath);
            foreach (string file in files)
            {

                // create managed file
                FileContext context = FileFactory.CreateManagedFile(file);

                // file identifier in managed storage
                string fileGuid = context.FileGuid.ToString();

                string fileName = context.OriginalFilename;

                // status of file
                string info = EnumHelper.GetEnumDescription(FileStatusInfo.FileInManagedStorage);

                try
                {
                    ProcessFile(context, fileGuid, "", info);
                }
                catch (Exception ex)
                {
                    ExceptionLogger.LogEdiException(fileGuid, fileName, ex.Message);
                }
                //fileContent = null;
            }
        }

        /// <summary>
        /// Reprocess files in managed storage
        /// </summary>
        /// <param name="fileGuids">Managed storage file identifiers</param>
        public static void ProcessFiles(string[] fileGuids)
        {
            // when pulling files from lpcftlfs to lpcnocsql1, part of path (Information Technology)
            // is different (InformationTechnology)...need to replace in order to find file. :O
            string fileServerDriveLetter = ConfigurationManager.AppSettings["FileServerDriveLetter"];
            string networkFileServer = ConfigurationManager.AppSettings["NetworkFileServer"];

            foreach (string fileGuid in fileGuids)
            {
                // create managed file
                FileContext context = FileFactory.GetManagedFileByFileGuid(fileGuid);
                string fullPath = context.FullFilePath.Replace(fileServerDriveLetter, networkFileServer);
                context.FullFilePath = fullPath;


                // status of file
                string info = EnumHelper.GetEnumDescription(FileStatusInfo.FileReprocessing);

                try
                {
                    ProcessFile(context, fileGuid, "", info);
                }
                catch (Exception ex)
                {
                    ExceptionLogger.LogEdiException(fileGuid, context.OriginalFilename, ex.Message);
                }
            }
        }

        /// <summary>
        /// Creates an edi file and process log and then passes 
        /// responsibility to edi file manager for process flow
        /// </summary>
        /// <param name="context">File context object from file manager</param>
        /// <param name="fileGuid">File identifier in managed storage</param>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="info">Log information</param>
        private static void ProcessFile(FileContext context, string fileGuid, string utilityCode, string info)
        {
            try
            {
                string fileName = context.OriginalFilename;

                // get file contents
                string fileContent = FileFactory.GetFileContents(context);

                if (fileContent.Contains("CENTRAL HUDSON GAS & ELECTRIC"))
                    fileContent = fileContent.Replace("\r", "~");

                if (fileContent.Contains("006954317"))
                    fileContent = fileContent.Replace("\n", "~");

                if (fileContent.Contains("006948954"))
                    fileContent = fileContent.Replace("�", "~");

                if (fileContent.Contains("006949002"))
                    fileContent = fileContent.Replace("\n", "~");

                if (fileContent.Contains("006949002"))
                    fileContent = fileContent.Replace("\n", "~");

                if (fileContent.Contains("006908818"))
                    fileContent = fileContent.Replace("", "*");

                if (fileContent.Contains("006999189"))
                    fileContent = fileContent.Replace("\n", "~");
                

                // get field delimiter of file (should always be in same position)
                char fieldDelimiter = Convert.ToChar(fileContent.Substring(3, 1));

                // get file type
                EdiFileType ediFileType = getFileType(ref fileContent, fieldDelimiter);
                int fileType = Convert.ToInt16(ediFileType);

                // log file info and create file log
                EdiFileLog fileLog = Logger.LogFileInfo(0, fileGuid, fileName, utilityCode, 1, info, false, fileType);

                // create process log
                EdiProcessLog processsLog = Logger.LogProcessInfo(0, fileLog.ID, "", false);

                //Verify if the type is DailyControlFile - 1-7490383
                if (ediFileType == EdiFileType.DailyControlFile)
                {
                    try
                    {
                        //Call parser... get te return object and save on database
                        Mappers.DailyControlMapper dailyControlMapper = new Mappers.DailyControlMapper();
                        List<EdiDailyTransaction> ediDailyTransactions = dailyControlMapper.MapData(fileContent);

                        TransactionsSql.InsertEdiDailyTransactionBulkCopy(createEdiDailyTransactionDataTable(ediDailyTransactions, fileLog.ID));
                        TransactionsSql.InsertEdiDailyTransaction();
                        /*
                                                foreach( EdiDailyTransaction ediDailyTransaction in ediDailyTransactions )
                                                {
                                                    TransactionsSql.InsertEdiDailyTransaction( ediDailyTransaction.DunsNumber, fileLog.ID, ediDailyTransaction.AccountNumber,
                                                                                              ediDailyTransaction.TransactionNumber,
                                                                                              ediDailyTransaction.TransactionDate, ediDailyTransaction.RequestType,
                                                                                              ediDailyTransaction.TransactionReferenceNumber,
                                                                                              ediDailyTransaction.Direction, ediDailyTransaction.Tstatus,
                                                                                              ediDailyTransaction.FileName );
                                                }
                        */
                        fileLog.Information = EnumHelper.GetEnumDescription(FileStatusInfo.FileSuccessfullyParsed);
                        fileLog.IsProcessed = true;
                        Logger.LogFileInfo(fileLog);
                    }
                    catch (Exception)
                    {
                        fileLog.Information = EnumHelper.GetEnumDescription(FileStatusInfo.FileHasOneOrMoreErrors);
                        fileLog.IsProcessed = false;
                        Logger.LogFileInfo(fileLog);
                    }
                }
                else
                {
                    // pass responsibility to edi file manager for process flow
                    processContent(ref fileContent, fileLog.FileGuid, ref fileLog, ref processsLog, ref fieldDelimiter, ref ediFileType);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static DataTable createEdiDailyTransactionDataTable(List<EdiDailyTransaction> ediDailyTransactions, int fileLogId)
        {
            DataTable dtEdiDailyTransaction = new DataTable("EdiDailyTransactionTemp");
            DataRow drEdiDailyTransaction;

            dtEdiDailyTransaction.Columns.Add("Edifilelogid", typeof(int));
            dtEdiDailyTransaction.Columns.Add("DunsNumber", typeof(string));
            dtEdiDailyTransaction.Columns.Add("AccountNumber", typeof(string));
            dtEdiDailyTransaction.Columns.Add("TransactionNumber", typeof(string));
            dtEdiDailyTransaction.Columns.Add("TransactionDate", typeof(DateTime));
            dtEdiDailyTransaction.Columns.Add("RequestType", typeof(string));
            dtEdiDailyTransaction.Columns.Add("TransactionReferenceNumber", typeof(string));
            dtEdiDailyTransaction.Columns.Add("Direction", typeof(string));
            dtEdiDailyTransaction.Columns.Add("Tstatus", typeof(int));
            dtEdiDailyTransaction.Columns.Add("FileName", typeof(string));

            foreach (EdiDailyTransaction ediDailyTransaction in ediDailyTransactions)
            {
                drEdiDailyTransaction = dtEdiDailyTransaction.NewRow();
                drEdiDailyTransaction["Edifilelogid"] = fileLogId;
                drEdiDailyTransaction["DunsNumber"] = ediDailyTransaction.DunsNumber;
                drEdiDailyTransaction["AccountNumber"] = ediDailyTransaction.AccountNumber;
                drEdiDailyTransaction["TransactionNumber"] = ediDailyTransaction.TransactionNumber;
                drEdiDailyTransaction["TransactionDate"] = ediDailyTransaction.TransactionDate;
                drEdiDailyTransaction["RequestType"] = ediDailyTransaction.RequestType;
                drEdiDailyTransaction["TransactionReferenceNumber"] = ediDailyTransaction.TransactionReferenceNumber;
                drEdiDailyTransaction["Direction"] = ediDailyTransaction.Direction;
                drEdiDailyTransaction["Tstatus"] = ediDailyTransaction.Tstatus;
                drEdiDailyTransaction["FileName"] = ediDailyTransaction.FileName;

                dtEdiDailyTransaction.Rows.Add(drEdiDailyTransaction);
            }

            return dtEdiDailyTransaction;
        }

        private static void processContent(ref string fileContent, string fileGuid, ref EdiFileLog ediFileLog, ref EdiProcessLog ediProcesssLog, ref char fieldDelimiter, ref EdiFileType ediFileType)
        {
            bool doProcess = true;

            // create edi file list to be used for serialization for eye candy
            //EdiFileList ediFileList = new EdiFileList();

            if (fileContent.Contains("CENTRAL HUDSON GAS & ELEC CORP"))
                fileContent = fileContent.Replace("\r", "~");

            // get duns number
            string dunsNumber = getDuns(ref fileContent, fieldDelimiter);
            if (dunsNumber == string.Empty)
                throw new Exception("Duns number is empty. Please notify technical support.");

            // get the utility config based on the duns number
            UtilityConfig config = ConfigurationFactory.GetUtilityConfigurations(dunsNumber);

            if (config == null)
                throw new Exception("Utility cannot be found based on the Duns'" + dunsNumber + "'" + ". Please notify technical support.");

            if (!config.Parsable)
                throw new Exception("Parser turned off for " + config.Code + "; please notify technical support.");

            // set the utility code in the edi file log
            ediFileLog.UtilityCode = config.UtilityCode;

            // validate file configuration
            FileConfigDataExistsRule configRule = Validator.ValidateFileConfiguration(dunsNumber, ref fileContent, fieldDelimiter, config);

            // bug 2848
            if (config.UtilityCode == "O&R" && fileContent.Contains("N1*8S*"))
            {
                int idx = fileContent.IndexOf("N1*8S*") + 6;

                if ((fileContent.Substring(idx, 25) == "ROCKLAND ELECTRIC COMPANY"))
                    config.UtilityCode = "ORNJ";
            }

            if (configRule.DefaultSeverity.Equals(BrokenRuleSeverity.Error))
                doProcess = false;

            // bug 2841
            if (config.UtilityCode == "UGI" | config.UtilityCode == "DUQ")
            {
                string eightSixSevenList = "";
                string eightOneFourList = "";

                Processor.breakTransactionTypes(ref fileContent, ref eightSixSevenList, ref eightOneFourList, config.FieldDelimiter, config.RowDelimiter);

                // parse file contents returning generic file rows with file cells for mapping
                if (eightOneFourList != "")
                {
                    /*ediFileList.Add(*/
                    fileContent = eightOneFourList;
                    processFileDetails(ref fileContent, fileGuid, config, ediFileLog, ediProcesssLog, EdiFileType.EightOneFour);// );
                }
                if (eightSixSevenList != "")
                /*ediFileList.Add(*/
                {
                    fileContent = eightSixSevenList;
                    processFileDetails(ref fileContent, fileGuid, config, ediFileLog, ediProcesssLog, EdiFileType.EightSixSeven);// );
                }
            }
            else
            {
                switch (ediFileType)
                {
                    case EdiFileType.EightSixSeven:
                    case EdiFileType.EightOneFour:
                        {
                            if (doProcess) // have necessary configuration data, process file
                                /*ediFileList.Add(*/
                                processFileDetails(ref fileContent, fileGuid, config, ediFileLog, ediProcesssLog, ediFileType);// );
                            else // do not process file
                                ExceptionLogger.LogFileExceptions(ediFileLog, configRule);

                            break;
                        }
                    case EdiFileType.StatusUpdate: // no processing for status update files
                        {
                            string info = EnumHelper.GetEnumDescription(FileStatusInfo.FileStatusUpdate);
                            ExceptionLogger.LogFileExceptions(ediFileLog, info);
                            break;
                        }
                }
            }
        }

        public static void processContent(string fileContent, ref char fieldDelimiter, ref char rowDelimiter,ref bool isMix,ref string utilityCode,ref string marketCode)
        {

            // create edi file list to be used for serialization for eye candy
            //EdiFileList ediFileList = new EdiFileList();

            if (fileContent.Contains("CENTRAL HUDSON GAS & ELEC CORP"))
                fileContent = fileContent.Replace("\r", "~");

            // get duns number
            string dunsNumber = getDuns(ref fileContent, fieldDelimiter);
            if (dunsNumber == string.Empty)
                return;

            // get the utility config based on the duns number
            UtilityConfig config = ConfigurationFactory.GetUtilityConfigurations(dunsNumber);
            
            if (config == null)
                throw new Exception("Utility cannot be found based on the Duns'" + dunsNumber + "'" + ". Please notify technical support.");

            if (!config.Parsable)
                throw new Exception("Parser turned off for " + config.Code + "; please notify technical support.");

            if (utilityCode != config.UtilityCode)
            {
                utilityCode = config.UtilityCode;
                marketCode = config.RetailMarketCode;
                isMix = true;
            }
            // validate file configuration
            FileConfigDataExistsRule configRule = Validator.ValidateFileConfiguration(dunsNumber, ref fileContent, fieldDelimiter, config);
            
            // bug 2848
            if (config.UtilityCode == "O&R" && fileContent.Contains("N1*8S*"))
            {
                int idx = fileContent.IndexOf("N1*8S*") + 6;

                if ((fileContent.Substring(idx, 25) == "ROCKLAND ELECTRIC COMPANY"))
                    config.UtilityCode = "ORNJ";
            }

            fieldDelimiter = config.FieldDelimiter;
            rowDelimiter = config.RowDelimiter;

        }

        private static EdiFile processFileDetails(ref string fileContent, string fileGuid, UtilityConfig utilityConfig, EdiFileLog fileLog, EdiProcessLog processLog, EdiFileType fileType)
        {
            string file = utilityConfig.FullName;
            string dunsNumber = utilityConfig.DunsNumber;
            string utilityCode = utilityConfig.UtilityCode;
            string marketCode = utilityConfig.RetailMarketCode;
            char rowDelimiter = utilityConfig.RowDelimiter;
            char fieldDelimiter = utilityConfig.FieldDelimiter;

            // create top level object
            EdiFile ediFile = new EdiFile(fileGuid, file, dunsNumber, utilityCode);

            ediFile.FileType = fileType;
            ediFile.EdiFileLog = fileLog;
            ediFile.EdiProcessLog = processLog;

            // get file log id for referencing account list
            int ediFileLogID = ediFile.EdiFileLog.ID;

            // parse file contents returning generic file rows with file cells for mapping
            bool bError = ParserFactory.CreateFileEdi(ref fileContent, rowDelimiter, fieldDelimiter, utilityCode, marketCode, fileType, fileGuid, ediFileLogID);

            EdiFileLog finalFileLog = ediFile.EdiFileLog;

            // if file did not have "errors", then log success
            if (!bError)
            {
                finalFileLog.Information = EnumHelper.GetEnumDescription(FileStatusInfo.FileSuccessfullyParsed);
                finalFileLog.IsProcessed = true;
                Logger.LogFileInfo(finalFileLog);
            }
            else // file has one or more errors
            {
                finalFileLog.Information = EnumHelper.GetEnumDescription(FileStatusInfo.FileHasOneOrMoreErrors);
                finalFileLog.IsProcessed = false;
                Logger.LogFileInfo(finalFileLog);
            }
            return ediFile;
        }


        private static string getDuns(ref string fileContent, char delimiter)
        {
            // The DUNS is the fourth cell found in the matching pattern.
            const int cellMatch = 3;
            const int cellReturn = 4;

            //Process currentProcess = Process.GetCurrentProcess();


            /*System.Text.UTF8Encoding encoding = new System.Text.UTF8Encoding();
            byte[] OriginalBuffer = encoding.GetBytes( fileContent );

            int numBytesToRead = OriginalBuffer.Length;

            byte[] finalBuffer = new byte[numBytesToRead];
                int i = 0;
                foreach( byte bb in OriginalBuffer )
                {
                    //remove "&" | "(" - ")" |  "-" | "," |  "."
                    if( bb == 38 || bb == 40 || bb == 41 || bb == 45 | bb == 46 )
                        continue;
                    Buffer.SetByte( finalBuffer, i, bb );
                    i++;
                }
            string fcClean =null;
            if( Encoding.ASCII.GetString( finalBuffer ).IndexOf( "\r\n" ) > -1 )
                fcClean = Encoding.ASCII.GetString( finalBuffer ).Replace( "\r\n", delimiter.ToString() );
            else
                fcClean = Encoding.ASCII.GetString( finalBuffer );*/

            /***
             * 
             * Pattern that will extract the beginning of the file up and including the DUNS.
             * 
             * ^ indicates that match must start at the beginning and that ^ISA it starts with ISA.
             * 
             * \^ is a charet character since ^ alone means something else.
             *
             * [\d\w\s]* means zero or more digits, words, or blank characters.
             * 
             * (?=\^) it's a lookahead and it means that the previous pattern matches only 
             * if it is succeeded by a ^ but does not consume the ^.
             * 
            ***/

            //string pattern = @"N1\" + delimiter + @"8S(\" + delimiter + @"([\d\w\s]*)){" + cellMatch.ToString() + "}";
            string pattern = @"N1\" + delimiter + @"8S(\" + delimiter + @"([\d\w\s&\-,\.()]*)){" + cellMatch.ToString() + "}";
            Regex r = new Regex(pattern);

            // Match the pattern within the file content.
            Match m = r.Match(fileContent);

            // Split the resulting string into cells.
            string[] cells = m.Value.Split(new char[] { Convert.ToChar(delimiter) });

            if (cells.Length < cellReturn)
                return "";

            // Extract the DUNS from the specific cell position.
            string duns = cells[cellReturn].Trim();
            if (duns != null && duns.IndexOf("\r\n") > -1)
                duns = duns.Substring(0, duns.IndexOf("\r\n"));
            return duns;
        }

        private static EdiFileType getFileType(ref string fileContent, char fieldDelimiter)
        {
            EdiFileType ediFileType;
            string pattern;
            Regex r;

            if (fieldDelimiter == char.Parse("P"))
            {
                pattern = "ASP_TPID";
                r = new Regex(pattern);

                // Match the pattern within the file content.
                Match m = r.Match(fileContent);
                if (m.Success)
                    ediFileType = EdiFileType.DailyControlFile;
                else
                    throw new ApplicationException("Pattern not found on fileContent");
            }
            else
            {
                pattern = @"ST\" + fieldDelimiter + @"814";

                r = new Regex(pattern);

                // Match the pattern within the file content.
                Match m = r.Match(fileContent);
                if (m.Success)
                    ediFileType = EdiFileType.EightOneFour;
                else
                {
                    pattern = @"BPT\" + fieldDelimiter + @"SU";
                    r = new Regex(pattern);

                    // Match the pattern within the file content.
                    m = r.Match(fileContent);

                    if (m.Success)
                        ediFileType = EdiFileType.StatusUpdate;
                    else
                        ediFileType = EdiFileType.EightSixSeven;
                }
            }
            return ediFileType;
        }
        /*
        // Call this method every time you need to know the current cpu usage. 
        public static string getCurrentCpuUsage()
        {      
            return cpuCounter.NextValue()+"%";
        }

        // Call this method every time you need to get the amount of the available RAM in Mb 
        public static string getAvailableRAM()
        {
            return ramCounter.NextValue() + "Mb";
        }
        */
    }
}

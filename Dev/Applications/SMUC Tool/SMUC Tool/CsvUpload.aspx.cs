using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CsvHelper;
using System.Text;
using System.IO;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using System.Data;
using SmucDataLayer;
using SmucBusinessLayer;
using SmucBusinessLayer.UsageServiceWcf;

namespace SMUC_Tool
{
    public partial class SMUCUpload : System.Web.UI.Page
    {




        #region private variables


        private string _accountNumber = string.Empty;
        private string _utilityCode = string.Empty;
        private string _appName = "SMUC";
        private const string NAMESPACE = "SMUC_Tool";
        private const string CLASS = "SMUCUpload";
        private ILogger _logger = null;
        private IBusinessLayer _businessLayer = null;
        private IDal _dal = null;
        private const string spliter = "\t";
        #endregion
        string messageId = Guid.NewGuid().ToString();
        BulkRequestResponse bulkRequestResponse;
        protected void Page_Load(object sender, EventArgs e)
        {

            string method = "Page_Load()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _dal = new Dal(messageId, _logger);
                _businessLayer = new BusinessLayer(messageId, _logger, _dal);
                if (!IsPostBack)
                {
                    Session["Output"] = null;
                }
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            string method = "btnUpload_Click";
            DateTime beginDate = DateTime.Now;
            
            try
            {
               // dvProgress.Visible = true;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                StringBuilder stringBuilder = new StringBuilder();
                string FilePath = string.Empty;
                if (csvFileUploader.PostedFile.FileName == string.Empty)
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Error :{3}", NAMESPACE, CLASS, method, "File Doesn't Exist!"));
                    lblMessage.Text = "File Doesn't Exist!";
                    Session["Output"] = null;
                    btnDownload.Visible = false;
                    return;
                }
                else
                {

                    string[] FileExt = csvFileUploader.FileName.Split('.');
                    HttpPostedFile file = null;
                    string FileEx = FileExt[FileExt.Length - 1];
                    if (FileEx.ToLower() == "csv" || FileEx.ToLower() == "txt")
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Extention CSV/Text", NAMESPACE, CLASS, method));
                        if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} File Object Created.", NAMESPACE, CLASS, method));
                            file = Request.Files[0];
                        }
                    }
                    else
                    {
                        _logger.LogError(messageId, string.Format("{0}.{1}.{2} Error :{3}", NAMESPACE, CLASS, method, "Invalid File Extention !"));
                        lblMessage.Text = "Invalid File Extention !";
                        Session["Output"] = null;
                        btnDownload.Visible = false;
                        return;
                    }

                    using (var sr = new StreamReader(file.InputStream))
                    {
                        var reader = new CsvReader(sr);
                        reader.Configuration.Delimiter = spliter;
                        reader.Configuration.DetectColumnCountChanges = true;
                        reader.Configuration.HasHeaderRecord = true;
                        reader.Configuration.IgnoreHeaderWhiteSpace = true;
                        reader.Configuration.IsHeaderCaseSensitive = false;
                        //CSVReader will now read the whole file into an List Collection
                        List<DataRecord> records = reader.GetRecords<DataRecord>().ToList<DataRecord>();
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Data Mapped Successfully !", NAMESPACE, CLASS, method));
                        if (records.Count <= 0)
                        {
                            _logger.LogError(messageId, string.Format("{0}.{1}.{2} Error : File Have No Records !", NAMESPACE, CLASS, method));
                            lblMessage.Text = "Error File Have No Records !";
                            return;

                        }
                        foreach (DataRecord record in records)
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} AccountNumber is :{3},utiltiycode is :{4}", NAMESPACE, CLASS, method, record.AccountNumber, record.UtilityCode));

                        }

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Begin _businessLayer.RunProcess(records) ", NAMESPACE, CLASS, method));
                        bulkRequestResponse = _businessLayer.RunProcess(messageId, records);

                        foreach (string key in bulkRequestResponse.Results.Keys)
                        {
                            stringBuilder.AppendLine(string.Format("AccountNumber:{0};Message:{1}", key, bulkRequestResponse.Results[key]));
                        }

                        ViewState["OutPut"] = stringBuilder.ToString();
                        ViewState["dtTransactionTable"] = bulkRequestResponse.dtTransactions;
                        btnDownload.Visible = true;
                       // btnFileStatusDownload.Visible = true;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End _businessLayer.RunProcess(records) ", NAMESPACE, CLASS, method));
                        lblMessage.Text = "File Submitted Successfully!";
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}  File Submitted Successfully !", NAMESPACE, CLASS, method));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End", NAMESPACE, CLASS, method));

                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }

            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                lblMessage.Text = "Error Occured While Submitting the File !";
                ViewState["OutPut"] = null;
                ViewState["dtTransactionTable"] = null;
            }
        }

        private MemoryStream ConvertStringToMemoryStream(string messageId, string output)
        {
            string method = string.Format("ConvertStringToMemoryStream(messageId, output:{0})", Utilities.Common.NullSafeString(output));
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (StreamWriter streamWriter = new StreamWriter(memoryStream))
                    {
                        streamWriter.Write(output.ToString());
                        streamWriter.Flush();
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return fr END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                        return memoryStream;
                    }
                }
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            string method = "btnDownload_Click";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                string outPut = Common.NullSafeString(ViewState["OutPut"]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} OutPut : {3}", NAMESPACE, CLASS, method, outPut));
                MemoryStream memoryStream = ConvertStringToMemoryStream(messageId, outPut);
                DateTime now = DateTime.Now;
                string outputName = string.Format("SmucIsta{0}{1}{2}{3}{4}{5}{6}", now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, now.Millisecond);
                string fileName = outputName + ".txt";
                Response.Clear();
                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                Response.AddHeader("Content-Length", memoryStream.ToArray().Length.ToString());
                Response.ContentType = "application/octet-stream";
                Response.BinaryWrite(memoryStream.ToArray());
                Response.Flush();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }

       

        protected void btnFileStatusDownload_Click(object sender, EventArgs e)
        {
            string method = "btnFileStatusDownload_Click";
            DateTime beginDate = DateTime.Now;
            DataTable dtResults;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                dtResults = (DataTable)(ViewState["dtTransactionTable"]);
                dtResults = _businessLayer.GetProcessingDetailByTransactionId(messageId, dtResults);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dtResults Records Successfully Processed.", NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN GetOutPutFromDataTable(messageId,dtResults)", NAMESPACE, CLASS, method));
                string outPut = GetOutPutFromDataTable(messageId,dtResults);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End GetOutPutFromDataTable(messageId,dtResults) OutPut : {3}", NAMESPACE, CLASS, method,outPut));
                MemoryStream memoryStream = ConvertStringToMemoryStream(messageId, outPut);
                DateTime now = DateTime.Now;
                string outputName = string.Format("SmucIsta{0}{1}{2}{3}{4}{5}{6}", now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, now.Millisecond);
                string fileName = outputName + ".txt";
                Response.Clear();
                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                Response.AddHeader("Content-Length", memoryStream.ToArray().Length.ToString());
                Response.ContentType = "application/octet-stream";
                Response.BinaryWrite(memoryStream.ToArray());
                Response.Flush();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));


            }
        }

        private string GetOutPutFromDataTable(string messageId,DataTable dtResults)
        {
            string method = "GetOutPutFromDataTable(string messageId,DataTable dtResults)";
            DateTime beginDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                foreach (DataRow datarowResult in dtResults.Rows)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Inside Foreach Loop", NAMESPACE, CLASS, method));
                    string accountNumber = Common.NullSafeString(datarowResult["AccountNumber"]);
                    string utilityCode = Common.NullSafeString(datarowResult["UtilityCode"]);
                    Boolean isComplete = false;
                    Boolean.TryParse(Common.NullSafeString(datarowResult["IsComplete"]), out isComplete);
                    string error = Common.NullSafeString(datarowResult["Error"]);
                    string source = Common.NullSafeString(datarowResult["Source"]);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} accountNumber : {3},utilityCode : {4}, isComplete : {5},error : {6},source : {7}", NAMESPACE, CLASS, method,accountNumber,utilityCode,Common.NullSafeString(isComplete),error,source));
                    if (isComplete && !string.IsNullOrEmpty(error))
                    {
                        sb.AppendLine(string.Format("AccountNumber:{0};Message:Account Processed Successfully  for {1} !", accountNumber,source));
                    }
                    else if (isComplete && string.IsNullOrEmpty(error))
                    {
                        sb.AppendLine(string.Format("AccountNumber:{0};Message : Error While Processing File  for {1} Error Message : {2}", accountNumber, source,error));
                    }
                    else if (!isComplete)
                    {
                        sb.AppendLine(string.Format("AccountNumber:{0};Message:Account Processing in Progress for {1}!", accountNumber,source));
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} sb.ToString() : {3}", NAMESPACE, CLASS, method, Common.NullSafeString(sb.ToString())));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return sb.ToString();
                
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            return null;

            
        }


    }
}
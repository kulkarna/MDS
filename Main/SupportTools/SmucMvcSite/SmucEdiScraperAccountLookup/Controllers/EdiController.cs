using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using SmucRunBusinessLayer;
using SmucRunDataAccessLayer;

using UtilityLogging;
using UtilityUnityLogging;
using Utilities;


namespace SmucEdiScraperAccountLookup.Controllers
{
    public class EdiController : Controller
    {
        #region private variables
        private const string NAMESPACE = "SmucEdiScraperAccountLookup.Controllers";
        private const string CLASS = "EdiController";

        private ILogger _logger = null;
        private IBusinessLayer _businessLayer = null;
        private IDal _dal = null;
        #endregion


        #region public constructors
        public EdiController()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "EdiController()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _dal = new Dal(messageId, _logger);
                _businessLayer = new BusinessLayer(messageId, _logger, _dal);
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }
        #endregion


        [AllowAnonymous]
        public ActionResult Index(string messageId)
        {
            string method = "Index(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                ViewBag.Message = "SMUC Edi";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View();
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View("Error");
            }
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult Index()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "Index() [HttpPost]";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // declare variables
                FileResult fr = null;
                StringBuilder stringBuilder = new StringBuilder();

                // validate Request object
                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    // transform file into bytes
                    HttpPostedFileBase file = Request.Files[0];
                    BinaryReader binaryReader = new BinaryReader(file.InputStream);
                    byte[] byteArray = binaryReader.ReadBytes((int)file.InputStream.Length);

                    // process bytes
                    BulkEdiRequestResponse bulkEdiRequestResponse = _businessLayer.BulkEdiRequestWithResponse(messageId, byteArray);

                    foreach (string key in bulkEdiRequestResponse.Results.Keys)
                    {
                        stringBuilder.AppendLine(string.Format("AccountNumber:{0};Message:{1}", key, bulkEdiRequestResponse.Results[key]));
                    }

                    // generate output file
                    MemoryStream memoryStream = ConvertStringToMemoryStream(messageId, stringBuilder.ToString());
                    DateTime now = DateTime.Now;
                    string outputName = string.Format("SmucIsta{0}{1}{2}{3}{4}{5}{6}", now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, now.Millisecond);
                    fr = File(memoryStream.ToArray(), "text/csv", outputName);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return fr END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                return fr;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View("Error");
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

    }
}

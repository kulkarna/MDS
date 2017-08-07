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
    public class FileUploadController : Controller
    {
        #region private variables
        private const string NAMESPACE = "SmucEdiScraperAccountLookup.Controllers";
        private const string CLASS = "FileUploadController";

        private ILogger _logger = null;
        private IBusinessLayer _businessLayer = null;
        private IDal _dal = null;
        #endregion


        #region public constructors
        public FileUploadController()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "FileUploadController()";
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

                ViewBag.Message = "SMUC File Upload";

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

                FileResult fr = null;

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    BinaryReader binaryReader = new BinaryReader(file.InputStream);
                    byte[] byteArray = binaryReader.ReadBytes((int)file.InputStream.Length);

                    MemoryStream memoryStream = _businessLayer.Process(messageId, byteArray);
                    DateTime now = DateTime.Now;
                    string outputName = string.Format("Smuc{0}{1}{2}{3}{4}{5}{6}", now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, now.Millisecond);
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
    }
}

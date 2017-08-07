using System;
using System.Configuration;
using log4net;
using log4net.Config;

namespace UtilityLogging
{
    /// <summary>
    /// Class Logger.
    /// </summary>
    public class Logger : ILogger
    {
        #region public methods
        /// <summary>
        /// Logs the debug.
        /// </summary>
        /// <param name="e">The e.</param>
        public void LogDebug(object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                //logger.Debug(string.Format("{0} DEBUG {1}", CreateTimeStamp(), e.ToString()));
                logger.Debug(string.Format("{0}", e.ToString()));
            else
                logger.Debug("NULL Log Data DEBUG");
        }

        /// <summary>
        /// Logs the debug.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        public void LogDebug(string messageId, object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                //logger.Debug(string.Format("{0} {1} DEBUG {2}", messageId, CreateTimeStamp(), e.ToString()));
                logger.Debug(string.Format("{0} {1}", messageId, e.ToString()));
            else
                logger.Debug(string.Format("{0} NULL Log Data DEBUG", messageId));
        }

        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="e">The e.</param>
        public void LogError(object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                logger.Error(string.Format("{0} ERROR {1}", CreateTimeStamp(), e.ToString()));
            else
                logger.Error("NULL Log Data ERROR");
        }

        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        public void LogError(string messageId, object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                logger.Error(string.Format("{0} {1} ERROR {2}", messageId, CreateTimeStamp(), e.ToString()));
            else
                logger.Error(string.Format("{0} NULL Log Data ERROR", messageId));
        }

        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="e">The e.</param>
        /// <param name="exc">The exc.</param>
        public void LogError(object e, Exception exc)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                logger.Error(string.Format("{0} ERROR {1}", CreateTimeStamp(), e.ToString()));
            else
                logger.Error("NULL Log Data ERROR");
        }

        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        /// <param name="exc">The exc.</param>
        public void LogError(string messageId, object e, Exception exc)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                logger.Error(string.Format("{0} ERROR {1}", messageId, e.ToString()));
            else
                logger.Error(string.Format("{0} NULL Log Data ERROR", messageId));
        }

        /// <summary>
        /// Logs the information.
        /// </summary>
        /// <param name="e">The e.</param>
        public void LogInfo(object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                //logger.Info(string.Format("{0} INFO {1}", CreateTimeStamp(), e.ToString()));
                logger.Info(string.Format("{0}", e.ToString()));
            else
                logger.Info("NULL Log Data INFO");
        }

        /// <summary>
        /// Logs the information.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        public void LogInfo(string messageId, object e)
        {
            XmlConfigurator.Configure();
            ILog logger = LogManager.GetLogger(ConfigurationManager.AppSettings["LOGGER_NAME"]);
            if (e != null)
                //logger.Info(string.Format("{0} {1} INFO {2}", messageId, CreateTimeStamp(), e.ToString()));
                logger.Info(string.Format("{0} {1}", messageId, e.ToString()));
            else
                logger.Info(string.Format("{0} NULL Log Data INFO", messageId));
        }
        #endregion


        #region private methods
        /// <summary>
        /// Creates the time stamp.
        /// </summary>
        /// <returns>System.String.</returns>
        private string CreateTimeStamp()
        {
            return string.Format("{0}-{1}-{2} {3}:{4}:{5}.{6}", DateTime.Now.Year.ToString(), DateTime.Now.Month.ToString(), DateTime.Now.Day.ToString(),
                DateTime.Now.Hour.ToString(), DateTime.Now.Minute.ToString(), DateTime.Now.Second.ToString(), DateTime.Now.Millisecond.ToString());
        }
        #endregion
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityLogging
{
    /// <summary>
    /// Interface ILogger
    /// </summary>
    public interface ILogger
    {
        /// <summary>
        /// Logs the debug.
        /// </summary>
        /// <param name="e">The e.</param>
        void LogDebug(object e);
        /// <summary>
        /// Logs the debug.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        void LogDebug(string messageId, object e);
        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="e">The e.</param>
        void LogError(object e);
        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        void LogError(string messageId, object e);
        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="e">The e.</param>
        /// <param name="exc">The exc.</param>
        void LogError(object e, Exception exc);
        /// <summary>
        /// Logs the error.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        /// <param name="exc">The exc.</param>
        void LogError(string messageId, object e, Exception exc);
        /// <summary>
        /// Logs the information.
        /// </summary>
        /// <param name="e">The e.</param>
        void LogInfo(object e);
        /// <summary>
        /// Logs the information.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="e">The e.</param>
        void LogInfo(string messageId, object e);
    }
}

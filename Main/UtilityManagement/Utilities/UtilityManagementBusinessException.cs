using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    /// <summary>
    /// Class UtilityManagementBusinessException.
    /// </summary>
    [Serializable]
    public class UtilityManagementBusinessException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="UtilityManagementBusinessException"/> class.
        /// </summary>
        /// <param name="transactionId">The transaction identifier.</param>
        /// <param name="code">The code.</param>
        /// <param name="message">The message.</param>
        public UtilityManagementBusinessException(string transactionId, string code, string message)
        {
            TransactionId = transactionId;
            Code = code;
            Message = message;
        }

        /// <summary>
        /// Gets or sets the transaction identifier.
        /// </summary>
        /// <value>The transaction identifier.</value>
        public string TransactionId { get; set; }
        /// <summary>
        /// Gets or sets the code.
        /// </summary>
        /// <value>The code.</value>
        public string Code { get; set; }
        /// <summary>
        /// Gets a message that describes the current exception.
        /// </summary>
        /// <value>The message.</value>
        /// <returns>The error message that explains the reason for the exception, or an empty string("").</returns>
        public string Message { get; set; }
    }
}

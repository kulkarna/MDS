using System;

namespace CrmServiceAccountUpdater
{
    /// <summary>
    /// Represents an account.
    /// </summary>
    public class Account
    {
        #region Fields

        /// <summary>
        /// Number of the account.
        /// </summary>
        public string Number { get; set; }

        /// <summary>
        /// Utility ID.
        /// </summary>
        public string UtilityId { get; set; }

        /// <summary>
        /// Utility code.
        /// </summary>
        public string UtilityCode { get; set; }

        /// <summary>
        /// Usage date.
        /// </summary>
        public DateTime UsageDate { get; set; }

        /// <summary>
        /// Usage.
        /// </summary>
        public int Usage { get; set; }

        /// <summary>
        /// Annual usage updated date with the last usage update.
        /// </summary>
        public DateTime AnnualUsageUpdatedDate { get; set; }

        #endregion
    }
}
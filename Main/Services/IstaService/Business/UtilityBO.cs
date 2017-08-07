using LibertyPower.DataAccess.WebServiceAccess.IstaWebService.DataAccess;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Business
{
    /// <summary>
    /// Executes business logic related to utilities.
    /// </summary>
    interface IUtilityBO
    {
        /// <summary>
        /// Adjusts the name-key:
        ///   1. If the name-key is null, returns null.
        ///   2. If the name-key is empty or consists only of white-spaces, returns null.
        ///   3. If the name-key has content, truncates or pads the name key to its maximum size according to utility's name-key pattern.
        /// </summary>
        /// <param name="utilityId">The id of the utility from which retrieve the pattern.</param>
        /// <param name="nameKey">The original name-key string.</param>
        /// <returns>The adjusted name-key value.</returns>
        string AdjustNameKey(int utilityId, string nameKey);
    }

    sealed class UtilityBO : IUtilityBO
    {
        private readonly IUtilityDAO utilityDAO;
        private readonly IRegexHelper regexHelper;

        public UtilityBO(IUtilityDAO dao = null, IRegexHelper helper = null)
        {
            this.utilityDAO = dao ?? new UtilityDAO();
            this.regexHelper = regexHelper ?? new RegexHelper();
        }

        public string AdjustNameKey(int utilityId, string nameKey)
        {
            if (string.IsNullOrWhiteSpace(nameKey))
                return null;

            var nameKeyPattern = utilityDAO.GetNameKeyPattern(utilityId);
            var maximumSize = regexHelper.GetMaximumSize(nameKeyPattern);

            if (maximumSize == 0)
                return nameKey;

            if (nameKey.Length <= maximumSize)
                return nameKey.PadRight(maximumSize);
            else
                return nameKey.Substring(0, maximumSize);
        }
    }
}

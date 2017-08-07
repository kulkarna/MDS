using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Util
{
    interface IRegexHelper
    {
        /// <summary>
        /// Returns the maximum size of a matching string for the supplied regular expression (pattern).
        /// If no maximum limit is found, returns 0.
        /// </summary>
        /// <param name="pattern">The pattern to analyze.</param>
        /// <returns>The maximum size of a matching string or zero.</returns>
        int GetMaximumSize(string pattern);
    }

    sealed class RegexHelper : IRegexHelper
    {
        public int GetMaximumSize(string pattern)
        {
            if (string.IsNullOrWhiteSpace(pattern))
                return 0;

            // This expression will capture the maximum sizes defined in a regular expression, like:
            //   /[a-z]{3}/g            -> will match 3       <n2>
            //   /[a-z]{,3}[\d*]{0,5}/g -> will match 3 and 5 <n1>
            var getMaximumLimitsExpression = new Regex(@"\{\d*,(?<n1>\d*)\}|\{(?<n2>\d*)\}");

            var limitsMatches = getMaximumLimitsExpression.Matches(pattern);
            var maxLimits = new List<string>();
            foreach (Match match in limitsMatches)
            {
                Action<string> addToLimitsIfFound = (groupName) =>
                {
                    if (match.Groups[groupName] != null && !string.IsNullOrEmpty(match.Groups[groupName].Value))
                        maxLimits.Add(match.Groups[groupName].Value);
                };

                addToLimitsIfFound("n1");
                addToLimitsIfFound("n2");
            }

            return maxLimits
                .Select(x => ToIntOrZero(x))
                .Sum();
        }

        #region Auxiliary

        /// <summary>
        /// Converts the supplied string to a valid int or zero.
        /// </summary>
        /// <param name="source">Source string.</param>
        /// <returns>The resulting conversion or zero.</returns>
        private int ToIntOrZero(string source)
        {
            int result = 0;
            int.TryParse(source, out result);

            return result;
        }

        #endregion
    }

    #region Tests -> Should be moved to a separate project

    /*
     * This test guarantees that the regex pattern is parsed correctly.
     * Please, avoid removing it.
     */


    [TestClass]
    public class RgexHelperTests
    {
        [TestMethod]
        public void ShouldGetMaximumStringLengthFromExpression()
        {
            var maximumSize4 = new RegexHelper().GetMaximumSize("^[a-zA-z]{4}$");
            var maximumSize7 = new RegexHelper().GetMaximumSize("^[a-z]{3}[a-zA-z]{4}$");
            var maximumSize10 = new RegexHelper().GetMaximumSize("^[a-zA-z]{0,10}$");
            var maximumSize13 = new RegexHelper().GetMaximumSize("^[a-z]{0,7}[a-zA-z]{0,6}$");
            var maximumSize16 = new RegexHelper().GetMaximumSize("^[a-zA-z]{,16}$");
            var maximumSize19 = new RegexHelper().GetMaximumSize("^[a-z]{,3}[a-zA-z]{,16}$");

            Assert.AreEqual(maximumSize4, 4);
            Assert.AreEqual(maximumSize7, 7);
            Assert.AreEqual(maximumSize10, 10);
            Assert.AreEqual(maximumSize13, 13);
            Assert.AreEqual(maximumSize16, 16);
            Assert.AreEqual(maximumSize19, 19);
        }
    }

    #endregion
}
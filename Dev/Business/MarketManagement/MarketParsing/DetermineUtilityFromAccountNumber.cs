namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;

    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public static class DetermineUtilityFromAccountNumber
    {
        #region Methods

        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility, or at least narrow the message
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static UtilityList GetAllUtilitiesMatchingAccountNumber( string accountNumber, UtilityDictionary utilities )
        {
            UtilityList candidates = null;

            foreach( KeyValuePair<string, Utility> item in utilities )
            {
                Utility util = item.Value;

                if( util.AccountNumberLength == accountNumber.Length )
                    if( accountNumber.StartsWith( util.AccountNumberPrefix ) )
                    {
                        if( candidates == null )
                            candidates = new UtilityList();
                        candidates.Add( item.Value );
                    }
            }

            return candidates;
        }

        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility, or at least narrow the message
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static UtilityList GetTexasUtilitiesMatchingAccountNumber( string accountNumber, UtilityDictionary utilities )
        {
            UtilityList candidates = null;

            foreach( KeyValuePair<string, Utility> item in utilities )
            {
                Utility util = item.Value;

                if(util.RetailMarketCode == "TX")
                    if( util.AccountNumberLength == accountNumber.Length )
                        if( accountNumber.StartsWith( util.AccountNumberPrefix ) )
                        {
                            if( candidates == null )
                                candidates = new UtilityList();
                            candidates.Add( item.Value );
                        }
            }

            return candidates;
        }

        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility by best match
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static Utility GetTexasUtilitiesBestMatchingAccountNumber(string accountNumber, UtilityDictionary utilities)
        {
            Utility candidate = null;

            foreach (KeyValuePair<string, Utility> item in utilities)
            {
                Utility util = item.Value;
                var matchScore = 0;
                if (util.RetailMarketCode == "TX")
                    if (util.AccountNumberLength == accountNumber.Length)
                        if (accountNumber.StartsWith(util.AccountNumberPrefix))
                        {
                            if (util.AccountNumberPrefix.Length > matchScore)
                            {
                                matchScore = util.AccountNumberPrefix.Length;
                                candidate = item.Value;
                            }
                        }
            }

            return candidate;
        }

        #endregion Methods
    }
}
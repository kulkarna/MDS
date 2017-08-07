using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    /// <summary>
    /// Represents a historical section type.
    /// </summary>
    public enum HistoricalSection
    {
        /// <summary>
        /// Represents the Historical Usage data.
        /// </summary>
        HU,

        /// <summary>
        /// Represents the Historical Interval Summary data.
        /// </summary>
        HI
    }
}

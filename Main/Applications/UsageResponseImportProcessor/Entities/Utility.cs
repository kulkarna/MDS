using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Entities
{
    /// <summary>
    /// Represents an utility in the application.
    /// </summary>
    public class Utility
    {
        public int UtilityId { get; set; }

        public string TerritoryCode { get; set; }

        public string UtilityCode { get; set; }

        public string MarketName { get; set; }

        public int MarketId { get; set; }
    }
}

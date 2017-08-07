using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageEventAggregator.Events.Consolidation
{
 public   class IdrSummarizeRequested
    {

        public string AccountNumber { get; set; }
        public string EdiLogId { get; set; }
        public string Source { get; set; }
        public long TransactionId { get; set; }
        public string UtilityCode { get; set; }

    }
}

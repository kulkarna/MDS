using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsageResponseImportProcessor.Entities
{
    public class UsageResponse
    {
        public string account_number { get; set; }

        public int external_id { get; set; }

        public int utility_id { get; set; }

        public int market_id { get; set; }

        public string transaction_type { get; set; }

        public string action_code { get; set; }

        public string service_type2 { get; set; }

        public DateTime? transaction_date { get; set; }

        public DateTime? request_date { get; set; }
        
        public int direction { get; set; }

        public string request_or_response { get; set; }

        public string reject_or_accept { get; set; }

        public string reasoncode { get; set; }

        public string reasontext { get; set; }

        public string transaction_number { get; set; }

        public string reference_transaction_number { get; set; }
        
        public int? AccountID { get; set; }
    }
}

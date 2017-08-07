using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsageResponseImportProcessor.Entities
{
    public class UsageResponseFileRow
    {
        public int FileId { get; set; }

        public string CUSTOMER_PROSPECT_TKN { get; set; }

        public string CUSTOMER_PROSPECT_ACCOUNT_TKN { get; set; }

        public string TERRITORY_CODE { get; set; }

        public string LDC_ACCOUNT_NUM { get; set; }

        public string STATUS_DESC { get; set; }

        public string CREATE_TSTAMP { get; set; }

        public string TRANS_ID { get; set; }

        public string ORIGINAL_TRANS_ID { get; set; }

        public string TYPE_DESC { get; set; }

        public string REASON_CODE { get; set; }

        public string REASON_DESC { get; set; }

        public string USAGE_TYPE { get; set; }

        public string Status { get; set; }

        public DateTime? DateCreated { get; set; }

        #region Auxiliary

        public UsageResponse UsageResponse { get; set; }

        public int Index { get; set; }

        public DateTime? Date { get; set; }

        #endregion
    }
}

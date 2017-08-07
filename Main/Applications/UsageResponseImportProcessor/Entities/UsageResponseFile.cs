using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsageResponseImportProcessor.Entities
{
    public class UsageResponseFile
    {
        public int Id { get; set; }

        public string FileName { get; set; }

        public List<UsageResponseFileRow> Rows { get; set; }

        public string Status { get; set; }

        public DateTime? DateCreated { get; set; }
    }
}

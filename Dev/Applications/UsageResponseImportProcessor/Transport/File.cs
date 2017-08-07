using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsageResponseImportProcessor.Transport
{
    /// <summary>
    /// Represents an common file in the application.
    /// </summary>
    public class File
    {
        public string Name { get; set; }

        public string ContentType { get; set; }

        public MemoryStream MemoryStream { get; set; }

        public string Header { get; set; }

        public IEnumerable<string> Rows { get; set; }
    }
}

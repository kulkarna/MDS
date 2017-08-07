using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageResponseImportProcessor.Entities;
using UsageResponseImportProcessor.Transport;

namespace DailyBillingImportProcessor.Business
{
    /// <summary>
    /// Abstracts the usage response file parsing.
    /// </summary>
    public interface IUsageResponseFileParser
    {
        /// <summary>
        /// Parse common file to usage response file.
        /// </summary>
        /// <param name="file">Commom file to be parsed.</param>
        /// <returns>Resulting usage response file.</returns>
        UsageResponseFile Parse(File file);
    }
}

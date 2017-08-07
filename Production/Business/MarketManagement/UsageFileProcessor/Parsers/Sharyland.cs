using System;
using System.Collections.Generic;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Interfaces;

namespace UsageFileProcessor.Parsers
{
    public class Sharyland : IUsageFileParser
    {
        public string Error { get; private set; }
        public bool IsParser(UsageFile file)
        {
            return file.UtilityCode.Equals("Sharyland", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool IsValidFileTemplate(UsageFile file)
        {
            throw new System.NotImplementedException();
        }

        public IEnumerable<ParserAccount> Parse(UsageFile file)
        {
            throw new System.NotImplementedException();
        }
    }
}
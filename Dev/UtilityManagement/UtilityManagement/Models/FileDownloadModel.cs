using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Web.Hosting;


namespace UtilityManagement.Models
{
    public class FileDownloadModel
    {
        public List<FileNames> GetFiles()
        {
            List<FileNames> lstFiles = new List<FileNames>()
            {
                new FileNames() { FileId = 1, FileName = "UtilityCompanies.csv", FilePath = @"c:\Temp\UtilityCompanies.csv", Name= "Utility Companies", LinkedText = "Download"},
                new FileNames() { FileId = 2, FileName = "StrataPatterns.csv", FilePath = @"c:\Temp\StrataPatterns.csv", Name= "Strata Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 3, FileName = "ServiceAddressZipPatterns.csv", FilePath = @"c:\Temp\ServiceAddressZipPatterns.csv", Name= "Service Address Zip Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 4, FileName = "ServiceAccountPatterns.csv", FilePath = @"c:\Temp\ServiceAccountPatterns.csv", Name= "Service Account Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 5, FileName = "RequestModeIdr.csv", FilePath = @"c:\Temp\RequestModeIdr.csv", Name= "Request Mode IDR", LinkedText = "Download"},
                new FileNames() { FileId = 6, FileName = "RequestModeICap.csv", FilePath = @"c:\Temp\RequestModeICap.csv", Name= "Request Mode ICap", LinkedText = "Download"},
                new FileNames() { FileId = 7, FileName = "RequestModeHistoricalUsage.csv", FilePath = @"c:\Temp\RequestModeHistoricalUsage.csv", Name= "Request Mode Historical Usage", LinkedText = "Download"},
                new FileNames() { FileId = 8, FileName = "NameKeyPatterns.csv", FilePath = @"c:\Temp\NameKeyPatterns.csv", Name= "Name Key Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 9, FileName = "MeterNumberPatterns.csv", FilePath = @"c:\Temp\MeterNumberPatterns.csv", Name= "Meter Number Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 10, FileName = "ICapTCapNumberPatterns.csv", FilePath = @"c:\Temp\ICapTCapNumberPatterns.csv", Name= "ICap TCap Number Patterns", LinkedText = "Download"},
                new FileNames() { FileId = 11, FileName = "BillingAccountPatterns.csv", FilePath = @"c:\Temp\BillingAccountPatterns.csv", Name= "Billing Account Patterns", LinkedText = "Download"},
            };          
            return lstFiles; 
        }
    }

    public class FileNames
    {
        public int FileId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string Name { get; set; }
        public string LinkedText { get; set; }
    }
}
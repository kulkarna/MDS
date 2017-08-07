using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Entities
{
    public class ScraperUsageRequest
    {

        #region Data Members

        [Required]
        public string AccountNumber { get; set; }

        [Required]
        public string UtilityCode { get; set; }

        #endregion

        public string RunScraperReturningTransactionId()
        {
            return string.Empty;
        }
    }
}
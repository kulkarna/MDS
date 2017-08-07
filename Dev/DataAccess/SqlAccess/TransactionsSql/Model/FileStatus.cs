using System.ComponentModel;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public enum FileStatus
    {
        /// <summary>
        /// File In Managed Storage
        /// </summary>
        [Description("Unknown Status")]
        Unknown = 0,

        /// <summary>
        /// File In Managed Storage
        /// </summary>
        [Description("File In Managed Storage")]
        FileInManagedStorage = 1,

        /// <summary>
        /// Tab Has One Or More Errors
        /// </summary>
        [Description("Tab Has One Or More Errors")]
        OneOrMoreTabsWithErrors = 2,

        /// <summary>
        /// File Successfully Parsed
        /// </summary>
        [Description("File Successfully Parsed")]
        FileSuccessfullyParsed = 5,

        /// <summary>
        /// Invalid File Type
        /// </summary>
        [Description("Invalid File Type")]
        InvalidFileType = 6,


        /// <summary>
        /// Data Errors
        /// </summary>
        [Description("Data Errors")]
        DataErrors = 7,

        [Description("Failure")]
        Failure = 8,

        [Description("Success")]
        Success = 9,

        [Description("Partial Success")]
        PartialSuccess = 10,

        [Description("Needs Attention")]
        NeedsAttention = 11
    }
}

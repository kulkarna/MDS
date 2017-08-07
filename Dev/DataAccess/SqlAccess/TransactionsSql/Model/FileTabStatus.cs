using System.ComponentModel;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public enum FileTabStatus
    {
        [Description("Success")]
        Success = 0,

        [Description("File In Managed Storage")]
        FileInManagedStorage = 1,

        [Description("File Has One Or More Errors")]
        OneOrMoreTabsWithErrors = 2,

        [Description("File Successfully Parsed")]
        FileSuccessfullyParsed = 5,

        [Description("Invalid File Type")]
        InvalidFileType = 6,

        [Description("Data Errors")]
        DataErrors = 6
    }
}

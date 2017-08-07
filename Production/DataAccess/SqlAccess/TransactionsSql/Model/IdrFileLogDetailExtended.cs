namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public partial class IdrFileLogDetail
    {
        public string StatusStr
        {
            get { return ((FileStatus)Status).ToString(); }
        }

        public string FormatTypeStr
        {
            get
            {
                return FormatType != null ? ((FormatType)FormatType).ToString() : null;
            }
        }
    }
}


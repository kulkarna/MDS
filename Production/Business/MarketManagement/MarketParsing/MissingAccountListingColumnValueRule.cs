namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    /// <summary>
    /// Checks that there is a value for each required message
    /// </summary>
    [Guid( "9C6D7E4E-088B-4413-ADA1-F2E79A07AD64" )]
    public class MissingAccountListingColumnValueRule : BusinessRule
    {
        #region Fields

        private string columnName;
        private DataRow dr;
        private int rowNumber;

        #endregion Fields

        #region Constructors

        public MissingAccountListingColumnValueRule( int rowNumber, DataRow dr, string columnName )
            : base("MissingAccountListingColumnValueRule", BrokenRuleSeverity.Warning)
        {
            this.rowNumber = rowNumber;
            this.dr = dr;
            this.columnName = columnName;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            if( this.dr[this.columnName] == DBNull.Value )
            {
                string format = "The column named [{0}] is missing a required value at row {1} of the file.";
                string reason = string.Format( format, this.columnName, this.rowNumber );
                this.SetException( reason );
            }

            return this.Exception == null;
        }

        #endregion Methods
    }
}
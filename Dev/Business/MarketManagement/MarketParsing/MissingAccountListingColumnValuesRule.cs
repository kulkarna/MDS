namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    /// <summary>
    /// Checks that column names exist in Excel file
    /// </summary>
    [Guid( "6D961509-18AF-435e-843B-E9BDA4A9C4D9" )]
    public class MissingAccountListingColumnValuesRule : BusinessRule
    {
        #region Fields

        private string[] columnNames;
        private DataRow dr;
        private int rowNumber;

        #endregion Fields

        #region Constructors

        public MissingAccountListingColumnValuesRule( int rowNumber, DataRow dr, string[] columnNames )
            : base("MissingAccountListingColumnValuesRule", BrokenRuleSeverity.Warning)
        {
            this.rowNumber = rowNumber;
            this.dr = dr;
            this.columnNames = columnNames;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            foreach( string columnName in this.columnNames )
            {
                MissingAccountListingColumnValueRule rule = new MissingAccountListingColumnValueRule( this.rowNumber, this.dr, columnName );

                if( !rule.Validate() )
                {
                    if( this.Exception == null )
                        this.SetException( string.Format( "Row {0} is missing one or more required column values.", this.rowNumber ) );

                    this.AddDependentException( rule.Exception );
                }
            }

            return this.Exception == null;
        }

        #endregion Methods
    }
}
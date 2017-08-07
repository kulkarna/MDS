namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Linq.Expressions;

    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

    /// <summary>
    /// Parses string properties of a EdiAccount instance.
    /// </summary>
    public class IcapDecimalParser : PropertyParser<decimal>
    {
        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="propertySetter">Setter of the property that will be parsed</param>
        /// <param name="cellIndex">Positon of th data in the field</param>
        public IcapDecimalParser(Expression<Func<EdiAccount, decimal>> propertySetter, int cellIndex)
            : base(propertySetter, cellIndex)
        {
        }

        /// <summary>
        /// Parses field data
        /// </summary>
        /// <param name="fileRowCell">Row cell containing the field</param>
        /// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
        /// <returns>Parsed value of the field</returns>
        protected override decimal Parse(ref string fileRowCell, char fieldDelimiter)
        {
            string parsedValue = string.Empty;
            decimal parsed = 0;
            char[] cD = { fieldDelimiter };

            string[] cells = fileRowCell.Split(cD, CellIndex + 2);

            if (CellIndex < cells.Length)
                parsedValue = cells[CellIndex].Trim();

            if (string.IsNullOrEmpty(parsedValue))
                parsed = Convert.ToDecimal(-1);
            else
                decimal.TryParse(parsedValue, out parsed);

            return parsed;
        }

        /// <summary>
        /// Assigns the parsed value to the property
        /// </summary>
        /// <param name="target">EdiAccount instance</param>
        /// <param name="fileRowCell">Row cell containing the field</param>
        /// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
        public override void SetValue(EdiAccount target, ref string fileRowCell, char fieldDelimiter)
        {
            object parsedValue = Parse(ref fileRowCell, fieldDelimiter);
            if (target.Icap<=0)
                Setter.SetValue(target, parsedValue, null);
        }
    }
}

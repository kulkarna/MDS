namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Linq.Expressions;

    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using System.Data.SqlTypes;

    /// <summary>
    /// Parses string properties of a EdiAccount instance.
    /// </summary>
    public class TcapDateParser : PropertyParser<DateTime>
    {
        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="propertySetter">Setter of the property that will be parsed</param>
        /// <param name="cellIndex">Positon of th data in the field</param>
        public TcapDateParser(Expression<Func<EdiAccount, DateTime>> propertySetter, int cellIndex)
            : base(propertySetter, cellIndex)
        {
        }

        /// <summary>
        /// Parses field data
        /// </summary>
        /// <param name="fileRowCell">Row cell containing the field</param>
        /// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
        /// <returns>Parsed value of the field</returns>
        protected override DateTime Parse(ref string fileRowCell, char fieldDelimiter)
        {
            string parsedValue = string.Empty;

            char[] cD = { fieldDelimiter };

            string[] cells = fileRowCell.Split(cD, CellIndex + 2);

            if (CellIndex < cells.Length)
                parsedValue = cells[CellIndex].Trim();

            DateTime parsed = DateHelper.ConvertDateString(parsedValue);

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
            if ((target.TcapEffectiveDate <= (DateTime)SqlDateTime.MinValue ))
            Setter.SetValue(target, parsedValue, null);
        }
    }
}

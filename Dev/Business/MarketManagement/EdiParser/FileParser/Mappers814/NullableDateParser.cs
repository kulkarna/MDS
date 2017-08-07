namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Linq.Expressions;

    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using System.Globalization;

    /// <summary>
    /// Parses string properties of a EdiAccount instance.
    /// </summary>
    public class NullableDateParser : PropertyParser<DateTime?>
    {
        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="propertySetter">Setter of the property that will be parsed</param>
        /// <param name="cellIndex">Positon of th data in the field</param>
        public NullableDateParser(Expression<Func<EdiAccount, DateTime?>> propertySetter, int cellIndex)
            : base(propertySetter, cellIndex)
        {
        }

        /// <summary>
        /// Parses field data
        /// </summary>
        /// <param name="fileRowCell">Row cell containing the field</param>
        /// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
        /// <returns>Parsed value of the field</returns>
        protected override DateTime? Parse(ref string fileRowCell, char fieldDelimiter)
        {
            string parsedValue = string.Empty;

            char[] cD = { fieldDelimiter };

            string[] cells = fileRowCell.Split(cD, CellIndex + 2);

            if (CellIndex < cells.Length)
                parsedValue = cells[CellIndex].Trim();

            DateTime? parsed = DateTryParse(parsedValue);
            //DateTime parsed = DateHelper.ConvertDateString( parsedValue );

            return parsed;
        }

        public static DateTime? DateTryParse(string text)
        {
            DateTime date;
            return DateTime.TryParseExact(text, "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date) ? date : (DateTime?)null;
        }
    }

}

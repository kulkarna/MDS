namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    public class OH814Mapper : EdiAccountMap814
    {
        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="marker">Marker containing the position of each data in the field</param>
        public OH814Mapper(MarkerBase marker)
            : base(marker)
        {
            RemoveFieldMap("AMTKC");
            RemoveFieldMap("AMTKZ");
            AddFieldMap("DTM152", new IcapDateParser(account => account.IcapEffectiveDate, Marker.IcapEffectiveDateCell));
            AddFieldMap("DTM152", new DateParser(account => account.FutureIcapEffectiveDate, Marker.IcapEffectiveDateCell));
            AddFieldMap("AMTKC", new DecimalParser(account => account.FutureIcap, Marker.IcapCell));
            AddFieldMap("AMTKC", new IcapDecimalParser(account => account.Icap, Marker.IcapCell));
            AddFieldMap("DTM152", new TcapDateParser(account => account.TcapEffectiveDate, Marker.TcapEffectiveDateCell));
            AddFieldMap("DTM152", new DateParser(account => account.FutureTcapEffectiveDate, Marker.TcapEffectiveDateCell));
            AddFieldMap("AMTKZ", new DecimalParser(account => account.FutureTcap, Marker.TcapCell));
            AddFieldMap("AMTKZ", new TcapDecimalParser(account => account.Tcap, Marker.TcapCell));
        }
    }
}

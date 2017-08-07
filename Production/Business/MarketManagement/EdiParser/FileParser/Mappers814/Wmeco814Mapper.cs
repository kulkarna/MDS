namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Map for BGE
    /// </summary>
    public class Wmeco814Mapper : EdiAccountMap814
    {
        /// <summary>
        /// BGE map constructor
        /// </summary>
        /// <param name="maker">Marker containing the position of each data in the field</param>
        public Wmeco814Mapper(MarkerBase maker)
            : base(maker)
        {
            RemoveFieldMap("REF12");
            RemoveFieldMap("REFMG");
            
            AddFieldMap("REFMG", new StringParser(account => account.AccountNumber, maker.AccountNumberCell));
            AddFieldMap("REF12", new StringParser(account => account.BillingAccount, maker.AccountNumberCell));
            AddFieldMap("DTM007", new DateParser(account => account.IcapEffectiveDate, Marker.IcapEffectiveDateCell));
            AddFieldMap("DTM007", new DateParser(account => account.TcapEffectiveDate, Marker.TcapEffectiveDateCell));
           
        }
    }
}
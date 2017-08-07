using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    /// <summary>
    /// Class for Sales Taxes
    /// </summary>
    [Serializable]
    public class RetailMarketSalesTax
    {
        public int Identifier
        {
            get;
            set;
        }

        public int MarketID
        {
            get;
            set;
        }

        public double SalesTax
        {
            get;
            set;
        }

        public DateTime EffectiveStartDate
        {
            get;
            set;
        }

        public DateTime? EffectiveEndDate
        {
            get;
            set;
        }

        public DateTime CreatedDate
        {
            get;
            set;
        }

        public int TaxTypeID
        {
            get;
            set;
        }

        public int ChannelTypeID
        {
            get;
            set;
        }

        public int ApplicationKeyID
        {
            get;
            set;
        }

        public RetailMarketSalesTax() { }


        public RetailMarketSalesTax(int identifier, int marketId, double salesTax, DateTime effectiveStartDate, DateTime? effectiveEndDate, DateTime createdDate)
        {
            this.Identifier = identifier;
            this.MarketID = marketId;
            this.SalesTax = salesTax;
            this.EffectiveStartDate = effectiveStartDate;
            this.EffectiveEndDate = effectiveEndDate;
            this.CreatedDate = createdDate;
        }

        public RetailMarketSalesTax(int identifier, int marketId, double salesTax, DateTime effectiveStartDate, DateTime? effectiveEndDate, DateTime createdDate,
            int taxTypeID, int channelTypeID, int applicationKeyID)
        {
            this.Identifier = identifier;
            this.MarketID = marketId;
            this.SalesTax = salesTax;
            this.EffectiveStartDate = effectiveStartDate;
            this.EffectiveEndDate = effectiveEndDate;
            this.CreatedDate = createdDate;
            this.TaxTypeID = taxTypeID;
            this.ChannelTypeID = channelTypeID;
            this.ApplicationKeyID = applicationKeyID;
        }
    }
}

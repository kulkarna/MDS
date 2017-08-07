using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.UsageEclRepository;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;

namespace LibertyPower.MarketDataServices.UsageEclBusinessLayer
{
    /// <summary>
    /// Interface IBusinessLayer
    /// </summary>
    public interface IBusinessLayer
    {
        IsIdrEligibleResponse IsIdrEligible(string messageId, string accountNumber, int utilityCode);
    }
}
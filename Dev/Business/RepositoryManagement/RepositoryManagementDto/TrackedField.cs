using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibertyPower.RepositoryManagement.Dto
{
    [Serializable()]
    public enum TrackedField
    {
        AccountType = 0,
        BillingAccount = 1,
        Grid = 2,
        ICap = 3,
        LBMPZone = 4,
        LoadProfile = 5,
        LoadShapeID = 6,
        LossFactor = 7,
        MeterNumber = 8,
        MeterType = 9,
        NameKey = 10,
        RateClass = 11,
        ServiceAddressZipCode = 12,
        ServiceClass = 13,
        Strata = 14,
        TariffCode = 15,
        Utility = 16,
        TCap = 17,
        Voltage = 18,
        Zone = 19
    }
}
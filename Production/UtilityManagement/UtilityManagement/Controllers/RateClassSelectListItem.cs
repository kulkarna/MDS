using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UtilityManagement.Controllers
{
    public class RateClassSelectListItem
    {
        public RateClassSelectListItem(RateClass rateClass)
        { 
            if (rateClass != null && rateClass.Id != Guid.Empty)
            {
                Id = rateClass.Id;
                Name = string.Format("{0}:{1}", Common.NullSafeString(rateClass.LpStandardRateClass.LpStandardRateClassCode), Common.NullSafeString(rateClass.RateClassId));
            }
            else
            {
                Id = Guid.Empty;
                Name = string.Empty;
            }
        }
        public Guid Id { get; set; }
        public string Name { get; set; }
    }
}
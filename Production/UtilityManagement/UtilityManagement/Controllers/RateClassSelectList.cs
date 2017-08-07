using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;

namespace UtilityManagement.Controllers
{
    public class RateClassSelectList : List<RateClassSelectListItem>
    {
        public RateClassSelectList(List<RateClass> rateClassList)
        {
            if (rateClassList != null && rateClassList.Count > 0)
            {
                foreach (RateClass rateClass in rateClassList)
                {
                    if (rateClass != null)
                    {
                        this.Add(new RateClassSelectListItem(rateClass));
                    }
                }
            }
        }
    }
}
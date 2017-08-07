using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;

namespace UtilityManagement.Controllers
{
    public class TariffCodeSelectList : List<TariffCodeSelectListItem>
    {
        public TariffCodeSelectList(List<TariffCode> tariffCodeList)
        {
            if (tariffCodeList != null && tariffCodeList.Count > 0)
            {
                foreach (TariffCode tariffCode in tariffCodeList)
                {
                    if (tariffCode != null)
                    {
                        this.Add(new TariffCodeSelectListItem(tariffCode));
                    }
                }
            }
        }
    }
}
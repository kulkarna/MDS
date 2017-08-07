using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UtilityManagement.Controllers
{
    public class TariffCodeSelectListItem
    {
        public TariffCodeSelectListItem(TariffCode tariffCode)
        {
            if (tariffCode != null && tariffCode.Id != Guid.Empty)
            {
                Id = tariffCode.Id;
                Name = string.Format("{0}:{1}", Common.NullSafeString(tariffCode.LpStandardTariffCode.LpStandardTariffCodeCode), Common.NullSafeString(tariffCode.TariffCodeId));
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
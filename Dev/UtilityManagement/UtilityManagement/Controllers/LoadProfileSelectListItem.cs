using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UtilityManagement.Controllers
{
    public class LoadProfileSelectListItem
    {
        public LoadProfileSelectListItem(LoadProfile loadProfile)
        {
            if (loadProfile != null && loadProfile.Id != Guid.Empty)
            {
                Id = loadProfile.Id;
                Name = string.Format("{0}:{1}", Common.NullSafeString(loadProfile.LpStandardLoadProfile.LpStandardLoadProfileCode), Common.NullSafeString(loadProfile.LoadProfileId));
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
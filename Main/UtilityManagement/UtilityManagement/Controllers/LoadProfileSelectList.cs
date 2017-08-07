using System;
using System.Collections.Generic;
using System.Linq;
using DataAccessLayerEntityFramework;

namespace UtilityManagement.Controllers
{
    public class LoadProfileSelectList : List<LoadProfileSelectListItem>
    {
        public LoadProfileSelectList(List<LoadProfile> loadProfileList)
        {
            if (loadProfileList != null && loadProfileList.Count > 0)
            {
                foreach (LoadProfile loadProfile in loadProfileList)
                {
                    if (loadProfile != null)
                    {
                        this.Add(new LoadProfileSelectListItem(loadProfile));
                    }
                }
            }
        }
    }
}
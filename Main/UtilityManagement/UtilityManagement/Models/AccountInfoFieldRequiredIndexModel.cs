using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class AccountInfoFieldRequiredIndexModel
    {
        public List<string> AccountInfoFields { get; set; }
        public List<AccountInfoFieldRequiredModel> AccountInfoFieldRequiredModels { get; set; }
    }
}
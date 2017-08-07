using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class RequestModeIdrModel
    {
        public List<RequestModeIdr> RequestModeIdrList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }

        public RequestModeIdrModel()
        {
        }
    }
}
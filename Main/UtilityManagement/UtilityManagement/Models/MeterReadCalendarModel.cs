using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class MeterReadCalendarModel
    {
        public List<MeterReadCalendarListModel> MeterReadCalendarList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }

        public MeterReadCalendarModel()
        {
        }

    }
}
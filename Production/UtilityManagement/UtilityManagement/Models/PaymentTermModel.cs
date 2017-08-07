using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class PaymentTermModel
    {
        public List<PaymentTermListModel> PaymentTermList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }

        public PaymentTermModel()
        {
        }

    }
}
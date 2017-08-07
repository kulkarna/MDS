using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class UtilityRequiredData
    {
        #region Constructors

        public UtilityRequiredData()
        {

        }

        #endregion


        #region Primary key(s)

        public System.Int32? UtilityRequiredDataID { get; set; }

        #endregion

        #region Non Primary key(s)

        public System.String UtilityCode { get; set; }

        public int RequiredLength { get; set; }

        public UtilityRequiredDataControlType ControlType { get; set; }

        public int HasControlData { get; set; }

        public System.String LabelText { get; set; }

        public System.String AccountInfoField { get; set; }

        public System.String FieldDataType { get; set; }

        public System.Int16 FieldDataLength { get; set; }

        public System.String StoredProcVal { get; set; }

        public System.DateTime? Created { get; set; }

        public System.String CreatedBy { get; set; }

        #endregion


    }
}

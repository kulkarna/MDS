using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class CancelContractReasonFactory
    {
        /// <summary>
        /// Check if the contract cancellation reason code is a valid one.
        /// </summary>
        /// <param name="code">Cancellation code</param>
        /// <returns>True if exists this contract reason code</returns>
        public static bool ExistsCancelContractReasonCode(string code)
        {
            LpDealCaptureEntities entities = new LpDealCaptureEntities();

            return entities.CancelContractReasons.Count(x => x.Code == code) > 0;
        }
        /// <summary>
        /// Gets all CancelContract reasons.
        /// </summary>
        /// <returns></returns>
        public static List<CancelContractReason> GetAllCancelContractReasons()
        {
            using (LpDealCaptureEntities entities = new LpDealCaptureEntities())
            {
                return entities.CancelContractReasons.Select(item => new CancelContractReason()
                {
                    Code = item.Code,
                    Description = item.Description
                }).ToList();
            }
        }


    }
}

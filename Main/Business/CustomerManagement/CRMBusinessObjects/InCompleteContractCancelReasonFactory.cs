using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class InCompleteContractCancelReasonFactory
    {
        /// <summary>
        /// Saves a reason why a contract was cancelled and is incomplete.
        /// </summary>
        /// <param name="incompleteContractNumber">The incomplete contract number associated to the cancellation reason</param>
        /// <param name="cancelContractReasonCode">The incomplete contract cancel reason entity to save</param>
        /// <param name="userId">The user ID that cancelled the contract that was being completed</param>
        public static void SaveInCompleteContractCancelReason(string incompleteContractNumber, string cancelContractReasonCode, int userId)
        {
            LpDealCaptureEntities entities = new LpDealCaptureEntities();

            var tabletIncompleteContract = entities.TabletIncompleteContracts.FirstOrDefault(x => x.ContractNumber == incompleteContractNumber);

            if (tabletIncompleteContract == null)
                throw new NullReferenceException("Unable to find TabletIncompleteContract with contract number: " + incompleteContractNumber);

            var cancelContractReason = entities.CancelContractReasons.FirstOrDefault(x => x.Code == cancelContractReasonCode);

            if (cancelContractReason == null)
                throw new NullReferenceException("Unable to find CancelContractReason with code: " + cancelContractReasonCode);

            entities.InCompleteContractCancelReasons.AddObject(new DataAccess.SqlAccess.CustomerManagementEF.InCompleteContractCancelReason
            {
                TabletIncompleteContractId = tabletIncompleteContract.TabletIncompleteContractID,
                CancelContractReasonId = cancelContractReason.CancelContractReasonId,
                CreatedBy = userId,
                CreatedDate = DateTime.Now,
                ModifiedBy = userId,
                ModifiedDate = DateTime.Now
            });

            entities.SaveChanges();
        }
    }
}

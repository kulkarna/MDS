using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class MultiTermWinServiceData
    {
        #region Contructors

        public MultiTermWinServiceData()
        {

        }

        #endregion

        #region Properties
        /// <summary>			
        /// RecordId : 
        /// </summary>
        public int RecordId { get; set; }
        /// <summary>			
        /// LeadTime : 
        /// </summary>
        public int LeadTime { get; set; }
        /// <summary>			
        /// StartToSubmitDate : 
        /// </summary>
        public DateTime StartToSubmitDate { get; set; }
        /// <summary>			
        /// ToBeExpiredAccountContactRateId : 
        /// </summary>
        public int ToBeExpiredAccountContactRateId { get; set; }
        /// <summary>			
        /// MeterReadDate : 
        /// </summary>
        public DateTime MeterReadDate { get; set; }
        /// <summary>			
        /// NewAccountContractRateId : 
        /// </summary>
        public int NewAccountContractRateId { get; set; }
        /// <summary>			
        /// RateEndDateAjustedByService: 
        /// </summary>
        public bool RateEndDateAjustedByService { get; set; }
        /// <summary>			
        /// MultyTermWinServiceStatusId : 
        /// </summary>
        public int MultiTermWinServiceStatusId { get; set; }
        /// <summary>			
        /// ServiceLastRunDate : 
        /// </summary>
        public DateTime? ServiceLastRunDate { get; set; }
        /// <summary>			
        /// DateCreated : 
        /// </summary>
        public DateTime DateCreated { get; set; }
        /// <summary>			
        /// CreatedBy : 
        /// </summary>
        public int CreatedBy { get; set; }
        /// <summary>			
        /// DateModified : 
        /// </summary>
        public DateTime? DateModified { get; set; }
        /// <summary>			
        /// ModifiedBy :
        /// </summary>
        public int? ModifiedBy { get; set; }
		//----------Reenrollment implementation PBI1004 task4700 start here ------
		/// <summary>			
		/// DateModified : 
		/// </summary>
		public DateTime? ReenrollmentFollowingMeterDate { get; set; }
		//----------Reenrollment implementation PBI1004 task4700 end here ------
        #endregion
    }
}

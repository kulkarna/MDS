using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;
using Utilities;


namespace UtilityManagementServiceData
{
    /// <summary>
    /// This object serves as the response object for the method GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate.
    /// </summary>
    [DataContract]
    public class GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse : GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase
    {
        /// <summary>
        /// The generic constructor for GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.
        /// </summary>
        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse() : base()
        { }

        /// <summary>
        /// A constructor for GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse which populates message id and next meter read date.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="previousMeterReadDate">The previous meter read date for a particular utility and read cycle with reference to the inquiry date provided.</param>
        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(string messageId, DateTime previousMeterReadDate) : base(messageId)
        {
            PreviousMeterReadDate = previousMeterReadDate;
        }

        /// <summary>
        /// A constructor for GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse which populates all properties for the response object.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="previousMeterReadDate">The previous meter read date for a particular utility and read cycle with reference to the inquiry date provided.</param>
        /// <param name="message">A string which provides the method caller insight into the result of the call (e.g., Success or Error).</param>
        /// <param name="isSuccess">A boolean which, if true, denotes that the call succeeded and results were found, and if false, denotes that the call did not succeed.</param>
        /// <param name="code">A string based result which gives the developer based results on what occurred during the call (e.g., 0000 = success, 9999 = error).</param>
        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(string messageId, DateTime previousMeterReadDate, string message, bool isSuccess, string code) : 
            base(messageId, message, isSuccess, code)
        {
            PreviousMeterReadDate = previousMeterReadDate;
        }
        
        /// <summary>
        /// The next meter read date for a particular utility and read cycle with reference to the inquiry date provided.
        /// </summary>
        [DataMember]
        public DateTime PreviousMeterReadDate { get; set; }

        /// <summary>
        /// A method which generates a string describing the inner properties of this particular class and their values.
        /// </summary>
        /// <returns>A string describing the inner properties of this particular class and their values.</returns>
        public override string ToString()
        {
            string returnValue = string.Format("MessageId:{0};PreviousMeterReadDate:{1};Message:{2};IsSuccess:{3};Code:{4}", 
                MessageId ?? "NULL VALUE", 
                Common.NullSafeDateToString(PreviousMeterReadDate),
                Common.NullSafeString(Message),
                IsSuccess,
                Common.NullSafeString(Code));
            return returnValue;
        }
    }
}
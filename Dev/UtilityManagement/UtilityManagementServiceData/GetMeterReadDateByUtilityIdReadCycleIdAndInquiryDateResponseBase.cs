﻿using System;
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
    /// This object serves as the response object for the method GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate.
    /// </summary>
    [DataContract]
    public class GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase
    {
        /// <summary>
        /// The generic constructor for GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase.
        /// </summary>
        public GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase()
        { }

        /// <summary>
        /// A constructor for GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase which populates message id and next meter read date.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        public GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase(string messageId)
        {
            MessageId = messageId;
        }

        /// <summary>
        /// A constructor for GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse which populates all properties for the response object.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="message">A string which provides the method caller insight into the result of the call (e.g., Success or Error).</param>
        /// <param name="isSuccess">A boolean which, if true, denotes that the call succeeded and results were found, and if false, denotes that the call did not succeed.</param>
        /// <param name="code">A string based result which gives the developer based results on what occurred during the call (e.g., 0000 = success, 9999 = error).</param>
        public GetMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponseBase(string messageId, string message, bool isSuccess, string code)
        {
            MessageId = messageId;
            Message = message;
            IsSuccess = isSuccess;
            Code = code;
        }

        /// <summary>
        /// A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.
        /// </summary>
        [DataMember]
        public string MessageId { get; set; }

        /// <summary>
        /// A string which provides the method caller insight into the result of the call (e.g., Success or Error).
        /// </summary>
        [DataMember]
        public string Message { get; set; }

        /// <summary>
        /// A boolean which, if true, denotes that the call succeeded and results were found, and if false, denotes that the call did not succeed.
        /// </summary>
        [DataMember]
        public bool IsSuccess { get; set; }

        /// <summary>
        /// A string based result which gives the developer based results on what occurred during the call (e.g., 0000 = success, 9999 = error).
        /// </summary>
        [DataMember]
        public string Code { get; set; }

        /// <summary>
        /// A method which generates a string describing the inner properties of this particular class and their values.
        /// </summary>
        /// <returns>A string describing the inner properties of this particular class and their values.</returns>
        public override string ToString()
        {
            string returnValue = string.Format("MessageId:{0};Message:{1};IsSuccess:{2};Code:{3}",
                MessageId ?? "NULL VALUE",
                Common.NullSafeString(Message),
                IsSuccess,
                Common.NullSafeString(Code));
            return returnValue;
        }
    }
}
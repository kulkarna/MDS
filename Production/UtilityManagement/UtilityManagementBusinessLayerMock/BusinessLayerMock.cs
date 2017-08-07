using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;
//using UtilityManagementBusinessLayer;
using UtilityManagementServiceData;

namespace UtilityManagementBusinessLayerMock
{
    public class BusinessLayerMock //: IBusinessLayer
    {
        public const string CODE = "0000";
        private const string NOVALUERETURNED = "4001";
        private const string ERRORCODE = "9999";
        private const string INVALIDINPUTPARAMETER = "7777";
        private const string ERRORMESSAGE = "An Error Occurred While Processing The Service Call";


        public RequestMode GetHURequestMode(string messageId, int utilityIdInt, EnrollmentType enrollmentType)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            var iteration = random.Next(10);
            switch (iteration)
            {
                case 1:
                    return null;
                case 2:
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, string.Format("Utility ID {0} is not defined in Utility Management", utilityIdInt));
                case 3:
                    throw new UtilityManagementBusinessException(messageId, ERRORCODE, ERRORMESSAGE);
                default:
                    return new RequestMode()
                    {
                        Address = Guid.NewGuid().ToString(),
                        EmailTemplate = Guid.NewGuid().ToString(),
                        EnrollmentType = EnrollmentType.PostEnrollment,
                        Instructions = Guid.NewGuid().ToString(),
                        IsLoaRequired = random.Next(0,1) == 0,
                        LibertyPowerSlaResponse = random.Next(100),
                        RequestModeType = Guid.NewGuid().ToString(),
                        UtilityId = random.Next(100),
                        UtilitySlaResponse = random.Next(200)
                    };
            }
        }

        public RequestMode GetIcapRequestModeData(string messageId, int utilityIdInt, EnrollmentType enrollmentType)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            var iteration = random.Next(10);
            switch (iteration)
            {
                case 1:
                    return null;
                case 2:
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, "No Result Returned");
                case 3:
                    throw new UtilityManagementBusinessException(messageId, ERRORCODE, ERRORMESSAGE);
                default:
                    return new RequestMode()
                    {
                        Address = Guid.NewGuid().ToString(),
                        EmailTemplate = Guid.NewGuid().ToString(),
                        EnrollmentType = EnrollmentType.PostEnrollment,
                        Instructions = Guid.NewGuid().ToString(),
                        IsLoaRequired = random.Next(0, 1) == 0,
                        LibertyPowerSlaResponse = random.Next(100),
                        RequestModeType = Guid.NewGuid().ToString(),
                        UtilityId = random.Next(100),
                        UtilitySlaResponse = random.Next(200)
                    };
            }
        }

        public IdrRequestMode GetIdrRequestModeData(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string rateClass, string loadProfile, string annualUsage, bool hia)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            var iteration = random.Next(10);
            switch (iteration)
            {
                case 1:
                    return null;
                case 2:
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, "No Result Returned");
                case 3:
                    throw new UtilityManagementBusinessException(messageId, ERRORCODE, ERRORMESSAGE);
                case 4:
                    return new IdrRequestMode()
                    {
                        Address = string.Empty,
                        EmailTemplate = string.Empty,
                        EnrollmentType = EnrollmentType.PostEnrollment,
                        Instructions = string.Empty,
                        IsLoaRequired = false,
                        LibertyPowerSlaResponse = 0,
                        RequestModeType = string.Empty,
                        UtilityId = 0,
                        UtilitySlaResponse = 0,
                        IsProhibited = true
                    };
                default:
                    return new IdrRequestMode()
                    {
                        Address = Guid.NewGuid().ToString(),
                        EmailTemplate = Guid.NewGuid().ToString(),
                        EnrollmentType = EnrollmentType.PostEnrollment,
                        Instructions = Guid.NewGuid().ToString(),
                        IsLoaRequired = random.Next(0, 1) == 0,
                        LibertyPowerSlaResponse = random.Next(100),
                        RequestModeType = Guid.NewGuid().ToString(),
                        UtilityId = random.Next(100),
                        UtilitySlaResponse = random.Next(200),
                        IsProhibited = false
                    };
            }
        }

        public HasPurchaseOfReceivableAssuranceResponse HasPurchaseOfReceivableAssurance(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            return new HasPurchaseOfReceivableAssuranceResponse()
            {
                Code = CODE,
                IsSuccess = true,
                Message = string.Empty,
                MessageId = Guid.NewGuid().ToString(),
                HasPurchaseOfReceivableAssuranceList = new List<PurchaseOfReceivable>() 
                {
                    new PurchaseOfReceivable()
                    {
                        Id = Guid.NewGuid(),
                        IsPorAssurance = random.Next(0,1) == 0,
                        IsPorOffered = random.Next(0,1) == 0,
                        IsPorParticipated = random.Next(0,1) == 0,
                        PorDiscountEffectiveDate = DateTime.Now.AddDays(random.Next(30) - random.Next(10)),
                        PorDiscountExpirationDate = DateTime.Now.AddDays(random.Next(30) - random.Next(10)),
                        PorDiscountRate = (decimal)random.NextDouble(),
                        PorFlatFee = (decimal)random.NextDouble(),
                        PurchaseOfReceivableRecourse = PurchaseOfReceivableRecourse.Recourse
                    }
                }
            };
        }

        public List<UtilityManagementServiceData.BillingType> GetBillingTypes(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            int throwErrorCount = random.Next(10);
            List<UtilityManagementServiceData.BillingType> returnValue = new List<UtilityManagementServiceData.BillingType>();

            switch (throwErrorCount)
            {
                case 1:
                    return null;
                case 2:
                    throw new ArgumentException("Nothing!");
                default:
                    int numberOfItems = random.Next(3);
                    for (int i = 0; i < numberOfItems; i++)
                    {
                        returnValue.Add((BillingType)(i + 1));
                    }
                    return returnValue;
            }
        }

        public IGetAllUtilitiesResponse GetAllUtilities(string messageId)
        {
            throw new NotImplementedException();
        }

        public IGetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypes(string messageId)
        {
            throw new NotImplementedException();
        }

        public GetNextMeterReadResponse GetNextMeterRead(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            return new GetNextMeterReadResponse()
            {
                Code = CODE,
                IsSuccess = true,
                Message = string.Empty,
                MessageId = Guid.NewGuid().ToString(),
                NextMeterRead = DateTime.Now.AddDays(random.Next(30))
            };
        }

        public DateTime? GetNextMeterReadEstimated(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string accountNumber)
        {
            Random random = new Random(DateTime.Now.Millisecond);
            int throwErrorCount = random.Next(10);
            switch (throwErrorCount)
            {
                case 1:
                    return null;
                case 2:
                    throw new ArgumentException("Nothing!");
                default:
                    return DateTime.Now.AddDays(random.Next(31));
            }

        }
    }
}
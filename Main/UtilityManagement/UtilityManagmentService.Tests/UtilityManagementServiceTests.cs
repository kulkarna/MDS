using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Specialized;

namespace UtilityManagmentService.Tests
{
    public class UtilityData
    {
        public int LegacyUtilityId { get; set; }
        public string UtilityCode { get; set; }
        public Guid UtilityId { get; set; }
        public int UtilityIdInt { get; set; }
    }

    [TestClass]
    public class UtilityManagementServiceTests
    {

        private DataForTest GenerateData()
        {
            List<Guid> listOfRequestModeEnrollmentTypes = new List<Guid>();
            List<UtilityData> listOfUtilities = new List<UtilityData>();
            string messageId = Guid.NewGuid().ToString();
            using (UtiltyManagementService.UtilityManagementServiceClient client = new UtiltyManagementService.UtilityManagementServiceClient())
            {
                var utilityResponse = client.GetAllUtilities(messageId);
                if (utilityResponse.IsSuccess)
                {
                    foreach (var utility in utilityResponse.Utilities)
                    {
                        var utilityData = new UtilityData()
                        {
                            LegacyUtilityId = utility.LegacyUtilityId,
                            UtilityCode = utility.UtilityCode,
                            UtilityId = utility.UtilityId,
                            UtilityIdInt = utility.UtilityIdInt
                        };
                        listOfUtilities.Add(utilityData);
                    }

                    var requestModeEnrollmentTypeResponse = client.GetAllRequestModeEnrollmentTypes(messageId);
                    if (requestModeEnrollmentTypeResponse.IsSuccess)
                    {
                        foreach (var requestModeEnrollmentType in requestModeEnrollmentTypeResponse.RequestModeEnrollmentTypes)
                        {
                            listOfRequestModeEnrollmentTypes.Add(requestModeEnrollmentType.RequestModeEnrollmentTypeId);
                        }
                    }
                }
            }

            DataForTest dataForTest = new DataForTest()
            {
                ListOfEnrollmentTypes = listOfRequestModeEnrollmentTypes,
                ListOfUtilities = listOfUtilities
            };
            return dataForTest;
        }

    }

    public class DataForTest
    {
        public List<Guid> ListOfEnrollmentTypes { get; set; }
        public List<UtilityData> ListOfUtilities { get; set; }
        public int NumberOfUtilitiesInList
        {
            get
            {
                if (ListOfUtilities == null)
                    return 0;
                return ListOfUtilities.Count;
            }
        }
        public int NumberOfRequestModeEnrollmentTypes
        {
            get
            {
                if (ListOfEnrollmentTypes == null)
                    return 0;
                return ListOfEnrollmentTypes.Count;
            }
        }

    }
}
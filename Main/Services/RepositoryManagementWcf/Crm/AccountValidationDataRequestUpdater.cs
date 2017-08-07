using System;
using System.Diagnostics;
using System.Linq;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using Microsoft.Xrm.Sdk.Query;
using RepositoryManagementWcf.DataRequest;

namespace LibertyPower.RepositoryManagement.Web.Crm
{
    public class AccountValidationDataRequestUpdater : IAccountValidationDataRequestUpdater
    {
        public AccountValidationDataRequestUpdater(string crmUrl, string user, string password)
        {
            this.crmUrl = crmUrl;
            this.user = user;
            this.password = password;
        }

        public void Update(AccountValidationResponse validation)
        {
            try
            {
                DataRequestClient client = new DataRequestClient();
                client.AiComplete(validation.AccountNumber, validation.UtilityId, validation.IsDataProcessCompleted, validation.Message, validation.Source);
            }
            catch (Exception error)
            {
                EventLogger.WriteEntry(error.ToString(), EventLogEntryType.Error);
            }
        }

        private readonly string crmUrl;
        private readonly string user;
        private readonly string password;
    }
}
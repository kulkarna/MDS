using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.RepositoryManagement.Data;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using LibertyPower.RepositoryManagement.Services;
using UtilityLogging;


namespace LibertyPower.RepositoryManagement.Common
{
    public class RepositoryManagementFacade
    {
        public string UpdateCrmIfAccountMeetsPropertiesRequirements(int utilityId, string account, string messageId)
        {
            string method = string.Format("UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId:{0},account:{1},messageId)", utilityId.ToString(), account ?? "NULL");
            ILogger logger = new Logger();
            try
            {
                logger.LogInfo(messageId, string.Format("LibertyPower.RepositoryManagement.Common.{0} BEGIN", method));

                string connectionString = ConfigurationManager.ConnectionStrings["LibertyPowerDb"].ConnectionString;
                string crmUrl = ConfigurationManager.AppSettings["CrmUrl"];
                string crmUser = ConfigurationManager.AppSettings["CrmUser"];
                string crmPassword = ConfigurationManager.AppSettings["CrmPassword"];

                IAccountManagementRepository accountManagementRepository = new AccountManagementRepository(connectionString);  //()>().WithConstructorArgument("connectionString", Connections.LibertyPower);
                AccountManagementService accountManagementService = new AccountManagementService(accountManagementRepository);
                IAccountRequirementsProvider mustHavePropertiesProvider = new CachingAccountRequirementsProvider();
                IAccountValidationDataRequestUpdater accountValidationDataRequestUpdater = new AccountValidationDataRequestUpdater(crmUrl, crmUser, crmPassword);


                accountManagementService.UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(utilityId, account, mustHavePropertiesProvider, accountValidationDataRequestUpdater, messageId);


                logger.LogInfo(messageId, string.Format("LibertyPower.RepositoryManagement.Common.{0} return SUCCESS END", method));

                return "SUCCESS";
            }
            catch (Exception exc) 
            {
                logger.LogError(messageId, string.Format("ERROR:Message={0};StackTrace:{1}", exc.Message ?? "NULL", exc.StackTrace ?? "NULL"));
                logger.LogInfo(messageId, string.Format("LibertyPower.RepositoryManagement.Common.{0} return ERROR END", method));
                return exc == null ? "ERROR: Unspecified" : exc.Message;
            }
        }
    }
}

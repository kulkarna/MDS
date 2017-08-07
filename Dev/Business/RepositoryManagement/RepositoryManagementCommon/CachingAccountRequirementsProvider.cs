using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Web;
using AutoMapper;
using RepositoryManagementCommon.UtilityManagement;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using UtilityLogging;

namespace LibertyPower.RepositoryManagement.Common
{
    /// <summary>
    /// Class CachingAccountRequirementsProvider.
    /// </summary>
    internal class CachingAccountRequirementsProvider : IAccountRequirementsProvider
    {

        private ILogger _logger = new Logger();
        private const string NAMESPACE = "LibertyPower.RepositoryManagement.Web.AccountValidation";
        private const string CLASS = "CachingAccountRequirementsProvider";

        /// <summary>
        /// Initializes static members of the <see cref="CachingAccountRequirementsProvider"/> class.
        /// </summary>
        static CachingAccountRequirementsProvider()
        {
            Mapper.CreateMap<AccountInfoRequiredFields, AccountRequirements>();
        }

        /// <summary>
        /// Gets the utilities account must have properties.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <returns>List{AccountRequirements}.</returns>
        public List<AccountRequirements> GetUtilitiesAccountMustHaveProperties(string messageId)
        {
            string method = string.Format("GetUtilitiesAccountMustHaveProperties(messageId)");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                var service = GetCachedOrLive(messageId);
                _logger.LogDebug(messageId, "GetCachedOrLive Called");
                _logger.LogDebug(messageId, "service is null = " + (service == null).ToString());
                List<AccountRequirements> accountRequirementsList = new List<AccountRequirements>();
                foreach (AccountInfoRequiredFields item in service)
                {
                    AccountRequirements accountRequirements = new AccountRequirements()
                    {
                        MustHaveProperties = item.RequiredFields.ToList(),
                        UtilityCode = item.UtilityCode,
                        UtilityId = item.UtilityId
                    };
                    accountRequirementsList.Add(accountRequirements);
                }
                //var result = Mapper.Map<List<AccountInfoRequiredFields>, List<AccountRequirements>>(service);
                _logger.LogDebug(messageId, "Data Mapped");
                _logger.LogDebug(messageId, "result is null = " + (accountRequirementsList == null).ToString());

                return accountRequirementsList;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Gets the cached or live.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <returns>List{AccountInfoRequiredFields}.</returns>
        private List<AccountInfoRequiredFields> GetCachedOrLive(string messageId)
        {
            string method = string.Format("GetCachedOrLive(messageId)");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                const string key = "RequeredAccountFields";
                var result = HttpRuntime.Cache[key] as List<AccountInfoRequiredFields>;
                if (result == null)
                {
                    result = GetLive(messageId);
                    HttpRuntime.Cache.Insert(key, result, null, DateTime.Now.AddMinutes(Configuration.CacheUtilitiesRequiredAccountFieldsTimeOutMinutes), TimeSpan.Zero);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return result;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        /// <summary>
        /// Gets the live.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <returns>List{AccountInfoRequiredFields}.</returns>
        private List<AccountInfoRequiredFields> GetLive(string messageId)
        {
            string method = string.Format("GetLive(messageId)");
            List<AccountInfoRequiredFields> result;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _logger.LogDebug(messageId, "Instantiating UtilityManagementServiceClient");

                var client = new UtilityManagementServiceClient();

                try
                {

                    _logger.LogDebug(messageId, "Calling UtilityManagementServiceClient");
                    _logger.LogDebug(client.Endpoint.Address.Uri);
                    _logger.LogDebug(client.Endpoint.Binding.Name);
                    result = client.GetAllUtilityAccountInfoRequiredFields().ToList();
                    _logger.LogDebug(messageId, "UtilityManagementServiceClient Called, Closing Client");
                    client.Close();
                }
                catch (FaultException ex)
                {
                    string innerexception = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exeption = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exeption + innerexception;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    Console.WriteLine(ex);
                    client.Abort();
                    throw;
                }
                catch (CommunicationException ex)
                {
                    string innerexeption = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exeption = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exeption + innerexeption;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    Console.WriteLine(ex);
                    client.Abort();
                    throw;
                }
                catch (TimeoutException ex)
                {
                    string innerexeption = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exeption = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exeption + innerexeption;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    Console.WriteLine(ex);
                    client.Abort();
                    throw;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} result:{3} END", NAMESPACE, CLASS, method, result.ToString()));
                return result;
            }
            catch (Exception ex)
            {
                string innerexeption = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                string exeption = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                string errorMessage = exeption + innerexeption;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
    }
}
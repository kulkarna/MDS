using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoMapper;
using Core.Extensions.Data.SqlClient;
using System.Data;
using LibertyPower.RepositoryManagement.Core.AccountManagement;
using UtilityLogging;
using LibertyPower.RepositoryManagement.Dto;
using Utilities;

namespace LibertyPower.RepositoryManagement.Data
{
    public class AccountManagementRepository : IAccountManagementRepository
    {
        private readonly string connectionString;
        private readonly ILogger _logger = new Logger();
        private const string NAMESPACE = "LibertyPower.RepositoryManagement.Data";
        private const string CLASS = "AccountManagementRepository";

        static AccountManagementRepository()
        {
            Mapper.CreateMap<Core.AccountManagement.ServiceAccountProperty, LibertyPower.RepositoryManagement.Dto.ServiceAccountProperty>();
            Mapper.CreateMap<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperty, Core.AccountManagement.ServiceAccountProperty>();
            Mapper.CreateMap<Core.AccountManagement.ServiceAccountProperties, LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties>();
            Mapper.CreateMap<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties, Core.AccountManagement.ServiceAccountProperties>();
        }
        public AccountManagementRepository(string connectionString)
        {
            this.connectionString = connectionString;
        }

        private LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties CoreToDto(Core.AccountManagement.ServiceAccountProperties core)
        {
            var dto = Mapper.Map<Core.AccountManagement.ServiceAccountProperties, LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties>(core);
            dto.Properties = Mapper.Map<List<Core.AccountManagement.ServiceAccountProperty>, List<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperty>>(core.Properties);
            return dto;
        }

        private Core.AccountManagement.ServiceAccountProperties DtoToCore(string messageId, LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties dto)
        {
            string method = string.Format("DtoToCore(messageId,dto:{0})", dto);
            _logger.LogInfo(string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

            try
            {
                var core = Mapper.Map<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties, Core.AccountManagement.ServiceAccountProperties>(dto);

                core.Properties = Mapper.Map<List<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperty>, List<Core.AccountManagement.ServiceAccountProperty>>(dto.Properties);

                _logger.LogInfo(string.Format("{0}.{1}.{2} core:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(core == null ? "NULL" : core.ToString())));
                return core;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR", NAMESPACE, CLASS, method));
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void Save(Core.AccountManagement.ServiceAccountProperties accountProperties)
        {
            LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties ps = CoreToDto(accountProperties);
            using (var cmd = new SqlCommandWrapper<int>("usp_Determinants_SetAccountProperties", connectionString))
            {
                cmd.SetCommandType(CommandType.StoredProcedure)
                    .AddXml("@PropertiesXml", ps.ToXml())
                    .AsNonQuery();
            }
        }

        public Core.AccountManagement.ServiceAccountProperties GetServiceAccountProperties(string utility, string accountNumber)
        {
            string messageId = Guid.NewGuid().ToString();
            string method = string.Format("GetServiceAccountProperties(utility:{0}, accountNumber:{1})", utility, accountNumber);
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

            try
            {
                using (var cmd = new SqlCommandWrapper<LibertyPower.RepositoryManagement.Dto.ServiceAccountProperties>("usp_Determinants_AccountCurrentPropertiesSelectXml_RepoMan", connectionString))
                {
                    var result = cmd.SetCommandType(CommandType.StoredProcedure)
                        .AddString("@UtilityCode", utility)
                        .AddString("@AccountNumber", accountNumber)
                        .AddXml("@PropertiesXml", PropertiesToXml())
                        .AsSingleFromXml();

                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} result:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(result)));

                    Core.AccountManagement.ServiceAccountProperties returnValue = DtoToCore(messageId, result);

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(returnValue)));

                    return returnValue;
                }
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR", NAMESPACE, CLASS, method));
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetZipCodeByAccountNumber(string messageId, string accountNumber)
        {
            using (var cmd = new SqlCommandWrapper<string>("usp_OEAccountAddress_GetZipByAccountNumber", connectionString))
            {
                string zipCode = cmd.SetCommandType(CommandType.StoredProcedure).AddString("@AccountNumber", accountNumber).AsSingle();
                return zipCode;
            }
        }

        private string PropertiesToXml()
        {
            var names = Enum.GetNames(typeof(TrackedField)).ToList();
            var sb = new StringBuilder();
            sb.Append("<Properties>");
            foreach (var name in names)
                sb.Append("<Name>").Append(name).Append("</Name>");

            sb.Append("</Properties>");
            return sb.ToString();
        }


        //public Core.AccountManagement.ServiceAccountProperties GetServiceAccountProperties(string utility, string accountNumber)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
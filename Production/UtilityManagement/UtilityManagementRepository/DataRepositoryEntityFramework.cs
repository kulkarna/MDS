using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityLogging;
using UtilityUnityLogging;
using DataAccessLayerEntityFramework;
using Utilities;
using UtilityManagementServiceData;

namespace UtilityManagementRepository
{
    public class DataRepositoryEntityFramework : IDataRepository
    {

        #region private variables
        private const string NAMESPACE = "UtilityManagementRepository";
        private const string CLASS = "DataRepositoryEntityFramework";
        private string _messageId = Guid.NewGuid().ToString();
        private Lp_UtilityManagementEntities _lp_UtilityManagementEntities;
        private ILogger _logger;
        #endregion

        #region public constructors
        public DataRepositoryEntityFramework()
        {
            string method = "DataRepositoryEntityFramework()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion

        #region public properties
        public string MessageId { get { return _messageId; } set { _messageId = value; } }

        public List<DataAccessLayerEntityFramework.RequestModeEnrollmentType> RequestModeEnrollmentTypes
        {
            get
            {
                string method = "RequestModeEnrollmentTypes GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeEnrollmentTypes.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue.ToList();
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeHistoricalUsage> RequestModeHistoricalUsages
        {
            get
            {
                string method = "RequestModeHistoricalUsages GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeHistoricalUsages.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeIcap> RequestModeIcaps
        {
            get
            {
                string method = "RequestModeIcaps GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeIcaps.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeIdr> RequestModeIdrs
        {
            get
            {
                string method = "RequestModeIdrs GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeIdrs.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeType> RequestModeTypes
        {
            get
            {
                string method = "RequestModeTypes GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeTypes;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue.ToList();
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeGenre> RequestModeTypeGenres
        {
            get
            {
                string method = "RequestModeTypeGenres GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeTypeGenres.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeToRequestModeEnrollmentType> RequestModeTypeToRequestModeEnrollmentTypes
        {
            get
            {
                string method = "RequestModeTypeToRequestModeEnrollmentTypes GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeTypeToRequestModeEnrollmentTypes.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeToRequestModeTypeGenre> RequestModeTypeToRequestModeTypeGenres
        {
            get
            {
                string method = "RequestModeTypeToRequestModeTypeGenres GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.RequestModeTypeToRequestModeTypeGenres;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue.ToList();
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.CustomerAccountType> CustomerAccountTypes
        {
            get
            {
                string method = "CustomerAccountTypes GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.CustomerAccountTypes.OrderBy(x => x.AccountType);

                    if (returnValue == null)
                        _logger.LogError("returnValue is NULL!");
                    else
                        _logger.LogDebug("returnValue is not null");

                    var listVal = returnValue.ToList();

                    _logger.LogDebug("after listVal");

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));

                    return listVal;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies
        {
            get
            {
                string method = "UtilityCompanies GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UtilityCompanies.OrderBy(x => x.UtilityCode);

                    if (returnValue == null)
                        _logger.LogError("returnValue is NULL!");
                    else
                        _logger.LogDebug("returnValue is not null");

                    var listVal = returnValue.ToList();

                    _logger.LogDebug("after listVal");

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));

                    return listVal;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceControlAndValueGoverningControlVisibility> UserInterfaceControlAndValueGoverningControlVisibilities
        {
            get
            {
                string method = "UserInterfaceControlAndValueGoverningControlVisibilities GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UserInterfaceControlAndValueGoverningControlVisibilities;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue.ToList();
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceControlVisibility> UserInterfaceControlVisibilities
        {
            get
            {
                string method = "UserInterfaceControlVisibilities GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UserInterfaceControlVisibilities.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceForm> UserInterfaceForms
        {
            get
            {
                string method = "UserInterfaceForms GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UserInterfaceForms.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceFormControl> UserInterfaceFormControls
        {
            get
            {
                string method = "UserInterfaceFormControls GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UserInterfaceFormControls;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue.ToList();
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.zAuditRequestModeHistoricalUsage> zAuditRequestModeHistoricalUsages
        {
            get
            {
                string method = "zAuditRequestModeHistoricalUsages GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.zAuditRequestModeHistoricalUsages.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.zAuditUtilityCompany> zAuditUtilityCompanies
        {
            get
            {
                string method = "zAuditUtilityCompanies GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.zAuditUtilityCompanies.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UtilityLegacy> UtilityLegacies
        {
            get
            {
                string method = "UtilityLegacies GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UtilityLegacies.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public List<DataAccessLayerEntityFramework.UtilityCompanyToUtilityLegacy> UtilityCompanyToUtilityLegacies
        {
            get
            {
                string method = "UtilityCompanyToUtilityLegacies GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.UtilityCompanyToUtilityLegacies.ToList();

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public System.Data.Entity.Infrastructure.DbChangeTracker ChangeTracker
        {
            get
            {
                string method = "ChangeTracker GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.ChangeTracker;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public System.Data.Entity.Infrastructure.DbContextConfiguration Configuration
        {
            get
            {
                string method = "Configuration GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.Configuration;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public System.Data.Entity.Database Database
        {
            get
            {
                string method = "Database GET";
                try
                {
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                    if (_lp_UtilityManagementEntities == null)
                        _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                    var returnValue = _lp_UtilityManagementEntities.Database;

                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                    return returnValue;
                }
                catch (Exception exc)
                {
                    _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                    _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
            }
        }

        public System.Data.Objects.ObjectContext ObjectContext
        {
            get { throw new NotImplementedException(); }
        }
        #endregion


        public void Dispose()
        {
            string method = "Dispose()";
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities != null)
                    _lp_UtilityManagementEntities.Dispose();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId(string messageId, int utilityId)
        {
            // declare variables utilized throughout the method
            string method = string.Format("usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId(messageId,utilityId:{0}", utilityId);
            DataSet dataSet = null;

            try
            {
                // log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // ensure we have an active reference to the data framework
                if (_lp_UtilityManagementEntities == null)
                {
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                }

                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statemenet
                using (SqlConnection sqlConnection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId", sqlConnection))
                    {
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }
                // log the method exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return dataSet;
            }
            catch (Exception exc)
            { 
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR {3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly(string messageId)
        {
            // declare variables utilized throughout the method
            string method = "usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly(messageId)";
            DataSet dataSet = null;

            try
            {
                // log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // ensure we have an active reference to the data framework
                if (_lp_UtilityManagementEntities == null)
                {
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                }

                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
                using (SqlConnection sqlConnection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly", sqlConnection))
                    {
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                // log the method exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return dataSet;
            }
            catch (Exception exc)
            { 
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR {3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        ///  Method which calls the usp_MeterReadCalendarGetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate stored procedure on the LPCNOCSQLINT2\DELTA 
        ///  LP_UtilityManagement database which returns the next meter read date based on the utility id, read cycle id and inquiry date
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="utilityId">The integer representing a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt.</param>
        /// <param name="readCycleId">A string representing a particular Read Cycle or Meter Read Trip for a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.MeterReadCalendar.ReadCycleId.</param>
        /// <param name="isAmr">A boolean specifying whether the meters in question are automated meter reads.</param>
        /// <param name="inquiryDate">A date (usually today's date) serving as a reference point for obtaining the next future meter read for the specified utility id and read cycle id.</param>
        /// <returns>A dataset containing the next meter read date for the specified utility id, read cycle id and inquiry date.</returns>
        public DataSet usp_MeterReadCalender_GetNextReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            // declare variables used throughout the method
            string method = string.Format("usp_MeterReadCalender_GetNextReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId,utilityId:{0},readCycleId:{1},isAmr:{2},inquiryDate:{3})",
                Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(isAmr), Utilities.Common.NullSafeDateToString(inquiryDate));
            DataSet ds = new DataSet();

            try
            {
                //  log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // ensure we have an active reference to the data framework
                if (_lp_UtilityManagementEntities == null)
                {
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                }

                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    // create and execute the database command
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@InquiryDate", inquiryDate));
                        adapter.Fill(ds);
                    }
                }

                // log the exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        /// <summary>
        ///  Method which calls the usp_MeterReadCalendarGetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate stored procedure on the LPCNOCSQLINT2\DELTA 
        ///  LP_UtilityManagement database which returns the previous meter read date based on the utility id, read cycle id and inquiry date
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="utilityId">The integer representing a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt.</param>
        /// <param name="readCycleId">A string representing a particular Read Cycle or Meter Read Trip for a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.MeterReadCalendar.ReadCycleId.</param>
        /// <param name="isAmr">A boolean specifying whether the meters in question are automated meter reads.</param>
        /// <param name="inquiryDate">A date (usually today's date) serving as a reference point for obtaining the previous future meter read for the specified utility id and read cycle id.</param>
        /// <returns>A dataset containing the previous meter read date for the specified utility id, read cycle id and inquiry date.</returns>
        public DataSet usp_MeterReadCalender_GetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            // declare variables used throughout the method
            string method = string.Format("usp_MeterReadCalender_GetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId,utilityId:{0},readCycleId:{1},isAmr:{2},inquiryDate:{3})",
                Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(isAmr), Utilities.Common.NullSafeDateToString(inquiryDate));
            DataSet ds = new DataSet();

            try
            {
                //  log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // ensure we have an active reference to the data framework
                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    // create and execute the database command
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@InquiryDate", inquiryDate));
                        adapter.Fill(ds);
                    }
                }

                // log the exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists(string messageId, Guid utilityId, Guid porDriverId, Guid loadProfileId,
            Guid rateClassId, Guid tariffCodeId, Guid utilityOfferedBillingTypeId)
        {
            string method = string.Format("usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists(messageId,utilityId:{0},porDriverId:{1},loadProfileId:{2},rateClassId:{3},tariffCodeId:{4},utilityOfferedBillingTypeId:{5})",
                Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(porDriverId), Utilities.Common.NullSafeString(loadProfileId), Utilities.Common.NullSafeString(rateClassId),
                Utilities.Common.NullSafeString(tariffCodeId), Utilities.Common.NullSafeString(utilityOfferedBillingTypeId));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDriverId", porDriverId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileId", loadProfileId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassId", rateClassId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCodeId", tariffCodeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityOfferedBillingTypeId", utilityOfferedBillingTypeId));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue(string messageId, string utilityCode, string porDriver, string loadProfileCode,
            string rateClassCode, string tariffCode, string utilityOfferedBillingType, string lpApprovedBillingType)
        {
            string method = string.Format("usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue(messageId,utilityCode:{0},porDriver:{1},loadProfileCode:{2},rateClassCode:{3},tariffCode:{4},utilityOfferedBillingType:{5})",
                Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(porDriver), Utilities.Common.NullSafeString(loadProfileCode), Utilities.Common.NullSafeString(rateClassCode),
                Utilities.Common.NullSafeString(tariffCode), Utilities.Common.NullSafeString(utilityOfferedBillingType));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDriver", porDriver));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", loadProfileCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", rateClassCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityOfferedBillingType", utilityOfferedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpApprovedBillingType", lpApprovedBillingType));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LibertyPowerBillingType_SELECT_By_UtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LibertyPowerBillingType_SELECT_By_UtilityCode(messageId,utilityCode:{0})", Utilities.Common.NullSafeString(utilityCode));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LibertyPowerBillingType_SELECT_By_UtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LibertyPowerBillingType_SELECT_By_All(string messageId)
        {
            string method = "usp_LibertyPowerBillingType_SELECT_By_All(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LibertyPowerBillingType_SELECT_By_All", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_PurchaseOfReceivables_UPDATE(string messageId, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate, DateTime? expirationDate, bool inactive, string user)
        {
            string method = string.Format("usp_PurchaseOfReceivables_UPDATE(messageId,utilityCode:{0},porDriver:{1},loadProfileCode:{2},rateClassCode:{3},tariffCodeCode:{4},isOffered:{5},isParticipated:{6},isAssurance:{7},recourse:{8},discountRate:{9},flatFee:{10},effectiveDate:{11},expirationDate:{12},inactive:{13},user:{14})",
                Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(porDriver),
                Utilities.Common.NullSafeString(loadProfileCode), Utilities.Common.NullSafeString(rateClassCode), Utilities.Common.NullSafeString(tariffCodeCode),
                Utilities.Common.NullSafeString(isOffered), Utilities.Common.NullSafeString(isParticipated), Utilities.Common.NullSafeString(isAssurance),
                Utilities.Common.NullSafeString(recourse), Utilities.Common.NullSafeString(discountRate), Utilities.Common.NullSafeString(flatFee),
                Utilities.Common.NullSafeDateToString(effectiveDate), Utilities.Common.NullSafeDateToString(expirationDate), Utilities.Common.NullSafeString(inactive),
                Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_PurchaseOfReceivables_UPDATE_ByLookupParameters(utilityCode, porDriver, rateClassCode, loadProfileCode, tariffCodeCode,
                    isOffered, isParticipated, recourse, isAssurance, discountRate, flatFee, effectiveDate, expirationDate, inactive, user, DateTime.Now, user, DateTime.Now);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_PurchaseOfReceivables_INSERT(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode,
            string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate,
            DateTime? expirationDate, bool inactive, string user)
        {
            string method = string.Format("usp_PurchaseOfReceivables_INSERT(messageId,id:{0},utilityCode:{1},porDriver:{2},loadProfileCode:{3},rateClassCode:{4},tariffCodeCode:{5},isOffered:{6},isParticipated:{7},isAssurance:{8},recourse:{9},discountRate:{10},flatFee:{11},effectiveDate:{12},expirationDate:{13},inactive:{14},user:{15})",
                Utilities.Common.NullSafeString(id), Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(porDriver),
                Utilities.Common.NullSafeString(loadProfileCode), Utilities.Common.NullSafeString(rateClassCode), Utilities.Common.NullSafeString(tariffCodeCode),
                Utilities.Common.NullSafeString(isOffered), Utilities.Common.NullSafeString(isParticipated), Utilities.Common.NullSafeString(isAssurance),
                Utilities.Common.NullSafeString(recourse), Utilities.Common.NullSafeString(discountRate), Utilities.Common.NullSafeString(flatFee),
                Utilities.Common.NullSafeDateToString(effectiveDate), Utilities.Common.NullSafeDateToString(expirationDate), Utilities.Common.NullSafeString(inactive),
                Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_PurchaseOfReceivables_INSERT_ByLookupParameters(id, utilityCode, porDriver, rateClassCode, loadProfileCode,
                    tariffCodeCode, isOffered, isParticipated, recourse, isAssurance, discountRate, flatFee, effectiveDate,
                    expirationDate, inactive, user, DateTime.Now, user, DateTime.Now);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool usp_UtilityCompany_DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode)
        {
            string method = string.Format("usp_UtilityCompany_DoesUtilityCodeBelongToIso(messageId,Iso:{0},UtilityCode:{1})", Iso, UtilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                bool returnValue = false;

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var sprocReturnValue = _lp_UtilityManagementEntities.usp_UtilityCompany_DoesUtilityCodeBelongToIso(Iso, UtilityCode);
                int? nullableValue = sprocReturnValue.FirstOrDefault();
                if (nullableValue == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:false END", NAMESPACE, CLASS, method));
                    return false;
                }
                returnValue = nullableValue == 1;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<int?> usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(string requestModeEnrollmentTypeId, string utilityCompanyId)
        {
            string method = string.Format("usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(requestModeEnrollmentTypeId:{0}, utilityCompanyId:{1})", requestModeEnrollmentTypeId, utilityCompanyId);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(requestModeEnrollmentTypeId, utilityCompanyId);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<string> usp_RequestModeEnrollmentType_SELECT_NameById(string id)
        {
            string method = string.Format("usp_RequestModeEnrollmentType_SELECT_NameById(id:{0})", id);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_RequestModeEnrollmentType_SELECT_NameById(id);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<string> usp_RequestModeType_SELECT_NameById(string id)
        {
            string method = string.Format("usp_RequestModeType_SELECT_NameById(id:{0})", id);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_RequestModeType_SELECT_NameById(id);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<usp_AccountInfoFieldRequired_GetByUtility_Result> usp_AccountInfoFieldRequired_GetByUtility(string messageId)
        {
            string method = "usp_AccountInfoFieldRequired_GetByUtility()";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_AccountInfoFieldRequired_GetByUtility();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public List<usp_IdrRule_IntegratedWithTariffCode_Result> usp_IdrRule_Integrated(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage)
        {
            string method = "usp_IdrRule_Integrated()";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_IdrRule_IntegratedWithTariffCode(rateClassCode, loadProfileCode, tariffCodeCode, eligibility, hia, utilityIdInt, usage);

                var returnValueList = returnValue.ToList();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValueList;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public List<usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType)
        {
            string method = string.Format("usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest(messageId,rateClassCode:{0},loadProfileCode:{1},tariffCodeCode:{2},eligibility:{3},hia:{4},utilityIdInt:{5},usage:{6},enrollmentType:{7})",
                Common.NullSafeString(rateClassCode), Common.NullSafeString(loadProfileCode), Common.NullSafeString(tariffCodeCode), Common.NullSafeString(eligibility), Common.NullSafeString(hia), Common.NullSafeString(utilityIdInt), Common.NullSafeString(usage), Common.NullSafeString(enrollmentType));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest(rateClassCode, loadProfileCode, tariffCodeCode, eligibility, hia, utilityIdInt, usage, Common.NullSafeString(enrollmentType));

                var returnValueList = returnValue.ToList();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValueList;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public List<usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType)
        {
            string method = string.Format("usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField(messageId,rateClassCode:{0},loadProfileCode:{1},tariffCodeCode:{2},eligibility:{3},hia:{4},utilityIdInt:{5},usage:{6},enrollmentType:{7})",
                Common.NullSafeString(rateClassCode), Common.NullSafeString(loadProfileCode), Common.NullSafeString(tariffCodeCode), Common.NullSafeString(eligibility), Common.NullSafeString(hia), Common.NullSafeString(utilityIdInt), Common.NullSafeString(usage), Common.NullSafeString(enrollmentType));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField(rateClassCode, loadProfileCode, tariffCodeCode, eligibility, hia, utilityIdInt, usage, Common.NullSafeString(enrollmentType));

                var returnValueList = returnValue.ToList();
                var returnValueValue = returnValueList.FirstOrDefault();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValueValue[businessFactorNotMet:{3},GuaranteedFactorNotMet:{4},InsufficientInfo:{5},IsAlwaysRequestSet:{6},Match:{7}] END",
                    NAMESPACE, CLASS, method, returnValueValue.BusinessFactorNotMet,
                    returnValueValue.GuaranteedFactorNotMet, returnValueValue.InsufficientInfo, returnValueValue.IsAlwaysRequestSet,
                    returnValueValue.Match));

                return returnValueList;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId_Result> usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(string requestModeEnrollmentTypeId)
        {
            string method = string.Format("usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(requestModeEnrollmentTypeId:{0})", requestModeEnrollmentTypeId);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(requestModeEnrollmentTypeId);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<usp_IdrRuleAndRequestMode_SelectByParamWithTariffCode_Result> usp_IdrRuleAndRequestMode_SelectByParam(string messageId, int utilityIdInt, string rateClass, string loadProfile, string tariffCode, string annualUsage, int enrollmentType, bool? isHia)
        {
            string method = string.Format("usp_IdrRuleAndRequestMode_SelectByParam(messageId,utilityIdInt:{0},rateClass:{1},loadProfile:{2},annualUsage:{3},enrollmentType:{4},isHia:{5})", utilityIdInt, rateClass, loadProfile, annualUsage, enrollmentType, isHia == null ? "NULL VALUE" : isHia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                int? annualUsageInt = null;
                int annualUsageIntTemp = 0;
                if (!string.IsNullOrWhiteSpace(annualUsage) && int.TryParse(annualUsage, out annualUsageIntTemp))
                    annualUsageInt = annualUsageIntTemp;
                var returnValue = _lp_UtilityManagementEntities.usp_IdrRuleAndRequestMode_SelectByParamWithTariffCode(rateClass, loadProfile, tariffCode, utilityIdInt, annualUsageInt, enrollmentType, isHia);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<usp_IdrRuleAndRequestMode_SelectByParams_Result> usp_IdrRuleAndRequestMode_SelectByParams(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, string enrollmentType, bool? isHia)
        {
            string method = string.Format("usp_IdrRuleAndRequestMode_Select(messageId,utilityIdInt:{0},rateClass:{1},loadProfile:{2},annualUsage:{3},enrollmentType:{4},isHia:{5})", utilityIdInt, rateClass, loadProfile, annualUsage, enrollmentType, isHia == null ? "NULL VALUE" : isHia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                int? annualUsageInt = null;
                int annualUsageIntTemp = 0;
                if (!string.IsNullOrWhiteSpace(annualUsage) && int.TryParse(annualUsage, out annualUsageIntTemp))
                    annualUsageInt = annualUsageIntTemp;
                var returnValue = _lp_UtilityManagementEntities.usp_IdrRuleAndRequestMode_SelectByParams(rateClass, loadProfile, utilityIdInt, annualUsageInt, enrollmentType, isHia);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityCompanyLoadProfileRateClassTariffCode(string messageId, string utilityCode, string loadProfile, string rateClass, string tariffCode)
        {
            string method = string.Format("usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode(messageId,utilityCode:{0},loadProfile:{1},rateClass:{2},tariffCode:{3})", utilityCode, loadProfile ?? "NULL VALUE", rateClass ?? "NULL VALUE", tariffCode ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                if (string.IsNullOrWhiteSpace(loadProfile))
                    loadProfile = null;
                if (string.IsNullOrWhiteSpace(rateClass))
                    rateClass = null;
                if (string.IsNullOrWhiteSpace(tariffCode))
                    tariffCode = null;


                var returnValue = _lp_UtilityManagementEntities.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode(utilityCode, loadProfile, rateClass, tariffCode);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public System.Data.Objects.ObjectResult<int?> usp_BillingType_RetrieveByUtilityRateClassLoadProfileTariffCode(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode)
        {
            string method = string.Format("usp_BillingType_RetrieveByUtilityRateClassLoadProfileTariffCode(messageId,utilityIdInt:{0},loadProfile:{1},rateClass:{2},tariffCode:{3})", utilityIdInt, loadProfile ?? "NULL VALUE", rateClass ?? "NULL VALUE", tariffCode ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                var returnValue = _lp_UtilityManagementEntities.usp_BillingType_RetrieveBy_UtilityRateClassLoadProfileTariffCode(utilityIdInt, rateClass, loadProfile, tariffCode);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_BillingTypeWithDefault_RetrieveByUtilityRateClassLoadProfileTariffCode(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode)
        {
            string method = string.Format("usp_BillingTypeWithDefault_RetrieveByUtilityRateClassLoadProfileTariffCode(messageId,utilityIdInt:{0},loadProfile:{1},rateClass:{2},tariffCode:{3})", utilityIdInt, loadProfile ?? "NULL VALUE", rateClass ?? "NULL VALUE", tariffCode ?? "NULL VALUE");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_BillingTypeWithDefault_RetrieveBy_UtilityRateClassLoadProfileTariffCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityIdInt", utilityIdInt));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", Common.NullSafeString(rateClass)));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", Common.NullSafeString(loadProfile)));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", Common.NullSafeString(tariffCode)));
                        //adapter.SelectCommand.Parameters.Add(new SqlParameter("@MessageID", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        public System.Data.Objects.ObjectResult<Nullable<int>> usp_IdrRule_InsufficientInformation(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, bool? isOnEligibilityList, bool? isHia)
        {
            string method = string.Format("usp_IdrRule_InsufficientInformation(messageId,utilityIdInt:{0},rateClass:{1},loadProfile:{2},annualUsage:{3},isOnEligibilityList:{4},isHia:{5})", utilityIdInt, rateClass ?? "NULL VALUE", loadProfile ?? "NULL VALUE", annualUsage ?? "NULL VALUE", isOnEligibilityList == null ? "NULL VALUE" : isOnEligibilityList.ToString(), isHia == null ? "NULL VALUE" : isHia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                int? usageInt = null;
                int usage = 0;
                if (!string.IsNullOrWhiteSpace(annualUsage) && int.TryParse(annualUsage, out usage))
                    usageInt = usage;

                var returnValue = _lp_UtilityManagementEntities.usp_IdrRule_InsufficientInfo(utilityIdInt, rateClass, loadProfile, usageInt, isOnEligibilityList, isHia);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName_Result> usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(string requestModeEnrollmentTypeId, string requestModeTypeGenreName)
        {
            string method = string.Format("usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(requestModeEnrollmentTypeId:{0}, requestModeTypeGenreName:{1})", requestModeEnrollmentTypeId, requestModeTypeGenreName);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(requestModeEnrollmentTypeId, requestModeTypeGenreName);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate)
        {
            string method = string.Format("usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate(utilityIdInt:{0}, loadProfile:{1}, rateClass={2}, tariffCode={3}, porEffectiveDate={4})", utilityIdInt, loadProfile ?? "NULL VALUE", rateClass ?? "NULL VALUE", tariffCode ?? "NULL VALUE", porEffectiveDate);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate(utilityIdInt, porEffectiveDate, loadProfile, rateClass, tariffCode);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DateTime? usp_MeterReadSchedule_GetNext(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string serviceAccountNumber)
        {
            string method = string.Format("usp_MeterReadSchedule_GetNext(utilityIdInt:{0}, tripNumber:{1}, referenceDate={2}, serviceAccountNumber={3})", utilityIdInt, tripNumber, referenceDate, serviceAccountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_MeterReadSchedule_GetNext(utilityIdInt, tripNumber, referenceDate, serviceAccountNumber);
                if (returnValue == null)
                    return null;
                var processedReturnValue = returnValue.FirstOrDefault();
                if (processedReturnValue == null)
                    return null;
                var finalReturnValue = processedReturnValue.ReadDate;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, finalReturnValue));

                return finalReturnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm_Result> usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(string formName)
        {
            string method = string.Format("usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(formName:{0})", formName);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(formName);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Entity.Infrastructure.DbEntityEntry Entry(object entity)
        {
            string method = string.Format("Entry(entity:{0})", entity);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.Entry(entity);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class
        {
            string method = string.Format("Entry<TEntity>(TEntity entity:{0})", entity);
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.Entry<TEntity>(entity);

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> GetValidationErrors()
        {
            string method = string.Format("GetValidationErrors()");
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.GetValidationErrors();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public int SaveChanges()
        {
            string method = string.Format("SaveChanges()");
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.SaveChanges();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public List<TEntity> Set<TEntity>() where TEntity : class
        {
            string method = string.Format("Set<TEntity>()");
            try
            {
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();
                var returnValue = _lp_UtilityManagementEntities.Set<TEntity>();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue.ToList();

            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetZoneByUtilityCodeAndZipCodeFromDealCapture(string messageId, string utilityCode, string zipCode)
        {
            string method = string.Format("GetZoneByUtilityCodeAndZipCodeFromDealCapture(messageId,utilityCode:{0},zipCode:{1})", utilityCode, zipCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                Lp_deal_captureEntities lpDealCaptureEntities = new Lp_deal_captureEntities();
                usp_zip_to_zone_lookup_sel_Result usp_zip_to_zone_lookup_sel_Result = lpDealCaptureEntities.usp_zip_to_zone_lookup_sel(utilityCode, zipCode).FirstOrDefault();
                string returnValue = usp_zip_to_zone_lookup_sel_Result.zone;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} zone:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetZoneByAccountNumberFromErcot(string messageId, string accountNumber)
        {
            string method = string.Format("GetZoneByAccountNumberFromErcot(messageId,accountNumber:{0})", accountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                ErcotEntities ercotEntities = new ErcotEntities();
                usp_ErcotAccountInfoAccounts_GetZoneAndZipByAccountNumber_Result usp_ErcotAccountInfoAccounts_GetZoneAndZipByAccountNumber_Result = ercotEntities.usp_ErcotAccountInfoAccounts_GetZoneAndZipByAccountNumber(accountNumber).FirstOrDefault();
                string returnValue = usp_ErcotAccountInfoAccounts_GetZoneAndZipByAccountNumber_Result.DCZone;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} zone:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCodeAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_TariffCodeAlias_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCodeAlias_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCodeAlias_GetAll(string messageId)
        {
            string method = "usp_TariffCodeAlias_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCodeAlias_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCode_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_TariffCode_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCode_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCode_GetAll(string messageId)
        {
            string method = "usp_TariffCode_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCode_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardTariffCode_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LpStandardTariffCode_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardTariffCode_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardTariffCode_GetAll(string messageId)
        {
            string method = "usp_LpStandardTariffCode_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardTariffCode_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardTariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, bool inactive, string user)
        {
            string method = string.Format("usp_LpStandardTariffCode_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardTariffCode:{2},inactive:{3},user:{4})",
                id, utilityCode, lpStandardTariffCode, inactive, user);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardTariffCode_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardTariffCode", lpStandardTariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, string tariffCode, string description, string accountType, bool inactive, string user)
        {
            string method = string.Format("usp_TariffCode_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardTariffCode:{2},tariffCode:{3},description:{4},accountType:{5},inactive:{6},user:{7}",
                id, utilityCode, lpStandardTariffCode, tariffCode, description, accountType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCode_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardTariffCode", lpStandardTariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Description", description));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_TariffCodeAlias_UPSERT(string messageId, string id, string utilityCode, int tariffCodeId, string tariffCodeCodeAlias, bool inactive, string user)
        {
            string method = string.Format("usp_TariffCodeAlias_UPSERT(messageId,id:{0},utilityCode:{1},tariffCodeId:{2},tariffCodeCodeAlias:{3},inactive:{4},user:{5}",
                id, utilityCode, tariffCodeId, tariffCodeCodeAlias, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCodeAlias_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCodeId", tariffCodeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCodeAlias", tariffCodeCodeAlias));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardRateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, bool inactive, string user)
        {
            string method = string.Format("usp_LpStandardRateClass_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardRateClass:{2},inactive:{3},user:{4})",
                id, utilityCode, lpStandardRateClass, inactive, user);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardRateClass_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardRateClass", lpStandardRateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, string rateClass, string description, string accountType, bool inactive, string user)
        {
            string method = string.Format("usp_RateClass_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardRateClass:{2},rateClass:{3},description:{4},accountType:{5},inactive:{6},user:{7}",
                id, utilityCode, lpStandardRateClass, rateClass, description, accountType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClass_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardRateClass", lpStandardRateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Description", description));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClassAlias_UPSERT(string messageId, string id, string utilityCode, int rateClassId, string rateClassCodeAlias, bool inactive, string user)
        {
            string method = string.Format("usp_RateClassAlias_UPSERT(messageId,id:{0},utilityCode:{1},rateClassId:{2},rateClassCodeAlias:{3},inactive:{4},user:{5}",
                id, utilityCode, rateClassId, rateClassCodeAlias, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClassAlias_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassId", rateClassId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassAlias", rateClassCodeAlias));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardLoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, bool inactive, string user)
        {
            string method = string.Format("usp_LpStandardLoadProfile_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardLoadProfile:{2},inactive:{3},user:{4})",
                id, utilityCode, lpStandardLoadProfile, inactive, user);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardLoadProfile_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardLoadProfile", lpStandardLoadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, string loadProfile, string description, string accountType, bool inactive, string user)
        {
            string method = string.Format("usp_LoadProfile_UPSERT(messageId,id:{0},utilityCode:{1},lpStandardLoadProfile:{2},loadProfile:{3},description:{4},accountType:{5},inactive:{6},user:{7}",
                id, utilityCode, lpStandardLoadProfile, loadProfile, description, accountType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfile_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpStandardLoadProfile", lpStandardLoadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Description", description));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfileAlias_UPSERT(string messageId, string id, string utilityCode, int loadProfileId, string loadProfileCodeAlias, bool inactive, string user)
        {
            string method = string.Format("usp_LoadProfileAlias_UPSERT(messageId,id:{0},utilityCode:{1},loadProfileId:{2},loadProfileCodeAlias:{3},inactive:{4},user:{5}",
                id, utilityCode, loadProfileId, loadProfileCodeAlias, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfileAlias_UPSERT", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileId", loadProfileId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileAlias", loadProfileCodeAlias));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return ds END", NAMESPACE, CLASS, method));
                return ds;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClassAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_RateClassAlias_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClassAlias_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClass_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_RateClass_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClass_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClass_GetAll(string messageId)
        {
            string method = "usp_RateClass_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClass_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardRateClass_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LpStandardRateClass_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardRateClass_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardRateClass_GetAll(string messageId)
        {
            string method = "usp_LpStandardRateClass_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardRateClass_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfileAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LoadProfileAlias_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfileAlias_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfileAlias_GetAll(string messageId)
        {
            string method = "usp_LoadProfileAlias_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfileAlias_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfile_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LoadProfile_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfile_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LoadProfile_GetAll(string messageId)
        {
            string method = "usp_LoadProfile_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfile_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardLoadProfile_GetAll(string messageId)
        {
            string method = "usp_LpStandardLoadProfile_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardLoadProfile_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_RateClassAlias_GetAll(string messageId)
        {
            string method = "usp_RateClassAlias_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RateClassAlias_GetAll", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_LpStandardLoadProfile_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_LpStandardLoadProfile_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_LpStandardLoadProfile_GetByUtilityCode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PurchaseOfReceivables_IsDuplicate(string messageId, string utilityCode, string porDriverName, string loadProfileCode,
            string rateClassCode, string tariffCodeCode, bool isPorOffered, bool isPorParticipated, bool isPorAssurance, string porRecourse,
            decimal porDiscountRate, decimal porFlatFee, DateTime porDiscountEffectivedDate, DateTime? porDiscountExpirationDate, bool inactive)
        {
            string method = string.Format("usp_PurchaseOfReceivables_IsDuplicate(messageId,utilityCode:{0},porDriverName:{1},loadProfileCode:{2},rateClassCode:{3},tariffCodeCode:{4},isPorOffered:{5},isPorParticipated:{6},isPorAssurance:{7},porRecourse:{8},porDiscountRate:{9},porFlatFee:{10},porDiscountEffectivedDate:{11},porDiscountExpirationDate:{12},inactive:{13})",
                utilityCode, porDriverName, loadProfileCode, rateClassCode, tariffCodeCode, isPorOffered, isPorParticipated, isPorAssurance, porRecourse, porDiscountRate, porFlatFee, Utilities.Common.NullSafeDateToString(porDiscountEffectivedDate),
                Utilities.Common.NullSafeDateToString(porDiscountExpirationDate), inactive);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PurchaseOfReceivables_IsDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDriverName", porDriverName));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileCode", loadProfileCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassCode", rateClassCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCodeCode", tariffCodeCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsPorOffered", isPorOffered));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsPorParticipated", isPorParticipated));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsPorAssurance", isPorAssurance));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorRecourse", porRecourse));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDiscountRate", porDiscountRate));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorFlatFee", porFlatFee));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDiscountEffectivedDate", porDiscountEffectivedDate));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDiscountExpirationDate", porDiscountExpirationDate));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PurchaseOfReceivables_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_PurchaseOfReceivables_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PurchaseOfReceivables_GetByUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PurchaseOfReceivables_GetAll(string messageId)
        {
            string method = "usp_PurchaseOfReceivables_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PurchaseOfReceivables_GetAll", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PurchaseOfReceivables_GetUndefined(string messageId)
        {
            string method = "usp_PurchaseOfReceivables_GetUndefined(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PurchaseOfReceivables_GetAllUndefinedPors", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PurchaseOfReceivables_GetUndefinedAndAll(string messageId)
        {
            string method = "usp_PurchaseOfReceivables_GetUndefinedAndAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PurchaseOfReceivables_GetAllAndGetAllUndefinedPors", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_LpBillingType_GetAllDefinedAndEmptyLpBillingTypes(string messageId)
        {
            string method = "usp_LpBillingType_GetAllDefinedAndEmptyLpBillingTypes(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_GetAllDefinedAndEmptyLpBillingTypes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_LpBillingType_GetAllEmptyLpBillingTypes(string messageId)
        {
            string method = "usp_LpBillingType_GetAllEmptyLpBillingTypes(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_GetAllEmptyLpBillingTypes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_MeterReadCalendar_IsExactDuplicate(string messageId, string utilityCode, int year, int month,
            string readCycleId, string readDate,bool isAmr, bool inactive)
        {
            string method = string.Format("usp_MeterReadCalendar_IsExactDuplicate(messageId,utilityCode:{0},year:{1},month:{2},readCycleId:{3},readDate:{4},isAmr{5},inactive:{6})",
                utilityCode, year, month, readCycleId, readDate, isAmr,inactive);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalendar_IsExactDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Year", year));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Month", month));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadDate", readDate));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_MeterReadCalendar_IsDuplicate(string messageId, string utilityCode, int year, int month,
            string readCycleId,bool isAmr)
        {
            string method = string.Format("usp_MeterReadCalendar_IsDuplicate(messageId,utilityCode:{0},year:{1},month:{2},readCycleId:{3},isAmr{4})",
                utilityCode, year, month, readCycleId,isAmr);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalendar_IsDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Year", year));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Month", month));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_CapacityTresholdRule_UPDATE(string messageId, string utilityCode, bool
            CapcacityCheck, string AccountType, int CapacityTresholdmin, int CapacityTresholdmax, bool inactive,string userName)
        {
            string method = string.Format("usp_CapacityTresholdRule_UPDATE(messageId : {0},utilityCode:{1},CapcacityCheck:{2},AccountType:{3},CapacityTresholdmin{4},CapacityTresholdmax{5},inactive{6},userName{7})", Common.NullSafeString(messageId), utilityCode,
                                         Common.NullSafeString(CapcacityCheck), Common.NullSafeString(AccountType), CapacityTresholdmin, CapacityTresholdmax, Common.NullSafeString(inactive),userName);
                
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.USP_CAPACITYTRESHOLDRULE_UPDATE(utilityCode, AccountType, CapcacityCheck, CapacityTresholdmin, CapacityTresholdmax, inactive,userName);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_CapacityTresholdRule_Insert(string messageId, string utilityCode, bool
            CapcacityCheck, string AccountType, int CapacityTresholdmin, int CapacityTresholdmax, bool inactive,string user)
        {
            string method = string.Format("usp_CapacityTresholdRule_Insert(messageId : {0},utilityCode:{1},CapcacityCheck:{2},AccountType:{3})", Common.NullSafeString(messageId), utilityCode,
                                         Common.NullSafeString(CapcacityCheck), Common.NullSafeString(AccountType), CapacityTresholdmin, CapacityTresholdmax, Common.NullSafeString(inactive));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.USP_CAPACITYTRESHOLDRULE_INSERT (utilityCode, AccountType, CapcacityCheck, CapacityTresholdmin, CapacityTresholdmax, inactive,user);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_CapacityTresholdRule_IsDuplicate(string messageId, string utilityCode,string AccountType)
        {
            string method = string.Format("usp_CapacityTresholdRule_IsDuplicate(messageId:{0},utilityCode:{1},AccountType:{2})",
               messageId,utilityCode,AccountType);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_CapacityTresholdRule_IsDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", AccountType));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_CapacityTresholdRule_IsExactDuplicate(string messageId, string utilityCode, bool
            CapcacityCheck, string AccountType, int CapacityTresholdmin, int CapacityTresholdmax, bool inactive)
        {
            string method = string.Format("usp_CapacityTresholdRule_IsExactDuplicate(messageId : {0},utilityCode:{1},CapcacityCheck:{2},AccountType:{3})", Common.NullSafeString(messageId), utilityCode,
                                         Common.NullSafeString(CapcacityCheck), Common.NullSafeString(AccountType), CapacityTresholdmin, CapacityTresholdmax, Common.NullSafeString(inactive));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("USP_CAPACITYTRESHOLDRULE_ISEXACTDUPLICATE", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UTILITYCODE", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ACCOUNTTYPE", AccountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@CapacityCheck", CapcacityCheck));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@CapacityTresholdMin", CapacityTresholdmin));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@CapacityTresholdMax", CapacityTresholdmax));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_CapacityThresholdRuleGetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_CapacityThresholdRuleGetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_CapacityThresholdRuleGetByUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        //adapter.SelectCommand.Parameters.Add(new SqlParameter("@MessageID", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_MeterReadCalendar_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_MeterReadCalendar_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalendar_GetByUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        //adapter.SelectCommand.Parameters.Add(new SqlParameter("@MessageID", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_CapacityThresholdRule_GetAll(string messageId)
        {
            string method = "usp_CapacityThresholdRule_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_CapacityThresholdRule_GetAll", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_MeterReadCalendar_GetAll(string messageId)
        {
            string method = "usp_MeterReadCalendar_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalendar_GetAll", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_MeterReadCalendar_INSERT(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate,bool isAmr, bool inactive, string user)
        {
            string method = string.Format("usp_MeterReadCalendar_INSERT(messageId,id:{0},utilityCode:{1},year:{2},month:{3},readCycleId:{4},readDate:{5},isAmr:{6},inactive:{7},user:{8})",
                Utilities.Common.NullSafeString(id), Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(year),
                Utilities.Common.NullSafeString(month), Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeDateToString(readDate),
                Utilities.Common.NullSafeString(isAmr),
                Utilities.Common.NullSafeString(inactive),Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_MeterReadCalendar_INSERT(id, utilityCode, year, month, readCycleId,readDate,isAmr, inactive, user);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_MeterReadCalendar_UPDATE(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate,bool isAmr, bool inactive, string user)
        {
            string method = string.Format("usp_MeterReadCalendar_UPDATE(messageId,utilityCode:{0},year:{1},month:{2},readCycleId:{3},readDate:{4},isAmr:{5},inactive:{6},user:{7})",
                Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(year),Utilities.Common.NullSafeString(month), 
                Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(readDate),
                Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(isAmr),
                Utilities.Common.NullSafeString(inactive),
                Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_MeterReadCalendar_UPDATE(id, utilityCode, year, month, readCycleId, readDate,isAmr,
                    inactive, user);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }




        public DataSet usp_PaymentTerm_IsExactDuplicate(string messageId, string utilityCode, string accountType, string billingType,
            string market, string paymentTerm, bool inactive)
        {
            string method = string.Format("usp_PaymentTerm_IsExactDuplicate(messageId,utilityCode:{0},accountType:{1},billingType:{2},market:{3},paymentTerm:{4},inactive:{5})",
                utilityCode, accountType, billingType, market, paymentTerm, inactive);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PaymentTerm_IsExactDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@BillingType", billingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Market", market));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PaymentTerm", paymentTerm));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PaymentTerm_IsDuplicate(string messageId, string utilityCode, string accountType, string billingType,
            string market)
        {
            string method = string.Format("usp_PaymentTerm_IsDuplicate(messageId,utilityCode:{0},accountType:{1},billingType:{2},market:{3})",
                utilityCode, accountType, billingType, market);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PaymentTerm_IsDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@BillingType", billingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Market", market));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PaymentTerm_GetByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("usp_PaymentTerm_GetByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PaymentTerm_GetByUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_PaymentTerm_GetAll(string messageId)
        {
            string method = "usp_PaymentTerm_GetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_PaymentTerm_GetAll", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_PaymentTerm_INSERT(string messageId, Guid id, string utilityCode, string accountType, string billingType, string market, string paymentTerm, bool inactive, string user)
        {
            string method = string.Format("usp_PaymentTerm_INSERT(messageId,id:{0},utilityCode:{1},accountType:{2},billingType:{3},market:{4},paymentTerm:{5},inactive:{6},user:{7})",
                Utilities.Common.NullSafeString(id), Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountType),
                Utilities.Common.NullSafeString(billingType), Utilities.Common.NullSafeString(market), Utilities.Common.NullSafeDateToString(paymentTerm),
                Utilities.Common.NullSafeString(inactive), Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_PaymentTerm_INSERT(id, utilityCode, accountType, billingType, market,
                    paymentTerm, inactive, user);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_PaymentTerm_UPDATE(string messageId, Guid id, string utilityCode, string accountType, string billingType, string market, string paymentTerm, bool inactive, string user)
        {
            string method = string.Format("usp_PaymentTerm_UPDATE(messageId,utilityCode:{0},accountType:{1},billingType:{2},market:{3},paymentTerm:{4},inactive:{5},user:{6})",
                Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountType), Utilities.Common.NullSafeString(billingType),
                Utilities.Common.NullSafeString(market), Utilities.Common.NullSafeString(paymentTerm), Utilities.Common.NullSafeString(inactive),
                Utilities.Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _lp_UtilityManagementEntities.usp_PaymentTerm_UPDATE(id, utilityCode, accountType, billingType, market, paymentTerm,
                    inactive, user);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }




        public void usp_LpBillingType_INSERT_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user)
        {
            string method = string.Format("usp_LpBillingType_INSERT_ByCodes(messageId,id:{0},utilityCode:{1},porDriver:{2},loadProfile:{3},rateClass:{4},tariffCode:{5},defaultBillingType:{6},inactive:{7},user:{8})",
                id, utilityCode, porDriver, loadProfile, rateClass, tariffCode, defaultBillingType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_INSERT_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDriver", porDriver));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@tariffCode", tariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@DefaultBillingType", defaultBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_LpBillingType_UPDATE_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user)
        {
            string method = string.Format("usp_LpBillingType_UPDATE_ByCodes(messageId,id:{0},utilityCode:{1},porDriver:{2},loadProfile:{3},rateClass:{4},tariffCode:{5},defaultBillingType:{6},inactive:{7},user:{8})",
                id, utilityCode, porDriver, loadProfile, rateClass, tariffCode, defaultBillingType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_UPDATE_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@PorDriver", porDriver));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileCode", loadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassCode", rateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@DefaultBillingType", defaultBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_LpApprovedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user)
        {
            string method = string.Format("usp_LpApprovedBillingType_INSERT_ByCodes(messageId,id:{0},lpBillingTypeId:{1},approvedBillingType:{2},terms:{3},inactive:{4},user:{5})",
                id, lpBillingTypeId, approvedBillingType, terms, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpApprovedBillingType_INSERT_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpBillingTypeId", lpBillingTypeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ApprovedBillingType", approvedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Terms", terms));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_LpApprovedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user)
        {
            string method = string.Format("usp_LpApprovedBillingType_UPDATE_ByCodes(messageId,id:{0},lpBillingTypeId:{1},approvedBillingType:{2},terms:{3},inactive:{4},user:{5})",
                id, lpBillingTypeId, approvedBillingType, terms, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpApprovedBillingType_UPDATE_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpBillingTypeId", lpBillingTypeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ApprovedBillingType", approvedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Terms", terms));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_LpUtilityOfferedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user)
        {
            string method = string.Format("usp_LpUtilityOfferedBillingType_INSERT_ByCodes(messageId,id:{0},lpBillingTypeId:{1},utilityOfferedBillingType:{2},inactive:{3},user:{4})",
                id, lpBillingTypeId, utilityOfferedBillingType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpUtilityOfferedBillingType_INSERT_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpBillingTypeId", lpBillingTypeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityOfferedBillingType", utilityOfferedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        public void usp_LpUtilityOfferedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user)
        {
            string method = string.Format("usp_LpUtilityOfferedBillingType_UPDATE_ByCodes(messageId,id:{0},lpBillingTypeId:{1},utilityOfferedBillingType:{2},inactive:{3},user:{4})",
                id, lpBillingTypeId, utilityOfferedBillingType, inactive, user);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpUtilityOfferedBillingType_UPDATE_ByCodes", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LpBillingTypeId", lpBillingTypeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityOfferedBillingType", utilityOfferedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@User", user));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        public DataSet usp_LpBillingType_IsDuplicate(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, string defaultBillingType, string utilityOfferedBillingType, string lpApprovedBillingType, string terms, bool inactive)
        {
            string method = string.Format("usp_LpBillingType_IsDuplicate(messageId,id:{0},utilityCode:{1},porDriver:{2},loadProfileCode:{3},rateClassCode:{4},tariffCodeCode:{5},defaultBillingType:{6},utilityOfferedBillingType:{7},lpApprovedBillingType:{8},inactive:{9})",
                id, utilityCode, porDriver, loadProfileCode, rateClassCode, tariffCodeCode, defaultBillingType, utilityOfferedBillingType, lpApprovedBillingType, inactive);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LpBillingType_IsDuplicate", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        int? termsInt = null;
                        int termsIntTemp = 0;
                        if (!string.IsNullOrWhiteSpace(terms))
                        {
                            int.TryParse(terms, out termsIntTemp);
                            termsInt = termsIntTemp;
                        }

                        if (string.IsNullOrWhiteSpace(loadProfileCode))
                            loadProfileCode = null;

                        if (string.IsNullOrWhiteSpace(rateClassCode))
                            rateClassCode = null;

                        if (string.IsNullOrWhiteSpace(tariffCodeCode))
                            tariffCodeCode = null;

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@porDriver", porDriver));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@loadProfileCode", loadProfileCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@rateClassCode", rateClassCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@tariffCodeCode", tariffCodeCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@defaultBillingType", defaultBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityOfferedBillingType", utilityOfferedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@lpApprovedBillingType", lpApprovedBillingType));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@terms", termsInt));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@inactive", inactive));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool usp_LoadProfile_IsValid(string messageId, string utilityCode, string loadProfileCode)
        {
            string method = string.Format("usp_LoadProfile_IsValid(messageId,utilityCode:{0},loadProfileCode:{1})", utilityCode, loadProfileCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));
                bool returnValue = false;
                DataSet ds = new DataSet();

                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_LoadProfile_IsValid", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        if (string.IsNullOrWhiteSpace(loadProfileCode) || string.IsNullOrWhiteSpace(utilityCode))
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Invalid Load Profile Code or Utility Code, returning false: END", NAMESPACE, CLASS, method));
                            return false;
                        }

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@loadProfileCode", loadProfileCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));

                        returnValue = ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows != null && ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0] != null && ds.Tables[0].Rows[0][0] != null && ds.Tables[0].Rows[0][0].ToString() == "1";
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool usp_RateClass_IsValid(string messageId, string utilityCode, string rateClassCode)
        {
            string method = string.Format("usp_RateClass_IsValid(messageId,utilityCode:{0},rateClassCode:{1})", utilityCode, rateClassCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));
                bool returnValue = false;
                DataSet ds = new DataSet();

                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_RateClass_IsValid", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        if (string.IsNullOrWhiteSpace(rateClassCode) || string.IsNullOrWhiteSpace(utilityCode))
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Invalid Rate Class Code or Utility Code, returning false: END", NAMESPACE, CLASS, method));
                            return false;
                        }

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@rateClassCode", rateClassCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));

                        returnValue = ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows != null && ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0] != null && ds.Tables[0].Rows[0][0] != null && ds.Tables[0].Rows[0][0].ToString() == "1";
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool usp_TariffCode_IsValid(string messageId, string utilityCode, string tariffCodeCode)
        {
            string method = string.Format("usp_TariffCode_IsValid(messageId,utilityCode:{0},tariffCodeCode:{1})", utilityCode, tariffCodeCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (_lp_UtilityManagementEntities == null)
                    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));
                bool returnValue = false;
                DataSet ds = new DataSet();

                using (SqlConnection connection = new SqlConnection(_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_TariffCode_IsValid", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        if (string.IsNullOrWhiteSpace(tariffCodeCode) || string.IsNullOrWhiteSpace(utilityCode))
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Invalid Tariff Code Code or Utility Code, returning false: END", NAMESPACE, CLASS, method));
                            return false;
                        }

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@tariffCodeCode", tariffCodeCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));

                        returnValue = ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows != null && ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0] != null && ds.Tables[0].Rows[0][0] != null && ds.Tables[0].Rows[0][0].ToString() == "1";
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void usp_IdrRule_INSERT(string messageId, Guid id, Guid utilityCompanyId, Guid? rateClassId, Guid? loadProfileId, Guid? tariffCodeId, int? minUsageMWh, int? maxUsageMWh, bool isOnEligibleCustomerList, bool isHistoricalArchiveAvailable, Guid? requestModeIdrId, Guid? requestModeTypeId, bool alwaysRequest, bool inactive, string user)
        {
            string method = string.Format("usp_IdrRule_INSERT(messageId,id:{0},utilityCompanyId:{1},rateClassId:{2},loadProfileId:{3},tariffCodeId:{4},minUsageMWh:{5},maxUsageMWh:{6},isOnEligibleCustomerList:{7},isHistoricalArchiveAvailable:{8},requestModeIdrId:{9},requestModeTypeId:{10},alwaysRequest:{11},inactive:{12},user:{13})",
                id,
                Common.NullSafeString(utilityCompanyId),
                Common.NullSafeString(rateClassId),
                Common.NullSafeString(loadProfileId),
                Common.NullSafeString(tariffCodeId),
                Common.NullSafeInteger(minUsageMWh),
                Common.NullSafeInteger(maxUsageMWh),
                isOnEligibleCustomerList,
                isHistoricalArchiveAvailable,
                Common.NullSafeString(requestModeIdrId),
                Common.NullSafeString(requestModeTypeId),
                alwaysRequest,
                inactive, 
                Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                //if (_lp_UtilityManagementEntities == null)
                //    _lp_UtilityManagementEntities = new Lp_UtilityManagementEntities();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _lp_UtilityManagementEntities", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(System.Configuration.ConfigurationManager.ConnectionStrings["Lp_UtilityManagement"]);
                _logger.LogInfo(messageId, connectionString);
                using (SqlConnection connection = new SqlConnection(connectionString)) //_lp_UtilityManagementEntities.Database.Connection.ConnectionString))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_IdrRule_INSERT", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Id", id));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCompanyId", utilityCompanyId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassId", rateClassId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileId", loadProfileId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCodeId", tariffCodeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@MinUsageMWh", minUsageMWh));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@MaxUsageMWh", maxUsageMWh));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsOnEligibleCustomerList", isOnEligibleCustomerList));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsHistoricalArchiveAvailable", isHistoricalArchiveAvailable));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RequestModeIdrId", requestModeIdrId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RequestModeTypeId", requestModeTypeId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AlwaysRequest", alwaysRequest));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Inactive", inactive));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@CreatedBy", user));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@CreatedDate", DateTime.Now));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LastModifiedBy", user));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LastModifiedDate", DateTime.Now));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_UtilityGetAllUtilitiesData(string messageId)
        {
            string method = "usp_UtilityGetAllUtilitiesData(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(System.Configuration.ConfigurationManager.ConnectionStrings["Lp_UtilityManagement"]);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_UtilityGetAllUtilitiesData", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DataSet usp_UtilityGetAllActiveUtilitiesDumpData(string messageId, string energyType)
        {
            string method = string.Format("usp_UtilityGetAllActiveUtilitiesDumpData(messageId:{0}, energyType:{1})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId, energyType);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(System.Configuration.ConfigurationManager.ConnectionStrings["DataSync"]);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_UtilityGetAllActiveUtilitiesDumpData", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Commodity", energyType));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public DataSet usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType(string messageId, string utilityCode, string accountType)
        {
            string method = string.Format("usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType(messageId,utilityCode:{0},accountType:{1})",
                Common.NullSafeString(utilityCode),
                Common.NullSafeString(accountType));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(System.Configuration.ConfigurationManager.ConnectionStrings["Lp_UtilityManagement"]);
                _logger.LogDebug(messageId, connectionString);
                using (SqlConnection connection = new SqlConnection(connectionString)) 
                {
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType", connection))
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AccountType", accountType));

                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
    }
}
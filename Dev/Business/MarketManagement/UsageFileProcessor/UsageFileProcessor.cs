using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition.Registration;
using System.Reflection;
using System.Threading;
using System.Transactions;
using Common.Logging;
using LibertyPower.Business.CommonBusiness.SecurityManager;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.Consolidation;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Interfaces;
using UsageFileProcessor.Repository;
using UsageFileProcessor.Services;

namespace UsageFileProcessor
{
    public class UsageFileProcessor
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        private readonly string _utilityCode;
        private UsageFile _usageFile;
        private string _currentUser;
        private IEnumerable<IUsageFileParser> _parsers;
        private IRepository _repository;
        private CompositionContainer _container;

        public string Error { get; set; }

        public UsageFileProcessor(string utilityCode, string filePath)
        {
            _utilityCode = utilityCode;
            _LoadContainer();
            _LoadCurrentUser();
            _usageFile = new UsageFile(_utilityCode, filePath);
            _parsers = _container.GetExportedValues<IUsageFileParser>();
            _repository = _container.GetExportedValue<IRepository>();
        }


        public bool ProcessUsageFile()
        {
            var foundParser = false;
            try
            {
                IEnumerable<ParserAccount> accounts = null;
                foreach (var usageFileParser in _parsers)
                {
                    if (usageFileParser.IsParser(_usageFile))
                    {
                        foundParser = true;
                        if (usageFileParser.IsValidFileTemplate(_usageFile))
                            accounts = usageFileParser.Parse(_usageFile);
                        else if (string.IsNullOrWhiteSpace(usageFileParser.Error))
                        {
                            Error = "Invalid file template for " + _utilityCode + ". " + usageFileParser.Error;
                            return false;
                        }

                        if (!string.IsNullOrWhiteSpace(usageFileParser.Error))
                        {
                            Error = usageFileParser.Error;
                            return false;
                        }
                            
                    }
                    
                }

                if (!foundParser)
                {
                    Error = "No parser found for utility : " + _utilityCode;
                    return false;
                }

                if (accounts == null)
                {
                    Error = "No usage found.";
                    return false;
                }

                foreach (var account in accounts)
                {
                    if (account.HasError)
                    {
                        Error = account.Error;
                        return false;
                    }
                }

                foreach (var account in accounts)
                {
                    using (var transactionScope = new TransactionScope())
                    {

                        var fileAccountId = _repository.InsertAccount(account);
                        _repository.InsertAddresses(fileAccountId, account);
                        foreach (var usage in account.Usages)
                            _repository.InsertUsage(fileAccountId, usage.Value);

                        transactionScope.Complete();

                    }

                    ParserAccountService.ProcessAccountPropertyHistory(account, _currentUser);
                }

                return true;
            }
            catch (Exception ex)
            {
                Log.Error("Error parsing file " + _usageFile.Path, ex);
                Error = "Parsing failed. Internal Error.";
                return false;
            }
           
        }

        private void _LoadCurrentUser()
        {
            if (!Thread.CurrentPrincipal.Identity.IsAuthenticated)
            {
                _currentUser = "UsageManagement";
                return;
            }

            _currentUser = Thread.CurrentPrincipal.Identity.Name;

            if (string.IsNullOrWhiteSpace(_currentUser))
                _currentUser = "UsageManagement";
        }

        private void _LoadContainer()
        {
            var builderForParsers = new RegistrationBuilder();
            builderForParsers.ForTypesDerivedFrom<IUsageFileParser>()
                                   .ExportInterfaces();

            var builderForRepository = new RegistrationBuilder();
            builderForRepository.ForTypesDerivedFrom<IRepository>()
                                .ExportInterfaces();

            var catalog = new AggregateCatalog(new AssemblyCatalog(Assembly.GetExecutingAssembly(), builderForParsers),
                                               new AssemblyCatalog(Assembly.GetExecutingAssembly(), builderForRepository));

            _container = new CompositionContainer(catalog);

            _container.ComposeParts();
            
            Log.Info("Completed DI Contrainer registration");
        }

    }
}
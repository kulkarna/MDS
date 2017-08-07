using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition.Primitives;
using System.ComponentModel.Composition.Registration;
using System.Linq;
using System.Reflection;
using Common.Logging;

namespace UsageEventAggregator.Helpers
{
    public sealed class Locator
    {
        private static readonly object _syncRoot = new Object();
        private static volatile Locator _current;
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private CompositionContainer _container;

        public static Locator Current
        {
            get
            {
                if (_current == null)
                {
                    lock (_syncRoot)
                    {
                        if (_current == null)
                            _current = new Locator();
                    }
                }

                return _current;
            }
        }


        public void RegisterDIContainer(Assembly assemblyToRegister)
        {
            var builderForIHandleEvents = new RegistrationBuilder();
            builderForIHandleEvents.ForTypesMatching(t => t.GetInterface(typeof (IHandleEvents<>).Name) != null)
                                   .ExportInterfaces();
            builderForIHandleEvents.ForTypesMatching(t => t.GetInterface(typeof(ISubscriber<>).Name) != null)
                                   .ExportInterfaces();


            var builderForIEventAggregator = new RegistrationBuilder();
            builderForIEventAggregator.ForTypesDerivedFrom<IEventAggregator>().Export<IEventAggregator>();

            var catalog =
                new AggregateCatalog(new ComposablePartCatalog[]
                    {
                        new AssemblyCatalog(Assembly.GetExecutingAssembly(), builderForIEventAggregator),
                        new AssemblyCatalog(assemblyToRegister, builderForIHandleEvents)
                    });

            _container = new CompositionContainer(catalog);

            _container.ComposeParts();


            Log.Info("Completed DI Contrainer registration");
        }

        public object GetEventHandler(string type)
        {
            string contractName =
                _container.Catalog.Parts.First(p => p.ExportDefinitions.First().ContractName.Contains(type))
                          .ExportDefinitions.First()
                          .ContractName;

            List<Lazy<object, object>> handlers = _container.GetExports(typeof (object), null, contractName).ToList();

            if (!handlers.Any())
            {
                var ex = new NullReferenceException("Could not locate any handlers");
                Log.Error(ex.Message, ex);
                throw ex;
            }

            return handlers.First().Value;
        }

        public T GetInstance<T>()
        {
            var export = _container.GetExport<T>();
            if (export != null) 
                return export.Value;
            var message = "Could not find export with type of " + typeof (T).Name;
            Log.Error(message);
            throw new KeyNotFoundException(message);
        }
        
        public List<T> GetInstances<T>()
        {
            var list = _container.GetExports<T>().Select(export => export.Value).ToList();

            if (list.Any())
                return list;

            var message = "Could not find export with type of " + typeof (T).Name;
            Log.Error(message);
            throw new KeyNotFoundException(message);
        }

        public IEventAggregator GetAggregator()
        {
            try
            {
                if (_container == null)
                {
                    var builderForIEventAggregator = new RegistrationBuilder();
                    builderForIEventAggregator.ForTypesDerivedFrom<IEventAggregator>().Export<IEventAggregator>();

                    var catalog = new AssemblyCatalog(Assembly.GetExecutingAssembly(), builderForIEventAggregator);

                    _container = new CompositionContainer(catalog);
                    _container.ComposeParts();
                }

                Lazy<IEventAggregator> export = _container.GetExport<IEventAggregator>();
                if (export != null)
                    return export.Value;

                Log.Error("Get aggregator failed with no exception.");
                return null;
            }
            catch (Exception ex)
            {
                Log.Error("Get aggregator failed with error. " + ex.Message, ex);
            }

            return null;
        }

        public List<string> GetAllMessageTypes()
        {
            var list = new List<string>();
            foreach (var part in _container.Catalog.Parts)
            {
                var definition = part.ExportDefinitions.First();
                if(!definition.ContractName.Contains("IHandleEvents"))
                    continue;

                var export = _container.GetExports(typeof (object), null, definition.ContractName).First();
                var exportType = export.Value.GetType();
                var iHandleEventsInterface = exportType.GetInterfaces().First();
                list.Add(iHandleEventsInterface.GenericTypeArguments.First().Name);
            }
            return list;
        }
    }
}
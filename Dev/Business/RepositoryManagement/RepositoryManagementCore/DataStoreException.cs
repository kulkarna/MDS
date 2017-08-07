using System;

namespace LibertyPower.RepositoryManagement.Core
{
    public class DataStoreException : ApplicationException
    {
        public DataStoreException()
            : base()
        { }

        public DataStoreException(string message)
            : base(message)
        { }

        public DataStoreException(string message, Exception innerException)
            : base(message, innerException)
        { }
    }
}
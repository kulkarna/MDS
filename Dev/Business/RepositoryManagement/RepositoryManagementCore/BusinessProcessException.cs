using System;

namespace LibertyPower.RepositoryManagement.Core
{
    public class BusinessProcessException : ApplicationException
    {
        public BusinessProcessException()
            : base()
        { }

        public BusinessProcessException(string message)
            : base(message)
        { }

        public BusinessProcessException(string message, Exception innerException)
            : base(message, innerException)
        { }
    }
}
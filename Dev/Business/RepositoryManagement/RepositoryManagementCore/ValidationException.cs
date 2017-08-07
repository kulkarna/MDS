using System;

namespace LibertyPower.RepositoryManagement.Core
{
    public class ValidationException : ApplicationException
    {
        public ValidationException()
            : base()
        { }

        public ValidationException(string message)
            : base(message)
        { }

        public ValidationException(string message, Exception innerException)
            : base(message, innerException)
        { }
    }
}
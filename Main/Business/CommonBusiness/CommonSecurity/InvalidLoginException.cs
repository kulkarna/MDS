using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    class InvalidLoginException:SecurityException
    {
        /// <summary>
        /// If the user has an invalid login name or the password is incorrect this error will be thrown.
        /// </summary>
        /// <param name="message"></param>
        public InvalidLoginException(string message)
			: base( message )
		{

		}
        public InvalidLoginException()
            : base()
        {

        }

        public InvalidLoginException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}

using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower;

 namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
	[Serializable]
	public class SecurityException :LibertyPower.Business.BusinessException
	{
		public SecurityException()
			: base()
		{
		}

		public SecurityException( string message )
			: base( message )
		{
		}

        public SecurityException(string message, Exception innerException)
			: base( message, innerException )
		{
		}
	}
}

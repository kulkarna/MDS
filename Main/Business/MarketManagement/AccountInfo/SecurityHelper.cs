using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Web.Services2;
using Microsoft.Web.Services2.Security;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security.X509;


namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public static class SecurityHelper
	{
		/// <summary>
		/// get a token based on a cert
		/// </summary>
		/// <param name="commonName">common name of the cert we need to create the token for</param>
		/// <returns>token</returns>
		public static X509SecurityToken GetToken( string commonName )
		{
			X509SecurityToken securityToken = null;

			securityToken = new X509SecurityToken( GetCert( commonName ) );
			return securityToken;
		}

		/// <summary>
		/// get the cert
		/// </summary>
		/// <param name="commonName">the common name of the cert we need to get</param>
		/// <returns>cert</returns>
		public static X509Certificate GetCert( string commonName )
		{
			X509CertificateStore store = X509CertificateStore.LocalMachineStore( X509CertificateStore.RootStore );
			//X509CertificateStore store = X509CertificateStore.CurrentUserStore( X509CertificateStore.MyStore );
			store.OpenRead();
			//"6116339131000 09032009gpereyra"
			X509CertificateCollection certs = store.FindCertificateBySubjectString( commonName );

			X509Certificate cert = null;
			if( certs.Count == 1 )
			{
				cert = certs[0];
				return cert;
			}
			return null;

		}


	}
}

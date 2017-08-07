using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using Microsoft.Web.Services2;
using Microsoft.Web.Services2.Security;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security.X509;
using System.Xml;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public static class RunService
	{
		public static string FilePath;

		/// <summary>
		/// Get the report from erot
		/// </summary>
		/// <param name="reportID">report ID we want to get</param>
		/// <param name="certCommonName">the cert common name that is needed to connect to ercot</param>
		/// <param name="certUserID">the cert user id as indicated in the cert</param>
		/// <param name="Message">error message</param>
		/// <returns>true if success</returns>
		public static bool GetReport( string reportID, string certCommonName, string certUserID, 
			string webServiceURL, out string Message )
		{
			Message = string.Empty;
			try
			{
				ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback( delegate { return true; } );
				Random r = new Random();

				NodalService serviceProxy = new NodalService();
				serviceProxy.Url = webServiceURL;
				Microsoft.Web.Services2.SoapContext requestContext = serviceProxy.RequestSoapContext;
				X509SecurityToken token = SecurityHelper.GetToken(certCommonName);
				requestContext.Security.Tokens.Add( token );
				requestContext.Security.Elements.Add( new MessageSignature( token ) );

				RequestMessage requestMSG = new RequestMessage();

				//create the header
				HeaderType header = new HeaderType();
				header.Verb = HeaderTypeVerb.get;
				header.Noun = "Reports";
				header.Revision = "001";
				header.Source = "getReports";
				header.UserID = certUserID;
				//"API_cathyghazal";
				header.MessageID = r.Next().ToString();

				//Replay Detection
				ReplayDetectionType rdt = new ReplayDetectionType();
				AttributedDateTime ad = new AttributedDateTime();
				ad.Value = DateTime.Now.ToString( "yyyy-MM-ddTHH:mm:ss.fffzzz" );
				rdt.Created = ad;

				EncodedString es = new EncodedString();
				es.Value = r.Next().ToString();
				rdt.Nonce = es;

				header.ReplayDetection = rdt;

				//create the request
				RequestType request = new RequestType();
				request.Option = reportID;

				AttributedDateTime adS = new AttributedDateTime();
				adS.Value = DateTime.Now.AddDays( -7 ).ToString( "yyyy-MM-ddTHH:mm:ss.fffzzz" );

				request.StartTime = adS;
				request.EndTime = ad;
				//request.OperatingDate = DateTime.Now;


				//map the header and request to the message
				requestMSG.Request = request;
				requestMSG.Header = header;

				//get the response
				ResponseMessage responseMSG = new ResponseMessage();
				responseMSG = serviceProxy.MarketInfo( requestMSG );
				if( responseMSG.Reply.ReplyCode.Equals( "OK" ) )
				{
					XmlDocument d = new XmlDocument();
					XmlElement root = d.CreateElement( "ns1:Reports" );
					foreach( XmlElement item in responseMSG.Payload.Items )
					{
						foreach( XmlNode n in item.ChildNodes )
						{
							XmlNode nCopy = d.ImportNode( n, true );
							root.AppendChild( nCopy );
						}
					}
					d.AppendChild( root );
					d.Save( FilePath );
				}
				return true;
			}
			catch( Exception ex )
			{
				Message = ex.Message;
				AccountInfoFactory.Errors.Add( "Unable to connect to ERCOT: " + ex.Message );
				return false;
			}
		}

	}
}

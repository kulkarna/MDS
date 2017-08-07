using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Services;
using Aspose.Words;
using Aspose.Pdf;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	// production document repository web service
	// http://enrollment.libertypowercorp.com:83/proddocumentrepository/DocumentRepository.asmx

	// development document repository web service
	// http://sqldev:83/devdocumentRepository/DocumentRepository.asmx

	// local document repository web service
	// http://localhost:50798/DocumentRepository.asmx

	public static class PdfFactory
	{
		/// <summary>
		/// Creates a Electricity Facts Label in PDF format
		/// </summary>
		/// <param name="ds">Dataset containing the EFL data</param>
		/// <returns>Returns a path to the Electricity Facts Label PDF file</returns>
		public static string CreatePdf( DataSet ds, string documentTypeCode, string productId, int accountTypeID )
		{
			string docPath = "";

			// register Aspose licenses
			Aspose.Words.License licenseWord = new Aspose.Words.License();
			string licPath = System.Web.HttpContext.Current.Server.MapPath( "License\\Aspose.Words.lic" );
			licenseWord.SetLicense( licPath );

			Aspose.Pdf.License licensePdf = new Aspose.Pdf.License();
			string licPathPdf = System.Web.HttpContext.Current.Server.MapPath( "License\\Aspose.Pdf.lic" );
			licensePdf.SetLicense( licPathPdf );

			com.libertypowercorp.enrollment.RepositoryServices service = new com.libertypowercorp.enrollment.RepositoryServices();
			com.libertypowercorp.enrollment.Result result = default( com.libertypowercorp.enrollment.Result );
			int docTypeId = service.DocumentTypeInfo_ByCode( documentTypeCode ).DocumentTypeID;
			Array templateResult = service.FindTemplates( docTypeId, null, null, null, productId, accountTypeID, null, null, null, null );

			//DocumentRepository.RepositoryServices service = new DocumentRepository.RepositoryServices();
			//DocumentRepository.Result result = default( DocumentRepository.Result );
			//int docTypeId = service.DocumentTypeInfo_ByCode( "EFL" ).DocumentTypeID;

			//localhost.RepositoryServices service = new localhost.RepositoryServices();
			//localhost.Result result = default( localhost.Result );
			//int docTypeId = service.DocumentTypeInfo_ByCode( "EFD" ).DocumentTypeID;

			if( templateResult != null && templateResult.Length > 0 )
			{
				com.libertypowercorp.enrollment.usp_TemplateMappingSelectResult template = (com.libertypowercorp.enrollment.usp_TemplateMappingSelectResult) templateResult.GetValue( 0 );

				result = service.GetTemplateFullPath( template.TemplateID, true );
				string documentPath = result.Value.ToString();
				docPath = service.GetFilledTemplate( documentPath, ds, "" );

				// create Word doc
				//docPath = (string) result.Value;
				Aspose.Words.Document asposeWord = new Aspose.Words.Document( docPath );

				// save as xml file
				docPath = System.IO.Path.ChangeExtension( docPath, "xml" );
				asposeWord.Save( docPath, SaveFormat.Pdf );

				// read the document in Aspose.Pdf.Xml format into Aspose.Pdf. 
				Aspose.Pdf.Pdf asposePdf = new Aspose.Pdf.Pdf();
				asposePdf.BindXML( docPath, null );

				// produce the PDF file. 
				docPath = System.IO.Path.ChangeExtension( docPath, "pdf" );
				asposePdf.Save( docPath );
			}
			else
				throw new PdfNotCreatedException( result.ExceptionString );

			return docPath;
		}
	}
}

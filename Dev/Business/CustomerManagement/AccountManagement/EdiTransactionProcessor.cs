using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Web;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public static class EdiTransactionProcessor
    {

		private const string BusinessClosedMovedReasonCode = "010";


		static string format = "<div style=font-family:Verdana,Arial;font-size:10pt>{0}<br><br>{1}</div>";
		static string begin = "Process has begun.";
		static string end = "Process has ended";
		static string emailFrom = Properties.Settings.Default.EmailFrom;
		static string emailTo = Properties.Settings.Default.EmailTo;
		static string subject = "";
		static string smtpServer = Properties.Settings.Default.SMTPServer;

        public static void Process814Records()
        {
			ErrorFactory.LogError( "", "EdiTransactionProcessor.Process814Records", "Process814Records", DateTime.Now );
			subject = "Process 814 Records";
			Email email = new Email();

			ErrorFactory.LogError( "", "EdiTransactionProcessor.Step1", "Step1", DateTime.Now );

			if ( Helper.EmailEnabled )
			{
			// send email notification of process begin
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), begin ),
				null, null, null );
			}

			ErrorFactory.LogError( "", "EdiTransactionProcessor.Step2", "Step2", DateTime.Now );

			IstaHeader814List istaHeader814List = null;
			try
			{
				istaHeader814List = EdiFactory.GetUnprocessed814Records();
			}
			catch ( Exception ex )
			{
				ErrorFactory.LogError( "", "EdiTransactionProcessor.Step2 ERROR", ex.Message + ex.StackTrace, DateTime.Now );
			}

			ErrorFactory.LogError( "", "EdiTransactionProcessor.Step3", "Step3", DateTime.Now );

			ProcessTransactions( istaHeader814List );

			ErrorFactory.LogError( "", "EdiTransactionProcessor.Step4", "Step4", DateTime.Now );

			if ( Helper.EmailEnabled )
			{
			// send email notification of process end
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), end ),
				null, null, null );
        }
			ErrorFactory.LogError( "", "EdiTransactionProcessor.Step5", "Step5", DateTime.Now );

		}

        public static void ProcessTransactions(IstaHeader814List transactions)
        {
			ErrorFactory.LogError( "", "EdiTransactionProcessor.ProcessTransactions", "ProcessTransactions", DateTime.Now );
			//	HttpContext.Current.Response.Write( "<br>ProcessTransactions" ); 
            string errorLocation = "EdiTransactionProcessor.ProcessTransactions";

            DateTime began = DateTime.Now;									// batch begin date
            DateTime ended = DateTime.Now;									// batch end date
            int batchId = 0;												// used to identify process

            // insert header record, retrieving batch id
            DataSet ds = EdiSql.InsertEdiTransactionProcessingHeader(began, ended);

            if (ds.Tables[0].Rows.Count > 0)
                batchId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            else
                ErrorFactory.LogError("", errorLocation, "Batch ID not created.", DateTime.Now);

            // loop through headers, process only those which meet criteria
            // ( inbound enrollment or de-enrollment responses that were accepted )
            foreach (Ista814Header header in transactions)
            {
                // only process inbound transactions
                if (header.Direction.Equals(Convert.ToInt32(IstaTransactionDirection.Inbound)))
                {
                    foreach (Ista814Service service in header.Ista814ServiceList)
                    {
                        try
                        {
                            EdiTransactionProcessingOutcome EDIOutcome;

                            switch (header.ResponseType)
                            {
                                case ResponseType.EnrollmentAccept:
								case ResponseType.EnrollmentReject:
                                    {
                                        // INF97 Insert account event history
                                        // AccountEventProcessor.ProcessEvent(AccountEventType.Enrollment, service.AccountNumber, header.UtilityCode);

										ProcessEtfEnrollmentEvents( header, service );

                                        EDIOutcome = EdiTransactionProcessingOutcome.Processed;

                                        break;
                                    }
                                case ResponseType.DeenrollmentAccept:
									{
                                        // INF97 Insert account event history
                                        // AccountEventProcessor.ProcessEvent(AccountEventType.DeEnrollment, service.AccountNumber, header.UtilityCode);

										//INF 93
										ProcessEtf( header, service );

                                        EDIOutcome = EdiTransactionProcessingOutcome.Processed;

                                        break;
									}
								case ResponseType.DeenrollmentReject:
                                    {
                                        // INF97 Insert account event history
                                        // AccountEventProcessor.ProcessEvent(AccountEventType.DeEnrollment, service.AccountNumber, header.UtilityCode);

										//INF 93
										ProcessEtf( header, service );

                                        EDIOutcome = EdiTransactionProcessingOutcome.Processed;

                                        break;
									}
								case ResponseType.UtilityDeenrollmentNotification:
									{
                                        //INF 93
										ProcessEtf( header, service );

                                        EDIOutcome = EdiTransactionProcessingOutcome.Processed;

                                        break;
                                    }
                                default: // ignored
                                    {
                                        EDIOutcome = EdiTransactionProcessingOutcome.Ignored;

                                        break;
									}
							}

                                        // insert edi transaction result
                            EdiSql.InsertEdiTransactionProcessingDetail(service.Key814, Convert.ToInt32(EDIOutcome), "", batchId);

                                        // update records processed and end time
                                        EdiSql.UpdateEdiTransactionProcessingHeader(batchId, DateTime.Now);

                        }
                        catch (Exception ex)
                        {
                            // insert edi transaction result
                            EdiSql.InsertEdiTransactionProcessingDetail(service.Key814,
                                Convert.ToInt32(EdiTransactionProcessingOutcome.Error), ex.Message, batchId);

                            // update records processed and end time
                            EdiSql.UpdateEdiTransactionProcessingHeader(batchId, DateTime.Now);
                        }
                    }
                }
            }
        }



		#region ETF

        private static void ProcessEtf(Ista814Header header, Ista814Service service)
        {
			ErrorFactory.LogError( "", "EdiTransactionProcessor.ProcessEtf", service.AccountNumber, DateTime.Now );
			try
            {
                CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount(service.AccountNumber, header.UtilityCode);
				if ( header.ResponseType == ResponseType.UtilityDeenrollmentNotification )
				{
					if ( header.LibertyPowerReasonCode != null && header.LibertyPowerReasonCode == BusinessClosedMovedReasonCode )
					{
						companyAccount.WaiveEtf = true;
						// "010" maps to 1 in LibertyPower
						companyAccount.WaivedEtfReasonCodeID = 1;
						CompanyAccountFactory.UpdateEtfCorrespondence( companyAccount );

						//Reload company object
						companyAccount = CompanyAccountFactory.GetCompanyAccount( service.AccountNumber, header.UtilityCode );
					}
				}
				EtfFactory.ProcessEtf( companyAccount, header.ResponseType );
			}
			catch ( Exception ex )
			{
				string errorLocation = "EdiTransactionProcessor.ProcessEtf";
				ErrorFactory.LogError( service.AccountNumber, errorLocation, ex.Message, DateTime.Now );
            }
        }

		public static void ProcessEtfEnrollmentEvents( Ista814Header header, Ista814Service service )
        {
			try
            {
                CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount(service.AccountNumber, header.UtilityCode);
				ResetEtfCorrespondenceFlag( companyAccount );
				UpdateCurrentEtfID( companyAccount );
			}
			catch ( Exception ex )
			{
				string errorLocation = "EdiTransactionProcessor.ProcessEtfEnrollmentEvents";
				ErrorFactory.LogError( service.AccountNumber, errorLocation, ex.Message, DateTime.Now );
			}
		}

		private static void ResetEtfCorrespondenceFlag( CompanyAccount companyAccount )
                {
                    companyAccount.WaiveEtf = false;
					companyAccount.WaivedEtfReasonCodeID = null;
                    CompanyAccountFactory.UpdateEtfCorrespondence(companyAccount);
                }

		private static void UpdateCurrentEtfID( CompanyAccount companyAccount )
		{
			AccountSqlLP.UpdateCurrentEtfID( companyAccount.Identity, null );
            }

		#endregion

    
    }
}

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.Business.CommonBusiness.EmailManager;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Transactions;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class EtfFactory
	{

		public static Etf Get( CompanyAccount companyAccount )
		{

			DataSet ds = AccountEtfSql.Get( Convert.ToInt32( companyAccount.CurrentEtfID ) );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				return null;
			}

			DataRow dr = ds.Tables[0].Rows[0];

			Etf etf = new Etf();
			etf.EtfID = Helper.ConvertFromDB<int?>( dr["EtfID"] );
			etf.EtfState = (EtfState) Helper.ConvertFromDB<int>( dr["EtfProcessingStateID"] );
			etf.EtfEndStatus = (EtfEndStatus) Helper.ConvertFromDB<int>( dr["EtfEndStatusID"] );
			etf.ErrorMessage = Helper.ConvertFromDB<string>( dr["ErrorMessage"] );
			if( Helper.ConvertFromDB<bool>( dr["IsEstimated"] ) )
			{
				etf.EtfCalculationType = EtfCalculationType.Estimated;
			}
			else
			{
				etf.EtfCalculationType = EtfCalculationType.Actual;
			}

			// Reload Calculator
			string etfCalculatorType = Helper.ConvertFromDB<string>( dr["EtfCalculatorType"] ).Trim();
			if( etfCalculatorType.ToUpper() == "FIXED" )
			{
				//Fixed Calculator
				etf.EtfCalculator = FixedEtfCalculatorFactory.BuildObject( companyAccount, dr );
			}
			else if( etfCalculatorType.ToUpper() == "VARIABLE" )
			{
				//Variable Calculator
				etf.EtfCalculator = VariableEtfCalculatorFactory.BuildObject( companyAccount, dr );
			}
			else if( etfCalculatorType.ToUpper() == "MANUAL" )
			{
				etf.EtfCalculator = EtfCalculatorFactory.CreateManualEtfCalculator( companyAccount );
				etf.EtfCalculator.EtfFinalAmount = Helper.ConvertFromDB<decimal?>( dr["EtfFinalAmount"] );
			}
			else if (etfCalculatorType.ToUpper() == "DOORTODOORCALCULATOR")
			{
			    //DoorToDoorCalculator Calculator
			    etf.EtfCalculator = new NewYorkEtfCalculator(companyAccount, companyAccount.DeenrollmentDate,
			                                                 etf.EtfCalculationType);
			    etf.EtfCalculator.Calculate();
			}
            else if (etfCalculatorType.ToUpper() == "MonthScalar")
			{
                //MonthScalar Calculator
                etf.EtfCalculator = new MonthScalerEtfCalculator(companyAccount, companyAccount.DeenrollmentDate,
                                                             etf.EtfCalculationType);
                etf.EtfCalculator.Calculate();
			}
            else if (etfCalculatorType.ToUpper() == "DoubleMonth")
            {
                //MonthScalar Calculator
                etf.EtfCalculator = new DoubleMonthlyEtfCalculator(companyAccount, companyAccount.DeenrollmentDate,
                                                             etf.EtfCalculationType);
                etf.EtfCalculator.Calculate();
            }
            else 
            {
                //MonthScalar Calculator
                etf.EtfCalculator = new MonthScalerEtfCalculator(companyAccount, companyAccount.DeenrollmentDate,
                                                             etf.EtfCalculationType);
                etf.EtfCalculator.Calculate();
            }

		    if( Helper.ConvertFromDB<int?>( dr["EtfInvoiceId"] ).HasValue )
			{
				etf.EtfInvoice = EtfInvoiceFactory.GetEtfInvoice( Helper.ConvertFromDB<int>( dr["EtfInvoiceId"] ) );
			}

			etf.LastUpdatedBy = Helper.ConvertFromDB<string>( dr["LastUpdatedBy"] );

			return etf;
		}

		public static Etf Get( CompanyAccount companyAccount, int etfID )
		{

			DataSet ds = AccountEtfSql.Get( etfID );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new Exception( "Could not retrieve ETF information" );
			}

			DataRow dr = ds.Tables[0].Rows[0];

			Etf etf = new Etf();
			etf.EtfID = Helper.ConvertFromDB<int?>( dr["EtfID"] );
			etf.EtfState = (EtfState) Helper.ConvertFromDB<int>( dr["EtfProcessingStateID"] );
			etf.EtfEndStatus = (EtfEndStatus) Helper.ConvertFromDB<int>( dr["EtfEndStatusID"] );
			etf.ErrorMessage = Helper.ConvertFromDB<string>( dr["ErrorMessage"] );
			//etf.IsPaid = Helper.ConvertFromDB<bool>(dr["IsPaid"]);
			if( Helper.ConvertFromDB<bool>( dr["IsEstimated"] ) )
			{
				etf.EtfCalculationType = EtfCalculationType.Estimated;
			}
			else
			{
				etf.EtfCalculationType = EtfCalculationType.Actual;
			}

			// Reload Calculator
			string etfCalculatorType = Helper.ConvertFromDB<string>( dr["EtfCalculatorType"] ).Trim();
			if( etfCalculatorType.ToUpper() == "FIXED" )
			{
				//Fixed Calculator
				etf.EtfCalculator = FixedEtfCalculatorFactory.BuildObject( companyAccount, dr );
			}
			else if( etfCalculatorType.ToUpper() == "VARIABLE" )
			{
				//Variable Calculator
				etf.EtfCalculator = VariableEtfCalculatorFactory.BuildObject( companyAccount, dr );
			}
			else if( etfCalculatorType.ToUpper() == "MANUAL" )
			{
				etf.EtfCalculator = EtfCalculatorFactory.CreateManualEtfCalculator( companyAccount );
				etf.EtfCalculator.EtfFinalAmount = Helper.ConvertFromDB<decimal?>( dr["EtfFinalAmount"] );
			}
			else if( etfCalculatorType.ToUpper() == "DOORTODOORCALCULATOR" )
			{
				//DoorToDoorCalculator Calculator
				etf.EtfCalculator = new NewYorkEtfCalculator( companyAccount, companyAccount.DeenrollmentDate, etf.EtfCalculationType );
				etf.EtfCalculator.CalculatedEtfAmount = Helper.ConvertFromDB<decimal?>( dr["EtfAmount"] );
				etf.EtfCalculator.EtfFinalAmount = Helper.ConvertFromDB<decimal?>( dr["EtfFinalAmount"] );
			}

			if( Helper.ConvertFromDB<int?>( dr["EtfInvoiceId"] ).HasValue )
			{
				etf.EtfInvoice = EtfInvoiceFactory.GetEtfInvoice( Helper.ConvertFromDB<int>( dr["EtfInvoiceId"] ) );
			}

			etf.LastUpdatedBy = Helper.ConvertFromDB<string>( dr["LastUpdatedBy"] );

			return etf;
		}

		public static int SaveEtf( Etf etf, int accountID )
		{
			int? etfID = etf.EtfID;
			bool isEstimated = (etf.EtfCalculationType == EtfCalculationType.Estimated) ? true : false;
			string etfCalculatorType = (etf.EtfCalculator == null) ? null : etf.EtfCalculator.EtfCalculatorType.ToString();
			if( etfID.HasValue )
			{
				//Update
				AccountEtfSql.UpdateEtf( Convert.ToInt32( etfID ), Convert.ToInt32( accountID ), (int) etf.EtfState, (int) etf.EtfEndStatus, etf.ErrorMessage, Convert.ToDecimal( etf.EtfCalculator.CalculatedEtfAmount ), etf.EtfCalculator.DeenrollmentDate, isEstimated, etf.EtfCalculator.DateCalculated, etf.EtfCalculator.EtfFinalAmount, etf.LastUpdatedBy, etfCalculatorType );
			}
			else
			{

				using( TransactionScope transactionScope = new TransactionScope() )
				{

					//=======================================================================
					// BUG #1429
					//=======================================================================
					Decimal? calculatedEtfAmount = null;
					Decimal? etfFinalAmount = null;
					DateTime? deenrollmentDate = null;
					DateTime dateCalculated = DateTime.Now;
					if( etf.EtfCalculator != null )
					{
						calculatedEtfAmount = etf.EtfCalculator.CalculatedEtfAmount;
						if( !etf.EtfCalculator.EtfFinalAmount.HasValue )
							etf.EtfCalculator.EtfFinalAmount = calculatedEtfAmount;
						etfFinalAmount = etf.EtfCalculator.EtfFinalAmount;
						deenrollmentDate = etf.EtfCalculator.DeenrollmentDate;
						dateCalculated = etf.EtfCalculator.DateCalculated;
					}
					//=======================================================================
					//Insert
					etfID = AccountEtfSql.InsertEtf( Convert.ToInt32( accountID ), (int) etf.EtfState, (int) etf.EtfEndStatus, etf.ErrorMessage, calculatedEtfAmount, deenrollmentDate, isEstimated, dateCalculated, etfFinalAmount, etf.LastUpdatedBy, etfCalculatorType );

					AccountSqlLP.UpdateCurrentEtfID( accountID, etfID );

					transactionScope.Complete();
				}
			}

			//Save Etf Calculation
			if( etf.EtfCalculator != null ) // BUG #1429
			{
				if( etf.EtfCalculator.EtfCalculatorType == EtfCalculatorType.Fixed )
				{
					// Save Fixed Calculation
					FixedEtfCalculatorFactory.Save( Convert.ToInt32( etfID ), (FixedEtfCalculator) etf.EtfCalculator );
				}
				else if( etf.EtfCalculator.EtfCalculatorType == EtfCalculatorType.Variable )
				{
					// Save Variable Calculation  
					VariableEtfCalculatorFactory.Save( Convert.ToInt32( etfID ), (VariableEtfCalculator) etf.EtfCalculator );
				}
			}

			return Convert.ToInt32( etfID );
		}

		/// <summary>
		/// Call this method from the WebInterface to calculate the estimated ETF.
		/// </summary>
		/// <param name="companyAccount"></param>
		/// <returns></returns>
		public static Etf GetEstimatedEtf( CompanyAccount companyAccount, 
            string username, bool ETFOverride = false )
		{
			EtfContext etfContext = new EtfContext( companyAccount );
			etfContext.EtfProcessingAction = EtfProcessingAction.CalculateEstimatedEtf;

			if( companyAccount.CurrentEtfID == null )
			{
				// if no CurrentEtf was stored, initialize ETF context as start state 
				etfContext = EtfContextFactory.Create( companyAccount, EtfCalculationType.Estimated );
			}
			else
			{
                
				// we have a current ETF, load Context from database and make sure it is 
				// in ETF Estimated State
				etfContext = EtfContextFactory.Load( companyAccount );
                if (ETFOverride == true)
                {
                    if (etfContext.CompanyAccount.Etf.EtfState != EtfState.EtfEstimated)
                    {
                        etfContext.CompanyAccount.Etf.ErrorMessage = "Existing Letter";
                        etfContext.CompanyAccount.Etf.EtfState = EtfState.EtfEstimated;
                    }
                }

			    if( etfContext.CompanyAccount.Etf.EtfState != EtfState.EtfEstimated )
			    {
					throw new Exception( "ETF can not be calculated, incorrect status." );
				}
			}

			etfContext.CompanyAccount.Etf.LastUpdatedBy = username;

			//The outcome of the processing will be either an error or
			// a successful calculation
			etfContext = EtfContextFactory.Process( etfContext );

			// Only persist successful calculation since errors will be displayed on the 
			if( etfContext.CurrentIEtfState.EtfState == EtfState.EtfEstimated )
			{
				EtfContextFactory.Save( etfContext );
			}
			else
			{
				//SD17297 - if any error happens in the calculation, the user should be able to insert a value for it
				PrepareEtfForReceivingManualValue( etfContext );
				EtfContextFactory.Save( etfContext );
			}

			CompanyAccountFactory.InsertEtfEstimationComment( etfContext.CompanyAccount, username );

			return etfContext.CompanyAccount.Etf;
		}

		private static void PrepareEtfForReceivingManualValue( EtfContext etfContext )
		{
			etfContext.CompanyAccount.Etf.EtfState = EtfState.EtfEstimated;
			etfContext.CurrentIEtfState = new EtfEstimatedState();
			etfContext.CompanyAccount.Etf.EtfCalculationType = EtfCalculationType.Estimated;
			etfContext.CompanyAccount.Etf.EtfCalculator = EtfCalculatorFactory.CreateManualEtfCalculator( etfContext.CompanyAccount );
		}

		/// <summary>
		/// Call this method from the web interface to create an invoice
		/// </summary>
		/// <param name="estimatedEtf"></param>
        /// <remarks>0g02152013 hide the calculated amount for the batch update. This is needed for the comments screen</remarks>
        public static void CreateInvoiceForEtf(decimal estimatedEtf, CompanyAccount companyAccount, string username, bool hideCalculatedAmount = false)
		{
			EtfContext etfContext = EtfContextFactory.Load( companyAccount );
			etfContext.EtfProcessingAction = EtfProcessingAction.CreateInvoice;

			etfContext.CompanyAccount.Etf.EtfCalculator.EtfFinalAmount = estimatedEtf;

            if( etfContext.CompanyAccount.CurrentEtfID == null || etfContext.CompanyAccount.Etf.EtfState != EtfState.EtfEstimated )
			{
				throw new Exception( "ETF invoice can not be created, incorrect status." );
			}

			etfContext.CompanyAccount.Etf.ErrorMessage = "";
			etfContext.CompanyAccount.Etf.LastUpdatedBy = username;

			//Process
			etfContext = EtfContextFactory.Process( etfContext );

			if( etfContext.CurrentIEtfState.EtfState == EtfState.PendingInvoice )
			{
				EtfContextFactory.Save( etfContext );
                
                if (hideCalculatedAmount)
                {
                    etfContext.CompanyAccount.Etf.EtfCalculator.CalculatedEtfAmount = null;
                }

				CompanyAccountFactory.InsertInvoiceCreationComment( etfContext.CompanyAccount );
			}
		}     

		public static void PayEtf( CompanyAccount companyAccount, string username )
		{
			EtfContext etfContext = EtfContextFactory.Load( companyAccount );
			etfContext.EtfProcessingAction = EtfProcessingAction.PayEtf;

			if( etfContext.CompanyAccount.Etf.EtfState != EtfState.PendingInvoice )
			{
				throw new Exception( "ETF can not be marked as paid, incorrect status." );
			}

			etfContext.CompanyAccount.Etf.LastUpdatedBy = username;

			//Process
			etfContext = EtfContextFactory.Process( etfContext );

			if( etfContext.CurrentIEtfState.EtfState == EtfState.EtfCompleted )
			{
				EtfContextFactory.Save( etfContext );
				CompanyAccountFactory.InsertInvoicePaidComment( etfContext.CompanyAccount );
			}
		}

		/// <summary>
		/// This method gets called from EDI Transaction Processor when EDI Deenrollment event occurs. 
		/// </summary>
		/// <param name="companyAccount"></param>
		public static void ProcessEtf( CompanyAccount companyAccount, ResponseType responseType )
		{
			EtfContext etfContext = null;
			if( companyAccount.CurrentEtfID == null )
			{
				// if no CurrentEtf was stored, initialize ETF context as start state 
				etfContext = EtfContextFactory.Create( companyAccount, EtfCalculationType.Actual );
			}
			else
			{
				// we have a current ETF, load Context from database and make sure it is 
				// in Pending ETF Paid State or ETF Paid State
				etfContext = EtfContextFactory.Load( companyAccount );
				if( etfContext.CompanyAccount.Etf.EtfState != EtfState.EtfPaid && etfContext.CompanyAccount.Etf.EtfState != EtfState.EtfEstimated )
				{
					throw new Exception( "ETF can not be processed, incorrect status. Status has to be EtfPaid or PendingEtfPaid." );
				}
			}

			if( responseType == ResponseType.DeenrollmentReject )
			{
				etfContext.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
				etfContext.CompanyAccount.Etf.ErrorMessage = "Deenrollment was rejected by ISTA.";
				etfContext.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.NoEtfActionRequired;
				etfContext.CurrentIEtfState = new EtfCompletedState();
			}
			else
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.ProcessActualEtf;
				etfContext.IstaResponseType = responseType;
				etfContext = EtfContextFactory.Process( etfContext );
			}
			EtfContextFactory.Save( etfContext );
		}

		public static void SendPaidEtfNotificationEmail( CompanyAccount companyAccount )
		{
			if( Helper.EmailEnabled )
			{
				EmailTemplate emailTemplate = EmailTemplateFactory.GetTemplate( "ETF-Financing" );

				TokenizedEmail tokenizedEmail = new TokenizedEmail( emailTemplate );

				tokenizedEmail.SetTokenValue( "AccountName", companyAccount.BusinessName );
				tokenizedEmail.SetTokenValue( "AccountNumber", companyAccount.AccountNumber );
				tokenizedEmail.SetTokenValue( "PaymentDate", DateTime.Now );
				tokenizedEmail.SetTokenValue( "ETFAmount", companyAccount.Etf.EtfCalculator.EtfFinalAmount );
				tokenizedEmail.ProcessTokens();

				EmailServerFactory.SendEmail( tokenizedEmail );
			}
		}

		public static void DeleteEtf( int etfID )
		{
			AccountEtfSql.DeleteEtf( etfID );

		}
	}
}

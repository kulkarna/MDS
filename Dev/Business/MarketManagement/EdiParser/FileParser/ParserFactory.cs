namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq;
	using System.Collections.Generic;
	using System.Data;
	using System.Text.RegularExpressions;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using CommonBusiness.CommonRules;
	using CommonBusiness.FieldHistory;
	using DataAccess.SqlAccess.OfferEngineSql;
	//	using UsageEventAggregator;
	//	using UsageEventAggregator.Events.Edi;      
	using DataAccess.SqlAccess.TransactionsSql;

	
	/// <summary>
	/// Class for creating generic objects containing utility file data
	/// </summary>
	public static class ParserFactory
	{
		private static FieldHistoryManager.MapField _applyMapping = UtilityManagement.UtilityMappingFactory.ApplyMapping;
		private static string[] TxuUtilities = new string[] { "AEPCE","AEPNO","CTPEN","TXNMP","ONCOR","TXU-SESCO","ONCOR-SESCO","SHARYLAND","TXU"};
		/// <summary>
		/// Creates the file edi object with row and cell collections.
		/// </summary>
		/// <param name="fileContents">the content of the file</param>
		/// <param name="rowDelimiter">the row delimiter</param>
		/// <param name="fieldDelimiter">the field delimiter</param>
		/// <param name="utilityCode">the utlilty code</param>
		/// <param name="marketCode">the market code</param>
		/// <param name="fileType">the file type</param>
		/// <param name="fileGuid">the file GUID</param>
		/// <param name="logID">the Log ID</param>
		/// <returns>true is all the accounts were processed without any error</returns>
		public static bool CreateFileEdi( ref string fileContents, char rowDelimiter, char fieldDelimiter, string utilityCode, string marketCode, EdiFileType fileType, string fileGuid, int logID )
		{
			bool bError = false;
			string newAcountFlag = string.Empty;
			MapperBase mapper = null;
			FileMapper814 mapper814 = null;


			if( fileType.Equals( EdiFileType.EightSixSeven ) )
			{
				mapper = Mapper.GetMapper( utilityCode, marketCode );
				newAcountFlag = @"ST\" + fieldDelimiter + "867";
			}
			else
			{
				mapper814 = Mapper.Get814Mapper( utilityCode, marketCode );
				newAcountFlag = @"ST\" + fieldDelimiter + "814";
			}

			// get rows
			FileRowList rowList = GetFileRows( ref fileContents, newAcountFlag );

			fileContents = null;
			try
			{
				// get cells for each row
				List<EdiAccount> lstEdiAccounts = new List<EdiAccount>();

				foreach( FileRow row in rowList )
				{
					//ProcessEachRow( mapper, fRow, ediFile.FileType, ediFileLogID );
					// get an account list and associated usages based on the parsed generic rows
					EdiAccount ediAccount = null;
                    bool isMix = false;

                    FileController.processContent(row.Contents,ref fieldDelimiter,ref rowDelimiter,ref isMix,ref utilityCode,ref marketCode);

                    if (fileType.Equals(EdiFileType.EightSixSeven) && isMix)
                    {
                        mapper = Mapper.GetMapper(utilityCode, marketCode);
                        newAcountFlag = @"ST\" + fieldDelimiter + "867";
                    }
                    else if(isMix)
                    {
                        mapper814 = Mapper.Get814Mapper(utilityCode, marketCode);
                        newAcountFlag = @"ST\" + fieldDelimiter + "814";
                    }

					if( mapper != null )
						ediAccount = mapper.MapData( row, rowDelimiter, fieldDelimiter );
					else
						ediAccount = mapper814.Map( row, rowDelimiter, fieldDelimiter );

					if( ediAccount == null || ediAccount.AccountNumber == null || ediAccount.AccountNumber == string.Empty )
						continue;

					// validate data
					if( !Validator.ValidateEdiFile( ref ediAccount, fileType ) )
					{
						// log all account and usage exceptions
						ExceptionLogger.LogAccountExceptions( fileGuid, logID, fileType, ref ediAccount );

						if( ediAccount.AccountDataExistsRule.DefaultSeverity.Equals( BrokenRuleSeverity.Error ) )
						{
							bError = true;

							// phoenix
							PublishEvent( logID, ediAccount, fileType, true );
							
							continue;
						}
					}

					// insert account and usage
					DataInserter.Insert( logID, ediAccount, fileType );
					lstEdiAccounts.Add( ediAccount );
					//APH processing is now in Usage Management
                    //AcquireAndStoreDeterminantHistory( ediAccount, logID );
					// phoenix
                    PublishEvent( logID, ediAccount, fileType, false );
				}
                ////TFS-68346-At the end of the processing call the USageDuplicatehandling service to insert update the correct usage
                TransactionsSql.UpdateUsageQuantity(logID);

				if( utilityCode.ToUpper() == "AMEREN" )
				{

					foreach( string accountNumber in lstEdiAccounts.Select( e => e.AccountNumber ).Distinct() )
					{
						decimal? icap = null;
						List<string> servicePts = new List<string>();

						foreach( EdiAccount acct in lstEdiAccounts.Where( e => e.AccountNumber == accountNumber && e.Tcap >=0.0m ) )
						{
							if( !servicePts.Contains( acct.ServiceDeliveryPoint ) )// &&acct.)
							{
								servicePts.Add( acct.ServiceDeliveryPoint );

								if( icap == null )
									icap = acct.Icap;
								else
									icap += acct.Icap;
				}
						}

						if( icap.HasValue )
						{
							var aid = new AccountIdentifier( utilityCode, accountNumber);
							FieldHistoryManager.FieldValueInsert( aid, TrackedField.ICap, icap.ToString(), null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping );
						}
					}
				}
			}
			catch( Exception ex )
			{
				throw ex;
			}
			return bError;
		}

		private static void AcquireAndStoreDeterminantHistory( EdiAccount account, int ediFileLogID )
		{
			DataSet ds = OfferSql.AccountExistsInOfferEngine( account.AccountNumber, account.UtilityCode );
            if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(account.AccountNumber, account.UtilityCode))
				return;

			IcapList icapList = account.IcapList;
			TcapList tcapList = account.TcapList;
			int icapCount = icapList.Count;
			int tcapCount = tcapList.Count;

            // If the effective date is "1/1/1980" then use current date else use the EDI account's effective date
            var effectiveDate = account.EffectiveDate.Year == 1980 ? DateTime.Now.Date : account.EffectiveDate;

            var aid = new AccountIdentifier(account.UtilityCode, account.AccountNumber);
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, account.UtilityCode, null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping);
			if(!TxuUtilities.Contains(aid.UtilityCode))
				FieldHistoryManager.FieldValueInsert( aid, TrackedField.Zone, account.ZoneCode ?? "", null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping );
			FieldHistoryManager.FieldValueInsert( aid, TrackedField.RateClass, account.RateClass ?? "", null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping );
			FieldHistoryManager.FieldValueInsert( aid, TrackedField.LoadProfile, account.LoadProfile ?? "", null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping );

			if( account.Voltage != null && account.Voltage.Trim().Length > 0 )
				FieldHistoryManager.FieldValueInsert( aid, TrackedField.Voltage, account.Voltage, null, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping );

			if( icapCount == 0 )
			{
				//	TFS 29908 / 24516
			if( account.Icap >= 0 && account.UtilityCode.ToUpper() != "AMEREN" )
			{
				if(account.UtilityCode.ToUpper() == "CMP" )
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, (account.Icap * 1000.0m).ToString(), effectiveDate, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping);
				else
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, account.Icap.ToString(), effectiveDate, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping);
			}
			}
			else
			{
				// need to insert 1 record for each icap
				for( int i = 0; i < icapCount; i++ )
				{
					decimal icap = icapList[i].Value;
					DateTime? icapEffectiveDate = icapList[i].BeginDate;

					if( icap >= 0 && account.UtilityCode.ToUpper() != "AMEREN" )
					{
						if( account.UtilityCode.ToUpper() == "CMP" )
							FieldHistoryManager.FieldValueInsert( aid, TrackedField.ICap, (icap * 1000.0m).ToString(), icapEffectiveDate, FieldUpdateSources.EDIParser, "",
								FieldLockStatus.Unknown, icapEffectiveDate <= DateTime.Today ? _applyMapping : null );
						else
							FieldHistoryManager.FieldValueInsert( aid, TrackedField.ICap, icap.ToString(), icapEffectiveDate, FieldUpdateSources.EDIParser, "",
								FieldLockStatus.Unknown, icapEffectiveDate <= DateTime.Today ? _applyMapping : null );
					}
				}
			}

			if( tcapCount == 0 )
			{
			if( account.Tcap >= 0 )
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, account.Tcap.ToString(), effectiveDate, FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, _applyMapping);
			}
			else
			{
				// need to insert 1 record for each tcap
				for( int i = 0; i < tcapCount; i++ )
				{
					decimal tcap = tcapList[i].Value;
					DateTime? tcapEffectiveDate = tcapList[i].BeginDate;
			
					if( tcap >= 0 )
					{
						FieldHistoryManager.FieldValueInsert( aid, TrackedField.TCap, tcap.ToString(), tcapEffectiveDate,
							FieldUpdateSources.EDIParser, "", FieldLockStatus.Unknown, tcapEffectiveDate <= DateTime.Today ? _applyMapping : null );
					}
				}
			}
		}

		/// <summary>
		/// Creates a file row list
		/// </summary>
		/// <param name="fileContents">Contents of file</param>
		/// <param name="newAccountDelimiter">new account Identifier (ST 867 or ST 814)</param>
		/// <returns>Returns a file row list</returns>
		private static FileRowList GetFileRows( ref string fileContents, string newAccountDelimiter )
		{
			FileRowList list = new FileRowList();

			string[] rows = Regex.Split( fileContents, newAccountDelimiter );

			int count = rows.Length;

			for( int i = 0; i < count; i++ )
				list.Add( CreateFileRow( rows[i], i ) );

			return list;
		}

		private static void PublishEvent( int logID, EdiAccount ediAccount, EdiFileType fileType, bool error )
		{
			// per Jay, temporary solution until we upgrade to 4.5
			Func<EdiAccount, bool, bool, bool, int, bool, string> createMessage =
				( ea, is814, is867Hu, is867Hi, log, isError ) => "{" +
													  string.Format(
														  "\"AccountNumber\":\"{0}\",\"UtilityCode\":\"{1}\",\"TransactionId\":0,\"Message\":\"{2}\",\"Is814SummaryData\":\"{3}\",\"Is814IntervalData\":\"{4}\",\"Is867IntervalData\":\"{5}\",\"Is867SummaryData\":\"{6}\",\"ParserLogId\":\"{7}\",\"IsError\":\"{8}\"",
														  new object[]
                                                              {
                                                                  ea.AccountNumber,
                                                                  ea.UtilityCode,
                                                                  ea.AccountStatus,
                                                                  is814 & (ea.ProductType == "SHHU" || string.IsNullOrWhiteSpace(ea.ProductType)),
                                                                  is814 & ea.ProductType == "SHHI",
                                                                  is867Hi,
                                                                  is867Hu,
                                                                  log,
                                                                  isError
                                                              } )
													  + "}";

			var message = string.Empty;

			if( fileType == EdiFileType.EightOneFour )
			{
				message = createMessage( ediAccount, true, false, false, logID, error );
				TransactionsSql.SaveEvent( message, "EdiFileParsed" );
			}
			
			if( fileType.Equals( EdiFileType.EightSixSeven ) && (ediAccount.EdiUsageList != null && ediAccount.EdiUsageList.Count > 0) )
			{
				message = createMessage( ediAccount, false, true, false, logID, error );
				TransactionsSql.SaveEvent( message, "EdiFileParsed" );
			}
			
			if( fileType.Equals( EdiFileType.EightSixSeven ) && (ediAccount.IdrUsageList != null && ediAccount.IdrUsageList.Count > 0) )
			{
				message = createMessage( ediAccount, false, false, true, logID, error );
				TransactionsSql.SaveEvent( message, "EdiFileParsed" );
			}

		}

		/// <summary>
		/// Creates a file cell list
		/// </summary>
		/// <param name="row">File row object</param>
		/// <param name="fieldDelimiter">Character field delimiter</param>
		/// <returns>Returns a file cell list</returns>
		private static string[] GetRowCells( FileRow row, char fieldDelimiter )
		{
			//FileCellList list = new FileCellList();

			try
			{
				string[] cells = row.Contents.Split( fieldDelimiter );
				/*int count = cells.Length;

				for( int i = 0; i < count; i++ )
				{
					FileCell c = CreateFileCell( cells[i], i );
					//if( !list.Contains( c ) )
						list.Add( c );
				}*/

				return cells;
			}
			catch( Exception ex )
			{
				throw ex;
			}
		}

		/// <summary>
		/// Creates a file row object
		/// </summary>
		/// <param name="rowContents">Contents of file row</param>
		/// <param name="rowNumber">File row position</param>
		/// <returns>Returns a file row object</returns>
		private static FileRow CreateFileRow( string rowContents, int rowNumber )
		{
			return new FileRow( rowContents, rowNumber );
		}
	}
}

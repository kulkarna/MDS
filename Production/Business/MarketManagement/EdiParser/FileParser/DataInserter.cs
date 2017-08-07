namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Data;
	using DataSynchronizationServiceReference;
	using CommonBusiness.CommonHelper;
	using DataAccess.SqlAccess.TransactionsSql;
    using System.Linq;

	/// <summary>
	/// Class for inserting account and usage data.
	/// </summary>
	public static class DataInserter
	{
		/// <summary>
		/// Inserts account and usage data for utility file.
		/// </summary>
		/// <param name="ediFileLogID">Edi file log ID</param>
		/// <param name="account">Account list that contains account and respective usage data.</param>
		/// <param name="fileType">Format of the file (814, 867 or status update).</param>
		public static void Insert( int ediFileLogID, EdiAccount account, EdiFileType fileType )
		{

            ////Add a Logger to track.
            string logMessage = String.Format("Data Insert for Begin forEDI file-{0}- and Account-{1}", ediFileLogID, account.AccountNumber);
            ExceptionLogger.LogEdiException("Account DataInsert", "DuringEDiInsert", logMessage);
			string contactName = string.Empty;
			string emailAddress = string.Empty;
			string fax = string.Empty;
			string homePhone = string.Empty;
			string telephone = string.Empty;
			string workPhone = string.Empty;
			if( account.Contact != null )
			{
				contactName = account.Contact.Name;
				emailAddress = account.Contact.EmailAddress;
				fax = account.Contact.Fax;
				homePhone = account.Contact.HomePhone;
				telephone = account.Contact.Telephone;
				workPhone = account.Contact.WorkPhone;
			}
			int accountId = 0;

			IcapList icapList = account.IcapList;
			TcapList tcapList = account.TcapList;
			int icapCount = icapList.Count;
			int tcapCount = tcapList.Count;
			int iterations = icapCount > tcapCount ? icapCount : tcapCount;

			DateTime? icapEffectiveDate = null;
			DateTime? tcapEffectiveDate = null;
            int? daysInArrear=null;
            if (!string.IsNullOrEmpty(account.DaysInArrear) && account.DaysInArrear.All(Char.IsNumber))
                daysInArrear = Convert.ToInt32(account.DaysInArrear);
			if( iterations > 0 )
			{
				// need to insert 1 record for each icap/tcap
				for( int i = 0; i < iterations; i++ )
				{
					// there may be unequal quantities of icap/tcap
					int icapIndex = i > icapCount - 1 ? icapCount - 1 : i;
					int tcapIndex = i > tcapCount - 1 ? tcapCount - 1 : i;

					decimal icap = -1;
					icapEffectiveDate = null;
					if( icapIndex > -1 )
					{
						icap = icapList[icapIndex].Value;
						icapEffectiveDate = icapList[icapIndex].BeginDate;						
					}
					decimal tcap = -1;
					tcapEffectiveDate = null;
					if( tcapIndex > -1 )
					{
						tcap = tcapList[tcapIndex].Value;
						tcapEffectiveDate = tcapList[tcapIndex].BeginDate;
					}

					accountId = InsertEdiAccount( ediFileLogID, account, contactName, emailAddress, fax, telephone,
						workPhone, homePhone, icap, tcap, icapEffectiveDate, tcapEffectiveDate ,daysInArrear);
				}
			}
			else
			{
                if (account.HasIcap)
                    icapEffectiveDate = account.EffectiveDate;
                if (account.HasTcap)
                    tcapEffectiveDate = account.EffectiveDate;

				accountId = InsertEdiAccount( ediFileLogID, account, contactName, emailAddress, fax, telephone,
						workPhone, homePhone, account.Icap, account.Tcap, icapEffectiveDate, tcapEffectiveDate,daysInArrear );
			}

			//Removed for PDAPI
			//if( DataSetHelper.HasRow( ds ) )
			//{
			//    accountId = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );

			//    // Update all necessary databases with mapped EDI data
			//    UtilityAccount utilityAccount = EdiMappingFactory.MapEdiRawData( account );
			//    EdiMappingFactory.UpdateDatabasesWithMappedData( utilityAccount );
			//}

			//Success
			string address1 = "";
			string address2 = "";
			string city = "";
			string state = "";
			string postalCode = "";

			if( account.BillingAddress != null )
			{
				address1 = account.BillingAddress.Street == null ? "" : account.BillingAddress.Street;
				city = account.BillingAddress.CityName == null ? "" : account.BillingAddress.CityName;
				state = account.BillingAddress.State == null ? "" : account.BillingAddress.State;
				postalCode = account.BillingAddress.PostalCode == null ? "" : account.BillingAddress.PostalCode;

				if( (address1 + city + state + postalCode) != "" )
					TransactionsSql.InsertEdiAddress( accountId, (Int16) AddressType.BillingAddress, address1, address2, city, state, postalCode );
			}

			if( account.ServiceAddress != null )
			{
				address1 = "";
				address2 = "";
				city = "";
				state = "";
				postalCode = "";

				address1 = account.ServiceAddress.Street == null ? "" : account.ServiceAddress.Street;
				city = account.ServiceAddress.CityName == null ? "" : account.ServiceAddress.CityName;
				state = account.ServiceAddress.State == null ? "" : account.ServiceAddress.State;
				postalCode = account.ServiceAddress.PostalCode == null ? "" : account.ServiceAddress.PostalCode;

				if( (address1 + city + state + postalCode) != "" )
					TransactionsSql.InsertEdiAddress( accountId, (Int16) AddressType.ServiceAddress, address1, address2, city, state, postalCode );
			}

			if( fileType == EdiFileType.EightSixSeven )	// 814's don't have usage..
			{
				foreach( EdiUsage usage in account.EdiUsageList )
				{
					if( usage.BeginDate > DateHelper.DefaultDate && usage.EndDate > DateHelper.DefaultDate && accountId > 0 )
					{
						if( usage.PtdLoop.Equals( "SU" ) ) // Ticket 17219
						{
                            ///New Method-MTJ-6/29/2015-PBI-68346
                            ///This New method is called as part of 68346, to combine  meter reads if already exists
                            
							int usageId = 0;
                            if (usage.UnitOfMeasurement != "D1")
                            {
                                ///This New method is called as part of 68346, to combine  meter reads if already exists
                                usageId = InsertEdiUsage(
                                    accountId,
                                    usage.BeginDate,
                                    usage.EndDate,
                                    usage.Quantity,
                                    usage.MeterNumber,
                                    usage.MeasurementSignificanceCode,
                                    usage.TransactionSetPurposeCode,
                                    usage.UnitOfMeasurement,
                                    usage.ServiceDeliveryPoint,
                                    ediFileLogID, 
                                    usage.HistoricalSection);
                            }
						}
						else
						{
							// Ticket 17219
							int usageId = 0;
                            //New Method-MTJ-6/29/2015-PBI-68346
                            ////This New method is called as part of 68346, to combine  meter reads if already exists
                            if (usage.UnitOfMeasurement != "D1")
                            {
                            usageId = InsertEdiUsageDetail(accountId, usage.BeginDate, usage.EndDate, usage.Quantity,
                                                          usage.MeterNumber,
                                                          usage.MeasurementSignificanceCode, usage.PtdLoop,
                                                          usage.TransactionSetPurposeCode, usage.UnitOfMeasurement, ediFileLogID);
						}
					}
				}
				}

				/*				if( account.EdiUsageList != null )
								{
									DateTime from = DateTime.Today.AddDays( -365 );
									DateTime to = DateTime.Now;

									try
									{
										UsageList rawList = UsageFactory.GetRawUsage( account.AccountNumber, account.UtilityCode, from, to, "File Parser" );

										if( rawList.Count == 0 )
											UsageSql.InsertAuditUsageUsedLog( "UsageFactory", "GetRawUsage", "Account has no usage available.", "Consolidating Usage for Account " + account.AccountNumber, "File Parser" );

									}
									catch( Exception ex )
									{
										UsageSql.InsertAuditUsageUsedLog( "UsageFactory", "GetRawUsage", ex.Message, "Consolidating Usage for Account " + account.AccountNumber, "File Parser" );
									}
								}
				*/
				// IDR usage - September 2010
				// ------------------------------------------------------------------------------------
				if( account.IdrUsageList != null && account.IdrUsageList.Count != 0 )
				{
					DataTable dtIDR = new DataTable();
					DataColumn dc = new DataColumn( "accountID", System.Type.GetType( "System.Int32" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "meterNumber", System.Type.GetType( "System.String" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "ptdLookup", System.Type.GetType( "System.String" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "date", System.Type.GetType( "System.DateTime" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "interval", System.Type.GetType( "System.Int16" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "quantity", System.Type.GetType( "System.Decimal" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "code", System.Type.GetType( "System.String" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "unit", System.Type.GetType( "System.String" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "dateInsert", System.Type.GetType( "System.DateTime" ) );
					dtIDR.Columns.Add( dc );

					dc = new DataColumn( "dateUpdate", System.Type.GetType( "System.DateTime" ) );
					dtIDR.Columns.Add( dc );

					DataRow dr;
					foreach( EdiIdrUsage idrUsg in account.IdrUsageList.Values )
					{
                        if (idrUsg.UnitOfMeasurement != "D1")
                        {
                            dr = dtIDR.NewRow();
                            dr["accountID"] = accountId;
                            dr["meterNumber"] = idrUsg.MeterNumber;
                            dr["date"] = idrUsg.Date;
                            dr["interval"] = idrUsg.Interval;
                            dr["quantity"] = idrUsg.Quantity;
                            dr["ptdLookup"] = idrUsg.PtdLoop;
                            dr["code"] = idrUsg.TransactionSetPurposeCode;
                            dr["unit"] = idrUsg.UnitOfMeasurement;
                            dr["dateInsert"] = DateTime.Now;
                            dr["dateUpdate"] = DateTime.Now;
                            dtIDR.Rows.Add(dr);
                        }

						/*int usageId = 0;
						DataSet dsIDR = TransactionsSql.InsertIdrUsage( accountId, idrUsg.Date, idrUsg.Interval, idrUsg.Quantity, idrUsg.PtdLoop,
							idrUsg.TransactionSetPurposeCode, idrUsg.UnitOfMeasurement );

						if( DataSetHelper.HasRow( dsIDR ) )
							usageId = Convert.ToInt32( dsIDR.Tables[0].Rows[0]["ID"] );*/
					}

					TransactionsSql.InsertIdrUsageBulk( dtIDR );
					TransactionsSql.InsertIdrUsageFromTemp();
					//TransactionsSql.InsertIdrUsage( dtIDR );

				}
                //Added the logging
                logMessage = String.Format("Data Insert Completed for EDI file {0}- and Account {1}", ediFileLogID, account.AccountNumber);
                ExceptionLogger.LogEdiException("Account DataInsert", "DuringEDiInsert", logMessage);
			}

		}

		private static int InsertEdiAccount( int ediFileLogID, EdiAccount account, string contactName, string emailAddress,
			string fax, string telephone, string workPhone, string homePhone, decimal icap, decimal tcap,
			DateTime? icapEffectiveDate, DateTime? tcapEffectiveDate,int? daysInArrear )
		{
			int accountId = 0;

			DataSet ds = TransactionsSql.InsertEdiAccount( ediFileLogID, account.AccountNumber, account.BillingAccount, account.EspAccount, account.CustomerName,
				account.DunsNumber, icap, account.NameKey, account.PreviousAccountNumber, account.RateClass, account.LoadProfile, account.BillGroup.ToString(),
				account.RetailMarketCode, tcap, account.UtilityCode, account.ZoneCode, account.AccountStatus, account.BillingType, account.BillCalculation,
				account.ServicePeriodStart, account.ServicePeriodEnd, account.AnnualUsage, account.MonthsToComputeKwh,
				account.MeterType, account.MeterMultiplier, account.TransactionType, account.ServiceType, account.ProductType, account.ProductAltType,
				contactName, emailAddress, fax, telephone, workPhone, homePhone, account.MeterNumber, account.ServiceDeliveryPoint,
				account.LossFactor, account.Voltage, account.EffectiveDate, account.NetMeterType, icapEffectiveDate, tcapEffectiveDate,daysInArrear,account.TransactionCreatedDate );

			if( DataSetHelper.HasRow( ds ) )
			{
				accountId = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				/*this is being called from the service bus now
				 * try
				{
					var dataSyncClient = new DataSynchronizationClient( "BasicHttpBinding_IDataSynchronization" );
					dataSyncClient.SynchronizeAsync( account.AccountNumber, account.UtilityCode, account.ZoneCode, account.LoadProfile, account.RateClass, account.BillGroup.ToString(), icap.ToString(), tcap.ToString() );
					//dataSyncClient.Synchronize( account.AccountNumber, account.UtilityCode, account.ZoneCode, account.LoadProfile, account.RateClass, account.BillGroup.ToString(), account.Icap.ToString(), account.Tcap.ToString() );
				}
				catch( Exception ex )
				{
				}*/
			}
			else
			{
				string format = "Insert failed for account {0}.";
				throw new EdiAccountException( String.Format( format, account.AccountNumber ) );
			}
			return accountId;
		}
        /// <summary>
        /// New  Method to  Combine Usage Quantily if  More than one  Record  present with Different Quantity
        /// PBI-68346- MTJ-Added New code on 06/29/2015
        /// </summary>
        /// <returns></returns>
        private static int InsertEdiUsage(
            int ediAccountID,
            DateTime beginDate, 
            DateTime endDate,
            decimal quantity,
            string meterNumber, 
            string measurementSignificanceCode,
            string transactionSetPurposeCode, 
            string unitOfMeasurement, 
            string ServiceDeliveryPoint,
            int ediFileLogID, 
            string historicalSection = null)
        {
            int idOld = 0;
            int idNullMeter = 0;
            int idDupNullMeter = 0;
            int oldFileLogId = 0;
            int nullMeterFileLogId = 0;
            int dupNullMeterFileLogId = 0;
            decimal oldQuantity = 0;
            decimal nullMeterQuantity = 0;
            decimal dupNullMeterQuantity = 0;
            int usageId = 0;
            string oldMeterNumber = "";
            string dupOldMeterNumber = "";
            int usageType = 1;

            try
            {
                //TransactionSQL.GetUsageData()
                DataSet ds = TransactionsSql.GetEdiUsageRecord(ediAccountID, beginDate, endDate, meterNumber, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ServiceDeliveryPoint);
                if (DataSetHelper.HasRow(ds))
                {
                    idOld = Convert.ToInt32(ds.Tables[0].Rows[0]["ID"]);
                    oldQuantity = Convert.ToDecimal(ds.Tables[0].Rows[0]["quantity"]);
                    oldFileLogId = Convert.ToInt32(ds.Tables[0].Rows[0]["edifilelogid"]);
                }

                ///Check for Duplicate record with Meternumebr Null But same Quantity-  Assuming if two records with same quantity,
                ///but one with MErternumer = Null and other with MeterNumber > 0, The one with MeterNumber = Null will be discarded.
                DataSet dsNullMeter = null;
                dsNullMeter = TransactionsSql.GetEdiUsageRecordNullMeter(ediAccountID, beginDate, endDate, quantity, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ServiceDeliveryPoint);
                if (DataSetHelper.HasRow(dsNullMeter))
                {
                    idNullMeter = Convert.ToInt32(dsNullMeter.Tables[0].Rows[0]["ID"]);
                    nullMeterQuantity = Convert.ToDecimal(dsNullMeter.Tables[0].Rows[0]["quantity"]);
                    nullMeterFileLogId = Convert.ToInt32(dsNullMeter.Tables[0].Rows[0]["edifilelogid"]);
                    oldMeterNumber = dsNullMeter.Tables[0].Rows[0]["meternumber"].ToString();
                    ////If there is already a  row with null Meter  of same  Quantity and From Same file, just update the Meter number
                    if ((idNullMeter > 0) && (oldMeterNumber != meterNumber))
                    {
                        if ((oldMeterNumber == "") || (meterNumber == ""))
                        {
                            TransactionsSql.EdiUsageUpdateMeterNumber(idNullMeter, meterNumber, usageType, ediFileLogID);
                            return idNullMeter;
                        }
                    }
                }

                ///Check for Duplicate record with Meternumebr Null But same Quantity in Duplicate table-  Assuming if two records with same quantity,
                ///but one with MErternumer = Null and other with MeterNumber > 0, The one with MeterNumber = Null will be discarded.
                DataSet dsDupNullMeter = null;
                dsDupNullMeter = TransactionsSql.GetEdiUsageDupNullMeter(ediAccountID, beginDate, endDate, quantity, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ediFileLogID, ServiceDeliveryPoint, null, usageType);
                if (DataSetHelper.HasRow(dsDupNullMeter))
                {
                    idDupNullMeter = Convert.ToInt32(dsDupNullMeter.Tables[0].Rows[0]["ID"]);
                    dupNullMeterQuantity = Convert.ToDecimal(dsDupNullMeter.Tables[0].Rows[0]["quantity"]);
                    dupNullMeterFileLogId = Convert.ToInt32(dsDupNullMeter.Tables[0].Rows[0]["edifilelogid"]);
                    dupOldMeterNumber = dsDupNullMeter.Tables[0].Rows[0]["meternumber"].ToString();
                    ////If there is already a  row with null Meter  of same  Quantity and From Same file, just update the Meter number
                    if ((idDupNullMeter > 0) && (dupOldMeterNumber != meterNumber))
                    {
                        if ((dupOldMeterNumber == "") || (meterNumber == ""))
                        {
                            ///Update  the  recod from Duplicate as  same record already inserted.
                            TransactionsSql.EdiUsageDupUpdateMeterNumber(idDupNullMeter, meterNumber, usageType, ediFileLogID);
                            return idDupNullMeter;
                        }

                    }
                }


                //If the data is new record, or  old record is  from a diffferent File  do the regular Insert/Update Process           
                if ((idOld < 1) || ((idOld > 0) && (ediFileLogID != oldFileLogId)) || ((idOld > 0) && (meterNumber != "")))
                {
                    //Call the regular Insert/Update
                    DataSet dsUsage = TransactionsSql.InsertEdiUsage(
                        ediAccountID,
                        beginDate,
                        endDate, 
                        quantity, 
                        meterNumber, 
                        measurementSignificanceCode,
                        transactionSetPurposeCode, 
                        unitOfMeasurement, 
                        ServiceDeliveryPoint,
                        ediFileLogID,
                        historicalSection);

                    if (DataSetHelper.HasRow(dsUsage))
                    {
                        usageId = Convert.ToInt32(dsUsage.Tables[0].Rows[0]["ID"]);
                    }
                    else
                    {
                        string format = "Usage insert failed for account {0}.";
                        throw new EdiUsageException(String.Format(format, ediAccountID));  //account.AccountNumber ) );
                    }
                    return usageId;
                }
                else if ((idOld > 0) && (ediFileLogID.CompareTo(oldFileLogId) == 0) && (quantity != oldQuantity) && (meterNumber == ""))
                ////Same record from same file but quantity different so need to combine and add the meter 
                {
                    DataSet dsUsageduplicate = TransactionsSql.EdiUsageDuplicateInsert(
                        ediAccountID, 
                        beginDate,
                        endDate,
                        quantity, 
                        meterNumber, 
                        measurementSignificanceCode,
                        transactionSetPurposeCode,
                        unitOfMeasurement,
                        ServiceDeliveryPoint,
                        ediFileLogID,
                        null, 
                        usageType,
                        historicalSection);

                    if (DataSetHelper.HasRow(dsUsageduplicate))
                        usageId = Convert.ToInt32(dsUsageduplicate.Tables[0].Rows[0]["ID"]);

                    else
                    {
                        string format = "Usage insert failed for account {0}.";
                        throw new EdiUsageException(String.Format(format, ediAccountID));  //account.AccountNumber ) );
                    }
                    return usageId;
                }

            }
            catch (Exception ex)
            {
                string errorMessage = String.Format("{0}-{2}-{1}", ex.Message, ex.StackTrace, ex.InnerException == null ? String.Empty : ex.InnerException.ToString());
                ExceptionLogger.LogEdiException("UsageInsert", "DuringEDiInsert", errorMessage);
                throw ex;

            }
            return usageId;
        }
        /// <summary>
        /// New  Method to  Combine UsageDetail Quantity if  More than one  Record  present with Different Quantity
        /// PBI-68346-MTJ- Added New code on 06/29/2015
        /// </summary>
        /// <returns></returns>
        private static int InsertEdiUsageDetail(int ediAccountID, DateTime beginDate, DateTime endDate,
                                                 decimal quantity, string meterNumber, string measurementSignificanceCode, string ptdLoop,
                                                 string transactionSetPurposeCode, string unitOfMeasurement,
                                                 int ediFileLogID)
        {
            int idOld = 0;
            int idNullMeter = 0;
            int idDupNullMeter = 0;
            int oldFileLogId = 0;
            int nullMeterFileLogId = 0;
            int dupNullMeterFileLogId = 0;
            decimal oldQuantity = 0;
            decimal nullMeterQuantity = 0;
            decimal dupNullMeterQuantity = 0;
            int usageId = 0;
            string oldMeterNumber = "";
            string dupOldMeterNumber = "";
            int usageType = 2;

            try
            {
                //TransactionSQL.GetUsageData()
                DataSet ds = TransactionsSql.GetEdiUsageDetailRecord(ediAccountID, beginDate, endDate, meterNumber, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ptdLoop);
                if (DataSetHelper.HasRow(ds))
                {
                    idOld = Convert.ToInt32(ds.Tables[0].Rows[0]["ID"]);
                    oldQuantity = Convert.ToDecimal(ds.Tables[0].Rows[0]["quantity"]);
                    oldFileLogId = ds.Tables[0].Rows[0]["edifilelogid"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["edifilelogid"]);

                }

                ///Check for Duplicate record with Meternumebr Null But same Quantity-  Assuming if two records with same quantity,
                ///but one with MErternumer = Null and other with MeterNumber > 0, The one with MeterNumber = Null will be discarded.
                DataSet dsNullMeter = null;
                dsNullMeter = TransactionsSql.GetEdiUsageDetailNullMeter(ediAccountID, beginDate, endDate, quantity, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ptdLoop);
                if (DataSetHelper.HasRow(dsNullMeter))
                {
                    idNullMeter = Convert.ToInt32(dsNullMeter.Tables[0].Rows[0]["ID"]);
                    nullMeterQuantity = Convert.ToDecimal(dsNullMeter.Tables[0].Rows[0]["quantity"]);
                    //nullMeterFileLogId = Convert.ToInt32(dsNullMeter.Tables[0].Rows[0]["edifilelogid"]);
                    nullMeterFileLogId = dsNullMeter.Tables[0].Rows[0]["edifilelogid"] == DBNull.Value ? 0 : Convert.ToInt32(dsNullMeter.Tables[0].Rows[0]["edifilelogid"]);
                    oldMeterNumber = dsNullMeter.Tables[0].Rows[0]["meternumber"].ToString();
                    ////If there is already a  row with null Meter  of same  Quantity and From Same file, just update the Meter number
                    if ((idNullMeter > 0) && (oldMeterNumber != meterNumber))
                    {
                        if ((oldMeterNumber == "") || (meterNumber == ""))
                        {
                            TransactionsSql.EdiUsageUpdateMeterNumber(idNullMeter, meterNumber, usageType, ediFileLogID);
                            return idNullMeter;
                        }
                    }
                }
                ///Check for Duplicate record with Meternumebr Null But same Quantity in Duplicate table-  Assuming if two records with same quantity,
                ///but one with MErternumer = Null and other with MeterNumber > 0, The one with MeterNumber = Null will be discarded.
                DataSet dsDupNullMeter = null;
                dsDupNullMeter = TransactionsSql.GetEdiUsageDupNullMeter(ediAccountID, beginDate, endDate, quantity, measurementSignificanceCode,
                                                                transactionSetPurposeCode, unitOfMeasurement, ediFileLogID, null, ptdLoop, usageType);
                if (DataSetHelper.HasRow(dsDupNullMeter))
                {
                    idDupNullMeter = Convert.ToInt32(dsDupNullMeter.Tables[0].Rows[0]["ID"]);
                    dupNullMeterQuantity = Convert.ToDecimal(dsDupNullMeter.Tables[0].Rows[0]["quantity"]);
                    dupNullMeterFileLogId = Convert.ToInt32(dsDupNullMeter.Tables[0].Rows[0]["edifilelogid"]);
                    dupNullMeterFileLogId = dsDupNullMeter.Tables[0].Rows[0]["edifilelogid"] == DBNull.Value ? 0 : Convert.ToInt32(dsDupNullMeter.Tables[0].Rows[0]["edifilelogid"]);

                    dupOldMeterNumber = dsDupNullMeter.Tables[0].Rows[0]["meternumber"].ToString();
                    ////If there is already a  row with null Meter  of same  Quantity and From Same file, just update the Meter number
                    if ((idDupNullMeter > 0) && (dupOldMeterNumber != meterNumber))
                    {
                        if ((dupOldMeterNumber == "") || (meterNumber == ""))
                        {
                            ///Update the  recod from Duplicate as  same record already inserted.
                            TransactionsSql.EdiUsageDupUpdateMeterNumber(idDupNullMeter, meterNumber, usageType, ediFileLogID);
                            return idDupNullMeter;
                        }
                    }
                }
                /// Do Regular Insert/Update process here     
                if ((idOld < 1) || ((idOld > 0) && (ediFileLogID != oldFileLogId)) || ((idOld > 0) && (meterNumber != "")))
                {
                    //Call the regular Insert/Update
                    DataSet dsUsage = TransactionsSql.InsertEdiUsageDetail(ediAccountID, beginDate, endDate, quantity, meterNumber, measurementSignificanceCode,
                                                                            ptdLoop, transactionSetPurposeCode, unitOfMeasurement, ediFileLogID);

                    if (DataSetHelper.HasRow(dsUsage))
                    {
                        usageId = Convert.ToInt32(dsUsage.Tables[0].Rows[0]["ID"]);

                    }
                    else
                    {
                        string format = "Usage insert failed for account {0}.";
                        throw new EdiUsageException(String.Format(format, ediAccountID));
                    }
                    return usageId;
                }

                else if ((idOld > 0) && (ediFileLogID.CompareTo(oldFileLogId) == 0) && (quantity != oldQuantity) && (meterNumber == ""))
                ////Same record from same file but quantity different so need to combine and add the meter 
                {
                    usageType = 2;//Setting this for EDIUsageDetail Table
                    DataSet dsUsageduplicate = TransactionsSql.EdiUsageDuplicateInsert(ediAccountID, beginDate, endDate, quantity, meterNumber, measurementSignificanceCode,
                                                                        transactionSetPurposeCode, unitOfMeasurement, null,
                                                                        ediFileLogID, ptdLoop, usageType);
                    if (DataSetHelper.HasRow(dsUsageduplicate))
                        usageId = Convert.ToInt32(dsUsageduplicate.Tables[0].Rows[0]["ID"]);

                    else
                    {
                        string format = "Usage insert failed for account {0}.";
                        throw new EdiUsageException(String.Format(format, ediAccountID));
                    }
                    return usageId;
                }

            }
            catch (Exception ex)
            {
                string errorMessage = String.Format("{0}-{2}-{1}", ex.Message, ex.StackTrace, ex.InnerException == null ? String.Empty : ex.InnerException.ToString());
                ExceptionLogger.LogEdiException("UsageInsert", "DuringEDiInsert", errorMessage);
                throw ex;

            }
            return usageId;
        }
	}
}

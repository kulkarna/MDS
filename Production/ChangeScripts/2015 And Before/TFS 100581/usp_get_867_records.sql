USE [ISTA]
GO
/****** Object:  StoredProcedure [dbo].[usp_get_867_records]    Script Date: 1/12/2016 10:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Modify Jose Munoz - SWCS
	Add the column [IsTOU] in the table Premise.
	This column is new in ISTA system and should be added in ISTA database in Libertypower
	PBI # 100581
*/

ALTER Procedure [dbo].[usp_get_867_records]
AS
DECLARE @maxid int

--------------------------------------
-- variables used for Dynamic query
--------------------------------------
DECLARE @sqlCommand varchar(4000)
DECLARE @MaxValue Integer


------------------
-- tbl_867_HEADER
------------------
	SELECT @MAxValue = MAX([867_key]) FROM ISTA.dbo.tbl_867_Header

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_Header([867_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr, TransactionSetPurposeCode, TransactionNbr, TransactionDate, ReportTypeCode, ActionCode, ReferenceNbr, DocumentDueDate, EsiId, PowerRegion, OriginalTransactionNbr, TdspDuns, TdspName, CrDuns, CrName, CTRProcessFlag, ProcessFlag, ProcessDate, Direction, UtilityAccountNumber, TransactionTypeID, MarketID, ProviderID, PreviousUtilityAccountNumber ) ' +
						'SELECT [867_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr, TransactionSetPurposeCode, TransactionNbr, TransactionDate, ReportTypeCode, ActionCode, ReferenceNbr, DocumentDueDate, EsiId, PowerRegion, OriginalTransactionNbr, TdspDuns, TdspName, CrDuns, CrName, CTRProcessFlag, ProcessFlag, ProcessDate, Direction, UtilityAccountNumber, TransactionTypeID, MarketID, ProviderID, PreviousUtilityAccountNumber ' +
						'FROM OPENQUERY("10.100.242.50",' + '''' + 'SELECT * FROM Market..tbl_867_Header where [867_key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'
	EXEC (@sqlCommand) 





---------------------------------
-- tbl_867_IntervalDetail
---------------------------------
	SELECT @MAxValue = MAX(IntervalDetail_Key) FROM ISTA.dbo.tbl_867_IntervalDetail

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_IntervalDetail(IntervalDetail_Key, IntervalSummary_Key, [867_Key], TypeCode, MeterNumber, ServicePeriodStart, ServicePeriodEnd, ExchangeDate, ChannelNumber, MeterUOM, MeterInterval, MeterRole, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass) ' +
						'SELECT IntervalDetail_Key, IntervalSummary_Key, [867_Key], TypeCode, MeterNumber, ServicePeriodStart, ServicePeriodEnd, ExchangeDate, ChannelNumber, MeterUOM, MeterInterval, MeterRole, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_IntervalDetail  where [IntervalDetail_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)
	
	
	
	
	

---------------------------------
-- tbl_867_IntervalDetail_Qty
---------------------------------
	SELECT @MAxValue = MAX(IntervalDetailQty_Key) FROM ISTA.dbo.tbl_867_IntervalDetail_Qty

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_IntervalDetail_Qty(IntervalDetailQty_Key, IntervalDetail_Key, Qualifier, Quantity, IntervalEndDate, IntervalEndTime, RangeMin, RangeMax, ThermFactor, DegreeDayFactor) ' +
						'SELECT IntervalDetailQty_Key, IntervalDetail_Key, Qualifier, Quantity, IntervalEndDate, IntervalEndTime, RangeMin, RangeMax, ThermFactor, DegreeDayFactor ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_IntervalDetail_Qty  where [IntervalDetailQty_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)


-------------------------------
-- tbl_867_NONINTERVALDETAIL
-------------------------------
	SELECT @MAxValue = MAX(NonIntervalDetail_Key) FROM ISTA.dbo.tbl_867_NonIntervalDetail

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalDetail(NonIntervalDetail_Key, NonIntervalSummary_Key, [867_Key], TypeCode, MeterNumber, MovementTypeCode, ServicePeriodStart, ServicePeriodEnd, ExchangeDate, MeterRole, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, SequenceNumber, ServiceIndicator) ' +
						'SELECT NonIntervalDetail_Key, NonIntervalSummary_Key, [867_Key], TypeCode, MeterNumber, MovementTypeCode, ServicePeriodStart, ServicePeriodEnd, ExchangeDate, MeterRole, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, SequenceNumber, ServiceIndicator ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalDetail  where [NonIntervalDetail_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'
						
	Exec (@SQLCommand)
	
	
	
	
	
---------------------------------
-- tbl_867_NonIntervalDetail_Qty
---------------------------------
	SELECT @MAxValue = MAX(NonIntervalDetailQty_Key) FROM ISTA.dbo.tbl_867_NonIntervalDetail_Qty

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalDetail_Qty(NonIntervalDetailQty_Key, NonIntervalDetail_Key, Qualifier, Quantity, MeasurementCode, CompositeUOM, UOM, BeginRead, EndRead, MeasurementSignificanceCode, TransformerLossFactor, MeterMultiplier, PowerFactor, ProcessFlag, ProcessDate, RangeMin, RangeMax, ThermFactor, DegreeDayFactor) ' +
						'SELECT NonIntervalDetailQty_Key, NonIntervalDetail_Key, Qualifier, Quantity, MeasurementCode, CompositeUOM, UOM, BeginRead, EndRead, MeasurementSignificanceCode, TransformerLossFactor, MeterMultiplier, PowerFactor, ProcessFlag, ProcessDate, RangeMin, RangeMax, ThermFactor, DegreeDayFactor ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalDetail_Qty  where [NonIntervalDetailQty_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'
						
	Exec (@SQLCommand)
	
	
---------------------------------
-- tbl_867_NonIntervalSummary
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(NonIntervalSummary_Key),0) FROM ISTA.dbo.tbl_867_NonIntervalSummary

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalSummary([867_Key], TypeCode, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, ActualSwitchDate, SequenceNumber, ServiceIndicator) ' +
						'SELECT [867_Key], TypeCode, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, ActualSwitchDate, SequenceNumber, ServiceIndicator ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalSummary  where [NonIntervalSummary_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

	
	
---------------------------------
-- tbl_867_NonIntervalSummary_Qty
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(NonIntervalSummaryQty_Key),0) FROM ISTA.dbo.tbl_867_NonIntervalSummary_Qty

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalSummary_Qty(NonIntervalSummary_Key, Qualifier, Quantity, MeasurementSignificanceCode, ServicePeriodStart, ServicePeriodEnd, RangeMin, RangeMax, ThermFactor, DegreeDayFactor, CompositeUOM, MeterMultiplier) ' +
						'SELECT NonIntervalSummary_Key, Qualifier, Quantity, MeasurementSignificanceCode, ServicePeriodStart, ServicePeriodEnd, RangeMin, RangeMax, ThermFactor, DegreeDayFactor, CompositeUOM, MeterMultiplier ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalSummary_Qty  where [NonIntervalSummaryQty_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)
	
	
	
---------------------------------
-- tbl_867_ScheduleDeterminants
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(ScheduleDeterminants_Key),0) FROM ISTA.dbo.tbl_867_ScheduleDeterminants

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_ScheduleDeterminants([867_Key], Capacity_Obligation, Transmission_Obligation, Load_Profile, LDC_Rate_Class, Zone) ' +
						'SELECT [867_Key], Capacity_Obligation, Transmission_Obligation, Load_Profile, LDC_Rate_Class, Zone ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_ScheduleDeterminants  where [ScheduleDeterminants_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)	
	
	
	
---------------------------------
-- dbo.tbl_867_UnmeterDetail
---------------------------------
	SELECT @MAxValue = MAX(UnmeterDetail_Key) FROM ISTA.dbo.tbl_867_UnmeterDetail

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_UnmeterDetail(UnmeterDetail_Key, UnmeterSummary_Key, [867_Key], TypeCode, ServicePeriodStart, ServicePeriodEnd, ServiceType, [Description], CommodityCode, UtilityRateServiceClass, RateSubClass) ' +
						'SELECT UnmeterDetail_Key, UnmeterSummary_Key, [867_Key], TypeCode, ServicePeriodStart, ServicePeriodEnd, ServiceType, [Description], CommodityCode, UtilityRateServiceClass, RateSubClass ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_UnmeterDetail  where [UnmeterDetail_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)




---------------------------------
-- dbo.tbl_867_UnmeterDetail_Qty
---------------------------------
	SELECT @MAxValue = MAX(UnmeterDetailQty_Key) FROM ISTA.dbo.tbl_867_UnmeterDetail_Qty

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_UnmeterDetail_Qty(UnmeterDetailQty_Key, UnmeterDetail_Key, Qualifier, Quantity, CompositeUOM, UOM, NumberOfDevices, ConsumptionPerDevice, ProcessFlag, ProcessDate) ' +
						'SELECT UnmeterDetailQty_Key, UnmeterDetail_Key, Qualifier, Quantity, CompositeUOM, UOM, NumberOfDevices, ConsumptionPerDevice, ProcessFlag, ProcessDate ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_UnmeterDetail_Qty  where [UnmeterDetailQty_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)




--------------------------------  begin  -------------------------------------------------------
-- added 6/26/2008  ----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

---------------------------------
-- dbo.tblMarketFile
---------------------------------
	SELECT @MAxValue = MAX(MarketFileId) FROM ISTA.dbo.tblMarketFile

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tblMarketFile([FileName], FileType, ProcessStatus, ProcessDate, ProcessError, SenderTranNum, DirectionFlag, Status, LDCID, CSPDUNSID, RefMarketFileId, CreateDate, CspDunsTradingPartnerID, TransactionCount) ' +
						'SELECT [FileName], FileType, ProcessStatus, ProcessDate, ProcessError, SenderTranNum, DirectionFlag, Status, LDCID, CSPDUNSID, RefMarketFileId, CreateDate, CspDunsTradingPartnerID, TransactionCount ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tblMarketFile  where [MarketFileId] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)


---------------------------------  end  --------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

-----------------------------
--INSERT INTO Consumption
--SELECT * FROM
--OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Consumption') new
--WHERE new.ConsID not in
--(SELECT ConsID FROM Consumption)


INSERT INTO ConsumptionDetail
(ConsDetID, ConsID, ConsDetType, ConsDetQty, ConsUnitID, ConsMultiplier, Source, SourceID, MeterRegisterID )
SELECT ConsDetID, ConsID, ConsDetType, ConsDetQty, ConsUnitID, ConsMultiplier, Source, SourceID, MeterRegisterID 
FROM
OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..ConsumptionDetail') new
WHERE new.ConsDetID not in
(SELECT ConsDetID FROM ConsumptionDetail)


INSERT INTO Meter
SELECT MeterID, ESIIDID, AcctID, AddrID, TypeID, PremID, MeterNo, MeterUniqueNo, Pool, MeterReadType, MeterFactoryID, MeterFactor, BegRead, EndRead, DateFrom, Dateto, MeterStatus, SourceLevel, CreateDate, EdiRateClassId, EdiLoadProfileId ,AMSIndicator
FROM
OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Meter') new
WHERE new.MeterID not in
(SELECT MeterID FROM Meter)

----------------------------
SELECT @maxid = max(CustID) FROM Customer

INSERT INTO Customer
	  (CustID, CSPID, CSPCustID, PropertyID, PropertyCustID, CustomerTypeID, CustNo, CustName, LastName, FirstName, MidName, CompanyName, DBA, FederalTaxID, AcctsRecID, DistributedAR, ProductionCycle, BillCycle, RateID, SiteAddrID, MailAddrId, CorrAddrID, MailToSiteAddress, BillCustID, MasterCustID, Master, CustStatus, BilledThru, CSRStatus, CustType, Services, FEIN, DOB, Taxable, LateFees, NoOfAccts, ConsolidatedInv, SummaryInv, MsgID, TDSPTemplateID, TDSPGroupID, LifeSupportIndictor, LifeSupportStatus, LifeSupportDate, SpecialBenefitsPlan, BillFormat, PrintLayoutID, CreditScore, HitIndicator, RequiredDeposit, AccountManager, EnrollmentAlias, ContractID, ContractTerm, ContractStartDate, ContractEndDate, UserDefined1, CreateDate, RateChangeDate, ConversionAccountNo, PermitContactName, CustomerPrivacy, UsagePrivacy, CompanyRegistrationNumber, VATNumber, AccountStatus, AutoCreditAfterInvoiceFlag, LidaDiscount, DoNotDisconnect, DDPlus1, DeliveryTypeID)
SELECT CustID, CSPID, CSPCustID, PropertyID, PropertyCustID, CustomerTypeID, CustNo, CustName, LastName, FirstName, MidName, CompanyName, DBA, FederalTaxID, AcctsRecID, DistributedAR, ProductionCycle, BillCycle, RateID, SiteAddrID, MailAddrId, CorrAddrID, MailToSiteAddress, BillCustID, MasterCustID, Master, CustStatus, BilledThru, CSRStatus, CustType, Services, FEIN, DOB, Taxable, LateFees, NoOfAccts, ConsolidatedInv, SummaryInv, MsgID, TDSPTemplateID, TDSPGroupID, LifeSupportIndictor, LifeSupportStatus, LifeSupportDate, SpecialBenefitsPlan, BillFormat, PrintLayoutID, CreditScore, HitIndicator, RequiredDeposit, AccountManager, EnrollmentAlias, ContractID, ContractTerm, ContractStartDate, ContractEndDate, UserDefined1, CreateDate, RateChangeDate, ConversionAccountNo, PermitContactName, CustomerPrivacy, UsagePrivacy, CompanyRegistrationNumber, VATNumber, AccountStatus, AutoCreditAfterInvoiceFlag, LidaDiscount, DoNotDisconnect, DDPlus1, DeliveryTypeID
FROM [10.100.242.50].Billing.dbo.customer
WHERE CustID > @maxid

SELECT @maxid = max(CustID) FROM Premise

INSERT INTO Premise
      (PremID, CustID, CSPID, AddrID, TDSPTemplateID, ServiceCycle, TDSP, TaxAssessment, PremNo, PremDesc, PremStatus, PremType, LocationCode, SpecialNeedsFlag, SpecialNeedsStatus, SpecialNeedsDate, ReadingIncrement, Metered, Taxable, BeginServiceDate, EndServiceDate, SourceLevel, StatusID, StatusDate, CreateDate, RateID, UnitID, PropertyCommonID, DeleteFlag, LBMPId, PipelineId, GasLossId, GasPoolID, IsTOU) 
SELECT PremID, CustID, CSPID, AddrID, TDSPTemplateID, ServiceCycle, TDSP, TaxAssessment, PremNo, PremDesc, PremStatus, PremType, LocationCode, SpecialNeedsFlag, SpecialNeedsStatus, SpecialNeedsDate, ReadingIncrement, Metered, Taxable, BeginServiceDate, EndServiceDate, SourceLevel, StatusID, StatusDate, CreateDate, RateID, UnitID, PropertyCommonID, DeleteFlag, LBMPId, PipelineId, GasLossId, GasPoolID, IsTOU
FROM [10.100.242.50].Billing.dbo.Premise
WHERE PremID > @maxid






















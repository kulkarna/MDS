USE [ISTA]
GO
/****** Object:  StoredProcedure [dbo].[update_ISTA_Billing_Tables_Part2]    Script Date: 1/12/2016 10:50:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Hector Gomez
-- Create date: 10/13/2010
-- Description:	To alliviate the ISTA import, the objective is so that this stored proc will run simultaneaously with the other stored proc
-- therefore this entire process will be completed in half the time.
-- =============================================
-- 2016/01/12 Jose Munoz - SWCS
-- Update definition to column [IsTOU] to NOT NULL
-- This column is new in ISTA system and should be added in ISTA database in Libertypower
-- PBI # 100581


ALTER PROCEDURE [dbo].[update_ISTA_Billing_Tables_Part2] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
CREATE TABLE #ISTALocalTables(
	TableName varchar(200)
	)

INSERT INTO #ISTALocalTables VALUES('Account')
INSERT INTO #ISTALocalTables VALUES('accountsreceivable')
INSERT INTO #ISTALocalTables VALUES('AccountsReceivableHistory')
INSERT INTO #ISTALocalTables VALUES('Address')
INSERT INTO #ISTALocalTables VALUES('RateCategory')
INSERT INTO #ISTALocalTables VALUES('Consumption')
INSERT INTO #ISTALocalTables VALUES('ConsumptionDetail')
INSERT INTO #ISTALocalTables VALUES('Customer')
INSERT INTO #ISTALocalTables VALUES('CustomerAdditionalInfo')
INSERT INTO #ISTALocalTables VALUES('CustomerType')
INSERT INTO #ISTALocalTables VALUES('Invoice')
INSERT INTO #ISTALocalTables VALUES('InvoiceDetail')
INSERT INTO #ISTALocalTables VALUES('InvoiceTax')
INSERT INTO #ISTALocalTables VALUES('LBMP')
INSERT INTO #ISTALocalTables VALUES('LBMPLDC')
INSERT INTO #ISTALocalTables VALUES('LDC')
INSERT INTO #ISTALocalTables VALUES('Meter') --PENDING REVIEW WITH TEAM
INSERT INTO #ISTALocalTables VALUES('note')
INSERT INTO #ISTALocalTables VALUES('NoteCallType')
INSERT INTO #ISTALocalTables VALUES('NoteDepartment')
INSERT INTO #ISTALocalTables VALUES('NoteDetail')
INSERT INTO #ISTALocalTables VALUES('NotePriority')
INSERT INTO #ISTALocalTables VALUES('NoteStatus')
INSERT INTO #ISTALocalTables VALUES('NoteType')
INSERT INTO #ISTALocalTables VALUES('NoteTypeDetail')
INSERT INTO #ISTALocalTables VALUES('Payment')
INSERT INTO #ISTALocalTables VALUES('PaymentDetail')
INSERT INTO #ISTALocalTables VALUES('PlanType')
INSERT INTO #ISTALocalTables VALUES('Premise')
INSERT INTO #ISTALocalTables VALUES('Rate')
INSERT INTO #ISTALocalTables VALUES('RateDetail')
INSERT INTO #ISTALocalTables VALUES('RateVariable')
INSERT INTO #ISTALocalTables VALUES('SecUser')
INSERT INTO #ISTALocalTables VALUES('status')
INSERT INTO #ISTALocalTables VALUES('TDSPInvoice')
INSERT INTO #ISTALocalTables VALUES('TDSPPayments')
INSERT INTO #ISTALocalTables VALUES('UsageClass')
INSERT INTO #ISTALocalTables VALUES('tbl_820_Header')
INSERT INTO #ISTALocalTables VALUES('tbl_820_Detail')

INSERT INTO #ISTALocalTables VALUES('taxcertificate')
INSERT INTO #ISTALocalTables VALUES('taxpercentage')
INSERT INTO #ISTALocalTables VALUES('ldclookup')
INSERT INTO #ISTALocalTables VALUES('marketlookup')
INSERT INTO #ISTALocalTables VALUES('ChangeLog')
INSERT INTO #ISTALocalTables VALUES('ChangeLogDetail')
INSERT INTO #ISTALocalTables VALUES('CSPDUNS')

------------------------------------
--- MARKET LOOKUP TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'marketlookup'
	) > 0 
	BEGIN

		if exists (select * from sys.tables where name = 'marketlookup')
		drop table marketlookup
		select * into marketlookup
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..marketlookup') new
	END

------------------------------------
--- LDC LOOKUP TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'ldclookup'
	) > 0 
	BEGIN

		if exists (select * from sys.tables where name = 'ldclookup')
		drop table ldclookup
		select * into ldclookup
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..ldclookup') new
	END

------------------------------------
--- CHANGE LOG TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'ChangeLog'
	) > 0 
	BEGIN

		if exists (select * from sys.tables where name = 'ChangeLog')
		drop table ChangeLog
		select * into ChangeLog
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..ChangeLog') new
	END


------------------------------------
--- CHANGE LOG DETAIL TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'ChangeLogDetail'
	) > 0 
	BEGIN

		if exists (select * from sys.tables where name = 'ChangeLog')
		drop table ChangeLogDetail
		select * into ChangeLogDetail
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..ChangeLogDetail') new
	END


------------------------------------
--- TAX CERTIFICATE TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'taxcertificate'
	) > 0 
	BEGIN
		
		if exists (select * from sys.tables where name = 'taxcertificate')
		drop table taxcertificate
		select * into taxcertificate
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..taxcertificate') new
	END
	
------------------------------------
--- TAX PERCENTAGE TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'taxpercentage'
	) > 0 
	BEGIN
		
		if exists (select * from sys.tables where name = 'taxpercentage')
		drop table taxpercentage
		select * into taxpercentage
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..taxpercentage') new
	END
	
------------------------------------
--- Payment TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'Payment'
	) > 0 
	BEGIN
		-- Added by A. Iturbe on 2/2/2008
		if exists (select * from sys.tables where name = 'Payment')
		drop table Payment
		select * into Payment
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Payment') new
		
		CREATE CLUSTERED INDEX [PK_Payment]
		ON [dbo].[Payment] ([PaymentID])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

		CREATE NONCLUSTERED INDEX [Payment__Type_Paydate_I]
		ON [dbo].[Payment] ([Type],[PaidDate])
		INCLUDE ([PaymentID],[PostDate],[Amount])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

	END
	
------------------------------------
--- PaymentDetail TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'PaymentDetail'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 2/2/2008 
		if exists (select * from sys.tables where name = 'PaymentDetail')
			drop table PaymentDetail
		select * into PaymentDetail
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..PaymentDetail') new
		
		
		CREATE CLUSTERED INDEX [PK_PaymentDetail]
		ON [dbo].[PaymentDetail] ([PayDetID])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

		CREATE NONCLUSTERED INDEX [PaymentDetail__PaymentID_CustID]
		ON [dbo].[PaymentDetail] ([paymentid],[custid])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

	END
	
------------------------------------
--- PlanType TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'PlanType'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'PlanType')
		drop table PlanType
		select * into PlanType from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Plantype') new
	END
	


------------------------------------
--- Premise TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'Premise'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'Premise')
			drop table Premise
		select * into Premise from 
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Premise') new

		/*	2016/01/12
			ADDED JMUNOZ - SWCS 
			AVOID THE PROBLEM IN THE JOB
		*/
		ALTER TABLE Premise
		ALTER COLUMN [IsTOU] [bit] NULL

		CREATE CLUSTERED INDEX [Premise__PremID]
			ON [dbo].[Premise] ([PremID])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

		CREATE NONCLUSTERED INDEX [IX_PremNo] ON [dbo].[Premise] 
		(
			[PremNo] ASC
		)
		with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

		CREATE NONCLUSTERED INDEX [Premise__CustID_I]
			ON [dbo].[Premise] ([CustID])
			INCLUDE ([AddrID],[PremID])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

	END
	
------------------------------------
--- Rate TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'Rate'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'Rate')
		drop table Rate
		select * into Rate from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Rate') new
	END
	
------------------------------------
--- RateDetail TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'RateDetail'
	) > 0 
	BEGIN
		-- Added by Hector Gomez on 1/28/2009
		if exists (select * from sys.tables where name = 'RateDetail')
		drop table RateDetail
		select * into RateDetail from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..RateDetail') new
	END
	
------------------------------------
--- RateVariable TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'RateVariable'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 6/02/2008 
		if exists (select * from sys.tables where name = 'RateVariable')
			drop table RateVariable
		select * into RateVariable
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..RateVariable') new
	END
	
------------------------------------
--- SecUser TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'SecUser'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'SecUser')
			drop table SecUser
		select * into SecUser from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..SecUser') new
		
		CREATE CLUSTERED INDEX [SecUser__UserID]
		ON [dbo].[SecUser] ([UserID])
		with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
		
	END
	
------------------------------------
--- status TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'status'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 9/08/2008 
		if exists (select * from sys.tables where name = 'status')
			drop table [status]
		select * into [status]
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing.dbo.status') new
	END
	
	
------------------------------------
--- TDSPInvoice TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'TDSPInvoice'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'TDSPInvoice')
			drop table TDSPInvoice
		SELECT * into TDSPInvoice FROM
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..TDSPInvoice') new
	END

------------------------------------
--- TDSPPayments TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'TDSPPayments'
	) > 0 
	BEGIN
		-- Added by R. Enriquez on 12/17/2007 
		if exists (select * from sys.tables where name = 'TDSPPayments')
		drop  table TDSPPayments
		select * into TDSPPayments from 
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..TDSPPayments') new
	END
	
	
------------------------------------
--- UsageClass TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'UsageClass'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 6/04/2008 
		if exists (select * from sys.tables where name = 'UsageClass')
			drop table UsageClass
		select * into UsageClass
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..UsageClass') new
	END


----------------------------------
-- tbl_820_Header TABLE
----------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'tbl_820_Header'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 12/16/2009
		if exists (select * from sys.tables where name = 'tbl_820_Header')
			drop table tbl_820_Header
		select * into tbl_820_Header
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Market..tbl_820_Header') new
	END
------------------------------------
--- tbl_820_Detail TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'tbl_820_detail'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 12/16/2009
		if exists (select * from sys.tables where name = 'tbl_820_detail')
			drop table tbl_820_detail
		select * into tbl_820_detail
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Market..tbl_820_detail') new
	END





----------------------------------
-- CSPDUNS TABLE
----------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'CSPDUNS'
	) > 0 
	BEGIN
		-- Added by A.Iturbe on 4/29/2011
		if exists (select * from sys.tables where name = 'CSPDUNS')
			drop table CSPDUNS
		select * into CSPDUNS
		from
		OPENQUERY("10.100.242.50", 'SELECT * FROM billing..CSPDUNS') new
	END


----------------------------------
-- RATE DESCRIPTION
----------------------------------
if exists (select * from sys.tables where name = 'RateDescription')
drop table RateDescription

select * 
into RateDescription
from "10.100.242.50".billing.dbo.ratedescription


/* MOVED here from Part1 on 5/17/2011 by LF */
------------------------------------
--- Invoice TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'Invoice'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'Invoice')
			drop table Invoice
		select * into Invoice from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Invoice') new

		-- Added by Hector Gomez on 2/10/2009
		/****** Object:  Index [CLFK_CustID]    Script Date: 02/10/2009 15:11:37 ******/
		CREATE CLUSTERED INDEX [CLFK_CustID] ON [dbo].[Invoice] 
		(
			[CustID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

		-- Added by Hector Gomez on 2/10/2009
		/****** Object:  Index [PK_Invoice]    Script Date: 02/10/2009 15:08:44 ******/
		ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [PK_Invoice] PRIMARY KEY NONCLUSTERED 
		(
			[InvoiceID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

		CREATE NONCLUSTERED INDEX [Invoice__Type_InvAmt_I]
		ON [dbo].[Invoice] ([Type],[InvAmt])
		INCLUDE ([InvoiceID],[ParentInvoiceID])
			with (FILLFACTOR=100, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

	END
------------------------------------
--- InvoiceDetail TABLE
------------------------------------
IF (SELECT COUNT(*) FROM #ISTALocalTables LEFT JOIN ista.dbo.sysobjects ON Name=TableName
	WHERE (DateAdd(dd, DateDiff(dd, 0, CrDate) , 0 ) < DateAdd(dd, DateDiff(dd, 0, GetDate()) , 0 ) OR CrDate IS NULL)
		AND Tablename = 'InvoiceDetail'
	) > 0 
	BEGIN
		if exists (select * from sys.tables where name = 'InvoiceDetail')
			drop table InvoiceDetail
		select * into InvoiceDetail from
		OPENQUERY("10.100.242.50", 'SELECT * FROM Billing..Invoicedetail') new

		-- Added by Hector Gomez on 2/10/2009
		/****** Object:  Index [CLFK_InvoiceID]    Script Date: 02/10/2009 15:13:27 ******/
		CREATE CLUSTERED INDEX [CLFK_InvoiceID] ON [dbo].[InvoiceDetail] 
		(
			[InvoiceID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

		/****** Object:  Index [IX_InvoiceDetail_InvDetQty]    Script Date: 02/12/2009 16:46:58 ******/
		CREATE NONCLUSTERED INDEX [IX_InvoiceDetail_InvDetQty] ON [dbo].[InvoiceDetail] 
		(
			[InvDetQty] ASC
		)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


	END

/*************/

/* code below is now executed in update_ISTA_Billing_Tables_Part3 (separate and parallel job) 


DECLARE @sqlCommand varchar(4000)
DECLARE @MaxValue Integer

----------------------------------
-- ISTA 814 TABLES
----------------------------------

/*	 
-------------------------------
-- CUSTOMERTRANSACTIONREQUEST
-------------------------------
	SELECT @MAxValue = COALESCE(MAX(RequestID),0) FROM ISTA.dbo.CustomerTransactionRequest

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.CustomerTransactionRequest( RequestID, UserID, CustID, PremID, TransactionType, ActionCode, TransactionDate, Direction, RequestDate, ServiceActionCode, ServiceAction, StatusCode, StatusReason, SourceID, TransactionNumber, ReferenceSourceID, ReferenceNumber, OriginalSourceID, ESIID, ResponseKey, AlertID, ProcessFlag, ProcessDate, EventCleared, EventValidated, DelayedEventValidated, ConditionalEventValidated, TransactionTypeID, CreateDate) ' +
						'SELECT RequestID, UserID, CustID, PremID, TransactionType, ActionCode, TransactionDate, Direction, RequestDate, ServiceActionCode, ServiceAction, StatusCode, StatusReason, SourceID, TransactionNumber, ReferenceSourceID, ReferenceNumber, OriginalSourceID, ESIID, ResponseKey, AlertID, ProcessFlag, ProcessDate, EventCleared, EventValidated, DelayedEventValidated, ConditionalEventValidated, TransactionTypeID, CreateDate ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Billing..CustomerTransactionRequest  where [RequestID] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)
	 
---------------------------------
-- tbl_814_Header
---------------------------------
	SELECT @MAxValue = COALESCE(MAX([814_Key]),0) FROM ISTA.dbo.tbl_814_Header

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Header([814_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr, TransactionSetPurposeCode, TransactionNbr, TransactionDate, ReferenceNbr, ActionCode, TdspDuns, TdspName, CrDuns, CrName, ProcessFlag, ProcessDate, Direction, TransactionTypeID, MarketID, ProviderID, POLRClass, TransactionTime, TransactionTimeCode) ' +
						'SELECT [814_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr, TransactionSetPurposeCode, TransactionNbr, TransactionDate, ReferenceNbr, ActionCode, TdspDuns, TdspName, CrDuns, CrName, ProcessFlag, ProcessDate, Direction, TransactionTypeID, MarketID, ProviderID, POLRClass, TransactionTime, TransactionTimeCode ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Header  where [814_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

---------------------------------
-- tbl_814_Name
---------------------------------
	SELECT @MAxValue = COALESCE(MAX([Name_Key]),0) FROM ISTA.dbo.tbl_814_Name

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Name(Name_Key, [814_Key], EntityIdType, EntityName, EntityName2, EntityName3, EntityDuns, EntityIdCode, Address1, Address2, City, State, PostalCode, CountryCode, ContactCode, ContactName, ContactPhoneNbr1, ContactPhoneNbr2, ContactPhoneNbr3, EntityFirstName, EntityLastName, CustType) ' +
						'SELECT Name_Key, [814_Key], EntityIdType, EntityName, EntityName2, EntityName3, EntityDuns, EntityIdCode, Address1, Address2, City, State, PostalCode, CountryCode, ContactCode, ContactName, ContactPhoneNbr1, ContactPhoneNbr2, ContactPhoneNbr3, EntityFirstName, EntityLastName, CustType ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Name  where [Name_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

---------------------------------
-- tbl_814_Service
---------------------------------
	SELECT @MAxValue = COALESCE(MAX([Service_Key]),0) FROM ISTA.dbo.tbl_814_Service
	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Service(Service_Key, [814_Key], AssignId, ServiceTypeCode1, ServiceType1, ServiceTypeCode2, ServiceType2, ServiceTypeCode3, ServiceType3, ServiceTypeCode4, ServiceType4, ActionCode, MaintenanceTypeCode, DistributionLossFactorCode, PremiseType, BillType, BillCalculator, EsiId, StationId, SpecialNeedsIndicator, PowerRegion, EnergizedFlag, EsiIdStartDate, EsiIdEndDate, EsiIdEligibilityDate, NotificationWaiver, SpecialReadSwitchDate, PriorityCode, PermitIndicator, RTODate, RTOTime, CSAFlag, MembershipID, ESPAccountNumber, LDCBillingCycle, LDCBudgetBillingCycle, WaterHeaters, LDCBudgetBillingStatus, PaymentArrangement, NextMeterReadDate, ParticipatingInterest, EligibleLoadPercentage, TaxExemptionPercent, CapacityObligation, TransmissionObligation, TotalKWHHistory, NumberOfMonthsHistory, PeakDemandHistory, AirConditioners, PreviousEsiId, GasPoolId, LBMPZone, ResidentialTaxPortion, ESPCommodityPrice, ESPFixedCharge, ESPChargesCommTaxRate, ESPChargesResTaxRate, GasSupplyServiceOption, FundsAuthorization, BudgetBillingStatus, FixedMonthlyCharge, TaxRate, CommodityPrice, MeterCycleCodeDesc, BillCycleCodeDesc, FeeApprovedApplied, MarketerCustomerAccountNumber, GasSupplyServiceOptionCode, HumanNeeds, ReinstatementDate, MeterCycleCode, SystemNumber, StateLicenseNumber, SupplementalAccountNumber, NewCustomerIndicator, PaymentCategory, PreviousESPAccountNumber, RenewableEnergyIndicator, SICCode, ApprovalCodeIndicator, RenewableEnergyCertification, NewPremiseIndicator, SalesResponsibility, CustomerReferenceNumber, TransactionReferenceNumber, ESPTransactionNumber, OldESPAccountNumber, DFIIdentificationNumber, DFIAccountNumber, DFIIndicator1, DFIIndicator2, DFIQualifier, DFIRoutingNumber) ' +
						'SELECT Service_Key, [814_Key], AssignId, ServiceTypeCode1, ServiceType1, ServiceTypeCode2, ServiceType2, ServiceTypeCode3, ServiceType3, ServiceTypeCode4, ServiceType4, ActionCode, MaintenanceTypeCode, DistributionLossFactorCode, PremiseType, BillType, BillCalculator, EsiId, StationId, SpecialNeedsIndicator, PowerRegion, EnergizedFlag, EsiIdStartDate, EsiIdEndDate, EsiIdEligibilityDate, NotificationWaiver, SpecialReadSwitchDate, PriorityCode, PermitIndicator, RTODate, RTOTime, CSAFlag, MembershipID, ESPAccountNumber, LDCBillingCycle, LDCBudgetBillingCycle, WaterHeaters, LDCBudgetBillingStatus, PaymentArrangement, NextMeterReadDate, ParticipatingInterest, EligibleLoadPercentage, TaxExemptionPercent, CapacityObligation, TransmissionObligation, TotalKWHHistory, NumberOfMonthsHistory, PeakDemandHistory, AirConditioners, PreviousEsiId, GasPoolId, LBMPZone, ResidentialTaxPortion, ESPCommodityPrice, ESPFixedCharge, ESPChargesCommTaxRate, ESPChargesResTaxRate, GasSupplyServiceOption, FundsAuthorization, BudgetBillingStatus, FixedMonthlyCharge, TaxRate, CommodityPrice, MeterCycleCodeDesc, BillCycleCodeDesc, FeeApprovedApplied, MarketerCustomerAccountNumber, GasSupplyServiceOptionCode, HumanNeeds, ReinstatementDate, MeterCycleCode, SystemNumber, StateLicenseNumber, SupplementalAccountNumber, NewCustomerIndicator, PaymentCategory, PreviousESPAccountNumber, RenewableEnergyIndicator, SICCode, ApprovalCodeIndicator, RenewableEnergyCertification, NewPremiseIndicator, SalesResponsibility, CustomerReferenceNumber, TransactionReferenceNumber, ESPTransactionNumber, OldESPAccountNumber, DFIIdentificationNumber, DFIAccountNumber, DFIIndicator1, DFIIndicator2, DFIQualifier, DFIRoutingNumber ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Service  where [Service_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

---------------------------------
-- tbl_814_Service_Account_Change
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(Change_Key),0) FROM ISTA.dbo.tbl_814_Service_Account_Change
	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Service_Account_Change(Change_Key, Service_Key, ChangeReason, ChangeDescription) ' +
						'SELECT Change_Key, Service_Key, ChangeReason, ChangeDescription ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Service_Account_Change  where [Change_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)


---------------------------------
-- tbl_814_Service_Meter
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(Meter_Key),0) FROM ISTA.dbo.tbl_814_Service_Meter
	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Service_Meter(Meter_Key, Service_Key, EntityIdCode, MeterNumber, MeterCode, MeterType, LoadProfile, RateClass, RateSubClass, MeterCycle, MeterCycleDayOfMonth, SpecialNeedsIndicator, OldMeterNumber, MeterOwnerIndicator, EntityType, TimeOFUse, ESPRateCode, OrganizationName, FirstName, MiddleName, NamePrefix, NameSuffix, IdentificationCode, EntityName2, EntityName3, Address1, Address2, City, State, Zip, CountryCode, County, PlanNumber, ServicesReferenceNumber, AffiliationNumber, CostElement, CoverageCode, LossReportNumber, GeographicNumber, ItemNumber, LocationNumber, PriceListNumber, ProductType, QualityInspectionArea, ShipperCarOrderNumber, StandardPointLocation, ReportIdentification, Supplier, Area, CollectorIdentification, VendorAgentNumber, VendorAbbreviation, VendorIdNumber, VendorOrderNumber, PricingStructureCode) ' +
						'SELECT Meter_Key, Service_Key, EntityIdCode, MeterNumber, MeterCode, MeterType, LoadProfile, RateClass, RateSubClass, MeterCycle, MeterCycleDayOfMonth, SpecialNeedsIndicator, OldMeterNumber, MeterOwnerIndicator, EntityType, TimeOFUse, ESPRateCode, OrganizationName, FirstName, MiddleName, NamePrefix, NameSuffix, IdentificationCode, EntityName2, EntityName3, Address1, Address2, City, State, Zip, CountryCode, County, PlanNumber, ServicesReferenceNumber, AffiliationNumber, CostElement, CoverageCode, LossReportNumber, GeographicNumber, ItemNumber, LocationNumber, PriceListNumber, ProductType, QualityInspectionArea, ShipperCarOrderNumber, StandardPointLocation, ReportIdentification, Supplier, Area, CollectorIdentification, VendorAgentNumber, VendorAbbreviation, VendorIdNumber, VendorOrderNumber, PricingStructureCode ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Service_Meter  where [Meter_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

---------------------------------
-- tbl_814_Service_Reject
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(Reject_Key),0) FROM ISTA.dbo.tbl_814_Service_Reject
	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_814_Service_Reject(Reject_Key, Service_Key, RejectCode, RejectReason) ' +
						'SELECT Reject_Key, Service_Key, RejectCode, RejectReason ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_814_Service_Reject  where [Reject_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)

*/



















----------------------------------
-- ISTA 867 TABLES
----------------------------------


------------------
-- tbl_867_HEADER
------------------
	SELECT @MAxValue = MAX([867_key]) FROM ISTA.dbo.tbl_867_Header

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_Header([867_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr,TransactionSetPurposeCode, TransactionNbr, TransactionDate, ReportTypeCode, ActionCode, ReferenceNbr, DocumentDueDate, EsiId, PowerRegion, OriginalTransactionNbr, TdspDuns, TdspName, CrDuns, CrName, CTRProcessFlag, ProcessFlag, ProcessDate, Direction, UtilityAccountNumber, TransactionTypeID, MarketID, ProviderID, PreviousUtilityAccountNumber ) ' +
						'SELECT [867_Key], MarketFileId, TransactionSetId, TransactionSetControlNbr, TransactionSetPurposeCode,' +
						'TransactionNbr, TransactionDate, ReportTypeCode, ActionCode, ReferenceNbr, DocumentDueDate, EsiId, PowerRegion,' +
						'OriginalTransactionNbr, TdspDuns, TdspName, CrDuns, CrName, CTRProcessFlag, ProcessFlag, ProcessDate, Direction,' +
						'UtilityAccountNumber, TransactionTypeID, MarketID, ProviderID, PreviousUtilityAccountNumber  FROM OPENQUERY("10.100.242.50",' + '''' + 'SELECT * FROM Market..tbl_867_Header where [867_key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'
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

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalSummary(NonIntervalSummary_Key, [867_Key], TypeCode, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, ActualSwitchDate, SequenceNumber, ServiceIndicator) ' +
						'SELECT NonIntervalSummary_Key, [867_Key], TypeCode, MeterUOM, MeterInterval, CommodityCode, NumberOfDials, ServicePointId, UtilityRateServiceClass, RateSubClass, ActualSwitchDate, SequenceNumber, ServiceIndicator ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalSummary  where [NonIntervalSummary_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)


---------------------------------
-- tbl_867_NonIntervalSummary_Qty
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(NonIntervalSummaryQty_Key),0) FROM ISTA.dbo.tbl_867_NonIntervalSummary_Qty

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_NonIntervalSummary_Qty(NonIntervalSummaryQty_Key, NonIntervalSummary_Key, Qualifier, Quantity, MeasurementSignificanceCode, ServicePeriodStart, ServicePeriodEnd, RangeMin, RangeMax, ThermFactor, DegreeDayFactor, CompositeUOM, MeterMultiplier) ' +
						'SELECT NonIntervalSummaryQty_Key, NonIntervalSummary_Key, Qualifier, Quantity, MeasurementSignificanceCode, ServicePeriodStart, ServicePeriodEnd, RangeMin, RangeMax, ThermFactor, DegreeDayFactor, CompositeUOM, MeterMultiplier ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_NonIntervalSummary_Qty  where [NonIntervalSummaryQty_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)
	
	

---------------------------------
-- tbl_867_ScheduleDeterminants
---------------------------------
	SELECT @MAxValue = COALESCE(MAX(ScheduleDeterminants_Key),0) FROM ISTA.dbo.tbl_867_ScheduleDeterminants

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_ScheduleDeterminants(ScheduleDeterminants_Key, [867_Key], Capacity_Obligation, Transmission_Obligation, Load_Profile, LDC_Rate_Class, Zone) ' +
						'SELECT ScheduleDeterminants_Key, [867_Key], Capacity_Obligation, Transmission_Obligation, Load_Profile, LDC_Rate_Class, Zone ' +
						'FROM OPENQUERY("10.100.242.50", ' + '''' + 'SELECT * FROM Market..tbl_867_ScheduleDeterminants  where [ScheduleDeterminants_Key] > ' + CAST(@MaxValue as varchar(10)) + '''' + ')'

	Exec (@SQLCommand)	

---------------------------------
-- dbo.tbl_867_UnmeterDetail
---------------------------------
	SELECT @MAxValue = MAX(UnmeterDetail_Key) FROM ISTA.dbo.tbl_867_UnmeterDetail

	SET @sqlCommand = 'INSERT INTO ISTA.dbo.tbl_867_UnmeterDetail(UnmeterDetail_Key, UnmeterSummary_Key, [867_Key], TypeCode, ServicePeriodStart, ServicePeriodEnd, ServiceType, Description, CommodityCode, UtilityRateServiceClass, RateSubClass) ' +
						'SELECT UnmeterDetail_Key, UnmeterSummary_Key, [867_Key], TypeCode, ServicePeriodStart, ServicePeriodEnd, ServiceType, Description, CommodityCode, UtilityRateServiceClass, RateSubClass ' +
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


*/




END




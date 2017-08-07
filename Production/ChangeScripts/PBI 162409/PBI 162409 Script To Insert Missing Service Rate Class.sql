

USE Lp_UtilityManagement
go

SET NOCOUNT ON
BEGIN TRY
	BEGIN TRAN

	DECLARE @Loop			INT
		,@MaxLoop			INT
		,@UtilityCode		VARCHAR(15)
		,@ServiceClass		VARCHAR(100)
		,@POR				VARCHAR(10)
		,@AccountTypeID		UNIQUEIDENTIFIER
		,@IDRateClass		UNIQUEIDENTIFIER
		,@IDLPRateClass		UNIQUEIDENTIFIER
		,@Result			INT
		,@User				VARCHAR(20)
		,@Inactive			BIT
		,@AccountType		NVARCHAR(255)

	/* CREATE TEMP TABLES */
	IF OBJECT_ID ('TEMPDB..#Result') IS NOT NULL
		DROP TABLE #Result

	CREATE TABLE #Result (Result INT) 

	IF OBJECT_ID ('TEMPDB..#LOOPINSERT') IS NOT NULL
		DROP TABLE #LOOPINSERT

	CREATE TABLE #LOOPINSERT (ID				INT IDENTITY(1,1) PRIMARY KEY
							,UtilityCode		VARCHAR(15)
							,ServiceClass		VARCHAR(100)
							,POR				VARCHAR(10)
							,AccountType		VARCHAR(250)) 

	IF OBJECT_ID('TEMPDB..#TempRateClass') IS NOT NULL
		DROP TABLE #TempRateClass

	CREATE TABLE #TempRateClass (UtilityCode	VARCHAR(15)
					,ServiceClass				VARCHAR(100)
					,Descp						VARCHAR(100)
					,POR						VARCHAR(10)
					,AccountType				VARCHAR(250)
					,Active						VARCHAR(20))

	IF OBJECT_ID('TEMPDB..#TempPOR') IS NOT NULL
		DROP TABLE #TempPOR

	CREATE TABLE #TempPOR (UtilityCode	VARCHAR(15)
					,ServiceClass				VARCHAR(100)
					,Descp						VARCHAR(100)
					,POR						VARCHAR(10)
					,AccountType				VARCHAR(250)
					,Active						VARCHAR(20))

	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '820', '820', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '829', '829', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '830', '830', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '855', '855', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '857', '857', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '903', '903', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '904', '904', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '905', '905', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '906', '906', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '907', '907', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPCE', '911', '911', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPNO', '836', '836', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPNO', '820', '820', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AEPNO', '829', '829', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AMEREN', 'DS5U', 'DS5U', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AMEREN', 'T', 'T', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'AMEREN', 'Rate 1M Res Elect Service - RSC', 'Rate 1M Res Elect Service - RSC', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '150', '150', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '156', '156', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', 'G', 'G', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '142', '142', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '166', '166', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '144', '144', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '165', '165', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', 'R', 'R', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '155', '155', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '167', '167', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', 'GL', 'GL', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '152', '152', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'BGE', '140', '140', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CENHUD', '1', '1', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CENHUD', '2', '2', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '030', '030', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '005', '005', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', 'E', 'E', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '037', '037', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '116', '116', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '040', '040', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', 'D', 'D', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '001', '001', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CL&P', '018', '018', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '213', '213', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '242', '242', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '310', '310', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '200', '200', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '210', '210', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '203', '203', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '530', '530', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CMP', '316', '316', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'COMED', 'x1.', 'x1.', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'COMED', 'R25', 'R25', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '901', '901', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '51', '51', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '1', '1', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '9', '9', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '2', '2', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '116', '116', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '921', '921', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', '7', '7', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CONED', 'Residential', 'Residential', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CSP', '830', '830', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CTPEN', 'RESIDENTIAL', 'RESIDENTIAL', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CTPEN', 'UNMETERED', 'UNMETERED', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CTPEN', 'COMMERCIAL UNDER 10 KVA', 'COMMERCIAL UNDER 10 KVA', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CTPEN', 'COMMERCIAL OVER 10 KVA 01', 'COMMERCIAL OVER 10 KVA 01', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'CTPEN', 'COMMERCIAL OVER 10 KVA', 'COMMERCIAL OVER 10 KVA', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'DUKE', 'RSLI', 'RSLI', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'JCP&L', 'RSNH', 'RSNH', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'METED', 'RSNH', 'RSNH', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NIMO', 'SC2', 'SC2', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NIMO', '1SC1C', '1SC1C', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NIMO', 'SC1', 'SC1', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NIMO', 'SC3', 'SC3', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NIMO', 'SC2D', 'SC2D', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NSTAR-BOS', 'E', 'E', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0600D00', 'NED0600D00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0800E00', 'NED0800E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0100E00', 'NED0100E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0800D00', 'NED0800D00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0200E00', 'NED0200E00', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0100D00', 'NED0100D00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED0600E00', 'NED0600E00', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'NYSEG', 'NED05L0D00', 'NED05L0D00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'O&R', '301', '301', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'OHP', '850', '850', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '66', '66', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', 'Comm', 'Comm', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '06', '06', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '05', '05', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '01', '01', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '17', '17', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '00', '00', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '62', '62', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', '70', '70', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'ONCOR', 'MV', 'MV', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PECO', 'R', 'R', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PENELEC', 'WV_RT__01D', 'WV_RT__01D', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PENELEC', 'PN-STLTD', 'PN-STLTD', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-DC', '153', '153', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-DC', '150', '150', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-DC', '170', '170', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-DC', '180', '180', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-MD', '350', '350', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-MD', '250', '250', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-MD', '270', '270', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'PEPCO-MD', '370', '370', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0700E00', 'RED0700E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0100V00', 'RED0100V00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0410E00', 'RED0410E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0100E00', 'RED0100E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0200E00', 'RED0200E00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'RGE', 'RED0420V00', 'RED0420V00', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'UGI', 'GS4', 'GS4', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'UGI', 'SOL', 'SOL', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'UGI', 'LP', 'LP', 'Commercial', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'UI', 'R', 'R', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'WMECO', 'E', 'E', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'WPP', 'RSNH', 'RSNH', 'Residential', 'FALSE'
	INSERT INTO #TempRateClass (UtilityCode, ServiceClass, Descp , AccountType, Active) SELECT 'WPP', 'WP-GS20D', 'WP-GS20D', 'Commercial', 'FALSE'


	
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '820', 'FALSE', 'Commercial'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '829', 'FALSE', 'Residential'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '830', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '903', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '911', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '904', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '857', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '906', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '905', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '907', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPCE', '855', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPNO', '836', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPNO', '820', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AEPNO', '829', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AMEREN', 'DS5U', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AMEREN', 'T', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'AMEREN', 'Rate 1M Res Elect Service - RSC', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '150', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '156', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', 'G', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '142', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '166', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '144', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '165', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', 'R', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '155', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '167', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', 'GL', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '152', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'BGE', '140', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CENHUD', '1', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CENHUD', '2', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '30', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '5', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', 'E', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '37', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '116', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '40', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', 'D', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '1', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '18', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CL&P', '1', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '213', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '242', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '310', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '200', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '210', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '203', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '530', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CMP', '316', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'COMED', 'x1.', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'COMED', 'R25', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '901', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '51', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '1', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '9', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '2', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '116', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '921', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', '7', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CONED', 'Residential', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CSP', '830', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CTPEN', 'RESIDENTIAL', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CTPEN', 'UNMETERED', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CTPEN', 'COMMERCIAL UNDER 10 KVA', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CTPEN', 'COMMERCIAL OVER 10 KVA 01', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'CTPEN', 'COMMERCIAL OVER 10 KVA', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'DUKE', 'RSLI', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'JCP&L', 'RSNH', 'TRUE', 'Undetermined'
	--INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'MECO', 'R2A', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'METED', 'RSNH', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NIMO', 'SC2', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NIMO', '1SC1C', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NIMO', 'SC1', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NIMO', 'SC3', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NIMO', 'SC2D', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NSTAR-BOS', 'E', 'TRUE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0600D00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0800E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0100E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0800D00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0200E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0100D00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED0600E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'NYSEG', 'NED05L0D00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'O&R', '301', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'OHP', '850', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '66', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', 'Comm', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '6', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '5', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '1', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '17', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '0', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '62', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', '70', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'ONCOR', 'MV', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PECO', 'R', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PENELEC', 'WV_RT__01D', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PENELEC', 'PN-STLTD', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-DC', '153', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-DC', '150', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-DC', '170', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-DC', '180', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-MD', '350', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-MD', '250', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-MD', '270', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'PEPCO-MD', '370', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0700E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0100V00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0410E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0100E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0200E00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'RGE', 'RED0420V00', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'UGI', 'GS4', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'UGI', 'SOL', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'UGI', 'LP', 'FALSE', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'UI', 'R', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'WMECO', 'E', 'YES', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'WPP', 'RSNH', '', 'Undetermined'
	INSERT INTO #TempPOR (UtilityCode, ServiceClass, POR , AccountType) SELECT 'WPP', 'WP-GS20D', 'YES', 'Undetermined'

	UPDATE #TempRateClass
	SET POR	= BB.POR
	FROM #TempRateClass AA 
	INNER JOIN #TempPOR BB WITH (NOLOCK)
	ON BB.UtilityCode		= AA.UtilityCode
	AND BB.ServiceClass		= AA.ServiceClass

	/* FILTER TO INSERT ONLY NEW RATECLAS */
	INSERT INTO #LOOPINSERT (UtilityCode, ServiceClass, POR, AccountType)
	SELECT AA.UtilityCode
		,AA.ServiceClass
		,AA.POR
		,AA.AccountType 
	FROM #TempRateClass AA WITH (NOLOCK)
	WHERE NOT EXISTS (	SELECT 1 
						FROM [Lp_UtilityManagement].[dbo].[RateClass] RC WITH (NOLOCK)
						INNER JOIN [Lp_UtilityManagement].[dbo].[UtilityCompany] UT WITH (NOLOCK)
						ON UT.Id				= RC.UtilityCompanyId
						INNER JOIN [Lp_UtilityManagement].[dbo].[LpStandardRateClass] LP WITH (NOLOCK)
						ON LP.Id					= RC.LpStandardRateClassId
						AND lp.UtilityCompanyId		= RC.UtilityCompanyId
						LEFT JOIN #TempRateClass TT WITH (NOLOCK)
						ON TT.UtilityCode			= UT.UtilityCode
						AND TT.ServiceClass			= RC.RateClassCode
						WHERE UT.UtilityCode		= AA.UtilityCode
						AND RC.RateClassCode		= AA.ServiceClass)
	ORDER BY AA.UtilityCode, AA.ServiceClass

	SELECT @Loop			= 1
		,@User				= 'InsertScript'
		,@Inactive			= 0
		,@MaxLoop			= MAX(ID)
	FROM #LOOPINSERT WITH (NOLOCK)

	WHILE @Loop <= @MaxLoop
	BEGIN

		SELECT @UtilityCode = AA.UtilityCode
			,@ServiceClass	= AA.ServiceClass
			,@POR			= AA.POR
			,@AccountType	= AA.AccountType
		FROM #LOOPINSERT AA WITH (NOLOCK)
		WHERE AA.ID	= @Loop


		SELECT AA.*
		FROM #LOOPINSERT AA WITH (NOLOCK)
		WHERE AA.ID	= @Loop

		
		SELECT @IDLPRateClass = AA.Id
		FROM [Lp_UtilityManagement].[dbo].[LpStandardRateClass] AA WITH (NOLOCK)
		INNER JOIN [Lp_UtilityManagement].[dbo].[UtilityCompany] UT WITH (NOLOCK)
		ON UT.Id						= AA.UtilityCompanyId
		WHERE UT.UtilityCode			= @UtilityCode
		AND AA.LpStandardRateClassCode	= @ServiceClass

		IF @@ROWCOUNT = 0
		BEGIN
			/* Create a LpStandardRateClass Row */
			SET @IDLPRateClass = NEWID()

			DELETE FROM #Result
			INSERT INTO #Result
			EXEC [Lp_UtilityManagement].[dbo].[usp_LpStandardRateClass_UPSERT]
				@IDLPRateClass 
				,@ServiceClass
				,@UtilityCode
				,@Inactive
				,@User

			IF(SELECT RESULT FROM #Result) <> 1
				RAISERROR (50001, 1, 1, 'Error inserted the LpStandardRateClass')

		END

		SET @IDRateClass	= NEWID()

		DELETE FROM #Result
		INSERT INTO #Result
		EXEC [Lp_UtilityManagement].[dbo].[usp_RateClass_UPSERT]
				@IDRateClass,
				@UtilityCode,
				@ServiceClass,
				@ServiceClass,
				@ServiceClass,
				@AccountType,
				@Inactive,
				@User 

		IF(SELECT RESULT FROM #Result) = 1
			PRINT (@UtilityCode + '/' + @ServiceClass + '/' + @POR + 'INSERTED')
		

		SET @Loop = @Loop + 1
	END
	COMMIT TRAN
	PRINT 'COMMIT'
END TRY
BEGIN CATCH
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage; 
	ROLLBACK TRAN
	PRINT 'ROLLBACK'
END CATCH

IF OBJECT_ID ('TEMPDB..#Result') IS NOT NULL
	DROP TABLE #Result

IF OBJECT_ID ('TEMPDB..#LOOPINSERT') IS NOT NULL
	DROP TABLE #LOOPINSERT

IF OBJECT_ID('TEMPDB..#TempRateClass') IS NOT NULL
	DROP TABLE #TempRateClass

SET NOCOUNT OFF



Use WORKSPACE
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * USP_TCAPEffectiveDate_DataCorrection
 * Update the TcapEffectivedate for all the Utilities corresponding Accounts having the valied Tcap Value 
 * but the TcapEffectivedate is Null 
 *******************************************************************************
 * 07/19/2016 - Srikanth B
 * Created.
 *******************************************************************************
 */
 /*
 DECLARE       @return_value int

EXEC   @return_value = [dbo].[USP_TCAPEffectiveDate_DataCorrection]

SELECT 'Return Value' = @return_value
*/

 CREATE PROCEDURE USP_TCAPEffectiveDate_DataCorrection
 AS
 BEGIN
 SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

Declare @dateref datetime
IF Month(Getdate()) IN(01,02,03,04,05,06,07,08,09,10,11)
set @dateref=cast(Year(Getdate()) as varchar(10))+'01'+'01'
else IF Month(Getdate()) IN(12)
set @dateref=cast(Year(Getdate())+1 as varchar(10))+'01'+'01'
--select @dateref



--NY MARKET utility 'CONED','NIMO','NYSEG','CENHUD','RGE','O&R')
Update a
set a.TcapEffectiveDate= @dateref
from lp_transactions..EdiAccount a(nolock)
where a.UtilityCode IN('CONED','NIMO','NYSEG','CENHUD','RGE','O&R')
and cast(a.TransactionCreationDate as date) >=@dateref
and a.Tcap is not null 
and a.Tcap<>'-1.000000'
and a.TcapEffectiveDate<>@dateref
and (a.TcapEffectiveDate is null or a.TcapEffectiveDate='1980-01-01 00:00:00.000')

--PSEG Utility
Update a
set a.TcapEffectiveDate= @dateref
from lp_transactions..EdiAccount a(nolock)
where a.UtilityCode='PSEG'
and cast(a.TransactionCreationDate as date) >=@dateref
and a.Tcap is not null 
and a.Tcap<>'-1.000000'
and a.TcapEffectiveDate<>@dateref
and (a.TcapEffectiveDate is null or a.TcapEffectiveDate='1980-01-01 00:00:00.000')




Update a
set a.TcapEffectiveDate=@dateref
from lp_transactions..EdiAccount a(nolock)
where 1=1 
and cast(a.TransactionCreationDate as date) >=@dateref
and a.Tcap is not null 
and a.Tcap<>'-1.000000'
and a.TcapEffectiveDate<>@dateref
and (a.TcapEffectiveDate is null or a.TcapEffectiveDate='1980-01-01 00:00:00.000')
and a.UtilityCode IN(
'ACE',
'AEPCE',
'AEPNO',
'ALLEGMD',
'AMEREN',
'BANGOR',
'BGE',
'CEI',
'CL&P',
'CMP',
'COMED',
'CSP',
'CTPEN',
'DAYTON',
'DELDE',
'DELMD',
'DUKE',
'DUQ',
'JCP&L',
'MECO',
'METED',
'NANT',
'NECO',
'NSTAR-BOS',
'NSTAR-CAMB',
'NSTAR-COMM',
'OHED',
'OHP',
'ONCOR',
'ONCOR-SESCO',
'ORNJ',
'PECO',
'PENELEC',
'PENNPR',
'PEPCO-DC',
'PEPCO-MD',
'PGE',
'PPL',
'ROCKLAND',
'SCE',
'SDGE',
'SHARYLAND',
'TOLED',
'TXNMP',
'TXU',
'TXU-SESCO',
'UGI',
'UI',
'UNITIL',
'WMECO',
'WPP')


COMMIT TRANSACTION;
END TRY
	BEGIN CATCH
		IF @@Trancount >0
		ROLLBACK TRANSACTION;
		SELECT ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	SET NOCOUNT OFF;
END
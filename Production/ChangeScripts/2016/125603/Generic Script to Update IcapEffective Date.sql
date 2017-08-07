


Use WORKSPACE
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * USP_ICAPEffectiveDate_DataCorrection
 * Update the IcapEffectivedate for all the Utilities corresponding Accounts having the valied Icap Value 
 * but the IcapEffectivedate is Null 
 *******************************************************************************
 * 06/15/2016 - Srikanth B
 * Created.
 *******************************************************************************
 */
 /*
 DECLARE       @return_value int

EXEC   @return_value = [dbo].[USP_ICAPEffectiveDate_DataCorrection]

SELECT 'Return Value' = @return_value
*/

 CREATE PROCEDURE USP_ICAPEffectiveDate_DataCorrection
 AS
 BEGIN
 SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

Declare @Junedateref datetime
IF Month(Getdate()) IN(06,07,08,09,10,11,12)
set @Junedateref=cast(Year(Getdate()) as varchar(10))+'06'+'01'
else IF Month(Getdate()) IN(01,02,03,04,05)
set @Junedateref=cast(Year(Getdate())-1 as varchar(10))+'06'+'01'



Declare @Maydateref datetime
IF Month(Getdate()) IN(05,06,07,08,09,10,11,12)
set @Maydateref=cast(Year(Getdate()) as varchar(10))+'05'+'01'
else IF Month(Getdate()) IN(01,02,03,04)
set @Maydateref=cast(Year(Getdate())-1 as varchar(10))+'05'+'01'



Declare @PSEGdateref datetime
IF Month(Getdate()) IN(06,07,08,09)
set @PSEGdateref=cast(Year(Getdate()) as varchar(10))+'06'+'01'
else IF Month(Getdate()) IN(10,11,12)  
set @PSEGdateref=cast(Year(Getdate()) as varchar(10))+'10'+'01'
else IF Month(Getdate()) IN(01,02,03,04,05) 
set @PSEGdateref=cast(Year(Getdate()) as varchar(10))+'01'+'01'
--select @PSEGdateref

--NY MARKET utility 'CONED','NIMO','NYSEG','CENHUD','RGE','O&R')
Update a
set a.IcapEffectiveDate= @Maydateref
from lp_transactions..EdiAccount a(nolock)
where a.UtilityCode IN('CONED','NIMO','NYSEG','CENHUD','RGE','O&R')
and cast(a.TransactionCreationDate as date) >=@Maydateref
and a.Icap is not null 
and a.Icap<>'-1.000000'
and a.icapeffectivedate<>@Maydateref
and (a.IcapEffectiveDate is null or a.IcapEffectiveDate='1980-01-01 00:00:00.000')

--PSEG Utility
Update a
set a.IcapEffectiveDate= @PSEGdateref
from lp_transactions..EdiAccount a(nolock)
where a.UtilityCode='PSEG'
and cast(a.TransactionCreationDate as date) >=@PSEGdateref
and a.Icap is not null 
and a.Icap<>'-1.000000'
and a.icapeffectivedate<>@PSEGdateref
and (a.IcapEffectiveDate is null or a.IcapEffectiveDate='1980-01-01 00:00:00.000')




Update a
set a.icapEffectivedate=@Junedateref
from lp_transactions..EdiAccount a(nolock)
where 1=1 
and cast(a.TransactionCreationDate as date) >=@Junedateref
and a.Icap is not null 
and a.Icap<>'-1.000000'
and a.icapeffectivedate<>@Junedateref
and (a.IcapEffectiveDate is null or a.IcapEffectiveDate='1980-01-01 00:00:00.000')
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
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Truncate]    Script Date: 6/20/2014 4:29:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_Truncate
 * Truncate tables before running the Enrollment process and EDI Process.
 *  
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_Truncate]
as

set nocount on

truncate table dbo.RECONEDI_EnrollmentFixed
truncate table dbo.RECONEDI_EnrollmentVariable

truncate table dbo.RECONEDI_MTM

truncate table dbo.RECONEDI_ISOControl

truncate table dbo.RECONEDI_EDI
truncate table dbo.RECONEDI_EDIPending
truncate table dbo.RECONEDI_AccountChangePending
truncate table dbo.RECONEDI_EDIResult

truncate table dbo.RECONEDI_ForecastDates
truncate table dbo.RECONEDI_ForecastDaily
truncate table dbo.RECONEDI_ForecastWholesale
truncate table dbo.RECONEDI_ForecastWholesaleError

truncate table dbo.RECONEDI_Filter
truncate table dbo.RECONEDI_Tracking
truncate table dbo.RECONEDI_Header

truncate table dbo.RECONEDI_EDIAccounts
truncate table dbo.RECONEDI_EDIVolume

truncate table dbo.RECONEDI_MTMAccounts
truncate table dbo.RECONEDI_MTMVolume

set nocount off
GO

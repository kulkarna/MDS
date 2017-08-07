
-- =============================================
-- Author:		  Isabelle Tamanini
-- Modified date: 04/25/2010
-- Description:	Records accounts that needed date 
-- adjustments to be send to ISTA
-- =============================================

CREATE PROCEDURE [dbo].[usp_AccountDateErrorLogInsert]   
(                                                                                 
	@AccountID			 char(12),
	@RateChangeType		 char(12),
	@IntendedStartDate	 datetime,
	@ActualStartDate	 datetime
)
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	AccountDateErrorLog ( AccountId, RateChangeType, IntendedStartDate, ActualStartDate)
	VALUES		(@AccountID, @RateChangeType, @IntendedStartDate, @ActualStartDate)

    SET NOCOUNT OFF;
END                           


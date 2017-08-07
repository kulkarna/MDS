USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 12/30/2013
-- Description:	This trigger was created as a temporary
-- solution for the CustomDealUpload accounts that are being
-- entered as addon on renewals
-- Add where clause for the inserted query
--And if exists for update query
-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateCurrentRenewalContractId]
   ON  [dbo].[Account]
   AFTER UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	IF UPDATE(CurrentRenewalContractId)
	BEGIN
	
		DECLARE @w_AccountID INT;
		DECLARE @w_CurrentRenewalContractID INT;
		
		SELECT @w_AccountID = AccountId, 
			   @w_CurrentRenewalContractID = CurrentRenewalContractId
		FROM inserted where Origin = 'CustomDealUpload'
		AND CurrentContractID IS NULL ;	
		
		if (@w_AccountID>0)
		Begin
		    UPDATE  LibertyPower.dbo.Account 
		    SET CurrentContractID = @w_CurrentRenewalContractID
		    WHERE AccountId = @w_AccountID
		    AND Origin = 'CustomDealUpload'
		    AND CurrentContractID IS NULL
		End		
    
    END
    
    SET NOCOUNT OFF;
    
END
GO

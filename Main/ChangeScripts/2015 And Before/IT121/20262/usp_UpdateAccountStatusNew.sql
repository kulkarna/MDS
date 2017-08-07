use Libertypower
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------------------
-- Created 9/1/2013
-- Diogo Lima
-- IT121 - Update account status in new schema.
-----------------------------------------------------------------------------------------

CREATE PROCEDURE usp_UpdateAccountStatusNew
(
@LegacyAccountID varchar(12),
@Status varchar(20),
@SubStatus varchar(20)
)
as
SET NOCOUNT ON 

DECLARE @w_AccountContractStatus int;
DECLARE @w_ReasonRejected int = null;
DECLARE @w_EdiType int;
DECLARE @w_EdiStatus int = null;
 
IF @Status + @SubStatus	= '0100010' 
BEGIN
	SELECT @w_AccountContractStatus = 1
	SELECT @w_EdiType = 1  
	
END
ELSE IF @Status + @SubStatus	= '0500010'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 1
END
ELSE IF @Status + @SubStatus	= '0500020'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 2
END
ELSE IF @Status + @SubStatus	= '0500025'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1	
	SELECT @w_EdiStatus = 4
END
ELSE IF @Status + @SubStatus	= '0500030'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 3
END
ELSE IF @Status + @SubStatus	= '90500010' 
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 3
END 
ELSE IF @Status + @SubStatus	= '1100030'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 2
	SELECT @w_EdiStatus = 1
END
ELSE IF @Status + @SubStatus	= '1100040'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 2
	SELECT @w_EdiStatus = 2
END
ELSE IF @Status + @SubStatus	= '1100050'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 2
	SELECT @w_EdiStatus = 3
END
ELSE IF @Status + @SubStatus	= '1300060'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 1
END
ELSE IF @Status + @SubStatus	= '1300070'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 2
END
ELSE IF @Status + @SubStatus	= '1300080'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 3
END
ELSE IF @Status + @SubStatus	= '91100010'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_EdiType = 2
	SELECT @w_EdiStatus = 3
END
ELSE IF @Status + @SubStatus	= '99999810'  
BEGIN
	SELECT @w_AccountContractStatus = 2
	SELECT @w_ReasonRejected = 3
	SELECT @w_EdiType = 1
	SELECT @w_EdiStatus = 4
END
ELSE IF @Status + @SubStatus	= '99999910'  
BEGIN
	SELECT @w_AccountContractStatus = 3
	SELECT @w_ReasonRejected = 2
	SELECT @w_EdiType = 2
END
	
EXEC libertypower..usp_AccountSubmissionStatusUpdateRejected @LegacyAccountID,@w_AccountContractStatus,@w_ReasonRejected,@w_EdiType

IF @w_EdiStatus is not null
BEGIN
	EXEC libertypower..usp_AccountSubmissionStatusUpdate @LegacyAccountID, @w_EdiType,@w_EdiStatus
END

SET NOCOUNT OFF
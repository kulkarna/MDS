USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateInsert]    Script Date: 01/24/2014 10:35:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_AccountContractRateCreate]
*
* DEFINITION:  Inserts a record into AccountContractRate Table
*
* RETURN CODE: 
*
* REVISIONS:	
06/24/2011 Jaime Forero
10/12/2012 Gabor - Add @ProductCrossPriceMultiID
01/24/2014 Isabelle Tamanini - Add @IsCustomEnd
*/

ALTER PROCEDURE [dbo].[usp_AccountContractRateInsert]
     @AccountContractID INT
    ,@LegacyProductID CHAR(20) = NULL
    ,@Term	INT = NULL
	,@RateID INT = NULL
	,@Rate FLOAT = NULL
	,@RateCode VARCHAR(50)
	,@RateStart DATETIME
	,@RateEnd	DATETIME
	,@IsContractedRate BIT
	,@HeatIndexSourceID INT = NULL
	,@HeatRate DECIMAL(9,2) = NULL
	,@TransferRate FLOAT = NULL
	,@GrossMargin FLOAT = NULL
	,@CommissionRate FLOAT = NULL
	,@AdditionalGrossMargin FLOAT = NULL
	,@CreatedBy INT
	,@ModifiedBy INT
	,@IsSilent BIT = 0
	,@PriceID bigint = NULL
	,@ProductCrossPriceMultiID bigint = NULL
	,@IsCustomEnd bit = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	DECLARE @AccountContractRateID INT;
	
	INSERT INTO [LibertyPower].[dbo].[AccountContractRate]
           ( 
			 [AccountContractID]
			,[LegacyProductID]
			,[Term]
			,[RateID]
			,[Rate]
			,[RateCode]
			,[RateStart]
			,[RateEnd]
			,[IsContractedRate]
			,[HeatIndexSourceID]
			,[HeatRate]
			,[TransferRate]
			,[GrossMargin]
			,[CommissionRate]
			,[AdditionalGrossMargin]
			,[Modified]
			,[ModifiedBy]
			,[DateCreated]
			,[CreatedBy]
			,[PriceID]
			,[ProductCrossPriceMultiID]
			,[IsCustomEnd]
           )
     VALUES
           ( 
             @AccountContractID 
            ,@LegacyProductID
            ,@Term
			,@RateID 
			,@Rate 
			,@RateCode 
			,@RateStart
			,@RateEnd
			,@IsContractedRate
			,@HeatIndexSourceID 
			,@HeatRate 
			,@TransferRate 
			,@GrossMargin 
			,@CommissionRate 
			,@AdditionalGrossMargin 
			,GETDATE()
			,@ModifiedBy
			,GETDATE()
			,@CreatedBy
			,@PriceID
			,@ProductCrossPriceMultiID
			,@IsCustomEnd
            )
	;
	
	SET @AccountContractRateID  = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractRateSelect @AccountContractRateID  ;
	
	RETURN @AccountContractRateID;
	
END

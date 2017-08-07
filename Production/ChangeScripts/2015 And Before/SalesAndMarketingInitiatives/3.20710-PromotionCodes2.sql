/*********************************************************
PBI: 20710 part 2: Promotion Code in Deal Capture
Libertypower Database
1. usp_ContractQualifierSelect
2. usp_ContractQualifierInsert
3. usp_PriceTierIdGet
4. usp_PromotionCodebyCodeSelect
5. usp_PromotionCodebyIDSelect
6. usp_QualifierByPromoCodeandDeterminentsSelect
7. usp_GetAllValidQualifiersandPromoCodeforToday
************************************************************/

-------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractQualifierSelect]    Script Date: 09/26/2013 14:43:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ContractQualifierSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ContractQualifierSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractQualifierSelect]    Script Date: 09/26/2013 14:43:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 9/25/2013
-- Description:	Select Contract Qualifier Information (promotion)
-- =============================================

CREATE PROCEDURE [dbo].[usp_ContractQualifierSelect]
	@ContractQualifierID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		*
	From 
		LibertyPower.dbo.ContractQualifier with (nolock)		
	Where 
		ContractQualifierId = @ContractQualifierID
END



GO


-----------------------------------------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractQualifierInsert]    Script Date: 09/26/2013 14:19:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ContractQualifierInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ContractQualifierInsert]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractQualifierInsert]    Script Date: 09/26/2013 14:19:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 9/25/2013
-- Description:	Insert / update Contract Qualifier Information (promotion)
-- =============================================



CREATE PROCEDURE [dbo].[usp_ContractQualifierInsert]

@ContractID     int,
@AccountID     int=null,
@QualifierId     int,
@PromotionStatusId     int,
@Comment     int=null,
@CreatedBy     int,
@CreatedDate     datetime,
@ModifiedBy int,
@ModifiedDate datetime,
@IsSilent BIT =0


AS
BEGIN

SET NOCOUNT ON;

	DECLARE @ContractQualifierId INT=0;
IF NOT EXISTS
(
	SELECT	ContractQualifierId
	FROM	ContractQualifier WITH (NOLOCK)
	WHERE	ContractID		= @ContractID
	AND		QualifierId	= @QualifierId
	AND( AccountID= @AccountID or AccountId is Null)
)
	BEGIN
		INSERT INTO	ContractQualifier (ContractID, QualifierId,AccountId ,PromotionStatusId,Comment,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Values (@ContractID,@QualifierId,@AccountID,@PromotionStatusId,@Comment,@CreatedBy,@CreatedDate,@ModifiedBy, @ModifiedDate)
	   
	   SET @ContractQualifierId  = SCOPE_IDENTITY();
		
	END


	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_ContractQualifierSelect @ContractQualifierId  ;
	RETURN @ContractQualifierId;
SET NOCOUNT OFF;
END


GO


-----------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PriceTierIdGet]    Script Date: 09/26/2013 14:44:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceTierIdGet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PriceTierIdGet]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PriceTierIdGet]    Script Date: 09/26/2013 14:44:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * [usp_PriceTierIdGet]
 * Sara lakshmanan 
 * Sept 25 2013 To get the priceTierId from the priceTable based on the PriceID
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_PriceTierIdGet]  
	@PriceID					BIGINT
AS
	SELECT 
		PriceTier
	FROM [LibertyPower].[dbo].[Price] (NOLOCK)
	WHERE 
		ID = @PriceID                                                                                                                               
	
-- Copyright 2010 Liberty Power

GO


----------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyCodeSelect]    Script Date: 09/26/2013 14:45:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodebyCodeSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodebyCodeSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyCodeSelect]    Script Date: 09/26/2013 14:45:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_PromotionCodebyCodeSelect]
*
* DEFINITION:  Selects the promotionCode Details for the given promotionCode
*
* RETURN CODE: Returns the promotionCode Information for the given PromoCode
*
* REVISIONS:	Sara lakshamanan 9/23/2013
*/

Create PROCEDURE [dbo].[usp_PromotionCodebyCodeSelect]
	 @p_PromotionCode char(20)
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select P.* from  LibertyPower..PromotionCode P with (NOLock)

where
P.Code=@p_PromotionCode


Set NOCOUNT OFF;
END
         
GO


------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyIDSelect]    Script Date: 09/26/2013 14:48:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodebyIDSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodebyIDSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyIDSelect]    Script Date: 09/26/2013 14:48:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

           

/*
*
* PROCEDURE:	[usp_PromotionCodebyIDSelect]
*
* DEFINITION:  Selects the promotionCode Details for the given promotionCodeId
*
* RETURN CODE: Returns the promotionCode Information for the given PromoCodeid
*
* REVISIONS:	Sara lakshamanan 9/23/2013
*/

Create PROCEDURE [dbo].[usp_PromotionCodebyIDSelect]
	 @p_PromotionCodeId int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select P.* from  LibertyPower..PromotionCode P with (NoLock)

where
P.PromotionCodeId=@p_PromotionCodeId


Set NOCOUNT OFF;
END
        
GO


----------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 09/26/2013 16:23:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 09/26/2013 16:23:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
*
* PROCEDURE:	[usp_QualifierByPromoCodeandDeterminentsSelect]
*
* DEFINITION:  Selects the list of qualifier records that satisfy the given conditions
*
* RETURN CODE: Returns the Qualifier Information for the given PromoCode and Determinents
*
* REVISIONS:	Sara lakshamanan 9/20/2013
*/

CREATE PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
	 @p_PromotionCode char(20), @p_SignDate datetime, @p_SalesChannelId int= null, @p_MarketId int=null,
	  @p_UtilityId int = null,@p_AccountTypeId int=null,  @p_Term int=null,
 @p_ProductTypeId int=null, @p_PriceTier int=null, @p_ContractStartDate datetime=null  
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LibertyPower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId
where
Ltrim(Rtrim(P.Code))=Ltrim(Rtrim(@p_PromotionCode)) and
 Q.SignStartDate<=@p_SignDate and Q.SignEndDate>=@p_SignDate
and (Q.SalesChannelId=@p_SalesChannelId or Q.SalesChannelId is Null)
and (Q.MarketID=@p_MarketId or Q.MarketId is Null)
and (Q.UtilityId=@p_UtilityId or Q.UtilityId is Null)
and (Q.AccountTypeId=@p_AccountTypeId or Q.AccountTypeId is Null)
and (Q.Term=@p_Term or Term is Null)
and (Q.ProductTypeId=@p_ProductTypeId or Q.ProductTypeId is Null)
and (Q.PriceTierID=@p_PriceTier or Q.PriceTierID is Null)
and ((Q.ContractEffecStartPeriodStartDate<=@p_ContractStartDate and Q.ContractEffecStartPeriodLastDate>=@p_ContractStartDate)
	    or (Q.ContractEffecStartPeriodStartDate is Null and Q.ContractEffecStartPeriodLastDate is Null))


Set NOCOUNT OFF;
END
      
GO


------------------------------------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]    Script Date: 10/01/2013 10:13:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]    Script Date: 10/01/2013 10:13:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_GetAllValidQualifiersandPromoCodeforToday]
*
* DEFINITION:  Selects the list of Qualifier and PromotionCode records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information and Promotion code 
*
* REVISIONS:	Sara lakshamanan 9/30/2013
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock)
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END
      

GO


--------------------------------------------------------------------------------------
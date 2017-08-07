/*********************************************************
PBI: 20710: Promotion Code in Deal Capture
1. new Table in lp_deal_Capture Database
    ContractPromotionCode
New Procedures    
2. usp_Contract_PromotionCode_ins
3. usp_ContractIDbyContractNumber_Select
4. usp_PromotionCodebyContractIdSelect


************************************************************/

USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[ContractPromotionCode]    Script Date: 09/26/2013 13:58:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractPromotionCode]') AND type in (N'U'))
DROP TABLE [dbo].[ContractPromotionCode]
GO

USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[ContractPromotionCode]    Script Date: 09/26/2013 13:58:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ContractPromotionCode](
	[ContractPromotionCodeId] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[AccountId] [int] NULL,
	[PromotionCodeId] [int] NOT NULL,
 CONSTRAINT [PK_ContractPromotionCode] PRIMARY KEY CLUSTERED 
(
	[ContractPromotionCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--------------------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_Contract_PromotionCode_ins]    Script Date: 09/26/2013 14:08:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Contract_PromotionCode_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Contract_PromotionCode_ins]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_Contract_PromotionCode_ins]    Script Date: 09/26/2013 14:08:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 9/23/2013
-- Description:	Insert / update PromotionCode Information (promotion)
-- =============================================



CREATE PROCEDURE [dbo].[usp_Contract_PromotionCode_ins]

@p_ContractID     int,
--@p_AccountID     int,
@p_PromotionCodeId int


AS
BEGIN

SET NOCOUNT ON;
IF NOT EXISTS
(
	SELECT	PromotionCodeId
	FROM	ContractPromotionCode WITH (NOLOCK)
	WHERE	ContractID		= @p_ContractID
	AND		PromotionCodeId	= @p_PromotionCodeId
	--AND AccountID= @p_AccountID
)
	BEGIN
		INSERT INTO	ContractPromotionCode (ContractID, PromotionCodeId)
		Values (@p_ContractID,@p_PromotionCodeId)
		
	END

SET NOCOUNT OFF;
END


GO
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractIDbyContractNumber_Select]    Script Date: 09/26/2013 14:09:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ContractIDbyContractNumber_Select]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ContractIDbyContractNumber_Select]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_ContractIDbyContractNumber_Select]    Script Date: 09/26/2013 14:09:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
*
* PROCEDURE:	[usp_ContractIDbyContractNumber_Select]
*
* DEFINITION:  Get the top 1 contractId from Contract Number
*
* RETURN CODE: Returns the ContractId from Contract Number
*
* REVISIONS:	Sara lakshamanan 9/23/2013
*/

Create PROCEDURE [dbo].[usp_ContractIDbyContractNumber_Select]
	 @p_ContractNumber varchar(50)
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Top 1 C.ID from  Lp_deal_capture..deal_contract C with (NoLock)

where
C.contract_nbr=@p_ContractNumber
order BY C.ID desc


Set NOCOUNT OFF;
END

GO


----------------------------------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyContractIdSelect]    Script Date: 09/26/2013 14:11:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodebyContractIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodebyContractIdSelect]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyContractIdSelect]    Script Date: 09/26/2013 14:11:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------

/*
*
* PROCEDURE:	[usp_PromotionCodebyContractIdSelect]
*
* DEFINITION:  Selects the promotionCode Details for the given ContractId
*
* RETURN CODE: Returns the promotionCode Information for the given ContractId
*
* REVISIONS:	Sara lakshamanan 9/24/2013
*/

Create PROCEDURE [dbo].[usp_PromotionCodebyContractIdSelect]
	 @p_ContractId int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select * from  lp_deal_capture..ContractPromotionCode C  with (NoLock)  Inner Join LibertyPower..PromotionCode P with (NoLock) on C.PromotionCodeId=P.PromotionCodeId
Where 
 C.ContractId=@p_ContractId



Set NOCOUNT OFF;
END
GO


------------------------------------------------------------------------------------------------
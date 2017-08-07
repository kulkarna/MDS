USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMeterNumber]    Script Date: 07/12/2013 20:18:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMeterNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMeterNumber]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMeterNumber]    Script Date: 07/12/2013 20:18:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 07-12-2013
-- Description:	Gets meter number by account number
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMeterNumber]
	-- Add the parameters for the stored procedure here
	@p_account_number		varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT oam.METER_NUMBER  
	FROM OE_ACCOUNT_METERS oam WITH (NOLOCK)  
	JOIn OE_ACCOUNT oa WITH (NOLOCK) on oa.ID=oam.OE_Account_ID
	WHERE oa.ACCOUNT_NUMBER = @p_account_number
	
	SET NOCOUNT OFF;
END

GO



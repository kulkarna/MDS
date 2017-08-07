USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUsageSourcePriorities]    Script Date: 03/05/2014 10:56:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUsageSourcePriorities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUsageSourcePriorities]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUsageSourcePriorities]    Script Date: 03/05/2014 10:56:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 3/5/2014 10:55 AM
-- Description:	gets the priorities for all the usage sources
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetUsageSourcePriorities] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Value,Description,Priority from UsageSource (nolock)
	
	SET NOCOUNT OFF
END

GO



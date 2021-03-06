USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetUtilityCodebyUtilityId]    Script Date: 01/13/2017 12:11:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usp_GetUtilityCodebyUtilityId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Usp_GetUtilityCodebyUtilityId]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetUtilityCodebyUtilityId]    Script Date: 01/13/2017 12:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usp_GetUtilityCodebyUtilityId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Vikas Sharma>
-- Create date: <10/01/2017>
-- Description:	<Get Utlity Code by Utility Id>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_GetUtilityCodebyUtilityId]
	@UtilityId int
AS
BEGIN
	
	select lpc_UtilityCode as UtilityCode from LibertyCrm_MSCRM.dbo.lpc_utility(NOLOCK) UC
	where lpc_dc_id=@UtilityId
	
END
' 
END
GO

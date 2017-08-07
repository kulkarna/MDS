USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyInsert]    Script Date: 12/09/2013 15:47:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyInsert ************************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyInsert]
		@ISO			AS VARCHAR(50),
		@Zone			AS VARCHAR(50),
		--@ZoneAlias		AS VARCHAR(50),
		@CreatedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	SET NOCOUNT ON;
	
	INSERT	INTO MtMReportZkey 
			(
				ISO,
				Zone,
				--ZoneAlias,
				CreatedBy
			)
	VALUES	(
				@ISO,
				@Zone,
				--@ZoneAlias,
				@CreatedBy
			)	
			
	SELECT	@@IDENTITY
	
	SET NOCOUNT OFF;
END


USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************************/
 /********************************* usp_MtMReportZkeyInsert ************************************/
/**********************************************************************************************/
-- =============================================
-- Author:		
-- Create date: 
-- Description:	Create ZKeys
-- =============================================
-- Modified:	Gail Mangaroo 
-- Modified date: 5/28/2013
-- Description:	Use Iso and Location ID
-- =============================================
-- exec 
-- ============================================
ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyInsert]
		@ISOId			AS int,
		@ZainetLocationId		AS int,		
		@Year		int ,
		@BookId		int,
		@CreatedBy		AS VARCHAR(50)
		
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT	INTO MtMReportZkey 
			(
				ISOId,
				ZainetLocationId ,
				[Year],
				BookId,
				CreatedBy,
				DateCreated
			)
	VALUES	(
				@ISOId,
				@ZainetLocationId,
				@Year, 
				@BookId,
				@CreatedBy,
				GETDATE()
			)	
			
	SELECT SCOPE_IDENTITY()
	
	SET NOCOUNT OFF;
END

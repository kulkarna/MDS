USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueSelect]    Script Date: 10/14/2013 17:00:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueSelect]    Script Date: 10/14/2013 17:00:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueSelect] 
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 60 ),
	@ContextDate datetime = null
AS
BEGIN
	DECLARE @Properties XML;
	SET @Properties = '<Properties><Name>'+ISNULL(@FieldName,'')+'</Name></Properties>'
	EXEC dbo.usp_Determinants_AccountCurrentPropertiesSelect
		@UtilityID,
		@AccountNumber,
		@Properties,
		@ContextDate
END;

GO



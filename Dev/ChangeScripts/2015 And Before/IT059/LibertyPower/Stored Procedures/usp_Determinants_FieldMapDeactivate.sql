USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapDeactivate]    Script Date: 07/13/2013 14:07:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapDeactivate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapDeactivate]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapDeactivate]    Script Date: 07/13/2013 14:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapDeactivate] 
	@ID INT
AS
BEGIN

SET NOCOUNT ON
BEGIN TRANSACTION
	UPDATE DeterminantFieldMaps
	SET ExpirationDate = GETDATE()
	WHERE ID= @ID and ExpirationDate IS NULL
IF @@ERROR != 0
    ROLLBACK
ELSE
    COMMIT
SET NOCOUNT OFF;
END;

GO



USE LibertyPower
Go

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 2/14/2013
-- Description:	Get AccountTypeId By ProductAccountTypeId
-- =============================================
CREATE PROCEDURE dbo.usp_GetAccountTypeIdByProductAccountTypeId 
	@ProductAccountTypeId int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT [ID]
    FROM dbo.AccountType with (nolock)
    WHERE ProductAccountTypeId=@ProductAccountTypeId
END
GO

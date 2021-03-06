USE [lp_Market867]
GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_UsageLog]    Script Date: 2/11/2016 1:28:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Iraj Rahmani
-- Create date: 9/30/2009
-- Description:	Retreive 867 Usage
-- Modified:02/11/2016 - Increased the account number to varchar(50)
-- =============================================
ALTER PROCEDURE [dbo].[usp_Insert_UsageLog]
	@UtilityAccountNbr varchar(50),
	@Duns			varchar(30),
	@EnrollCustID      Integer,
	@Applicationname Varchar(30),
	@UserName Varchar(50)

AS
BEGIN

INSERT INTO [lp_Common].[dbo].[UsageLog](UtilityAccountNbr, Duns, ApplicationName, UserID, EnrollCustID)
VALUES (@UtilityAccountNbr, @Duns, @Applicationname, @UserName,  @EnrollCustID)
  

END

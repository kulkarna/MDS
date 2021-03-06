USE [lp_Market867]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertUsageLog]    Script Date: 2/11/2016 1:23:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Thanath
-- Create date: 07/02/2015
-- Description:	Log the Namekey for Usage Request-PBI68730
-- Modified:02/11/2016 - Increased the account number to varchar(50)
-- =============================================
ALTER PROCEDURE [dbo].[usp_InsertUsageLog]
	@UtilityAccountNbr varchar(50),
	@Duns			varchar(30),
	@NameKey		varchar(30)= null,
	@EnrollCustID      Integer,
	@Applicationname Varchar(30),
	@UserName Varchar(50)

AS
BEGIN

INSERT INTO [lp_Common].[dbo].[UsageLog](UtilityAccountNbr, Duns, NameKey, ApplicationName, UserID, EnrollCustID)
VALUES (@UtilityAccountNbr, @Duns,@NameKey, @Applicationname, @UserName,  @EnrollCustID)
  

END


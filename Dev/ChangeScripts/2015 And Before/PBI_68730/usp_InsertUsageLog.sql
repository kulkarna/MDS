USE [lp_Market867]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertUsageLog]    Script Date: 7/2/2015 9:01:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Thanath
-- Create date: 07/02/2015
-- Description:	Log the Namekey for Usage Request-PBI68730
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertUsageLog]
	@UtilityAccountNbr varchar(20),
	@Duns			varchar(30),
	@NameKey		varchar(30),
	@EnrollCustID      Integer,
	@Applicationname Varchar(30),
	@UserName Varchar(50)

AS
BEGIN

INSERT INTO [lp_Common].[dbo].[UsageLog](UtilityAccountNbr, Duns, NameKey, ApplicationName, UserID, EnrollCustID)
VALUES (@UtilityAccountNbr, @Duns,@NameKey, @Applicationname, @UserName,  @EnrollCustID)
  

END

GO




CREATE PROCEDURE [dbo].[usp_VRE_GetErcotAdderAll]
 --@Month int,
 --@Year int,
 --@AccountTypeID int
AS
BEGIN
    SET NOCOUNT ON;

  Select 
		--TOP 1 
		[ID],
		[MarketCode],
		[AccountTypeID],
		[Month],
		[Year],
		[Mcpe],
		[Adder],
		[Username],
		[DateCreated]
	From
		[Libertypower].[dbo].[EflDefaultProduct] 
	--Where month= @Month and year=@Year and AccountTypeID = @AccountTypeID
	Order By
		DateCreated Desc
    

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_GetErcotAdderAll';


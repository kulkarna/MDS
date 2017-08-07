


CREATE PROCEDURE [dbo].[usp_VRE_RateChangeAcceptedAccountsSelect]  
	@ListOfAccounts varchar(max)
AS

Set NoCount On

Select 
	AccountNumber,
	RawStartingDate,
	RawEndingDate,
	Usage
From
	RateChange WITH (NOLOCK)	
	Inner Join	
	(Select * From Split(@ListOfAccounts,',')) ListOfAccounts
	on AccountNumber = ListOfAccounts.Items
Where
	[Status] = 1 and -- Rate update accepted
	DateCreated > DateAdd(DAY,-60,GETDATE())
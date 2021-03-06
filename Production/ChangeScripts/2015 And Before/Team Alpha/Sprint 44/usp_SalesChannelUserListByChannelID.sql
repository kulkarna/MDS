USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelUserListByChannelID]    Script Date: 12/15/2014 07:49:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* PROCEDURE:	[usp_SalesChannelUserListByChannelID]
* PURPOSE:		Get all valid sales channel sales agents list
* HISTORY:		 
 *******************************************************************************
* 1/9/2014 - Pradeep Katiyar
* Created.
* 12/8/2014 - Partha Bhattacharjee
* Updated - Added the check to display only for the Tablet
*******************************************************************************

*/

ALTER proc [dbo].[usp_SalesChannelUserListByChannelID](
	@ChannelID int
)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

	Select   
			U.UserID,              
			U.UserName,              
			U.Password,              
			U.Firstname,              
			U.Lastname,              
			U.Email,              
			U.DateCreated,  
			U.DateModified,  
			U.CreatedBy,  
			U.ModifiedBy,  
			U.UserType,  
			U.LegacyID,
			U.IsActive
		         
		from [User] U (NOLOCK)
		inner join SalesChannelUser SCU (NOLOCK) on U.UserID = SCU.UserID
		inner join SalesChannel SC(NOLOCK) on SCU.ChannelID = SC.ChannelID
		where (SCU.ChannelID = @ChannelID
		or @ChannelID = 0)
		and Sc.Tablet = 1
		 order by u.Firstname, u.LastName asc
		 
Set NOCOUNT OFF;
END
-- Copyright 1/9/2014 Liberty Power	 




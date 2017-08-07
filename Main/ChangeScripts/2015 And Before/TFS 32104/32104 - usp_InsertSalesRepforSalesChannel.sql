
USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_InsertSalesRepforSalesChannel' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_InsertSalesRepforSalesChannel;
GO
/*******************************************************************************

 * PROCEDURE:	[usp_InsertSalesRepforSalesChannel]
 * PURPOSE:		Insert sales rep for sales channel 
 * HISTORY:		 
 *******************************************************************************
 * 1/9/2014 - Pradeep Katiyar
 * Created.
 * 1/27/2014 - Pradeep Katiyar
 * Updated. Resolved the scope identity issue for userid.
 *******************************************************************************
[usp_InsertSalesRepforSalesChannel] 'libertypower\nymtestnew9', 'Fname9', 'Lname4', 'P@s$w0rd1#','test1@test.com',1194,2103
 */

create PROC [dbo].[usp_InsertSalesRepforSalesChannel] (        
	@Uname					varchar(50)
	,@FName					varchar(50)
	,@LName					Varchar(50)
	,@Pwd					varchar(50)
	,@UEmail				varchar(50)  = NULL
	,@ChannelParentId		INT				= 357 -- OUTBOUNDTELESALES AS DEFAULT
	,@CreatedById			int
)

As
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
Declare @UType				varchar(50)
Declare @UserId				int
Declare @EntityId			Int


--SET NO_BROWSETABLE OFF
	-- check if the user exists, if not, then create it
	
	select @UserId		= userid
	from libertypower..[user] with (nolock)
	where (firstname	= @FName
	and lastname		= @Lname
	and email			= @UEmail)
	or UserName			= @Uname
	
	IF not exists( select userid from libertypower..[user] with (nolock)
					where (firstname	= @FName
					and lastname		= @Lname
					and email			= @UEmail)
					or UserName			= @Uname )
	BEGIN

		exec  usp_UserInsert @UserName=@UName,@Password=@Pwd,@Firstname=@FName,@Lastname=@LName,@Email=@UEmail,@createdBy=49,@legacyID=0,@userType=N'EXTERNAL',@IsActive=N'Y'	
		select @UserId		= userid
			from libertypower..[user] with (nolock)
			where UserName			= @Uname
			
		exec	usp_EntityIndividualInsert @EntityType=N'I',@FirstName=@FName,@LastName=@LName,@MiddleName=N'',@MiddleInitial=N'',@Title=N'Sales Rep',@SocialSecurityNumber=N'',@CreatedBy=49,@Tag=N'',@BirthDate=NULL

		select @EntityId = EntityId 
		  from libertypower..EntityIndividual with (nolock)
		 where FirstName = @FName 
		   and LastName=@LName 
		   and MiddleInitial = '' 
		   and Title = 'Sales Rep'
		   
		exec	usp_SalesChannelSalesAgentInsert @UserID=@UserId,@ChannelID=@ChannelParentId,@createdBy=49,@EntityID=@EntityId,@ReportsTo=@ChannelParentId		

	END
	
Set NOCOUNT OFF;
END	

-- Copyright 1/9/2014 Liberty Power	 



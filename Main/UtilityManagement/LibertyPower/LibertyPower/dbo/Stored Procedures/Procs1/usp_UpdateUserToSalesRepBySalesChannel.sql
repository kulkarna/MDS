
    
CREATE PROC [dbo].[usp_UpdateUserToSalesRepBySalesChannel] (        
	@Uname					varchar(50)
	,@FName					varchar(50)
	,@LName					Varchar(50)
	,@Pwd					varchar(50)
	,@UEmail				varchar(50)  = NULL
	,@ChannelParentId		INT				= 357 -- OUTBOUNDTELESALES AS DEFAULT
	,@CreatedById			int
)

As
Declare @UType				varchar(50)
Declare @UserId				int
Declare @EntityId			Int

BEGIN

	-- check if the user exists, if not, then create it
	PRINT ' BEGIN HERE... LOOK FOR THE USER'

	PRINT 'Looking for User Id for ' + @FName + ' ' + @LName + ' ' + @UEmail
	
	select @UserId		= userid
	from libertypower..[user] with (nolock)
	where (firstname	= @FName
	and lastname		= @Lname
	and email			= @UEmail)
	or UserName			= @Uname
	
	IF @@ROWCOUNT > 0
	BEGIN

		exec	usp_EntityIndividualInsert @EntityType=N'I',@FirstName=@FName,@LastName=@LName,@MiddleName=N'',@MiddleInitial=N'',@Title=N'Sales Rep',@SocialSecurityNumber=N'',@CreatedBy=49,@Tag=N'',@BirthDate=NULL

		select	@EntityId = EntityId from EntityIndividual where FirstName = @FName and LastName=@LName and MiddleInitial = '' and Title = 'Sales Rep'

		exec	usp_SalesChannelUserInsert @UserID=@UserId,@ChannelID=@ChannelParentId,@createdBy=49,@EntityID=@EntityId,@ReportsTo=@ChannelParentId		

	END
	ELSE
	BEGIN

		PRINT 'executing user insert'

		-- check if the user exists first only create new users
		select @UserId		= userid
		  from libertypower..[user] with (nolock)
		 where firstname	= @FName
		   and lastname		= @Lname
		   and email		= @UEmail		

		If @@Rowcount = 0
			BEGIN
				exec  usp_UserInsert @UserName=@UName,@Password=N'',@Firstname=@FName,@Lastname=@LName,@Email=@UEmail,@createdBy=49,@legacyID=0,@userType=N'INTERNAL',@IsActive=N'Y'	
				SET @UserId = @@IDENTITY
			END
		PRINT 'User is ' + convert(varchar(10),@UserId)
		
		exec	usp_EntityIndividualInsert @EntityType=N'I',@FirstName=@FName,@LastName=@LName,@MiddleName=N'',@MiddleInitial=N'',@Title=N'Sales Rep',@SocialSecurityNumber=N'',@CreatedBy=49,@Tag=N'',@BirthDate=NULL
		
		select @EntityId = EntityId 
		  from EntityIndividual 
		 where FirstName = @FName 
		   and LastName=@LName 
		   and MiddleInitial = '' 
		   and Title = 'Sales Rep'
		   
		exec	usp_SalesChannelUserInsert @UserID=@UserId,@ChannelID=@ChannelParentId,@createdBy=49,@EntityID=@EntityId,@ReportsTo=@ChannelParentId		

	END

END	
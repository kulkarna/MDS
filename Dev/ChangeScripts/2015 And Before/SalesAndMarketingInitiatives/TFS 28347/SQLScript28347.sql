USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelUserListByChannelID' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_SalesChannelUserListByChannelID;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelUserListByChannelID]
 * PURPOSE:		Get all valid sales channel sales agents list
 * HISTORY:		 
 *******************************************************************************
 * 1/9/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE proc [dbo].[usp_SalesChannelUserListByChannelID](
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
		where SCU.ChannelID = @ChannelID
		 order by u.Firstname, u.LastName asc
Set NOCOUNT OFF;
END
-- Copyright 1/9/2014 Liberty Power	 

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelSalesAgentInsert' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_SalesChannelSalesAgentInsert;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelSalesAgentInsert]
 * PURPOSE:		Insert sales rep for sales channel 
 * HISTORY:		 
 *******************************************************************************
 * 1/9/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 */
 
 CREATE proc [dbo].[usp_SalesChannelSalesAgentInsert](@UserID int, @ChannelID int,      
          @CreatedBy int, @EntityID int, @ReportsTo int)      
as      
Begin
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
declare @CountOfDuplicates	int,
	    @RoleId				int
	
Set     @RoleId = 519 -- Channel manager role to be added to the Parent Sales Channel to be able to manage repts under it

select  @CountOfDuplicates = count(UserID)  
  from  SalesChannelUser with (nolock)
 where  UserID= @UserID 
   and  ChannelId = @ChannelID

IF (@CountOfDuplicates > 0)    
BEGIN    
	RaisError('THIS LOGIN NAME ALREADY EXISTS. PLEASE CHOOSE ANOTHER NAME.',11,1)    
END  
ELSE
BEGIN    

	Insert SalesChannelUser      
		(      
		ChannelID,      
		UserID,      
		CreatedBy,      
		ModifiedBy,      
		EntityID,  
		ReportsTo      
		)      
	values (      
		@ChannelID,      
		@UserID,      
		@CreatedBy,      
		@CreatedBy,      
		@EntityID ,  
		@ReportsTo     
		)     

		
	IF not exists( select * from UserRole WITH (NOLOCK) where RoleID = @RoleId and UserID = @ChannelID)  
	BEGIN      
		INSERT INTO [UserRole] (        
			 RoleID,        
			UserID,    
		 CreatedBy,    
		 ModifiedBy)        
		VALUES (        
			@RoleId,        
			@ChannelID,    
			@CreatedBy,    
			@CreatedBy) 	
	END
	
	
	
	select       
		EI.EntityID,       
		EI.MiddleName,            
		EI.MiddleInitial,            
		EI.Title,            
		EI.SocialSecurityNumber,       
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
		U.IsActive,      
		SCU.ChannelID,  
		SCU.ReportsTo        
	from [Libertypower].[dbo].[User] U WITH (NOLOCK)     
	inner join [Libertypower].[dbo].[SalesChannelUser] SCU WITH (NOLOCK)
	on U.UserID = SCU.UserID      
	inner join [Libertypower].[dbo].[EntityIndividual] EI WITH (NOLOCK)
	on SCU.EntityID = EI.EntityID        
	inner join [Libertypower].[dbo].[Entity] E WITH (NOLOCK)
	on E.EntityID = EI.EntityID       
	where U.UserID = @UserID      

END 
Set NOCOUNT OFF;
End
-- Copyright 1/9/2014 Liberty Power	

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
 *******************************************************************************
[usp_InsertSalesRepforSalesChannel] 'libertypower/pkkatiyar', 'Fname', 'Lname', 'P@s$w0rd1','test1@test.com',638,2103
 */

CREATE PROC [dbo].[usp_InsertSalesRepforSalesChannel] (        
	@Uname					varchar(50)
	,@FName					varchar(50)
	,@LName					Varchar(50)
	,@Pwd					varchar(50)
	,@UEmail				varchar(100)  = NULL
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
		SET @UserId = Scope_Identity()
		exec	usp_EntityIndividualInsert @EntityType=N'I',@FirstName=@FName,@LastName=@LName,@MiddleName=N'',@MiddleInitial=N'',@Title=N'Sales Rep',@SocialSecurityNumber=N'',@CreatedBy=49,@Tag=N'',@BirthDate=NULL
		
		select @EntityId = EntityId 
		  from EntityIndividual 
		 where FirstName = @FName 
		   and LastName=@LName 
		   and MiddleInitial = '' 
		   and Title = 'Sales Rep'
		   
		exec	usp_SalesChannelSalesAgentInsert @UserID=@UserId,@ChannelID=@ChannelParentId,@createdBy=49,@EntityID=@EntityId,@ReportsTo=@ChannelParentId		

	END
	
Set NOCOUNT OFF;
END	

-- Copyright 1/9/2014 Liberty Power	 




-- =============================================
-- Modified Rafael Vasconcelos 08/28/2012
-- Ticket 23241 
-- Commented the update statement that put 'hasmanagedusers' column to 1
-- =============================================  
-- =============================================
-- Modified José Muñoz 05/20/2011
-- Ticket 23241 
-- Once the new agent/rep is created, update the sales channel partner parent.  
-- Update libertypower..saleschannel, set HasManagedUsers to 1 for channelid = @ReportsTo.  
-- Also update the new agent/rep record with the same usertype setting as the parent sales channel
-- =============================================     
      
CREATE proc [dbo].[usp_SalesChannelUserInsert](@UserID int, @ChannelID int,      
          @CreatedBy int, @EntityID int, @ReportsTo int)      
as      

declare @CountOfDuplicates	int
	   ,@ReportsToUserType		varchar(20)  -- Added Ticket 23241
	   ,@RoleId				int
	
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

	/* Ticket 23241 Begin */
	--Update statement commented because is aways setting 'hasmanagedusers' to 1
	--when the defaoult should be 0
	--update [libertypower].[dbo].[saleschannel]
	--   set HasManagedUsers			= 1
	-- where ChannelID				= @ReportsTo

	select @ReportsToUserType	= usertype
	  from [Libertypower].[dbo].[user] with (nolock)
	 where UserId = @ReportsTo

	update [Libertypower].[dbo].[user]
	   set UserType				= @ReportsToUserType
	     , IsActive				= 'Y'
	 where UserID				= @UserID 
		
	IF not exists( select * from UserRole where RoleID = @RoleId and UserID = @ChannelID)  
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
	
	/* Ticket 23241 End */
	
	
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
	from [Libertypower].[dbo].[User] U (NOLOCK)      
	inner join [Libertypower].[dbo].[SalesChannelUser] SCU (NOLOCK) 
	on U.UserID = SCU.UserID      
	inner join [Libertypower].[dbo].[EntityIndividual] EI (NOLOCK)  
	on SCU.EntityID = EI.EntityID        
	inner join [Libertypower].[dbo].[Entity] E (NOLOCK) 
	on E.EntityID = EI.EntityID       
	where U.UserID = @UserID      
END 

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserInsert';


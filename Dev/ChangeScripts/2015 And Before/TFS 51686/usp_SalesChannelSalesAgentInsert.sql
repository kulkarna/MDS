USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSalesAgentInsert]    Script Date: 10/21/2014 11:42:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelSalesAgentInsert]
 * PURPOSE:		Insert sales rep for sales channel 
 * HISTORY:		 
 *******************************************************************************
 * 1/9/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 * 10/21/2014 - Sal Tenorio
 * Fixed issue with inserting UserRole. It was passing ChannelID instead of UserId 
 * to the UserId field...
 *******************************************************************************
 */
 
 ALTER proc [dbo].[usp_SalesChannelSalesAgentInsert](@UserID int, @ChannelID int,      
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

		
	IF not exists( select * from UserRole WITH (NOLOCK) where RoleID = @RoleId and UserID = @UserID)  
	BEGIN      
		INSERT INTO [UserRole] (        
		 RoleID,        
		 UserID,    
		 CreatedBy,    
		 ModifiedBy)        
		VALUES (        
		 @RoleId,        
		 @UserID,    
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


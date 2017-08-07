
CREATE proc [dbo].[usp_SalesChannelUserUpdate] 
(
	@UserID int, 
	@ChannelID int, 
	@ReportsTo int,
	@ModifiedBy int
)
as

Update SalesChannelUser
set ReportsTo = @ReportsTo
	, ModifiedBy = @ModifiedBy
	, DateModified = getdate()

where ChannelID = @ChannelID and UserID = @UserID

Select  EI.EntityID,   
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
             
  from [User] U (NOLOCK)  
  inner join SalesChannelUser SCU (NOLOCK) on U.UserID = SCU.UserID  
  inner join EntityIndividual EI (NOLOCK)  on SCU.EntityID = EI.EntityID    
  inner join Entity E (NOLOCK) on E.EntityID = EI.EntityID   
   where SCU.UserID = @UserID  
  

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserUpdate';


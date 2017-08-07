
  
  
  
CREATE proc [dbo].[usp_SalesChannelUserGetInternalUsers] 
as  
  
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
   where U.UserType = 'INTERNAL' 
  
  

  
  

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserGetInternalUsers';


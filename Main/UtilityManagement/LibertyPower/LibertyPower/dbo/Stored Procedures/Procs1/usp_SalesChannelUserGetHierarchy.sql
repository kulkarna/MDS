 
 CREATE proc [dbo].[usp_SalesChannelUserGetHierarchy] (@UserID int, @ChannelID int)
 as
 
  with CTE as (
  SELECT scu.ReportsTo, scu.UserID, scu.ChannelID
	from SalesChannelUser scu
	 where scu.UserID =  @UserID
	 and ChannelID = @ChannelID
	
	 
	 union all
	 
	SELECT s.ReportsTo, s.UserID, s.ChannelID
	from SalesChannelUser s
	 inner join CTE on CTE.UserID = s.ReportsTo
	 and s.UserID <> s.ReportsTo
	 and s.ChannelID = @ChannelID
	 )
	   
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
   SCU.ChannelID ,     
   SCU.ReportsTo               
  from    CTE
  inner join [User] U  on CTE.UserID = U.UserID
  inner join SalesChannelUser SCU on U.UserID = SCU.UserID    
  inner join EntityIndividual EI  on SCU.EntityID = EI.EntityID      
  inner join Entity E on E.EntityID = EI.EntityID  

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserGetHierarchy';


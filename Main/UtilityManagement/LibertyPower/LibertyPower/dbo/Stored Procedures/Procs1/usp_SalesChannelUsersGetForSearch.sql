

CREATE proc [dbo].[usp_SalesChannelUsersGetForSearch] (@CurrentUserID int,@RoleName varchar(50))

as
 
(            
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
   SCU.ChannelID,  
   SCU.ReportsTo    
   into #tmpUsers    
  from [User] U  (NOLOCK) 
  inner join SalesChannelUser SCU (NOLOCK) on U.UserID = SCU.UserID  
  inner join EntityIndividual EI (NOLOCK)  on SCU.EntityID = EI.EntityID    
  inner join Entity E (NOLOCK) on E.EntityID = EI.EntityID   
      
 
  )  
   if @RoleName= 'DevMgr'
    BEGIN
     SELECT * from #tmpUsers
    END
    else if @RoleName= 'LPChannelMgr'
    BEGIN
     SELECT * from #tmpUsers
     where ChannelID in (select ChannelID   
     from SalesChannelForLPMgr
      where  LPMgrID = @CurrentUserID )
    END
    
    else if @RoleName= 'ChannelMgr'
    BEGIN
     SELECT * from #tmpUsers
     where ChannelID in (select ChannelID 
     from udf_SalesChannelUserGetReportsTo(@CurrentUserID,#tmpUsers.ChannelID) )
    END
  else if @RoleName= 'Agent'
    BEGIN
     SELECT * from #tmpUsers
     where UserID = @CurrentUserID 
    END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUsersGetForSearch';


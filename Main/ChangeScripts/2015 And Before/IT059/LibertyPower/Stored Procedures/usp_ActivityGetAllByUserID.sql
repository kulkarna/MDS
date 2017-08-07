USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_ActivityGetAllByUserID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_ActivityGetAllByUserID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_ActivityGetAllByUserID
 * Retrieves all activities for a user
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

      
CREATE proc [dbo].[usp_ActivityGetAllByUserID] 
(
	@UserID int
)        
As        

SET NOCOUNT ON;

Select     
	a.ActivityKey, a.ActivityDesc, a.AppKey, a.DateCreated,    
	r.RoleName,     
	r.RoleID,    
	u.UserID,    
	u.UserName,    
	u.Firstname,    
	u.Lastname,    
	u.Email,    
	u.Password ,  
	u.DateCreated,  
	u.DateModified,  
	u.CreatedBy,  
	u.ModifiedBy,  
	u.LegacyID,  
	u.UserType,
	U.IsActive
From [User] u WITH (NOLOCK)   
join UserRole ur WITH (NOLOCK) on U.UserID = ur.UserID     
join Role r WITH (NOLOCK) on r.RoleID = ur.RoleID    
join ActivityRole ar WITH (NOLOCK) on  r.RoleID= ar.RoleiD    
left outer join Activity a WITH (NOLOCK) on ar.ActivityID = a.ActivityKey        
       
Where u.UserID = @UserID     

SET NOCOUNT OFF;     

GO

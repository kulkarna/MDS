CREATE proc [dbo].[usp_UserGetByUserID] (@UserID int )          
as          
select       
		UserID,      
		UserName,      
		Password,      
		Firstname,      
		Lastname,      
		Email,      
		DateCreated,      
		DateModified,      
		CreatedBy,      
		ModifiedBy,      
		UserType,      
		LegacyID,
		IsActive        
        
From [User]         
where UserID = @UserID 



CREATE  proc [dbo].[usp_UserGetALL]  
as      
Select UserID,    
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


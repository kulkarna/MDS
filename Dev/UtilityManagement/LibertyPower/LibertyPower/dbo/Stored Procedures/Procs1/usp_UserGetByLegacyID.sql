CREATE proc [dbo].[usp_UserGetByLegacyID](@LegacyID int )        
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
where LegacyID = @LegacyID

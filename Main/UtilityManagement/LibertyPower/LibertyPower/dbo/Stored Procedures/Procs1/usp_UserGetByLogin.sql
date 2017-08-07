
CREATE proc [dbo].[usp_UserGetByLogin](@Username varchar(100) )      
as      

IF(CHARINDEX('libertypower\', @UserName, 0) = 0)
BEGIN
	SET @UserName = 'libertypower\' + @UserName
END

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
where Username = @UserName



CREATE proc [dbo].[usp_UserGetByUsername] (@UserName varchar(100))  
as  
select UserID,      
		UserName,      
		Password,      
		Firstname,      
		Lastname,      
		Email,      
		DateCreated,
		DateModified,
		CreatedBy,
		ModifiedBy ,
		UserType,
		LegacyID ,
		IsActive           
from [User]  
where UserName= @UserName  


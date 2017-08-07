
Create proc usp_UserSetActive(@UserID int, @IsActive char(1))
as

Update [User]
set IsActive = @IsActive
where UserID = @UserID

select         
UserID,        
UserName,        
[Password],        
Firstname,        
Lastname,        
Email,        
DateCreated,        
DateModified,        
CreatedBy,        
ModifiedBy,        
UserType,        
LegacyID        
          
From [User]           
where UserID = @UserID 


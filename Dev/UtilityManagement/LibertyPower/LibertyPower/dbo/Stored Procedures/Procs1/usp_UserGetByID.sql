

CREATE  proc [dbo].[usp_UserGetByID] (@UserID int)  
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
LegacyID   
from [User]
where userID = @UserID


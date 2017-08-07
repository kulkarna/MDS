
/*********************************************
* Modified by: Isabelle Tamanini
* Date: 09/01/2010
* UserType added to update table
*********************************************/


CREATE PROCEDURE [dbo].[usp_UserUpdate]            
(            
    @UserName varchar(100),            
    @Password varchar(50),            
    @Firstname varchar(50),            
    @Lastname varchar(50),            
    @Email varchar(100)  ,    
	@UserID int,  
	@ModifiedBy int,
	@IsActive char(1) = null,
	@UserType varchar(20) = null
)            
AS            

If @IsActive is null
Begin
	Select @IsActive = IsActive from [User] where UserID = @UserID
End

If @UserType is null
Begin
	Select @UserType = UserType from [User] where UserID = @UserID
End

If @ModifiedBy = 0
Begin
	Set @ModifiedBy = 1
End
          
Update [User]             
    set  UserName = @UserName,            
    Password = @Password,            
    Firstname = @Firstname,            
    Lastname = @Lastname,            
    Email = @Email,
    IsActive = @IsActive,  
	ModifiedBy = @ModifiedBy ,  
	DateModified = getdate(),
	UserType = @UserType
 
 where UserID = @UserID    
      
          
select  UserID,                
		UserName,                
		Password,                
		Firstname,                
		Lastname,                
		Email,                
		DateCreated,  
		DateModified,  
		CreatedBy,  
		ModifiedBy,  
		LegacyID,  
		UserType,
		IsActive         
from [User] where UserID = @UserID     
  

      
      
CREATE PROCEDURE [dbo].[usp_UserInsert]          
(          
     @UserName varchar(100),          
    @Password varchar(50),          
    @Firstname varchar(50),          
    @Lastname varchar(50),          
    @Email varchar(100),  
 @CreatedBy int,  
 @UserType varchar(20),  
 @LegacyID int =0,
 @IsActive char(1) = 'Y'         
)          
AS          
if  exists(select Username from [User]          
where Username = @UserName          
)          
BEGIN
  RaisError('THIS LOGIN NAME ALREADY EXISTS. PLEASE CHOOSE ANOTHER NAME.',11,1)    
END
else
BEGIN
INSERT INTO [User] (          
     UserName,          
    Password,          
    Firstname,          
    Lastname,          
    Email,  
	CreatedBy,  
	ModifiedBy,  
	UserType,  
	LegacyID,
	IsActive)          
VALUES (          
    @UserName,          
    @Password,          
    @Firstname,          
    @Lastname,          
	@Email,  
	@CreatedBy,  
	@CreatedBy,  
	@UserType,  
	@LegacyID,
	@IsActive)          
        
select UserID,              
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
from [User] where UserID = Scope_Identity()   
END

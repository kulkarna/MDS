-- =============================================

-- Author:  Hugo Ramos

-- Create date: 15/10/2010

-- Description: Select users with specific roles

-- =============================================

/*

GetUsersWithRoles 'SalesManagers,SalesAdmin', 1

*/

CREATE PROCEDURE [dbo].[usp_GetUsersWithRoles]

@RoleList varchar(max),

@MustHaveAllRoles bit 
AS 

--DECLARE @Rolelist varchar(max)

--DECLARE @MustHaveAllRoles bit 
--SET @Rolelist = 'Administrators,Registered Users,Subscribers'

--SET @MustHaveAllRoles = 0 
DECLARE @roles TABLE

(

role_name char(100)

) 

INSERT @roles (role_name)

SELECT DISTINCT value FROM lp_account.dbo.ufn_split_delimited_string(@Rolelist, ',') 

declare @count int

set @count = (select count(1) from @roles) 

--select @count 
IF (@MustHaveAllRoles = 0)

BEGIN

SELECT DISTINCT

            [User].UserID,  --RoleName,

            UserName, 

            Password, 

            Firstname, 

            Lastname, 

            Email, 

            [User].DateCreated, 

            [User].DateModified, 

            [User].CreatedBy, 

            [User].ModifiedBy, 

            UserType, 

            LegacyID,

            IsActive 

From [User]

JOIN userRole ON userRole.UserID = [user].UserID

JOIN [role] ON [role].RoleID = userRole.RoleID

WHERE [role].RoleName IN (SELECT * FROM @roles)

END

ELSE

BEGIN

SELECT DISTINCT

            [User].UserID, -- RoleName,

            UserName, 

            Password, 

            Firstname, 

            Lastname, 

            Email, 

            [User].DateCreated, 

            [User].DateModified, 

            [User].CreatedBy, 

            [User].ModifiedBy, 

            UserType, 

            LegacyID,

            IsActive 

From [User]

JOIN userRole ON userRole.UserID = [user].UserID

JOIN [role] ON [role].RoleID = userRole.RoleID

JOIN (SELECT U.[UserID], COUNT(1) AS [COUNT] FROM [User] U

      JOIN userRole ON userRole.UserID = U.UserID

      JOIN [role] ON [role].RoleID = userRole.RoleID

      WHERE [role].RoleName IN (SELECT * FROM @roles)

      GROUP BY U.[UserID]) AS A ON A.[UserID] = [User].[UserID]

      WHERE [role].RoleName IN (SELECT * FROM @roles) AND A.[COUNT] = @count 
ORDER BY 1

END


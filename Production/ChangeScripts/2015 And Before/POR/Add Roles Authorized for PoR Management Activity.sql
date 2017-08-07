

-----		CREATES A NEW SECURITY ACTIVITY AND AUTHORIZES A FEW ROLES FOR THE PoR MANAGEMENT SCREEN		-----

IF EXISTS(select 1 from [LibertyPower]..[Activity] where [ActivityDesc] = 'PoR Management')
	RETURN	--DO NOT RE-RUN SCRIPT 
GO

------------Create new activity for PoR Management
INSERT INTO [LibertyPower]..[Activity] (
	[ActivityDesc]
	,[AppKey]
	,[DateCreated]
	,[CreatedBy]
) VALUES (
	'PoR Management'
	,'COM'				--Part of the COMMON app
	,GETDATE()
	,1021				--'LibertyPower/rrusson'
)
GO


------------Create new Credit Team Role
INSERT INTO [LibertyPower].[dbo].[Role] (
           [RoleName]
           ,[DateCreated]
           ,[DateModified]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[Description]
) VALUES (
           'CreditUser'
           ,GETDATE()
           ,NULL
           ,1021
           ,NULL
           ,'Credit Team'
)
GO


------------Get PK for new Activity
DECLARE @NewActivityID	int
SELECT @NewActivityID = ActivityKey
FROM LibertyPower..Activity (NOLOCK)
WHERE ActivityDesc = 'PoR Management'



------------Get Admin, Pricing_User, and Developer RoleIds
DECLARE @AdminRoleId	int
DECLARE @CreditUserRoleId	int
DECLARE @DeveloperRoleId	int

SELECT @AdminRoleId = RoleId
FROM LibertyPower..[Role] (NOLOCK)
WHERE RoleName = 'Administrators'
SELECT @AdminRoleId 

SELECT @CreditUserRoleId = RoleId
FROM LibertyPower..[Role] (NOLOCK)
WHERE RoleName = 'CreditUser'

SELECT @DeveloperRoleId = RoleId
FROM LibertyPower..[Role] (NOLOCK)
WHERE RoleName = 'Developer'



------------Add Admin Role for "PoR Management" Activity
INSERT INTO [LibertyPower].[dbo].[ActivityRole] (
	[RoleID]
	,[ActivityID]
	,[DateCreated]
	,[CreatedBy]
) VALUES (
	@AdminRoleId
	,@NewActivityID
	,GETDATE()
	,1021
)


------------Add CreditUser Role for "PoR Management" Activity
INSERT INTO [LibertyPower].[dbo].[ActivityRole] (
	[RoleID]
	,[ActivityID]
	,[DateCreated]
	,[CreatedBy]
) VALUES (
	@CreditUserRoleId
	,@NewActivityID
	,GETDATE()
	,1021
)


------------Add Developer Role for "PoR Management" Activity
INSERT INTO [LibertyPower].[dbo].[ActivityRole] (
	[RoleID]
	,[ActivityID]
	,[DateCreated]
	,[CreatedBy]
) VALUES (
	@DeveloperRoleId
	,@NewActivityID
	,GETDATE()
	,1021
)


------------Add Credit Team to their new Security Role
INSERT INTO [LibertyPower].[dbo].[UserRole]
SELECT
	@CreditUserRoleId			AS [RoleID]
	,[UserID]					AS [UserID]
	,GetDate()					AS [DateCreated]
	,NULL						AS [DateModified]
	,1021						AS [CreatedBy]
	,NULL						AS [ModifiedBy]
FROM [LibertyPower]..[User] u (NOLOCK)
WHERE (u.lastname = 'Diaz'	and u.firstname = 'Ariel')
OR (u.lastname = 'Mitova'	and u.firstname = 'Milena')
OR (u.lastname = 'Pena'		and u.firstname = 'Daniel')

GO


/*
	--FIND ROLES:
		SELECT *
		FROM LibertyPower..[Role] (NOLOCK)
		WHERE RoleName LIKE '%Credit%'

	--FIND USERS:
		SELECT top 10 *
		FROM LibertyPower..[User] (NOLOCK)
		where lastname = 'Stein'

	--TEST USER PERMISSIONS:
		EXEC [LibertyPower]..usp_ActivityGetByUserID @userID=1021, @AppKey=default
		
		
CREDIT TEAM:
	Ariel Diaz <adiaz@libertypowercorp.com>; Daniel Pena <dpena@libertypowercorp.com>; Milena Mitova <mmitova@libertypowercorp.com>
*/

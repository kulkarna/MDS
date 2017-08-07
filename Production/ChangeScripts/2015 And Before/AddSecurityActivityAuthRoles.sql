-- CREATES A NEW ACTIVITY SECURITY ROLE @ActivityDesc
-- AND AUTHORIZES ROLES FOR @UserRole
USE [LibertyPower]
GO

BEGIN TRANSACTION createSP
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF OBJECT_ID ( '[dbo].[usp_AddActivityAuthRoles]', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_AddActivityAuthRoles]
GO

CREATE PROCEDURE usp_AddActivityAuthRoles 
(
	@AppKey VARCHAR(5)=NULL,
	@ActivityDesc VARCHAR(50)=NULL,
	@RoleName VARCHAR(50)=NULL,
	@RoleDesc VARCHAR(200)=NULL,
	@UserIDs VARCHAR(500)=NULL
) AS

DECLARE @ActivityID INT,
		@CreatedBy INT,
		@RoleID INT
		
SET @CreatedBy = (SELECT UserID FROM LibertyPower..[User] (NOLOCK)
					WHERE UPPER(UserName) = (SELECT UPPER(SUSER_NAME())))

IF @ActivityDesc IS NOT NULL
BEGIN
	IF @AppKey IS NULL
	BEGIN
		PRINT '@AppKey must be provided if @ActivityDesc is provided'
		RETURN --DO NOT RE-RUN SCRIPT
	END

	------------Create new Activity
	IF NOT EXISTS(SELECT ActivityKey FROM LibertyPower..Activity (NOLOCK)
				   WHERE ActivityDesc = @ActivityDesc
					 AND AppKey = @AppKey)
		BEGIN
			INSERT INTO LibertyPower..Activity (
				ActivityDesc
				,AppKey
				,DateCreated
				,CreatedBy
			) VALUES (
				@ActivityDesc
				,@AppKey
				,GETDATE()
				,@CreatedBy
			)
			IF @@ROWCOUNT > 0 PRINT @ActivityDesc + ' added to Activity table'
		
			SET @ActivityID = (SELECT ActivityKey 
								FROM LibertyPower..Activity (NOLOCK)
								WHERE ActivityDesc = @ActivityDesc)
		END
END

-----------Put the users IDs into a temp table
IF @UserIDs IS NOT NULL AND @RoleName IS NULL
BEGIN
	PRINT '@RoleName must be provided to add users'
	RETURN
END
                     
------------Add Role, ActivityRole, and Users
IF @RoleName IS NOT NULL
BEGIN
	
	IF NOT EXISTS (SELECT RoleID
					FROM LibertyPower..[Role] (NOLOCK)
					WHERE RoleName = @RoleName)
	BEGIN
		INSERT INTO [LibertyPower]..[Role]
			(RoleName,DateCreated,CreatedBy,Description)
		VALUES (@RoleName,GETDATE(),@CreatedBy,@RoleDesc)
		
		IF @@ROWCOUNT > 0 PRINT @RoleName + ' added to Role table'
	END
		
	SET @RoleID = (SELECT RoleID
					FROM LibertyPower..[Role] (NOLOCK)
					WHERE RoleName = @RoleName)
	
	IF NOT EXISTS (SELECT ActivityRoleKey FROM ActivityRole (NOLOCK) 
					WHERE RoleID = @RoleID AND ActivityID = @ActivityID) 
		AND @ActivityID IS NOT NULL
	BEGIN
		INSERT INTO LibertyPower..ActivityRole (
			 RoleID
			,ActivityID
			,DateCreated
			,CreatedBy
		) VALUES (
			 @RoleID
			,@ActivityID
			,GETDATE()
			,@CreatedBy
		)
	
		IF @@ROWCOUNT > 0 PRINT 'Activity/Role added to ActivityRole table'
	END
	
	IF @UserIDs IS NOT NULL
	BEGIN
		EXEC ('INSERT INTO LibertyPower..UserRole
							SELECT ' + @RoleID + ',[UserID],GetDate(),NULL,' + @CreatedBy + ',NULL
							FROM [LibertyPower]..[User] u (NOLOCK)
							WHERE SUBSTRING(UserName,14,LEN(UserName)) IN ' + @UserIDs +
							'AND UserID NOT IN (SELECT ur.UserID FROM Libertypower..UserRole ur
								LEFT OUTER JOIN Libertypower..[User] u ON u.UserID = ur.UserID
								WHERE ur.RoleID =  ' + @RoleID + ' AND SUBSTRING(u.UserName,14,len(u.UserName)) IN ' + @UserIDs + ')')

	IF @@ROWCOUNT > 0 PRINT 'Users added for ' + @RoleName
	END	
	
--EXEC [dbo].[AddSecurityActivityAuthRoles]
--		--@AppKey = 'COM', 
--		--@ActivityDesc = N'ENTITYADMIN',
--		@RoleName = N'Admin Role',
--		--@RoleDesc = N'Admin Role',			-- Only needed for new roles
--		@UserIDs = N'(''slevine'')'	-- Leave this parameter out if no users to be added.
--											-- RoleName has to be populated to add users.
END

/*
	--FIND ROLES:
		SELECT *
		FROM LibertyPower..[Role] (NOLOCK)
		WHERE RoleName = 'Admin Role'

	--FIND USERS:
		SELECT *
		FROM LibertyPower..[User] (NOLOCK)
		where lastname IN ('Pena','Diaz')
		
	--FIND ACTIVITIES:
		SELECT *
		FROM LibertyPower..[Activity]
		WHERE AppKey = 'COM'

	--FIND ACTIVITY ROLES:
		SELECT *
		FROM LibertyPower..[ActivityRole] ar
		JOIN LibertyPower..[Role] r ON ar.RoleID = r.RoleID
		JOIN LibertyPower..[Activity] a ON ar.ActivityID = a.ActivityKey
		WHERE r.RoleName = 'Admin Role'
		AND a.ActivityDesc = 'TESTADMIN'
		
		SELECT * FROM ActivityRole WHERE RoleID = 164 and ActivityID = 111
		
	--FIND USERS WITH ACTIVITY ROLE
	SELECT * FROM ActivityRole ar
	JOIN Activity a ON a.ActivityKey = ar.ActivityID
	JOIN UserRole ur ON ar.RoleID = ur.RoleID
	JOIN [LibertyPower]..[User] u ON ur.UserID = u.UserID
	WHERE 
	--u.UserID = 1559 AND
	a.ActivityDesc = 'TESTADMIN' AND
	a.AppKey = 'COM'
		
	--DELETE PERMISSIONS:
	DELETE FROM LibertyPower..ActivityRole WHERE RoleID = 164 AND ActivityID = 111

	--TEST USER PERMISSIONS:
		EXEC [LibertyPower]..usp_ActivityGetByUserID @userID=1559, @AppKey='COM'
		
		
CREDIT TEAM:
	Ariel Diaz <adiaz@libertypowercorp.com>; Daniel Pena <dpena@libertypowercorp.com>; Milena Mitova <mmitova@libertypowercorp.com>
*/
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION createSP
GO

SET NOEXEC OFF
GO


-- EXEC LibertyPower.dbo.usp_RoleDiff 'libertypower\tsmith', 'libertypower\jpang'
CREATE PROCEDURE [dbo].[usp_RoleDiff] (@p1_username VARCHAR(100), @p2_username VARCHAR(100))
AS 
BEGIN
	--DECLARE @p1_username VARCHAR(100)
	--DECLARE @p2_username VARCHAR(100)
	SELECT r.RoleID, r.RoleName
	INTO #P1_Roles
	FROM [User] u
	JOIN UserRole ur ON u.UserID = ur.UserID
	JOIN Role r ON ur.RoleID = r.RoleID
	WHERE u.UserName = @p1_username

	SELECT r.RoleID, r.RoleName
	INTO #P2_Roles
	FROM [User] u
	JOIN UserRole ur ON u.UserID = ur.UserID
	JOIN Role r ON ur.RoleID = r.RoleID
	WHERE u.UserName = @p2_username

	SELECT @p1_username as [User 1], p1.*
	FROM #P1_Roles p1
	LEFT JOIN #P2_Roles p2 ON p1.RoleID = p2.RoleID
	WHERE p2.RoleID IS NULL
	UNION
	SELECT @p2_username as [User 2], p2.*
	FROM #P1_Roles p1
	RIGHT JOIN #P2_Roles p2 ON p1.RoleID = p2.RoleID
	WHERE p1.RoleID IS NULL

END 
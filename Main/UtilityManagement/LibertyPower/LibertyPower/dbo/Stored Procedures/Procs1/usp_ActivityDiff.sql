
-- EXEC LibertyPower.dbo.usp_ActivityDiff 'libertypower\tsmith', 'libertypower\jpang'
CREATE PROCEDURE usp_ActivityDiff (@p1_username VARCHAR(100), @p2_username VARCHAR(100))
AS 
BEGIN
	--DECLARE @p1_username VARCHAR(100)
	--DECLARE @p2_username VARCHAR(100)
	SELECT r.RoleID, r.RoleName, a.ActivityKey, a.ActivityDesc, a.AppKey
	INTO #P1_Activities
	FROM [User] u
	JOIN UserRole ur ON u.UserID = ur.UserID
	JOIN Role r ON ur.RoleID = r.RoleID
	JOIN ActivityRole ar ON r.RoleID = ar.RoleID
	JOIN Activity a ON ar.ActivityID = a.ActivityKey
	WHERE u.UserName = @p1_username

	SELECT r.RoleID, r.RoleName, a.ActivityKey, a.ActivityDesc, a.AppKey
	INTO #P2_Activities
	FROM [User] u
	JOIN UserRole ur ON u.UserID = ur.UserID
	JOIN Role r ON ur.RoleID = r.RoleID
	JOIN ActivityRole ar ON r.RoleID = ar.RoleID
	JOIN Activity a ON ar.ActivityID = a.ActivityKey
	WHERE u.UserName = @p2_username

	SELECT @p1_username, p1.*
	FROM #P1_Activities p1
	LEFT JOIN #P2_Activities p2 ON p1.ActivityKey = p2.ActivityKey
	WHERE p2.ActivityKey IS NULL
	UNION
	SELECT @p2_username, p2.*
	FROM #P1_Activities p1
	RIGHT JOIN #P2_Activities p2 ON p1.ActivityKey = p2.ActivityKey
	WHERE p1.ActivityKey IS NULL

END 
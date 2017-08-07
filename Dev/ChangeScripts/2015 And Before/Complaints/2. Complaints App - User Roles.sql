use LibertyPower

DECLARE @activityKey int
DECLARE @casePrimeRoleID int
DECLARE @legalRoleID int
DECLARE @activityRoleKey int

-- Create App
INSERT INTO AppName(AppKey, AppDescription) VALUES('CMPL', 'Complaints')

-- Create Complaint activity
INSERT INTO Activity(ActivityDesc, AppKey) VALUES('COMPLAINTS-USER', 'CMPL')
SET @activityKey = @@IDENTITY

--************************************************************************
-- CREATE ACTIVITY-ROLE FOR 'COMPLAINT APP USER'
SET @legalRoleID = (SELECT TOP 1 RoleID FROM [Role] WHERE RoleName = 'Legal')
INSERT INTO ActivityRole(RoleID, ActivityID) VALUES(@legalRoleID, @activityKey)
SET @activityRoleKey = @@IDENTITY

INSERT INTO [UserRole](RoleID, UserID)
SELECT @casePrimeRoleID, UserID
FROM [User]
WHERE UserName IN (
				'libertypower\clima', 
				'libertypower\eportocarrero')
--************************************************************************


--************************************************************************
-- Create case prime role
INSERT INTO [Role](RoleName, [Description]) VALUES('Complaint Case Prime', 'Complaint Case Prime')
SET @casePrimeRoleID = @@IDENTITY

-- Create activity-role for 'case prime'
INSERT INTO ActivityRole(RoleID, ActivityID) VALUES(@casePrimeRoleID, @activityKey)
SET @activityRoleKey = @@IDENTITY

-- Assign Case Prime role to corresponding users
INSERT INTO [UserRole](RoleID, UserID)
SELECT @casePrimeRoleID, UserID
FROM [User]
WHERE UserName IN (
				'libertypower\mcofer',
				'libertypower\dmintz',
				'libertypower\hberacha',
				'libertypower\bwhite',
				'libertypower\asantiago',
				'libertypower\kmcdonald',
				'libertypower\csenter',
				'libertypower\ooyewale',
				'libertypower\awilliams',
				'libertypower\tford',
				'libertypower\nwilson',
				'libertypower\lmcdonald',
				'libertypower\clima', 
				'libertypower\eportocarrero')
--************************************************************************
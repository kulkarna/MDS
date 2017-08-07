-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get USer ID based on username or firsdt name + last name if the flag is given and no record is found
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetUserId]
(
	@p_User VARCHAR(50),
	@p_TryNameIfUsernameFailed BIT = 0
)
RETURNS INT
AS
BEGIN
	DECLARE @w_UserID INT;
	SET @w_UserID = NULL;
	SELECT @w_UserID = U.UserID FROM LibertyPower.dbo.[User] U (NOLOCK) WHERE LOWER(U.UserName) = LOWER(LTRIM(RTRIM(@p_User)));
	-- if user id not found by username and the flag to look by fistname and last name is on then lookup
	IF @w_UserID IS NULL AND @p_TryNameIfUsernameFailed = 1
	BEGIN
		-- Get Sales manager user id
		SELECT @w_UserID = U.UserID FROM LibertyPower.dbo.[User] U (NOLOCK) WHERE LTRIM(RTRIM(LOWER(U.Firstname+ ' ' + U.Lastname))) = LOWER(LTRIM(RTRIM(@p_User)));
	END				
	-- Return the result of the function
	RETURN @w_UserID ;

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetUserId] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetUserId] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];


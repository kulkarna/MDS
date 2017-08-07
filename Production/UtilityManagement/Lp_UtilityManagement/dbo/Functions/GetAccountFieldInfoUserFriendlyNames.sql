CREATE FUNCTION GetAccountFieldInfoUserFriendlyNames() RETURNS NVARCHAR(2000)
AS
BEGIN
	DECLARE @UserFriendlyName AS NVARCHAR(255)
	DECLARE @CommaSeparatedNames AS NVARCHAR(2000)
	DECLARE @FirstTimeThrough AS BIT
	SET @FirstTimeThrough = 0
	SET @CommaSeparatedNames = ''
	DECLARE UserFriendlyNameCursor CURSOR
	FOR
	SELECT NameUserFriendly FROM AccountInfoField ORDER BY NameUserFriendly
	OPEN UserFriendlyNameCursor
	FETCH NEXT FROM UserFriendlyNameCursor
	INTO @UserFriendlyName

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @FirstTimeThrough <> 0
		BEGIN
			SET @CommaSeparatedNames += ','
		END
		SET @CommaSeparatedNames += '[' + @UserFriendlyName + ']'
		SET @FirstTimeThrough = 1
		FETCH NEXT FROM UserFriendlyNameCursor
		INTO @UserFriendlyName
	END
	CLOSE UserFriendlyNameCursor
	DEALLOCATE UserFriendlyNameCursor

	RETURN @CommaSeparatedNames
END
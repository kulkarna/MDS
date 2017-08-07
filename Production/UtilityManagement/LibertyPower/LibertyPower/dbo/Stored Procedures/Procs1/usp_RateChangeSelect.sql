
/* -----------------------------------------------------------------------------------
   PROCEDURE:    usp_RateChangeSelect

   AUTHOR:       Jaime Forero 7/7/2010
   ----------------------------------------------------------------------------------- */

CREATE PROCEDURE [dbo].[usp_RateChangeSelect]
(
    @DateCreatedStart DATETIME = NULL,
    @DateCreatedEnd DATETIME = NULL,
    @Status INT = NULL,
    @ID INT = NULL,
    @EffectiveDate DATETIME = NULL,
    @AccountNumber VARCHAR(50) = NULL,
    @RateCode VARCHAR(50) = NULL,
    @UtilityID VARCHAR(50) = NULL,
    @RateChangeQueueID INT = NULL
)
As
BEGIN
	
	DECLARE @SQL_STMT nVarChar(1000) --N.B. string must be unicode for sp_executesql
	
	SELECT @SQL_STMT = 'SELECT U.Firstname, U.Lastname, RC.* FROM RateChange RC LEFT JOIN [User] U on U.UserID = RC.CreatedBy WHERE 1=1 ';
	
	IF @ID IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[ID] = ' + CAST(@ID as VARCHAR);
		
	IF @Status IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[Status] = ' + CAST(@Status AS VARCHAR);
		
	IF @EffectiveDate IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[EffectiveDate] = ''' + CAST(@EffectiveDate as VARCHAR) + '''';
	
	IF @AccountNumber IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[AccountNumber] = ''' + @AccountNumber + '''';
	
	IF @RateCode IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[RateCode] = ''' + @RateCode + '''';
	
	IF @UtilityID IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[UtilityID] = ''' + @UtilityID + '''';
	
	IF @RateChangeQueueID IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[RateChangeQueueID] = ' +  CAST(@RateChangeQueueID as VARCHAR);
	
	IF @DateCreatedStart IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[DateCreated] >= ''' + CAST(@DateCreatedStart as VARCHAR) + '''';
	
	IF @DateCreatedEnd IS NOT NULL 
		SET @SQL_STMT = @SQL_STMT + ' AND RC.[DateCreatedEnd] <= ''' + CAST(@DateCreatedEnd as VARCHAR) + '''';
		
	-- By using this sp we guarantee caching so it will behave like a regular SP
	EXEC sp_executesql @SQL_STMT;

END


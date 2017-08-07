
CREATE FUNCTION [dbo].[ufn_ConvertAccountType]
(
	@AccountTypeID			int,
	@ConvertToAccountType	varchar(20)
)
RETURNS int
AS
BEGIN
	DECLARE @ConvertedAccountTypeID	int

	IF @ConvertToAccountType = 'Libertypower'
		BEGIN
			SELECT		@ConvertedAccountTypeID	= 
			CASE 
				WHEN		@AccountTypeID			= 1 THEN 2
				WHEN		@AccountTypeID			= 2 THEN 3
				WHEN		@AccountTypeID			= 3 THEN 1
				ELSE		@AccountTypeID
			END
		END
	ELSE
		BEGIN
			SELECT		@ConvertedAccountTypeID	= 
			CASE 
				WHEN		@AccountTypeID			= 1 THEN 3
				WHEN		@AccountTypeID			= 2 THEN 1
				WHEN		@AccountTypeID			= 3 THEN 2
				ELSE		@AccountTypeID
			END		
		END

	RETURN @ConvertedAccountTypeID
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_ConvertAccountType] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_ConvertAccountType] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];


-- =============================================
-- Author:		Jaime Forero
-- Create date: 9/11/2012
-- Description:	To copy contact records from deal capture to new tables to be used with Genie process
-- =============================================

CREATE PROCEDURE [dbo].[usp_GenieNameCopy]
	(@p_contract_nbr VARCHAR(50),
	@p_account_id VARCHAR(50),
	@p_link INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @NameID				INT
			,@ErrorMessage		varchar(max)
			,@processDate		datetime
			
	set @processDate	= GETDATE()
		
	Insert Into LibertyPower.dbo.[Name] 
	(				
		[Name],
		[Modified],
		[DateCreated]
	)	
	Select		
		LTRIM(RTRIM(full_name)),
		@processDate,
		@processDate
	from deal_name with (NOLOCK)
	where contract_nbr                            = @p_contract_nbr
	and   name_link                               = @p_link

	SET @NameID = SCOPE_IDENTITY();

	IF EXISTS (	SELECT NULL
				FROM LibertyPower..CustomerName A WITH (NOLOCK)
				INNER JOIN LibertyPower..Account B (NOLOCK)
				ON B.CustomerID				= A.CustomerID
				WHERE B.AccountIdLegacy		= @p_account_id
				AND NameID					= 1)
		UPDATE LibertyPower..CustomerName
		SET NameId			= @NameID
		FROM LibertyPower..CustomerName A WITH (NOLOCK)
		INNER JOIN LibertyPower..Account B (NOLOCK)
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @p_account_id
		AND NameID					= 1
		
	ELSE
		
		INSERT INTO LibertyPower..CustomerName
		(				
			[CustomerID],
			[NameID],
			[CreatedBy],
			[ModifiedBy],
			[Modified],
			[DateCreated]
		)	

		SELECT A.CustomerID, @NameID , 1029, 1029, @processDate, @processDate
		FROM LibertyPower..Account (NOLOCK)		A 
		WHERE @p_account_id = A.AccountIdLegacy

	
END

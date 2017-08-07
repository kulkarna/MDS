-- =============================================
-- Author:		Jaime Forero
-- Create date: 9/11/2012
-- Description:	To copy contact records from deal capture to new tables to be used with Genie process
-- =============================================
CREATE PROCEDURE [dbo].[usp_GenieAddressCopy]
	(@p_contract_nbr VARCHAR(50),
	@p_account_id VARCHAR(50),
	@p_link INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	DECLARE @ProcessDate		DATETIME
		,@AddressID				INT;
	
	SET @ProcessDate			= GETDATE()
	
	Insert Into LibertyPower.dbo.[Address] 
	(
		Address1,
		Address2,
		City,
		[State],
		StateFips,
		Zip,
		County,
		CountyFips,				
		DateCreated
	)	
	SELECT  [address],
            suite,
            city,
            [state],
			state_fips,
            zip,
            county,
            county_fips,
            @ProcessDate
      from deal_address with (nolock)
      where contract_nbr                            = @p_contract_nbr
      and   address_link                            = @p_link

	SET @AddressID = SCOPE_IDENTITY();

	IF EXISTS (	SELECT NULL
			FROM LibertyPower..CustomerAddress A WITH (NOLOCK)
			INNER JOIN LibertyPower..Account B (NOLOCK)
			ON B.CustomerID				= A.CustomerID
			WHERE B.AccountIdLegacy		= @p_account_id
			AND AddressID				= 1)
		UPDATE LibertyPower..CustomerAddress
		SET AddressID			= @AddressID
		FROM LibertyPower..CustomerName A WITH (NOLOCK)
		INNER JOIN LibertyPower..Account B (NOLOCK)
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @p_account_id
		AND AddressID				= 1
		
	ELSE
	
		INSERT INTO LibertyPower..CustomerAddress
		(				
			[CustomerID],
			[AddressID],
			[CreatedBy],
			[ModifiedBy],
			[Modified],
			[DateCreated]
		)	

		SELECT A.CustomerID, @AddressID , 1029, 1029, @ProcessDate, @ProcessDate
		FROM  LibertyPower..Account (NOLOCK) A		
		WHERE @p_account_id = A.AccountIdLegacy

	
END

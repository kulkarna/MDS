-- =============================================
-- Author:		Jaime Forero
-- Create date: 9/11/2012
-- Description:	To copy contact records from deal capture to new tables to be used with Genie process
-- =============================================
CREATE PROCEDURE [dbo].[usp_GenieContactCopy]
	(@p_contract_nbr VARCHAR(50),
	@p_account_id VARCHAR(50),
	@p_link INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ProcessDate		DATETIME
			,@ContactID			INT
	
	SET @ProcessDate			= GETDATE()
	
	Insert Into LibertyPower.dbo.[Contact] 
	(						
		[FirstName],
		[LastName],
		[Title],
		[Phone],
		[Fax],
		[Email],
		[Birthdate],		
		[DateCreated]
	)	
	Select TOP(1) -- For safety
		[first_name],
		[last_name],
		[title],
		[phone],
		[fax],
		[email],
		Case When isdate(birthday + '/1900') = 1 Then  convert(datetime, birthday + '/1900', 101)
		Else null
		End as [Birthdate],     
		@ProcessDate
	From deal_contact with (nolock)
	where contract_nbr                            = @p_contract_nbr
	and   contact_link                            = @p_link


	SET @ContactID = SCOPE_IDENTITY();

	IF EXISTS (	SELECT NULL
			FROM LibertyPower..CustomerContact A WITH (NOLOCK)
			INNER JOIN LibertyPower..Account B (NOLOCK)
			ON B.CustomerID				= A.CustomerID
			WHERE B.AccountIdLegacy		= @p_account_id
			AND ContactID				= 1)
		
		UPDATE LibertyPower..CustomerContact
		SET ContactID			= @ContactID
		FROM LibertyPower..CustomerContact A WITH (NOLOCK)
		INNER JOIN LibertyPower..Account B (NOLOCK)
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @p_account_id
		AND ContactID				= 1
		
	ELSE
		INSERT INTO LibertyPower..CustomerContact
		(				
			[CustomerID],
			 ContactID,
			[CreatedBy],
			[ModifiedBy],
			[Modified],
			[DateCreated]
		)	
		SELECT A.CustomerID, @ContactID , 1029, 1029, @ProcessDate, @ProcessDate
		FROM LibertyPower..Account (NOLOCK)		A 
		WHERE @p_account_id = A.AccountIdLegacy

	
END

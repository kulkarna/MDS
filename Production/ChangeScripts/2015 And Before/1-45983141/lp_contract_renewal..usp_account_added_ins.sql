USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_added_ins]    Script Date: 12/20/2012 13:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Ticket 23125
-- =============================================

--select * from ufn_account_detail('LAPTOPSALMEIRAO\Marcio Salmeirao')


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/14/2007
-- Description:	Add new account to account database
-- =============================================
-- Modified: Gail Mangaroo 10/26/2007
-- Added parameter for @p_future_ernoll_date to call to lp_account..usp_account_ins 
-- ===============================================
-- Modified: Eric Hernandez 11/09/2010
-- ticket 19485
-- Made the date_por_enrollment have the correct value based on utility lead time.
-- Also made sure the initial status of add-on accounts are correct.
-- ===============================================
-- Modified: Isabelle Tamanini 4/12/2011
-- ticket 22541 
-- Increasing the contract type field length from 15 to 25 to match the column lenght
-- in the table
-- ===============================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Added new table deal_account_contact into the query
-- Added new table deal_account_name into the query
-- Ticket 23125
-- =============================================
-- Modified Gabor Kovacs 05/9/2012
-- Added a null to the insertion of account_contact, account_address, and account_name.
-- The null is required since those are no longer tables, but views which have an extra field.
-- =====================================================================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove print)
-- Put WITH (NOLOCK) in the Select querys
-- Add @p_account_id parameter
-- =======================================
-- Modified 12/20/2012 - Rick Deigsler
-- Added code to get link ids for name, address and contact
-- =======================================

ALTER PROCEDURE [dbo].[usp_account_added_ins]
(
	@p_username				nchar(100) ,
	@p_account_number		varchar(30) ,
	@p_application			varchar(20) = ' ' OUTPUT ,
	@p_error				char(01) = ' ' OUTPUT ,
	@p_msg_id				char(08) = ' ' OUTPUT ,
	@p_descp_add			varchar(100) = ' ' OUTPUT, 
	@p_account_id			varchar(12)		= '')
AS

DECLARE @w_error				char(01)
	,@w_msg_id					char(08)
	,@w_return					int
	,@w_descp_add				varchar(100)
	,@w_application				varchar(20)
	,@w_rowcount				int
	,@w_getdate					datetime
	,@w_duns_number_entity		varchar(255)
	,@w_account_id				char(12)
	,@w_account_number			varchar(30)
	,@w_status					varchar(15)
	,@w_sub_status				varchar(15)
	,@w_entity_id				char(15)
	,@w_contract_nbr			char(12)
	,@w_contract_type			varchar(25)
	,@w_retail_mkt_id			char(02)
	,@w_utility_id				char(15)
	,@w_product_id				char(20)
	,@w_rate_id					int
	,@w_rate					float
	,@w_account_name_link		int
	,@w_customer_name_link		int
	,@w_customer_address_link	int
	,@w_customer_contact_link	int
	,@w_billing_address_link	int
	,@w_billing_contact_link	int
	,@w_owner_name_link			int
	,@w_service_address_link	int
	,@w_business_type			varchar(35)
	,@w_business_activity		varchar(35)
	,@w_additional_id_nbr_type	varchar(10)
	,@w_additional_id_nbr		varchar(30)
	,@w_contract_eff_start_date datetime
	,@w_term_months				int
	,@w_date_end				datetime
	,@w_date_deal				datetime
	,@w_date_created			datetime
	,@w_date_submit				datetime
	,@w_sales_channel_role		nvarchar(50)
	,@w_username				nchar(100)
	,@w_sales_rep				varchar(100)
	,@w_origin					varchar(50)
	,@w_annual_usage			money  --cevans shoule be cast to int before passing to usp_account_ins
	,@w_date_flow_start			datetime
	,@w_date_por_enrollment		datetime
	,@w_date_deenrollment		datetime
	,@w_date_reenrollment		datetime
	,@w_tax_status				varchar(20)
	,@w_tax_float				int
	,@w_credit_score			real
	,@w_credit_agency			varchar(30)
	,@w_por_option				varchar(03)
	,@w_billing_type			varchar(15)
	,@w_requested_flow_start_date datetime	--cevans 9/23/2009 INF40
	,@w_deal_type				char(20)			--cevans 9/23/2009 INF40
	,@w_customer_code			char(101)		--cevans 9/23/2009 INF40
	,@w_customer_group			char(100)		--cevans 9/23/2009 INF40
	,@w_enrollment_type			int				--cevans 9/23/2009 INF40
	,@w_risk_request_id			varchar(50)
	,@w_renew					tinyint
	,@UserID					int
	,@AccountNameID				int
	,@CustNameID				int
	,@OwnerNameID				int
	,@CustAddressID				int
	,@BillAddressID				int
	,@ServAddressID				int
	,@CustContactID				int
	,@BillContactID				int
	,@Address1					varchar(150)
	,@Address2					varchar(150)
	,@City						varchar(100)
	,@State						char(2)
	,@StateFips					char(2)
	,@Zip						char(10)
	,@County					varchar(100)
	,@CountyFips				char(3)
	,@FirstName					varchar(50)
	,@LastName					varchar(50)
	,@Title						varchar(50)
	,@Phone						varchar(20)
	,@Fax						varchar(20)
	,@Email						varchar(75)
	,@Birthdate					varchar(20)
	,@BDate						datetime	
	
SELECT
	@w_error			= 'I'
	,@w_msg_id			= '00000001'
	,@w_return			= 0
	,@w_descp_add		= ' '
	,@w_application		= 'COMMON'
	,@w_getdate			= getdate()
	,@w_descp_add		= ' '
	
--select @w_getdate                                   = date_submit
--from deal_contract_account with (NOLOCK)
--where account_number                                = @p_account_number

SELECT	@UserID		= ISNULL(UserID, 0)
FROM	Libertypower..[User] WITH (NOLOCK)
WHERE	Username	= @p_username

SELECT
	@w_account_id = ''
	,@w_account_number = ''
	,@w_entity_id = ''
	,@w_contract_nbr = ''
	,@w_contract_type = ''
	,@w_retail_mkt_id = ''
	,@w_utility_id = ''
	,@w_product_id = ''
	,@w_rate_id = 0
	,@w_rate = 0
	,@w_account_name_link = 0
	,@w_customer_name_link = 0
	,@w_customer_address_link = 0
	,@w_customer_contact_link = 0
	,@w_billing_address_link = 0
	,@w_billing_contact_link = 0
	,@w_owner_name_link = 0
	,@w_service_address_link = 0
	,@w_business_type = ''
	,@w_business_activity = ''
	,@w_additional_id_nbr_type = ''
	,@w_additional_id_nbr = ''
	,@w_contract_eff_start_date = '19000101'
	,@w_term_months = 0
	,@w_date_end = '19000101'
	,@w_date_deal = '19000101'
	,@w_date_created = '19000101'
	,@w_sales_channel_role = ''
	,@w_username = ''
	,@w_sales_rep = ''
	,@w_origin = ''
	,@w_date_submit = @w_getdate
	,@w_annual_usage = 0
	,@w_date_flow_start = '19000101'
	,@w_date_por_enrollment = '19000101'
	,@w_date_deenrollment = '19000101'
	,@w_date_reenrollment = '19000101'
	,@w_tax_status = 'FULL'
	,@w_tax_float = 0
	,@w_credit_score = 0
	,@w_credit_agency = 'NONE'
	,@w_por_option = 'NO'
	,@w_renew = 1
	,@w_status = ''
	,@w_sub_status = ''
	,@w_entity_id = ''


SELECT
	@w_account_id				= account_id ,
	@w_contract_nbr				= contract_nbr ,
	@w_account_number			= account_number ,
	@w_contract_type			= contract_type ,
	@w_retail_mkt_id			= retail_mkt_id ,
	@w_utility_id				= utility_id ,
	@w_product_id				= product_id ,
	@w_rate_id					= rate_id ,
	@w_rate						= rate ,
	@w_account_name_link		= account_name_link ,
	@w_customer_name_link		= customer_name_link ,
	@w_customer_address_link	= customer_address_link ,
	@w_customer_contact_link	= customer_contact_link ,
	@w_billing_address_link		= billing_address_link ,
	@w_billing_contact_link		= billing_contact_link ,
	@w_owner_name_link			= owner_name_link ,
	@w_service_address_link		= service_address_link ,
	@w_business_type			= business_type ,
	@w_business_activity		= business_activity ,
	@w_additional_id_nbr_type	= additional_id_nbr_type ,
	@w_additional_id_nbr		= additional_id_nbr ,
	@w_contract_eff_start_date	= contract_eff_start_date ,
	@w_term_months				= term_months ,
	@w_date_end					= date_end ,
	@w_date_deal				= date_deal ,
	@w_date_created				= date_created ,
	@w_sales_channel_role		= sales_channel_role ,
	@w_username					= username ,
	@w_sales_rep				= sales_rep ,
	@w_origin					= origin ,
	@w_annual_usage				= annual_usage ,
	@w_renew = renew --cevans 20090923 INF40,
	--@w_requested_flow_start_date = isnull(requested_flow_start_date , '19000101') , --cevans 20090923 INF40
	--@w_deal_type = isnull(deal_type , '') , --cevans 20090923 INF40
	--@w_customer_code = isnull(customer_code , '') , --cevans 20090923 INF40
	--@w_customer_group = isnull(customer_group , '') , --cevans 20090923 INF40
--@w_enrollment_type = isnull(enrollment_type , 1) --cevans 20090923 INF40
FROM
    deal_contract_account WITH ( NOLOCK )
WHERE  account_number	= @p_account_number
and account_id			= CASE WHEN @p_account_id = '' THEN account_id ELSE @p_account_id END

SET @w_rowcount = @@rowcount

SELECT
    @w_entity_id		= entity_id ,
    @w_por_option		= por_option ,
    @w_billing_type		= billing_type
FROM
    lp_common..common_utility b WITH ( NOLOCK )
WHERE
    utility_id = @w_utility_id

BEGIN TRAN val_usp_account_added_ins

EXEC @w_return = lp_account..usp_account_additional_info_ins @p_username , @w_account_id , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , 1 , @w_date_flow_start , @w_error OUTPUT , @w_msg_id OUTPUT , ' ' , 'N'

IF @w_return <> 0
BEGIN
	ROLLBACK TRAN val_usp_account_added_ins
	SELECT
		@w_application	= 'COMMON'
		,@w_error		= 'E'
		,@w_msg_id		= '00000051'
		,@w_return		= 1
		,@w_descp_add	= ' (Insert Account Additional Info) '
		
	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
END

-- =================  BEGIN  =============================
-- Modified 12/20/2012 - Rick Deigsler
-- Added code to get link ids for name, address and contact
-- =======================================================
IF NOT EXISTS ( SELECT account_id
		FROM lp_account..account_name WITH ( NOLOCK )
		WHERE account_id	= @w_account_id )
BEGIN
	DECLARE @Name	varchar(100)
	
	-- account name  -------------------------------------------------------------------------		
	SELECT	@Name		= ISNULL(full_name, '')
	FROM	deal_account_name with (nolock index = account_name_idx)
	WHERE	account_id	= @w_account_id 
	AND		name_link	= @w_account_name_link			

	EXECUTE @AccountNameID  = Libertypower..usp_NameInsert @Name, @UserID, @UserID, 1;
	
	INSERT INTO deal_account_name 
	SELECT @w_account_id, @AccountNameID, @Name ,0
	
	INSERT INTO lp_account..account_name
	SELECT null, @w_account_id, @AccountNameID, @Name, 0
	
	UPDATE	deal_contract_account
	SET		account_name_link	= @AccountNameID
	WHERE	account_id			= @w_account_id
	
	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Account Name)'
			
		EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
		GOTO goto_select
	END
	
	-- customer name  ---------------------------------------------------------------------------
	SELECT	@Name		= ISNULL(full_name, '')
	FROM	deal_account_name with (nolock index = account_name_idx)
	WHERE	account_id	= @w_account_id 
	AND		name_link	= @w_customer_name_link			

	EXECUTE @CustNameID  = Libertypower..usp_NameInsert @Name, @UserID, @UserID, 1;
	
	INSERT INTO deal_account_name 
	SELECT @w_account_id, @CustNameID, @Name ,0
	
	INSERT INTO lp_account..account_name
	SELECT null, @w_account_id, @CustNameID, @Name, 0
	
	UPDATE	deal_contract_account
	SET		customer_name_link	= @CustNameID
	WHERE	account_id			= @w_account_id	

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Customer Name)'
		EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
		GOTO goto_select
	END	
	
	-- owner name  ---------------------------------------------------------------------------
	SELECT	@Name		= ISNULL(full_name, '')
	FROM	deal_account_name with (nolock index = account_name_idx)
	WHERE	account_id	= @w_account_id 
	AND		name_link	= @w_owner_name_link			

	EXECUTE @OwnerNameID  = Libertypower..usp_NameInsert @Name, @UserID, @UserID, 1;
	
	INSERT INTO deal_account_name 
	SELECT @w_account_id, @OwnerNameID, @Name ,0
	
	INSERT INTO lp_account..account_name
	SELECT null, @w_account_id, @OwnerNameID, @Name, 0	
	
	UPDATE	deal_contract_account
	SET		owner_name_link		= @OwnerNameID
	WHERE	account_id			= @w_account_id		
	
	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Owner Name)'
			
		EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
		GOTO goto_select
	END	
END

IF NOT EXISTS ( SELECT account_id
                FROM lp_account..account_address WITH ( NOLOCK )
                WHERE account_id = @w_account_id )
BEGIN
	-- customer address  ------------------------------------------------------------------------
	SELECT	@Address1 = ISNULL([address], ''), @Address2 = ISNULL(suite, ''), @City = ISNULL(city, ''), @State = ISNULL([state], ''), @StateFips = ISNULL(state_fips, ''), @Zip = ISNULL(zip, ''), @County = ISNULL(county, ''), @CountyFips = ISNULL(county_fips, '')
	FROM	deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @w_account_id 
	AND		address_link	= @w_customer_address_link
	
	EXECUTE @CustAddressID	= Libertypower..usp_AddressInsert @Address1, @Address2, @City, @State, @StateFips, @Zip, @County, @CountyFips, @UserID, @UserID, 1	

	INSERT INTO deal_account_address
	SELECT @w_account_id, @CustAddressID, Address1, Address2, City, [State], StateFips, Zip, County, CountyFips, 0
	FROM Libertypower..[Address] WITH ( NOLOCK )
	WHERE AddressID  =  @CustAddressID
	
	INSERT INTO lp_account..account_address
	SELECT null, account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM deal_account_address WITH ( NOLOCK )
	WHERE account_id	= @w_account_id 
	AND address_link	= @CustAddressID
	
	UPDATE	deal_contract_account
	SET		customer_address_link	= @CustAddressID
	WHERE	account_id				= @w_account_id		

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Customer Address)'
			
	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
	END
	
	-- billing address  ------------------------------------------------------------------------
	SELECT	@Address1 = ISNULL([address], ''), @Address2 = ISNULL(suite, ''), @City = ISNULL(city, ''), @State = ISNULL([state], ''), @StateFips = ISNULL(state_fips, ''), @Zip = ISNULL(zip, ''), @County = ISNULL(county, ''), @CountyFips = ISNULL(county_fips, '')
	FROM	deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @w_account_id 
	AND		address_link	= @w_billing_address_link
	
	EXECUTE @BillAddressID	= Libertypower..usp_AddressInsert @Address1, @Address2, @City, @State, @StateFips, @Zip, @County, @CountyFips, @UserID, @UserID, 1		

	INSERT INTO deal_account_address
	SELECT @w_account_id, @BillAddressID, Address1, Address2, City, [State], StateFips, Zip, County, CountyFips, 0
	FROM Libertypower..[Address] WITH ( NOLOCK )
	WHERE AddressID  =  @BillAddressID
	
	INSERT INTO lp_account..account_address
	SELECT null, account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM deal_account_address WITH ( NOLOCK )
	WHERE account_id	= @w_account_id 
	AND address_link	= @BillAddressID
	
	UPDATE	deal_contract_account
	SET		billing_address_link	= @BillAddressID
	WHERE	account_id				= @w_account_id			

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Billing Address)'
			
	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
	END	
	
	-- service address  ------------------------------------------------------------------------
	SELECT	@Address1 = ISNULL([address], ''), @Address2 = ISNULL(suite, ''), @City = ISNULL(city, ''), @State = ISNULL([state], ''), @StateFips = ISNULL(state_fips, ''), @Zip = ISNULL(zip, ''), @County = ISNULL(county, ''), @CountyFips = ISNULL(county_fips, '')
	FROM	deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @w_account_id 
	AND		address_link	= @w_service_address_link
	
	EXECUTE @ServAddressID	= Libertypower..usp_AddressInsert @Address1, @Address2, @City, @State, @StateFips, @Zip, @County, @CountyFips, @UserID, @UserID, 1			

	INSERT INTO deal_account_address
	SELECT @w_account_id, @ServAddressID, Address1, Address2, City, [State], StateFips, Zip, County, CountyFips, 0
	FROM Libertypower..[Address] WITH ( NOLOCK )
	WHERE AddressID  =  @ServAddressID
	
	INSERT INTO lp_account..account_address
	SELECT null, account_id, @ServAddressID, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM deal_account_address WITH ( NOLOCK )
	WHERE account_id	= @w_account_id 
	AND address_link	= @ServAddressID
	
	UPDATE	deal_contract_account
	SET		service_address_link	= @ServAddressID
	WHERE	account_id				= @w_account_id		

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Service Address)'
			
	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
	END		
END

IF NOT EXISTS ( SELECT account_id
                FROM lp_account..account_contact WITH ( NOLOCK )
                WHERE account_id	= @w_account_id )
BEGIN

	SET	@BDate = CAST('1/1/1900' AS datetime)
	
	-- customer contact  -----------------------------------------------------------------------
	SELECT	@FirstName = first_name, @LastName = last_name, @Title = title, @Phone = phone, @Fax = fax, @Email = email, @Birthdate = isnull(birthday , '01/01')
	FROM	deal_account_contact with (nolock index = account_contact_idx)
	WHERE	account_id		= @w_account_id  
	AND		contact_link	= @w_customer_contact_link
	
	EXECUTE @CustContactID	= [Libertypower].[dbo].[usp_ContactInsert] @FirstName, @LastName, @Title, @Phone, @Fax, @Email, @BDate, @UserID, @UserID, 1			  
	
	INSERT INTO deal_account_contact 
	SELECT @w_account_id, @CustContactID, FirstName, LastName, Title, Phone, Fax, Email, BirthDate, 0
	FROM LIBERTYPOWER..CONTACT WITH ( NOLOCK )
	WHERE CONTACTID  = @CustContactID
	
	INSERT	INTO lp_account..account_contact
	SELECT	null, account_id, @CustContactID, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	deal_account_contact with (nolock index = account_contact_idx)
	WHERE	account_id		= @w_account_id  
	AND		contact_link	= @CustContactID
	
	UPDATE	deal_contract_account
	SET		customer_contact_link	= @CustContactID
	WHERE	account_id				= @w_account_id		

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Customer Contact)'
			
		EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
		GOTO goto_select
	END
	
	-- billing contact  -----------------------------------------------------------------------
	SELECT	@FirstName = first_name, @LastName = last_name, @Title = title, @Phone = phone, @Fax = fax, @Email = email, @Birthdate = isnull(birthday , '01/01')
	FROM	deal_account_contact with (nolock index = account_contact_idx)
	WHERE	account_id		= @w_account_id  
	AND		contact_link	= @w_billing_contact_link
	
	EXECUTE @BillContactID	= [Libertypower].[dbo].[usp_ContactInsert] @FirstName, @LastName, @Title, @Phone, @Fax, @Email, @BDate, @UserID, @UserID, 1			  			  

	INSERT INTO deal_account_contact 
	SELECT @w_account_id, @BillContactID, FirstName, LastName, Title, Phone, Fax, Email, BirthDate, 0
	FROM LIBERTYPOWER..CONTACT WITH ( NOLOCK )
	WHERE CONTACTID  = @BillContactID
	
	INSERT	INTO lp_account..account_contact
	SELECT	null, account_id, @BillContactID, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	deal_account_contact with (nolock index = account_contact_idx)
	WHERE	account_id		= @w_account_id  
	AND		contact_link	= @BillContactID
	
	UPDATE	deal_contract_account
	SET		billing_contact_link	= @BillContactID
	WHERE	account_id				= @w_account_id		

	IF @@error <> 0 OR @@rowcount = 0
	BEGIN
		ROLLBACK TRAN val_usp_account_added_ins
		SELECT
			@w_application	= 'COMMON'
			,@w_error		= 'E'
			,@w_msg_id		= '00000051'
			,@w_return		= 1
			,@w_descp_add	= '(Insert Customer Contact)'
			
		EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
		GOTO goto_select
	END	
END
-- ==================  END  ==============================
-- Modified 12/20/2012 - Rick Deigsler
-- Added code to get link ids for name, address and contact
-- =======================================================

SELECT
    @w_return = 1
EXEC @w_return = lp_account..usp_account_status_history_ins @w_username , @w_account_id , @w_status , @w_sub_status , @w_getdate , 'RENEWAL' , @w_utility_id , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , @w_getdate , @w_error OUTPUT , @p_msg_id OUTPUT , ' ' 
, 'N'


IF @w_return <> 0
BEGIN
	ROLLBACK TRAN val_usp_account_added_ins
	SELECT
		@w_application	= 'COMMON'
		,@w_error		= 'E'
		,@w_msg_id		= '00000051'
		,@w_return		= 1
		,@w_descp_add	= ' (Insert History Account) '
	
	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
END


-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.
-- We take the expected start date, derive the beginning of that month, then subtract the lead time.
SELECT @w_date_por_enrollment = dateadd(dd, -enrollment_lead_days, dateadd(m,datediff(m,0,@w_contract_eff_start_date),0))
FROM lp_common.dbo.common_utility (NOLOCK)
WHERE utility_id = @w_utility_id

SELECT top 1 @w_status	= isnull(wait_status,'01000')
	,@w_sub_status		= isnull(wait_sub_status,'01000')
FROM lp_common..common_utility_check_type ch with (nolock)
WHERE ch.contract_type	= @w_contract_type
AND	ch.utility_id		= @w_utility_id
AND ch.Check_Type		<> 'CHECK ACCOUNT'
ORDER BY [order]

set  @w_return = 1

EXEC @w_return = lp_account..usp_account_ins 
@p_username , 
@p_account_id = @w_account_id , 
@p_account_number=@w_account_number , 
@p_account_type='SMB' , 
@p_status=@w_status , 
@p_sub_status=@w_sub_status , 
@p_customer_id=' ' , 
@p_entity_id=@w_entity_id , 
@p_contract_nbr=@w_contract_nbr , 
@p_contract_type=@w_contract_type , 
@p_retail_mkt_id=@w_retail_mkt_id , 
@p_utility_id=@w_utility_id , 
@p_product_id=@w_product_id , 
@p_rate_id=@w_rate_id , 
@p_rate=@w_rate , 
@p_account_name_link		=	@AccountNameID , 
@p_customer_name_link		=	@CustNameID , 
@p_customer_address_link	=	@CustAddressID , 
@p_customer_contact_link	=	@CustContactID , 
@p_billing_address_link		=	@BillAddressID , 
@p_billing_contact_link		=	@BillContactID , 
@p_owner_name_link			=	@OwnerNameID , 
@p_service_address_link		=	@ServAddressID , 
@p_business_type=@w_business_type , 
@p_business_activity=@w_business_activity , 
@p_additional_id_nbr_type=@w_additional_id_nbr_type , 
@p_additional_id_nbr=@w_additional_id_nbr ,
--@w_getdate,				-- GM 10/25/2007 cevans 9/23/2009 removed with INF95/40 Merge
@p_contract_eff_start_date=@w_contract_eff_start_date ,
@p_term_months=@w_term_months , 
@p_date_end=@w_date_end , 
@p_date_deal=@w_date_deal , 
@p_date_created=@w_date_created , 
@p_date_submit=@w_date_submit , 
@p_sales_channel_role=@w_sales_channel_role , 
@p_sales_rep=@w_sales_rep , 
@p_origin=@w_origin , 
@p_annual_usage=@w_annual_usage , 
@p_date_flow_start=@w_date_flow_start , 
@p_date_por_enrollment=@w_date_por_enrollment , 
@p_date_deenrollment=@w_date_deenrollment , 
@p_date_reenrollment=@w_date_reenrollment , 
@p_tax_status=@w_tax_status , 
@p_tax_float=@w_tax_float , 
@p_credit_score=@w_credit_score , 
@p_credit_agency=@w_credit_agency , 
@p_por_option=@w_por_option , 
@p_billing_type=@w_billing_type , 
@p_billing_group='' ,	--@p_billing_group = '',				--cevans  9/23/2009
@p_icap='' ,	--@p_icap = '',							--cevans  9/23/2009
@p_tcap='' ,	--@p_tcap = '',							--cevans  9/23/2009
@p_load_profile='' ,	--@p_load_profile = '',					--cevans  9/23/2009
@p_loss_code='' ,	--@p_loss_code = '',					--cevans  9/23/2009
@p_meter_type='' ,	--@p_meter_type = '',					--cevans  9/23/2009
@p_requested_flow_start_date=NULL, --@w_requested_flow_start_date ,		--cevans  9/23/2009
@p_deal_type=NULL, --@w_deal_type ,								--cevans  9/23/2009
@p_enrollment_type=NULL, --@w_enrollment_type ,					--cevans  9/23/2009
@p_customer_code=NULL, --@w_customer_code , 					--cevans  9/23/2009
@p_customer_group=NULL, --@w_customer_group , 					--cevans  9/23/2009
@p_error=@w_error, 
@p_msg_id=@w_msg_id, 
@p_descp=' ' , 
@p_result_ind='N'

IF @w_return <> 0
BEGIN
	ROLLBACK TRAN val_usp_account_added_ins
	SELECT
		@w_application	= 'COMMON'
		,@w_error		= 'E'
		,@w_msg_id		= '00000051'
		,@w_return		= 1
		,@w_descp_add	= ' (Insert Account) '

	EXEC usp_contract_error_ins 'RENEWAL' , @w_contract_nbr , @w_account_number , @w_application , @w_error , @w_msg_id , @w_descp_add
	GOTO goto_select
END


COMMIT TRAN val_usp_account_added_ins
RETURN @w_return

goto_select:

SELECT
    @p_application = @w_application ,
    @p_error = @w_error ,
    @p_msg_id = @w_msg_id ,
    @p_descp_add = @w_descp_add

RETURN @w_return



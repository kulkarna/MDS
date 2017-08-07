
CREATE PROCEDURE [dbo].[sp_getAccountInfo] (
	@accountNumber varchar(30) = 0, @zipcode varchar(10)) AS -- Implies that: there is at least one entry or more in account_address, account_contact, account_name
BEGIN
	SET NOCOUNT ON;

	IF @zipcode IS NULL OR @zipcode = '' 
		SELECT 
			TOP 1 
				d.full_name
			, c.first_name
			, c.last_name
			, c.phone
			, c.email
			, b.address
			, b.city
			, b.state
			, b.zip
			, a.sales_rep 
		FROM 
			lp_account..account AS a with (nolock)
		left join lp_account..account_address AS b with (nolock) 
		on a.account_id = b.account_id
		and a.service_address_link = b.address_link
		left join lp_account..account_contact AS c with (nolock)
		on a.account_id = c.account_id
		and a.customer_contact_link = c.contact_link
		left join lp_account..account_name AS d with (nolock)
		on a.account_id = d.account_id
		and a.account_name_link = d.name_link
		WHERE 
			a.account_id=b.account_id AND a.account_id=c.account_id AND a.account_id=d.account_id 
		AND 
			a.account_type<>'RESIDENTIAL' AND (a.status='905000' OR a.status='906000') 
		AND 
			a.account_number=@accountNumber;
	ELSE
		SELECT 
			TOP 1 
				d.full_name, c.first_name, c.last_name, c.phone, c.email, b.address, b.city, b.state, b.zip, a.sales_rep 
		FROM 
			lp_account..account AS a with (nolock)
		left join lp_account..account_address AS b with (nolock) 
		on a.account_id = b.account_id
		and a.service_address_link = b.address_link
		left join lp_account..account_contact AS c with (nolock)
		on a.account_id = c.account_id
		and a.customer_contact_link = c.contact_link
		left join lp_account..account_name AS d with (nolock)
		on a.account_id = d.account_id
		and a.account_name_link = d.name_link
		WHERE 
			a.account_id=b.account_id AND a.account_id=c.account_id AND a.account_id=d.account_id 
		AND 
			a.account_type<>'RESIDENTIAL' AND (a.status='905000' OR a.status='906000') 
		AND 
			a.account_number=@accountNumber AND b.zip=@zipcode;
END;

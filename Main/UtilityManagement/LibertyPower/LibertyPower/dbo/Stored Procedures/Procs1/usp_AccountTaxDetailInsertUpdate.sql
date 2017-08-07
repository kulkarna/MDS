
-- =============================================
-- Created: Isabelle Tamanini 12/15/2010
-- Inserts or updates the tax details in account 
-- tax details table  
-- SD20278
-- =================================================

CREATE PROCEDURE [dbo].[usp_AccountTaxDetailInsertUpdate]
(
    @p_tax_type_id int,
    @p_percent_taxable decimal(9,6),
	@p_account_id varchar(25)
)
   
AS
if not exists(select * from AccountTaxDetail where accountID = @p_account_id and taxTypeid = @p_tax_type_id)
	begin		
		insert into AccountTaxDetail (TaxTypeID, PercentTaxable, AccountID)
		values  (@p_tax_type_id,  @p_percent_taxable, @p_account_id) 	
	end
else
	begin
		update AccountTaxDetail
		set PercentTaxable = @p_percent_taxable
		where accountID = @p_account_id and TaxTypeID = @p_tax_type_id
	end
	



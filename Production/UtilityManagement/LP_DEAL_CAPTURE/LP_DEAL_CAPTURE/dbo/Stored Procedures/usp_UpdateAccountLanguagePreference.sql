



-- =============================================
--	Author:			Ryan Russon
--	Create date:	08/03/2011
--	Description:	Updates language preference for all Accounts based off a printed template (usually a contract they signed)
--	Usage Example:	EXEC lp_documents..usp_UpdateAccountLanguagePreference @ContractNumber='172-15815', @TemplateVersionId=716
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateAccountLanguagePreference] (
	@ContractNumber			varchar(20),
	@TemplateVersionId		int
)

AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @LanguageId		int

--Get LanguageId based off template language
	SELECT	@LanguageId = MIN(dt.LanguageId)
	FROM lp_documents..TemplateVersions		v (NOLOCK)
	JOIN lp_documents..document_template	dt (NOLOCK)
		ON dt.template_id = v.TemplateId
	WHERE v.TemplateVersionId = @TemplateVersionId

--Update language for all existing accounts tied to passed ContractNumber		--Is this ever necessary?  Should be set on saving/creation of contract.
	UPDATE LibertyPower..AccountLanguage
	SET LanguageId = @LanguageId
	FROM lp_Account..account	a (NOLOCK)
	JOIN LibertyPower..AccountLanguage al (NOLOCK)
		ON a.account_number = al.AccountNumber
	WHERE a.contract_nbr = @ContractNumber

--Add language associations for all accounts based on ContractNumber
	INSERT INTO LibertyPower..AccountLanguage
		(AccountNumber, LanguageId)
	SELECT
		a.account_number, @LanguageId
	FROM lp_Account..account					a (NOLOCK)
	LEFT JOIN LibertyPower..AccountLanguage		al (NOLOCK)
		ON a.account_number = al.AccountNumber
	WHERE al.AccountNumber IS NULL	--Select only accounts that are missing from the AccountLanguage table
	AND a.contract_nbr = @ContractNumber
END



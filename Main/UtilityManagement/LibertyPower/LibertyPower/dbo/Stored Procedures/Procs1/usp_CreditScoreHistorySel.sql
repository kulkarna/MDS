-- =============================================================
-- Author:		Antonio Jr
-- Create date: 9/28/2009
-- Description:	Gets the last record in the History
--              given the Contract, Account  and score
-- =============================================================
CREATE proc [dbo].[usp_CreditScoreHistorySel] 
	@p_contract_nbr VARCHAR(30),
	@p_account_nbr varCHAR(30),
	@p_score NUMERIC(8,2) = NULL
AS
BEGIN
	
	SET NOCOUNT ON;
	
	declare @sqlQuery nvarchar(4000)
	declare @paramDefinition nvarchar(1000)
	
	set @sqlQuery = 'SELECT TOP 1
						CreditScoreHistoryID,CustomerName, StreetAddress, City, [State], ZipCode,
						DateAcquired, AgencyReferenceID, CreditAgencyID, Score,
						ScoreType, FullXMLReport, Source, CustomerID,
						Contract_nbr, Account_nbr, Username, DateCreated
						FROM dbo.CreditScoreHistory                      
					WHERE (Account_nbr = @x_account_nbr OR  Contract_nbr = @x_contract_nbr)' 
    
    if @p_score is null
    	set @sqlQuery = @sqlQuery + ' and (Score is null)'
    else
		set @sqlQuery = @sqlQuery + ' and (Score = @x_score)'
       
	SET @sqlquery = @sqlquery + ' ORDER BY DateAcquired DESC '
	
	set @paramDefinition = '@x_contract_nbr VARCHAR(30),
							@x_account_nbr varCHAR(30),
							@x_score NUMERIC(8,2) '



	execute sp_Executesql @sqlQuery,
                          @paramDefinition,
                          @x_contract_nbr = @p_contract_nbr,
                          @x_account_nbr = @p_account_nbr,
                          @x_score = @p_score
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreHistorySel';


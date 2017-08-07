-- ==========================================================================
-- Author:		Antonio Jr
-- Create date: April, 17, 2009
-- Description:	Gets the list of Credit Score Criteria depending on filters
-- p_status = 0 (Gets only non expired records), = 1 (Gets the last record)
--          > 1 (Gets all records) 
-- p_CriteriaSetId = null (Gets the default set), = -1 (Gets all sets)
-- ==========================================================================

CREATE proc [dbo].[usp_CreditScoreCriteriaHeaderSelectList] 
	@p_CreditAgencyID int = 0,
	@p_status int = 0,
	@p_CriteriaSetId int = null
	
AS
BEGIN
	
	SET NOCOUNT ON;

    declare @sqlQuery nvarchar(4000)
	declare @paramDefinition nvarchar(1000)
	
	set @sqlQuery = 'SELECT  CreditScoreCriteriaHeaderID, CreditAgencyID , EffectiveDate, ExpirationDate, CreatedBy, ModifiedBy, CriteriaSetId
					 FROM dbo.CreditScoreCriteriaHeader
					 WHERE 1=1' 

	if @p_CreditAgencyID > 0
       set @sqlQuery = @sqlQuery + ' and CreditAgencyID = @x_CreditAgencyID'
       
    if @p_CriteriaSetId is null
    begin
		set @p_CriteriaSetId = (select cs.CriteriaSetId from dbo.CriteriaSet cs where cs.IsDefault = 1)
	end
	
	if @p_CriteriaSetId <> -1
		set @sqlQuery = @sqlQuery + ' and CriteriaSetId = @x_CriteriaSetId'
	
	IF @p_status = 0
       set @sqlQuery = @sqlQuery + ' and ExpirationDate is null'
    ELSE
        IF @p_status = 1
        begin
			set @sqlQuery = 'SELECT  top 1 CreditScoreCriteriaHeaderID, CreditAgencyID , EffectiveDate, ExpirationDate, CreatedBy, ModifiedBy, CriteriaSetId
					 FROM dbo.CreditScoreCriteriaHeader
					 WHERE 1=1'
			IF @p_CreditAgencyID > 0
			begin	
				set @sqlQuery = @sqlQuery + ' and CreditAgencyID = @x_CreditAgencyID
											  and CriteriaSetId = @x_CriteriaSetId	 
					                          order by EffectiveDate desc' 
			end
        end  
		ELSE
			begin
				set @sqlQuery = @sqlQuery + ' order by CreditAgencyID, EffectiveDate'
			end 
    
        
    set @paramDefinition = '@x_CreditAgencyID int,
							@x_CriteriaSetId int'
	                       
	                   
	execute sp_Executesql @sqlQuery,
                          @paramDefinition,
                          @x_CreditAgencyID = @p_CreditAgencyID,
                          @x_CriteriaSetId  = @p_CriteriaSetId
                          
    print @sqlquery
    
END
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreCriteriaHeaderSelectList';


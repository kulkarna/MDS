
-- ==========================================================================
-- Author:		Antonio Jr
-- Create date: April, 23, 2009
-- Description:	Gets the list of AgencyScoreRequirements depending on filters
-- p_status = 0 (Gets only non expired records), = 1 (Gets the last record)
--          > 1 (Gets all records) 
-- ==========================================================================

CREATE proc [dbo].[usp_DepositAgencyRequirementSelectList] 
	@p_agencyID int = 0,
	@p_status INT = 0
	
AS
BEGIN
	
	SET NOCOUNT ON;

    declare @sqlQuery nvarchar(4000)
	declare @paramDefinition nvarchar(1000)
	
	set @sqlQuery = 'SELECT  DepositAgencyRequirementID, AgencyID , CreatedBy, DateCreated, ExpiredBy, DateExpired
					 FROM dbo.DepositAgencyRequirementHeader
					 WHERE 1=1' 

	if @p_agencyID > 0
       set @sqlQuery = @sqlQuery + ' and AgencyID = @x_AgencyID'

	IF @p_status = 0
       set @sqlQuery = @sqlQuery + ' and DateExpired is null'
    ELSE
       IF @p_status = 1
       begin
			set @sqlQuery = 'SELECT  top 1 DepositAgencyRequirementID, AgencyID , CreatedBy, DateCreated, ExpiredBy, DateExpired
					 FROM dbo.DepositAgencyRequirementHeader
					 WHERE 1=1' 
			IF @p_agencyID > 0
			begin	
				set @sqlQuery = @sqlQuery + ' and AgencyID = @x_AgencyID	 
					                          order by DateCreated desc' 
			end
       end 
    ELSE
       IF @p_status = 2
       begin
			set @sqlQuery = @sqlQuery + ' order by AgencyID, DateCreated'
       end    
    
        
    set @paramDefinition = '@x_AgencyID int'
	                       
	                   
	execute sp_Executesql @sqlQuery,
                          @paramDefinition,
                          @x_AgencyID = @p_agencyID
                          
    print @sqlquery
    
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementSelectList';


CREATE PROCEDURE [dbo].[usp_DealScreeningInsert]
	
	(
	@p_DealScreeningPathID int,
	@p_StepNumber INT,
	@p_StepTypeID int,
	@p_ContractNumber VARCHAR(50),
	@p_Disposition VARCHAR(50),
	@p_UserName VARCHAR(50),
	@p_DateDispositioned DATETIME,
	@p_Comments VARCHAR(MAX)
	)
	
AS
	INSERT INTO dbo.DealScreening (
		DealScreeningPathID,
		StepNumber,
		StepTypeID,
		ContractNumber,
		Disposition,
		UserName,
		DateDispositioned,
		Comments,
		DateCreated
	) VALUES ( 
		@p_DealScreeningPathID ,
		@p_StepNumber ,
		@p_StepTypeID ,
		RTRIM(LTRIM(@p_ContractNumber)) ,
		RTRIM(LTRIM(@p_Disposition)) ,
		RTRIM(LTRIM(@p_UserName)) ,
		@p_DateDispositioned ,
		RTRIM(LTRIM(@p_Comments)) ,
		GETDATE() ) 
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DealScreeningInsert';


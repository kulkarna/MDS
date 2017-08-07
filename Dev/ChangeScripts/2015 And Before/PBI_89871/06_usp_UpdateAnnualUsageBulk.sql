USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateAnnualUsageBulk]    Script Date: 10/15/2015 3:45:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Manoj Thanath 
-- Create date: 10/15/2015
-- Description:	Insert/Update  the Annual usage Data into AccountUsge  table, as well as AnnualUsageTranDetail  transaction table.
-- =============================================
ALTER PROCEDURE [dbo].[usp_UpdateAnnualUsageBulk] 
	-- Add the parameters for the stored procedure here
	 @AccountUsageList as [dbo].[AnnualUsageTranRecord] READONLY 
AS
BEGIN
	
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    BEGIN TRY
		DECLARE @CurrDate Datetime
		,@Loop					INT
		,@MaxLoop					INT
		,@AccountId					INT
		,@AnnualUsage				INT
		,@OldAnnualUsage			INT
		,@effectiveDate				datetime
		SELECT @CurrDate = GETDATE();
	
		Create table #AUpdateAnnualUsageStagingTable (
		ID	INT IDENTITY (1,1),
		AccountId  bigint ,
		AccountNumber nvarchar (30), 
		UtilityId int ,
		AnnualUsage bigint);
		--Copy the data from the list
		insert into #AUpdateAnnualUsageStagingTable
		select * from @AccountUsageList

		---Insert or update the AccountUsageTable with the incoming date Record.
		SELECT @Loop		= 1
				,@MaxLoop		= (SELECT MAX(ID) FROM #AUpdateAnnualUsageStagingTable)

			WHILE @Loop		<= @MaxLoop
			BEGIN
		
				SELECT @AccountId	= AA.AccountId,
					   @AnnualUsage= AA.AnnualUsage
				FROM #AUpdateAnnualUsageStagingTable AA
				WHERE ID = @Loop
			    
				SET @OldAnnualUsage = 0;
				---Check whether the Account already exists with annual usage
				IF EXISTS (	SELECT TOP 1  AU.AccountId
				FROM [Libertypower].[dbo].[AccountUsage] AU (NOLOCK)
				WHERE AU.AccountId		= @AccountId)
               -- IF (@OldAnnualUsage > 0) AND (@OldAnnualUsage <> @AnnualUsage)
				  BEGIN
				         SELECT @OldAnnualUsage = a.AnnualUsage
				         FROM [Libertypower].[dbo].[AccountUsage] a
				         WHERE AccountId = @AccountId
					     AND EffectiveDate IN (Select Max(effectiveDate) from [Libertypower].[dbo].[AccountUsage](nolock) b where b.accountId  = @AccountId); 
						 IF (@OldAnnualUsage <> @AnnualUsage)
						    BEGIN
								UPDATE [Libertypower].[dbo].[AccountUsage]
								SET AnnualUsage = @AnnualUsage,
									Modified = @CurrDate,
				                    ModifiedBy = 3705
								WHERE AccountId = @AccountId
								AND EffectiveDate IN (Select Max(effectiveDate) from [Libertypower].[dbo].[AccountUsage](nolock) b where b.accountId  = @AccountId);
							END
				  END
				ELSE
					--Get the effective Date for the accountId
					 BEGIN
						select  @effectiveDate =  c.Startdate from libertypower..Contract(nolock) c
						 Inner Join libertypower..Account(nolock) b
						 ON c.ContractID = b.CurrentContractID
						 and b.AccountID = @accountId;
					--Insert a new record with accountId and Annual usage and Effective date.

						INSERT INTO [Libertypower].[dbo].[AccountUsage]
						Values (@AccountId,@AnnualUsage,5,@effectiveDate,@CurrDate,3705,@CurrDate,null)	
					 END
				SET @Loop		= @Loop + 1
			END

		---If  the date Records updated/Inserted successfully, Update the TransactionDetaisl Table to mark these rows as complete.
		UPDATE AnnualUsageTranDetail
		SET			AnnualUsage = eu.AnnualUsage,
					Iscomplete = 1,
					CreateDate = @CurrDate
		FROM		#AUpdateAnnualUsageStagingTable eu WITH (NOLOCK)
		INNER JOIN	AnnualUsageTranDetail eud  ON eu.AccountID = eud.AccountID  
		
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	SET NOCOUNT OFF;
END

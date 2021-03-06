USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetBillGroupRecent]    Script Date: 8/10/2015 10:42:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_GetBillGroupRecent 
 * <Purpose,,>
 * This  SP Retrurns  the most recent BillGroup value for the Account/UtilityCode Passed in
 * Order of exec. EdiAccount/ScraperAccount/FileAccount
 * History

 *******************************************************************************
 * 08/03/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_GetBillGroupRecent] 
	(@p_AccountNumber			VARCHAR(30)		= NULL
	,@p_UtilityCode				VARCHAR(15)		= NULL
	)
AS

BEGIN
   SET NOCOUNT ON;         
   BEGIN TRY
           DECLARE @BillGroupFound     INT = 0
			   ,@SQLQuery			VARCHAR(500)
			   ,@strMessage			VARCHAR(500)	
			
            DECLARE @BillGroupTable	TABLE (
				ID						INT IDENTITY (1,1)
				,AccountNumber			VARCHAR(30)
				,UtilityCode			VARCHAR(15)
				,BillGroup           	VARCHAR(15)
				,TimeStampInsert        DATETIME) ;
				

		IF @p_AccountNumber IS NULL
			RAISERROR 50000 'Missing the and Account Number'

		IF @p_UtilityCode IS NULL
			RAISERROR 50000 'Missing  the Utility Code'
		--If both arguments valid Check the EdiAccount Table for BillGroup Data 
		IF (@p_AccountNumber IS NOT NULL) AND  (@p_UtilityCode IS NOT NULL)
		BEGIN
			INSERT INTO @BillGroupTable
			SELECT DISTINCT 
				 AccountNumber
				,UtilityCode
				,BillGroup
				,TimeStampInsert  
			FROM lp_transactions.dbo.EdiAccount (NOLOCK) 
			WHERE  AccountNumber = @p_AccountNumber
			AND    UtilityCode   = @p_UtilityCode
			AND    (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0) 
			

			IF @@ROWCOUNT > 0 ---This means at  least one row with a valid bill Group Exist, so get the latest value.
				BEGIN
					SELECT  BillGroup
					FROM @BillGroupTable 
					WHERE TimeStampInsert IN (SELECT MAX(TimeStampInsert) FROM @BillGroupTable)
					
					SET @BillGroupFound = 1;
				END			 
		END		
	    --**********************************************************
		IF @BillGroupFound = 0---This means at  No data row with a valid bill Group in EDI, so get the Data from ScraperAccounts
			     --Find the appropriate table name for scraper utility
			 BEGIN
			  
				 IF @p_UtilityCode = 'BGE' 
				           INSERT INTO  @BillGroupTable  
			               SELECT DISTINCT AccountNumber,'BGE',BillGroup, Created as TimeStampInsert  
			               FROM lp_transactions.dbo.BgeAccount (NOLOCK) 
			               WHERE  AccountNumber =  @p_AccountNumber 
			               AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 

				 ELSE IF @p_UtilityCode = 'CMP' 
				           INSERT INTO @BillGroupTable
							SELECT DISTINCT AccountNumber,'CMP',BillGroup,Created as TimeStampInsert  
							FROM lp_transactions.dbo.CmpAccount (NOLOCK) 
							WHERE  AccountNumber =  @p_AccountNumber 
							AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0);
				 ELSE IF @p_UtilityCode = 'AMEREN' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'AMEREN',BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.AmerenAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 
				 ELSE IF @p_UtilityCode = 'CENHUD' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'CENHUD',Billcycle as BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.CenhudAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (Billcycle IS NOT NULL ) AND (Billcycle <> -1) AND (Billcycle <> 0); 
				 ELSE IF @p_UtilityCode = 'COMED' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'COMED',MeterBillGroupNumber as BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.ComedAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (MeterBillGroupNumber IS NOT NULL ) AND (MeterBillGroupNumber <> -1) AND (MeterBillGroupNumber <> 0); 
				 ELSE IF @p_UtilityCode = 'CONED' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'CONED',TripNumber as BillGroup, Created as TimeStampInsert  
			                FROM lp_transactions.dbo.ConedAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (TripNumber IS NOT NULL ) AND (TripNumber <> -1) AND (TripNumber <> 0); 
				 ELSE IF @p_UtilityCode = 'PECO' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'PECO',BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.PecoAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 
				 ELSE IF @p_UtilityCode = 'RGE' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'RGE',BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.RgeAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 
				 ELSE IF @p_UtilityCode = 'NYSEG' 
				            INSERT INTO @BillGroupTable
			                SELECT DISTINCT AccountNumber,'NYSEG',BillGroup,Created as TimeStampInsert  
			                FROM lp_transactions.dbo.NysegAccount (NOLOCK) 
			                WHERE  AccountNumber =  @p_AccountNumber 
			                AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 
				 --ELSE IF @p_UtilityCode = 'NIMO' 
				            --INSERT INTO @BillGroupTable
			                --SELECT DISTINCT AccountNumber,'NIMO',BillGroup,Created as TimeStampInsert  
			                --FROM lp_transactions.dbo.NimoAccount (NOLOCK) 
			                --WHERE  AccountNumber =  @p_AccountNumber 
			               -- AND (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0); 
				

				IF @@ROWCOUNT > 0 ---This means at  least one row with a valid bill Group Exist, so get the latest value.
					BEGIN
						SELECT  BillGroup
						FROM @BillGroupTable 
						WHERE TimeStampInsert IN (SELECT MAX(TimeStampInsert) FROM @BillGroupTable)
					
						SET @BillGroupFound = 1;
					END		
			 END	
   -----**********************************************************************************************************
       IF @BillGroupFound = 0---This means at  No data row with a valid bill Group in EDI/Scraper, so get the Data FileAccounts
			  BEGIN
				INSERT INTO @BillGroupTable
				SELECT DISTINCT 
					 AccountNumber
					,UtilityCode
					,BillGroup
					,DateCreated as TimeStampInsert
				FROM lp_transactions.dbo.FileAccount (NOLOCK) 
				WHERE  AccountNumber = @p_AccountNumber
				AND    UtilityCode   = @p_UtilityCode
				AND    (BillGroup IS NOT NULL ) AND (BillGroup <> -1) AND (BillGroup <> 0) 
			
				IF @@ROWCOUNT > 0 ---This means at  least one row with a valid bill Group Exist, so get the latest value.
					BEGIN
						SELECT  BillGroup
						FROM @BillGroupTable
						WHERE TimeStampInsert IN (SELECT MAX(TimeStampInsert) FROM @BillGroupTable)
					
						SET @BillGroupFound = 1;
					END			 
			 END	
			 
    ---  ******************************************************************************************************************    	
	 IF  @BillGroupFound = 0
			BEGIN
				SET @strMessage		= 'BillGroup Not Found For the Account informed: ' + LTRIM(RTRIM(@p_AccountNumber)) + '(' + LTRIM(RTRIM(@p_UtilityCode))
				RAISERROR 50000 @strMessage
			END
		
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

-- Copyright 06/11/2015 Liberty Power

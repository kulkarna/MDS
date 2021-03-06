USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateAccountSubmissionQueue]    Script Date: 04/16/2015 09:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Date: 2014-11-21 - Diogo Lima, Jennifer Ford, Sadiel Jarvis
	Purpose: Insert or update into Libertypower..AccountSubmissionQueue table, getting mapping data from Libertypower..AccountStatusMappings.
		
    Modified: 04/16/2015- Bhavana Bakshi
              Bug: 65911, RCR: Dupilcates on AccountSubmissionQueue
              1.Removing the dependency on the usp_InsAccountSubmissionQueueByAccountContractID 
              2. The insert should add a new row to Libertypower..AccountSubmissionQueue table for each AccountContract Rate. 
              3. One AccountContractRate can have multiple entries for a category and Type in ASQ
*/



ALTER PROCEDURE [dbo].[usp_UpdateAccountSubmissionQueue]        
	@AccountContractID int,        
	@Status		VARCHAR(15),
	@SubStatus	VARCHAR(15) 
as  
SET NOCOUNT ON  

DECLARE @EdiStatus int;  
DECLARE @EdiType int;
DECLARE @Category int; 

	SELECT 
		@EdiStatus = AccountSubmissionQueue_EDIStatusID,
		@EdiType = AccountSubmissionQueue_TypeID,
		@Category = AccountSubmissionQueue_CategoryID
	FROM libertypower..AccountStatusMappings with(nolock)
	WHERE 
		AccountStatus_Status = @Status and 
		AccountStatus_Substatus = @SubStatus  
		     
   --UPSERT: INSERT if doesnt exist else UPDATE     
  if not exists(select top 1 1  
     from Libertypower..AccountContract ac WITH (NOLOCK)            
     inner join LibertyPower..AccountContractRate acr with(nolock) on ac.AccountContractID = acr.AccountContractID           
     inner join libertypower..accountsubmissionqueue asq WITH (NOLOCK) on acr.AccountContractRateid = asq.AccountContractRateid         
     WHERE ac.AccountContractID = @AccountContractID)  
	   begin --TFS 69511
			
			--Insert a record in ASQ for each Account Contract Rate. Multi-term accounts will have record for each Account Contract Rate.
			INSERT INTO libertypower..AccountSubmissionQueue
				SELECT @Category
					,@EdiType
					,@EdiStatus
					,dateadd(dd, - isnull(u.EnrollmentLeadDays, 0), acr.RateStart)
					,acr.RateStart
					,GETDATE()
					,AccountContractrateID
				FROM LibertyPower..AccountContract AC WITH (NOLOCK)
				INNER JOIN LibertyPower..Account A WITH (NOLOCK) ON AC.AccountId = A.AccountId
				INNER JOIN LibertyPower..Utility U WITH (NOLOCK) ON U.Id = A.UtilityId
				INNER JOIN LibertyPower..AccountContractRate acr WITH (NOLOCK) ON ac.AccountContractID = acr.AccountContractID
				WHERE ac.AccountContractID = @AccountContractID

	   end  
    else
		begin
			   update asq set EdiStatus = @EdiStatus, asq.type = @EdiType, asq.Category = @Category
			   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)                             
			   inner join LibertyPower..AccountContractRate acr with(nolock) on ac.AccountContractID = acr.AccountContractID           
			   inner join libertypower..accountsubmissionqueue asq with(nolock) on acr.AccountContractRateid = asq.AccountContractRateid       
			   WHERE ac.AccountContractID = @AccountContractID 
					       
		end  
   SET NOCOUNT OFF;
   
    
   
   
   
  


-- This proc will take an existing step type and add it to the end of the path specified.
-- If the step type is not recognized, it will create a new step type with the description provided.
-- If you need to move the step around after adding it, see proc usp_DealScreeningMoveStep.
CREATE PROCEDURE usp_DealScreeningAddStepToPath @DealScreeningPathID INT, @StepTypeDescription VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DealScreeningStepType WHERE Description = @StepTypeDescription)
		INSERT INTO DealScreeningStepType (Description) VALUES (@StepTypeDescription)
		
	DECLARE @StepTypeID INT
	SELECT @StepTypeID = DealScreeningStepTypeID 
	FROM DealScreeningStepType 
	WHERE Description = @StepTypeDescription

	---- Insert the step into the path
	IF NOT EXISTS (select * from DealScreeningStep where StepTypeID = @StepTypeID and DealScreeningPathID = @DealScreeningPathID)
	BEGIN
		INSERT INTO DealScreeningStep
			  (DealScreeningPathID  , StepNumber          , StepType, DateCreated, StepTypeID)
		SELECT p.DealScreeningPathID, max(stepnumber) + 10, null    , getdate()  , @StepTypeID
		FROM DealScreeningPath p
		JOIN DealScreeningStep s on p.DealScreeningPathID = s.DealScreeningPathID
		WHERE 1=1 
		AND p.DealScreeningPathID = @DealScreeningPathID
		GROUP BY p.DealScreeningPathID
		
		DECLARE @StepID INT
		SET @StepID = @@IDENTITY
		
		-- The current status of NA is a dummy value.
		-- Since no accounts are ever in this status, this step will not be created in the natural deal screening progression.
		INSERT INTO Libertypower.dbo.DealScreeningTransition
			(DealScreeningStepID, Disposition, CurrentAccountStatus, CurrentAccountSubStatus, NextStepNumber, NextAccountStatus, NextAccountSubStatus, DateCreated)
	    SELECT @StepID          , 'APPROVED' , 'NA'			       , 'NA'                   , NULL          , NULL             , NULL                , getdate()

		INSERT INTO Libertypower.dbo.DealScreeningTransition
			(DealScreeningStepID, Disposition, CurrentAccountStatus, CurrentAccountSubStatus, NextStepNumber, NextAccountStatus, NextAccountSubStatus, DateCreated)
	    SELECT @StepID          , 'REJECTED' , 'NA'		     	   , 'NA'                   , NULL          , NULL             , NULL                , getdate()
	    
	END
END
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DealScreeningAddStepToPath';


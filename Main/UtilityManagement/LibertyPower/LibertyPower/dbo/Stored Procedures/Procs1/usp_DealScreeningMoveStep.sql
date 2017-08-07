
CREATE PROCEDURE usp_DealScreeningMoveStep @DealScreeningPathID INT, @StepNumber INT, @NewStepNumber INT
AS
BEGIN
      ---- Before placing the step in its new position, we need to remove it from its old one.
      DECLARE @PreviousStep INT
     
      SELECT @PreviousStep = max(StepNumber)
      FROM DealScreeningStep
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber < @StepNumber
     
      ---- The current step's approve status will now be transferred to the previous step.
      DECLARE @CurrentStepsApproveStatus VARCHAR(50)
      DECLARE @CurrentStepsApproveSubStatus VARCHAR(50)
      DECLARE @CurrentStepsNextNumber INT
     
      SELECT @CurrentStepsApproveStatus = NextAccountStatus, @CurrentStepsApproveSubStatus = NextAccountSubStatus, @CurrentStepsNextNumber = NextStepNumber
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @StepNumber AND Disposition = 'APPROVED'
     
      UPDATE DealScreeningTransition
      SET NextAccountStatus = @CurrentStepsApproveStatus, NextAccountSubStatus = @CurrentStepsApproveSubStatus, NextStepNumber = @CurrentStepsNextNumber
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @PreviousStep AND Disposition = 'APPROVED'
     
     
      ---- Now we start to move the step to the new location.
      ---- Figure out what the new "next" and "previous" step will be after this step gets moved to it new location.
      DECLARE @NewPreviousStep INT
      DECLARE @NewNextStep INT
     
      SELECT @NewPreviousStep = max(StepNumber)
      FROM DealScreeningStep
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber < @NewStepNumber
     
      SELECT @NewNextStep = min(StepNumber)
      FROM DealScreeningStep
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber > @NewStepNumber
 
     
      ---- Update the step number
      UPDATE DealScreeningStep
      SET StepNumber = @NewStepNumber
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @StepNumber
     
     
      ---- The next step's wait status is the current step's approve status.
      DECLARE @NextStepsWaitStatus VARCHAR(50)
      DECLARE @NextStepsWaitSubStatus VARCHAR(50)
     
      SELECT @NextStepsWaitStatus = CurrentAccountStatus, @NextStepsWaitSubStatus = CurrentAccountSubStatus
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @NewNextStep AND Disposition = 'APPROVED'
     
      IF @NextStepsWaitStatus = 'ALL'
            SELECT @NextStepsWaitStatus = NULL, @NextStepsWaitSubStatus = NULL
     
      UPDATE DealScreeningTransition
      SET NextAccountStatus = @NextStepsWaitStatus, NextAccountSubStatus = @NextStepsWaitSubStatus, NextStepNumber = @NewNextStep
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @NewStepNumber AND Disposition = 'APPROVED'
     
     
      ---- The current step's wait status is the previous step's approve status.
      DECLARE @CurrentStepsWaitStatus VARCHAR(50)
      DECLARE @CurrentStepsWaitSubStatus VARCHAR(50)
     
      SELECT @CurrentStepsWaitStatus = CurrentAccountStatus, @CurrentStepsWaitSubStatus = CurrentAccountSubStatus
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @NewStepNumber AND Disposition = 'APPROVED'
     
      IF @CurrentStepsWaitStatus = 'ALL'
            SELECT @CurrentStepsWaitStatus = NULL, @CurrentStepsWaitSubStatus = NULL
 
      UPDATE DealScreeningTransition
      SET NextAccountStatus = @CurrentStepsWaitStatus, NextAccountSubStatus = @CurrentStepsWaitSubStatus, NextStepNumber = @NewStepNumber
      FROM libertypower.dbo.DealScreeningStep s
      JOIN libertypower.dbo.DealScreeningTransition t ON s.DealScreeningStepID = t.DealScreeningStepID
      WHERE DealScreeningPathID = @DealScreeningPathID AND StepNumber = @NewPreviousStep AND Disposition = 'APPROVED'
 
END
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DealScreeningMoveStep';


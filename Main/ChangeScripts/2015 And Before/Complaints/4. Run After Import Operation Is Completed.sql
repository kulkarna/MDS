use [LibertyPower]


UPDATE [dbo].[ComplaintDisputeOutcome] SET [Name] = 'Account Service Issue - DNU' WHERE [ComplaintDisputeOutcomeID] = 1
UPDATE [dbo].[ComplaintDisputeOutcome] SET [Name] = 'Conflict - DNU' WHERE [ComplaintDisputeOutcomeID] = 7
UPDATE [dbo].[Complaint] SET DisputeOutcomeID = 6 WHERE DisputeOutcomeID = 8
DELETE [dbo].[ComplaintDisputeOutcome] WHERE ComplaintDisputeOutcomeID = 8
CREATE VIEW DSPath_vw
AS 
SELECT p.DealScreeningPathID as PathID, p.Description as PathName, s.StepNumber, st.Description as StepName, t.DealScreeningTransitionID as TransID, t.Disposition, t.CurrentAccountStatus, t.CurrentAccountSubStatus, t.NextAccountStatus, t.NextAccountSubStatus 
FROM libertypower.dbo.DealScreeningPath p 
JOIN libertypower.dbo.DealScreeningStep s on p.DealScreeningPathID = s.DealScreeningPathID 
JOIN libertypower.dbo.DealScreeningStepType st on s.StepTypeID = st.DealScreeningStepTypeID 
JOIN libertypower.dbo.DealScreeningTransition t on s.DealScreeningStepID = t.DealScreeningStepID 
 
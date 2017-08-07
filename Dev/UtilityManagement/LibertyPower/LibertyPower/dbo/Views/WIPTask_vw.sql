

CREATE VIEW [dbo].[WIPTask_vw]
AS
SELECT wipt.WIPTaskID, c.ContractID, c.Number, tt.TaskTypeID, tt.TaskName, ts.TaskStatusID, ts.StatusName, wipt.UpdatedBy, wipt.DateUpdated, wipt.DateCreated
FROM LibertyPower..WIPTask wipt (NOLOCK)
JOIN LibertyPower..WIPTaskHeader wiph (NOLOCK) ON wipt.WIPTaskHeaderID = wiph.WIPTaskHeaderID
JOIN LibertyPower..Contract c (NOLOCK) ON wiph.ContractID = c.ContractID
JOIN LibertyPower..WorkflowTask wt ON wipt.WorkflowTaskID = wt.WorkflowTaskID
JOIN LibertyPower..TaskType tt ON wt.TaskTypeID = tt.TaskTypeID
JOIN LibertyPower..TaskStatus ts ON wipt.TaskStatusID = ts.TaskStatusID

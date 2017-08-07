ALTER TABLE lp_website.dbo.lpEmployees ADD SEQnum INT IDENTITY(1,1)
sp_rename 'lp_website.dbo.lpEmployees.EmployeeID','OldEmpID','COLUMN'
sp_rename 'lp_website.dbo.lpEmployees.SEQnum','EmployeeID','COLUMN'
ALTER TABLE lp_website.dbo.lpEmployees DROP COLUMN OldEmpID
ALTER TABLE lp_website.dbo.lpEmployees ALTER COLUMN Title VARCHAR(120)
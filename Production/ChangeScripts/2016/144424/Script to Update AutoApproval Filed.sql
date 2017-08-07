USE libertypower
Go

Update a
set a.AutoApproval=1,
a.PorOption='YES'
From libertypower..Utility a
where a.Utilitycode in('O&R','ORNJ','NIMO')





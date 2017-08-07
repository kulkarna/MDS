  
  
  
CREATE proc [dbo].[usp_EntityOrganizationDelete] (@DunsNumber varchar(100))  
as  
  
declare @ListToDelete Table  
(  
EntityID int,  
DunsNumber varchar(100)  
)  
  
insert into @ListToDelete (EntityID, DunsNumber)  
select EntityID, DunsNumber   
from EntityOrganization  
where DunsNumber = @DunsNumber  
  
delete EntityOrganization  
where EntityID in (select EntityID from @ListToDelete)  
  
delete Entity  
where EntityID in (select EntityID from @ListToDelete)  
  
  
  
  
  
  
  
  

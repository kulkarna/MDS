USE Libertypower
GO 

-- update existing defaults 
-- ===========================================
Update u set DeliveryLocationRefID = pir.ID
FROM LibertyPower..Utility u
	JOIN Lp_common..Zone z (NOLOCK) on z.zone_id = u.ZoneDefault
	JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) on z.zone = pir.Value and pir.propertyId = 1 
WHERE u.DeliveryLocationRefID is null 


/*
-- did it this way to avoid unresolved subquery error 
declare @u_id int 
declare @u_zn varchar(max) 
declare @pir int 

declare util_csr cursor for 

	SELECT u.id , z.zone 
	FROM LibertyPower..Utility u 
		JOIN Lp_common..Zone z on z.zone_id = u.ZoneDefault

open util_csr 
fetch next from util_csr into @u_id , @u_zn

while @@FETCH_STATUS = 0 
begin 
	set @pir = 0 

	select @u_id , @u_zn
	
	select @pir = pir.id 
	from LibertyPower..PropertyInternalRef pir 
	where pir.Value = @u_zn  and pir.propertytypeId = 1

	update libertypower..Utility set DeliveryLocationID = isnull(@pir , 0)
	where ID = @u_id
	
	fetch next from util_csr into @u_id , @u_zn
end 
close util_csr
deallocate util_csr 

*/


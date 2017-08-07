use OnlineEnrollment	
go
begin
begin tran T1

update ProductBrand set Active=1 where ProductBrandID = 21 and Active=0
update ProductBrand set Active=1 where ProductBrandID = 19 and Active=0
update ProductBrand set Active=1 where ProductBrandID = 1 and Active=0
update ProductBrand set Active=1 where ProductBrandID = 2 and Active=0
commit
--rollback tran T1
end
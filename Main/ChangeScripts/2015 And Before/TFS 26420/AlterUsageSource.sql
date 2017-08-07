use libertypower 
go
alter table usagesource add Priority int
go 
begin tran
--0	Edi	2009-11-06 00:00:00.000	dmarino	1
--1	Scraper	2009-05-11 16:25:00.000	rideigsler	NULL
--2	Ista	2008-12-30 09:18:50.063	eduardo	NULL
--3	WebBilling	2008-12-30 09:19:12.967	eduardo	NULL
--4	AccountBilling	2008-12-30 09:19:23.143	eduardo	NULL
--5	ProspectAccountBilling	2008-12-30 09:19:32.997	eduardo	NULL
--6	User	2008-12-30 09:19:01.580	eduardo	NULL
update usagesource set Priority=1 where value = 2
update usagesource set Priority=2 where value = 0
update usagesource set Priority=3 where value = 1
update usagesource set Priority=4 where value = 6
update usagesource set Priority=5 where value = 3
update usagesource set Priority=6 where value = 4
update usagesource set Priority=7 where value = 5
commit

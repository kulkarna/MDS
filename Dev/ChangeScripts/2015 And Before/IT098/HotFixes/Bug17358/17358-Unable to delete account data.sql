use lp_transactions
go

alter table [Lp_Transactions].dbo.IdrFileLogHeader
alter column Notes varchar(800) NULL

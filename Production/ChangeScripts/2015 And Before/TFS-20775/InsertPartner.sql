USE GENIE
GO

SELECT COUNT(*) FROM [GENIE].[dbo].[LK_Partner] with (Nolock)

IF NOT EXISTS (select * from Genie..LK_Partner where PartnerName='RFE')
BEGIN
insert into Genie..LK_Partner (PartnerName,PartnerDescription,MarginLimit,EmailAddress,EnableTemplateType)
values('RFE','Rockford Energy','0.00000','rockfordenergy@yahoo.com','false')
END


IF NOT EXISTS (select * from Genie..LK_Partner where PartnerName='IMC')
BEGIN
insert into Genie..LK_Partner (PartnerName,PartnerDescription,MarginLimit,EmailAddress,EnableTemplateType)
values('IMC','International Marketing Concepts','0.00000','jaunius.imc@hotmail.com','false')
END

IF NOT EXISTS (select * from Genie..LK_Partner where PartnerName='OEB2')
BEGIN
insert into Genie..LK_Partner (PartnerName,PartnerDescription,MarginLimit,EmailAddress,EnableTemplateType)
values('OEB2','Oceans Energy Group','0.00000','ranthony@oceansenergy.com','false')
END

IF NOT EXISTS (select * from Genie..LK_Partner where PartnerName='NYM')
BEGIN
insert into Genie..LK_Partner (PartnerName,PartnerDescription,MarginLimit,EmailAddress,EnableTemplateType)
values('NYM','New york Marketing','0.00000','kenreece@nymarketingfirm.org','false')
END


SELECT COUNT(*) FROM [GENIE].[dbo].[LK_Partner] with (Nolock)
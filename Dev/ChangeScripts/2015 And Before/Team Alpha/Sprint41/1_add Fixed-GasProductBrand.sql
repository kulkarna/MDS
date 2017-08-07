USE Libertypower;
go

IF NOT EXISTS (select top 1 1 from libertypower..ProductBrand pb with(nolock) 
    where(pb.Name='FIXED GAS' and pb.ProductTypeID=1 and pb.Active=1))
BEGIN
INSERT INTO [Libertypower].[dbo].[ProductBrand]
           ([ProductTypeID]
           ,[Name]
           ,[IsCustom]
           ,[IsDefaultRollover]
           ,[RolloverBrandID]
           ,[Active]
           ,[Username]
           ,[DateCreated]
           ,[IsMultiTerm]
           ,[Parent])
     VALUES
           (1	,'FIXED GAS',0,0,0,1,SUSER_SNAME(),GETDATE(),0,0);
          
END
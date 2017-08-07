-- =================================================

-- 0scar Garcia

-- Modified: 02/21/2013

-- Add the account name option

-- 1-66274991

--=================================================
IF NOT EXISTS(SELECT 1 FROM [Lp_common].[dbo].[common_views] (NOLOCK) WHERE process_id ='ACCOUNT EXPRESS' and seq=75 )
BEGIN

INSERT INTO [Lp_common].[dbo].[common_views]
           ([process_id]
           ,[seq]
           ,[option_id]
           ,[return_value]
           ,[active])
SELECT  'ACCOUNT EXPRESS',75,'Account Name','Account',1           
     
END
ELSE
BEGIN

PRINT 'Lookup value already exists!'

END



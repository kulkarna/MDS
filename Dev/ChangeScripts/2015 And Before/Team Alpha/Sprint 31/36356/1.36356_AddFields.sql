------------------------------------------------------------------------
--Add two new fields CurrentContAcc and CurrentNumber to deal_contract table
--May 21 2014
-------------------------------------------------------------------------

use Lp_deal_capture
GO



IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'deal_contract' AND COLUMN_NAME = 'CurrentNumber')
BEGIN

    ALTER TABLE [dbo].[deal_contract] ADD 
        [CurrentNumber] char(12)  NULL 
        
END
Go

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'deal_contract' AND COLUMN_NAME = 'CurrentContAcc')
BEGIN

    ALTER TABLE [dbo].[deal_contract] ADD 
        [CurrentContAcc] char(10)  NULL 
        
END
Go

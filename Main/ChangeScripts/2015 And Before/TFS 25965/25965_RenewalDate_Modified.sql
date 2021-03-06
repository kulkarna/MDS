USE [Lp_deal_capture]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetMinStartDateforanAccount]    Script Date: 11/15/2013 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 9/18/2013
-- Description:	Returns the MinStartDate for an Account
--Modified: Sept 30 2013
--There exists more than one accountId for the same account number.
-- So added additional filter account_id to the queries
--Modified: NOv 14 2013
--Added Logic for the minStart date for a renewal account
--if it is a renewal account for 12/1/2013 and the meter read date is 12/17/2013 and the Account Contract enddate for the current account is 12/27/2013
-- Then it is supposed to be the Account contract end date + 1 and not the meter read date
-- Modified Nov 15 2013
--Added Current COntractId, and Max(ACREndDate) 
-- =============================================
ALTER FUNCTION [dbo].[ufn_GetMinStartDateforanAccount](
               @p_AccountID char(12), 
               @p_AccountNumber varchar(50), 
               @p_contract_eff_start_date datetime, 
               @p_utility_id char(15))
RETURNS datetime
AS
BEGIN

    DECLARE @w_min_start_date datetime;
                        SET @w_min_start_date=@p_contract_eff_start_date;

    IF EXISTS(SELECT account_id
                FROM lp_account..account WITH (nolock)
                WHERE account_id
                    = @p_AccountID)
        BEGIN
            ---If the account is flowing it is a renewal deal 
            --else it is considered to be a new account
            DECLARE @EndDate datetime;
            SET @EndDate=(SELECT ALS.EndDate
                            FROM Libertypower..Account  A WITH (noLock) INNER JOIN LibertyPower..AccountLatestService ALS WITH (noLock)ON 
                            A.AccountID
                            = ALS.AccountID
                            WHERE A.AccountNumber
                                = @p_AccountNumber and  A.AccountIdLegacy=@p_AccountID);

            IF @EndDate IS NULL
            OR @EndDate
             > @p_contract_eff_start_date
                --Flowing renewal account		
              BEGIN
              --Added nov 14 2013 
                --If endDate> Effective Start (eg: 12/27/2013 > 12/1/2013) and If they all fall on the same month and year then 
                -- go by ACCOUNTCONTRACTRATE endDate +1
                
                --Added Nov 15 2013
                --getting the ACREndDate by providing the currentContractId also
                Declare @CurrentContractID int ;                
                Set @CurrentContractID=(Select A.CurrentContractID from Libertypower..Account A where A.AccountIdLegacy=@p_AccountID and A.AccountNumber=@p_AccountNumber )
                Declare @ACREndDate datetime;
                SET @ACREndDate=( Select MAX(ACR.RateEnd) from Libertypower..Account A inner Join LibertyPower..AccountContract AC
                on A.AccountID= AC.AccountID
                Inner Join Libertypower..AccountContractRate ACR on AC.AccountContractID=ACR.AccountContractID
                 where A.AccountIdLegacy=@p_AccountID and A.AccountNumber=@p_AccountNumber  and A.CurrentContractID=@CurrentContractID)
                 
                If @ACREndDate is Not NULL  AnD MONTH(@ACREndDate)=MONTH (@p_contract_eff_start_date) AND year(@ACREndDate)=year (@p_contract_eff_start_date) 
                Begin
               SET @w_min_start_date=(Select @ACREndDate +1);
                End
                Else
                 SET @w_min_start_date=(SELECT Lp_deal_capture.dbo.ufn_GetNextMeterReadDate(@p_AccountID, @p_AccountNumber, @p_contract_eff_start_date, @p_utility_id));
              END;
            ELSE --Account exists but not flowing
                BEGIN
                    --If Account exsists and not flowing then we need to see if the account is active
                    --If active and not expired then get the meter readdate+1 else today
                    IF NOT EXISTS(SELECT account_number
                                    FROM lp_account..account A WITH (noLock)
                                    WHERE account_number
                                        = @p_AccountNumber
                                        and account_id=@p_AccountID
                                      AND Status IN('999998', '999999')
                                      AND sub_status IN('10'))
                        BEGIN     
                            --If the account is active then get the next meter read date 

                            IF EXISTS(SELECT A.date_end
                                        FROM lp_account..account A WITH (noLock)
                                        WHERE account_number
                                            = @p_AccountNumber
                                          and  account_id=@p_AccountID
                                          AND date_end
                                            < GETDATE())
                                BEGIN     
                                    --If the account is expired 
                                    --set the meter read date
                                   SET @w_min_start_date=(SELECT Lp_deal_capture.dbo.ufn_GetNextMeterReadDate(@p_AccountID, @p_AccountNumber, @p_contract_eff_start_date, @p_utility_id));
                     
                                END;
                            ELSE-- if not expired get the contract enddate+1
                                BEGIN
                                Declare @ContractEndDate_1 datetime;
                                
                                    SET @ContractEndDate_1=((SELECT A.date_end +1
                                        FROM lp_account..account A WITH (noLock)
                                        WHERE account_number
                                            = @p_AccountNumber));
                                             --Modified Nov 15 2013
                                             --if the Contract EndDate also falls on the same montha nd year of the contractStartdate
                                             --Then we do the contractEndDate+1                                         
                                            If (@ContractEndDate_1 >@p_contract_eff_start_date)
                                            Begin
									   If (month(@ContractEndDate_1)=MOnth(@p_contract_eff_start_date) and Year(@ContractEndDate_1)=Year(@p_contract_eff_start_date))
									   Begin
										  SET @w_min_start_date=@ContractEndDate_1
									   End
									   Else
									   BEgin
										   SET @w_min_start_date=(SELECT Lp_deal_capture.dbo.ufn_GetNextMeterReadDate(@p_AccountID, @p_AccountNumber, @ContractEndDate_1, @p_utility_id));
									   END								    
								    END
								    Else
								    begin
								     SET @w_min_start_date=@p_contract_eff_start_date
								    End
								    
                                END;
                        END;
                    ELSE

                        BEGIN
                            SET @w_min_start_date=@p_contract_eff_start_date;
                        END;


                ----  if a new acount then we can use the same effective start date and end sdate
                --UPDATE Lp_deal_capture..deal_contract_account
                --SET contract_eff_start_date=@p_contract_eff_start_date, 
                --    date_end=CASE
                --             WHEN @w_fixed_end_date
                --                = 1 THEN @w_due_date
                --                 ELSE @w_date_end
                --             END
                --  WHERE contract_nbr
                --      = @p_contract_nbr
                --    AND account_number
                --      = @p_AccountNumber;

                END;


        END;
    ELSE
        BEGIN
            SET @w_min_start_date=@p_contract_eff_start_date;
        --  if a new acount then we can use the same effective start date and end sdate
        --UPDATE Lp_deal_capture..deal_contract_account
        --SET contract_eff_start_date=@p_contract_eff_start_date, 
        --    date_end=CASE
        --             WHEN @w_fixed_end_date
        --                = 1 THEN @w_due_date
        --                 ELSE @w_date_end
        --             END
        --  WHERE contract_nbr
        --      = @p_contract_nbr
        --    AND account_number
        --      = @p_AccountNumber;

        END;

    RETURN @w_min_start_date;
    


END;





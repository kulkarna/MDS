CREATE PROCEDURE [dbo].[usp_OE_FIX]
AS

-- GEt the accounts that were added for PPL after 2/19 (deploy of 20376) in order to resubmit their usage
Select	distinct 
		OA.ACCOUNT_NUMBER,Addr.ZIP,A.BillingAccountNumber,A.METER_TYPE,A.UTILITY,A.NAME_KEY, '007909427AC' as duns_number, '784087293' as EntityDuns, N.CUSTOMER_NAME
FROM	dbo.OE_OFFER_ACCOUNTS OA
Inner	JOIN dbo.OE_ACCOUNT A
On		OA.Account_Number = A.Account_Number
Inner	Join OE_OFFER O
ON		OA.OFFER_ID = O.OFFER_ID
INNER	JOIN dbo.OE_ACCOUNT_ADDRESS Addr
On		OA.Account_Number = Addr.Account_Number
Left	JOIN (	SELECT	distinct t1.ACCOUNT_NUMBER, ISNULL(CUSTOMER_NAME, '') AS CUSTOMER_NAME
				FROM	OE_PRICING_REQUEST_ACCOUNTS t1
				INNER	JOIN (
							Select	ACCOUNT_NUMBER, MAX(ID)ID
							FROM	OE_PRICING_REQUEST_ACCOUNTS
							GROUP	BY ACCOUNT_NUMBER
							) t2
				ON		t1.ID = t2.ID
				INNER	JOIN OE_PRICING_REQUEST PR
				ON		PR.REQUEST_ID = t1.PRICING_REQUEST_ID
				)N
ON		N.ACCOUNT_NUMBER = OA.ACCOUNT_NUMBER

WHERE	A.UTILITY = 'PPL'
AND		O.Date_CREATED > '2/19/2011'

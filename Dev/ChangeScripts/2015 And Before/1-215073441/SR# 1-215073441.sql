USE LibertyPower
GO
IF NOT EXISTS (SELECT * FROM LibertyPower..UtilityBillingType WITH(NOLOCK) where UtilityID=62 and BillingTypeID=2 )
BEGIN
Insert into LibertyPower..UtilityBillingType(UtilityID,BillingTypeID)
values(62,2)
END

IF NOT EXISTS (SELECT * FROM LibertyPower..UtilityBillingType WITH(NOLOCK) where UtilityID=64 and BillingTypeID=2 )
BEGIN
Insert into LibertyPower..UtilityBillingType(UtilityID,BillingTypeID)
values(64,2)
END
USE [LibertyPower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if not exists( Select 1 from LibertyPower..PromotionType WITH (NOLOCK) where Code='PowerBoostDiscount')
insert into LibertyPower..PromotionType(Code,[Description],CreatedBy,CreatedDate) 
			values('PowerBoostDiscount','To Support Bensalem Schools Affinity Program',1982,GETDATE())



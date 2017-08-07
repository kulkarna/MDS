USE [Libertypower]
GO

/****** Object:  View [dbo].[vw_AccountContractRate]    Script Date: 11/07/2012 15:19:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--GEt the current price of a multi term product. the current price is the price of the current subterm

CREATE VIEW [dbo].[vw_ProductCrossPriceMulti]
AS

SELECT	pcpm.ProductCrossPriceID, 
        pcpm.ProductCrossPriceMultiID, 
        b.StartDate,
        pcpm.Term, 
        pcpm.MarkupRate, 
        pcpm.Price
FROM	dbo.ProductCrossPriceMulti AS pcpm (nolock)
INNER	JOIN (
                  SELECT	pcpm1.ProductCrossPriceID, 
							MIN(pcpm1.StartDate) AS StartDate,
							MAX(DATEADD(d,-1,DATEADD(m,pcpm1.Term,pcpm1.StartDate))) AS EndDate
                  FROM		dbo.ProductCrossPriceMulti AS pcpm1 (nolock)
                  GROUP		BY 
                            pcpm1.ProductCrossPriceID
                  ) AS b 
ON      b.ProductCrossPriceID = pcpm.ProductCrossPriceID
WHERE 	1 = CASE 
  						WHEN b.StartDate >= GETDATE() AND b.StartDate = pcpm. StartDate THEN 1
  						WHEN (b.StartDate < GETDATE()AND b.EndDate >= GETDATE()) AND (pcpm.StartDate < GETDATE() AND DATEADD(d,-1,DATEADD(m,pcpm.Term,pcpm.StartDate)) >= GETDATE()) THEN 1
  						WHEN b.EndDate   < GETDATE() AND b.EndDate = DATEADD(d,-1,DATEADD(m,pcpm.Term,pcpm.StartDate)) THEN 1
						ELSE 0
			END  

GO



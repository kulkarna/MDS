USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiGetAccountAgregatedData]    Script Date: 2/17/2017 10:08:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================            

-- Author:  Miguel Vazquez            

-- Create date: 02/25/2013            

-- Description: Returns agregated EDI data (support for multiple meters)        

-- History *************************************-----        

--  Durgesh :- 12/03/2014 :- Updated stored for remove duplicate usage of same date without meter number against Bug #51960        

--  Test Data  

--  exec[dbo].[usp_EdiGetAccountAgregatedData]    'CSP','00040621064700435'    

--	exec [usp_EdiGetAccountAgregatedData] 'CSP' , '00040621085716554'    

--  exec[dbo].[usp_EdiGetAccountAgregatedData]    'METED','08061736030002108952'  

-- exec[dbo].[usp_EdiGetAccountAgregatedData]    'PPL','6403610351'      

--*************************************----------------------           
-- Modified By: Srikanth Bachina

--Modified Date:02/21/2017

--[TransactionSetPurposeCode] of table [IdrUsageHorizontal] is of type "varchar(10)".
 
--so use single quite to enclose the numeric value to avoid any possible issues. 
 -- Modify the iuh.TransactionSetPurposeCode = 52 to iuh.TransactionSetPurposeCode = '52' line no:500
 -- =============================================            

ALTER  PROCEDURE [dbo].[usp_EdiGetAccountAgregatedData]             

      @UtilityCode  varchar(50),            

      @AccountNumber varchar(50)            

AS       

SET NOCOUNT ON;  

BEGIN  

 IF (@UtilityCode NOT IN ('CSP', 'OHP','PPL'))  --If Utility code is not in CSP or OPH or PPL then below query run    

     BEGIN                

   
		IF OBJECT_ID('tempdb..#temp2') IS NOT NULL 

   DROP TABLE #temp2
 
 SELECT ea.UtilityCode, ea.AccountNumber, iuh.Date,    iuh.TimeStampInsert,  

    iuh.[0] , iuh.[15] , iuh.[30] , iuh.[45],      

    iuh.[100] , iuh.[115] , iuh.[130] , iuh.[145] ,      

    iuh.[200] , iuh.[215] , iuh.[230] , iuh.[245] ,      

    iuh.[300] , iuh.[315] , iuh.[330] , iuh.[345] ,      

    iuh.[400] , iuh.[415] , iuh.[430] , iuh.[445] ,      

    iuh.[500] , iuh.[515] , iuh.[530] , iuh.[545] ,      

    iuh.[600] , iuh.[615] , iuh.[630] , iuh.[645] ,      

    iuh.[700] , iuh.[715] , iuh.[730] , iuh.[745] ,      

    iuh.[800] , iuh.[815] , iuh.[830] , iuh.[845] ,      

    iuh.[900] , iuh.[915] , iuh.[930] , iuh.[945] ,      

    iuh.[1000] , iuh.[1015] , iuh.[1030] , iuh.[1045] ,      

    iuh.[1100] , iuh.[1115] , iuh.[1130] , iuh.[1145] ,      

    iuh.[1200] , iuh.[1215] , iuh.[1230] , iuh.[1245] ,      

    iuh.[1300] , iuh.[1315] , iuh.[1330] , iuh.[1345] ,      

    iuh.[1400] , iuh.[1415] , iuh.[1430] , iuh.[1445] ,      

    iuh.[1500] , iuh.[1515] , iuh.[1530] , iuh.[1545] ,      

    iuh.[1600] , iuh.[1615] , iuh.[1630] , iuh.[1645] ,      

    iuh.[1700] , iuh.[1715] , iuh.[1730] , iuh.[1745] ,      

    iuh.[1800] , iuh.[1815] , iuh.[1830] , iuh.[1845] ,      

    iuh.[1900] , iuh.[1915] , iuh.[1930] , iuh.[1945] ,      

    iuh.[2000] , iuh.[2015] , iuh.[2030] , iuh.[2045] ,      

    iuh.[2100] , iuh.[2115] , iuh.[2130] , iuh.[2145] ,      

    iuh.[2200] , iuh.[2215] , iuh.[2230] , iuh.[2245] ,      

    iuh.[2300] , iuh.[2315] , iuh.[2330] , iuh.[2345] ,      

    iuh.[2359] , iuh.[Int98] , iuh.[Int99] , iuh.[Int100]    ,iuh.MeterNumber   

	 into #temp2

    FROM IdrUsageHorizontal iuh WITH (NOLOCK)      

    INNER JOIN EdiAccount ea WITH (NOLOCK) ON iuh.EdiAccountId = ea.ID   
    WHERE       

      ea.UtilityCode = @UtilityCode   

    AND  ea.AccountNumber = @AccountNumber   

    AND  iuh.UnitOfMeasurement IN ('KH')    

If(@UtilityCode = 'DUKE')  
BEGIN
	update 
cp 
set 
cp.[0] = pp.[0]
from 
#temp2 cp, #temp2 pp 
where  cp.AccountNumber = pp.AccountNumber 
and cp.Date = pp.Date 
and substring(pp.MeterNumber,1,len(pp.MeterNumber)-1) = cp.MeterNumber  
END


    SELECT iuh.UtilityCode, iuh.AccountNumber, iuh.Date,      

    SUM(iuh.[0]) AS C0, SUM(iuh.[15]) AS C15, SUM(iuh.[30]) AS C30, SUM(iuh.[45]) AS C45,      

    SUM(iuh.[100]) AS C100, SUM(iuh.[115]) AS C115, SUM(iuh.[130]) AS C130, SUM(iuh.[145]) AS C145,      

    SUM(iuh.[200]) AS C200, SUM(iuh.[215]) AS C215, SUM(iuh.[230]) AS C230, SUM(iuh.[245]) AS C245,      

    SUM(iuh.[300]) AS C300, SUM(iuh.[315]) AS C315, SUM(iuh.[330]) AS C330, SUM(iuh.[345]) AS C345,      

    SUM(iuh.[400]) AS C400, SUM(iuh.[415]) AS C415, SUM(iuh.[430]) AS C430, SUM(iuh.[445]) AS C445,      

    SUM(iuh.[500]) AS C500, SUM(iuh.[515]) AS C515, SUM(iuh.[530]) AS C530, SUM(iuh.[545]) AS C545,      

    SUM(iuh.[600]) AS C600, SUM(iuh.[615]) AS C615, SUM(iuh.[630]) AS C630, SUM(iuh.[645]) AS C645,      

    SUM(iuh.[700]) AS C700, SUM(iuh.[715]) AS C715, SUM(iuh.[730]) AS C730, SUM(iuh.[745]) AS C745,      

    SUM(iuh.[800]) AS C800, SUM(iuh.[815]) AS C815, SUM(iuh.[830]) AS C830, SUM(iuh.[845]) AS C845,      

    SUM(iuh.[900]) AS C900, SUM(iuh.[915]) AS C915, SUM(iuh.[930]) AS C930, SUM(iuh.[945]) AS C945,      

    SUM(iuh.[1000]) AS C1000, SUM(iuh.[1015]) AS C1015, SUM(iuh.[1030]) AS C1030, SUM(iuh.[1045]) AS C1045,      

    SUM(iuh.[1100]) AS C1100, SUM(iuh.[1115]) AS C1115, SUM(iuh.[1130]) AS C1130, SUM(iuh.[1145]) AS C1145,      

    SUM(iuh.[1200]) AS C1200, SUM(iuh.[1215]) AS C1215, SUM(iuh.[1230]) AS C1230, SUM(iuh.[1245]) AS C1245,      

    SUM(iuh.[1300]) AS C1300, SUM(iuh.[1315]) AS C1315, SUM(iuh.[1330]) AS C1330, SUM(iuh.[1345]) AS C1345,      

    SUM(iuh.[1400]) AS C1400, SUM(iuh.[1415]) AS C1415, SUM(iuh.[1430]) AS C1430, SUM(iuh.[1445]) AS C1445,      

    SUM(iuh.[1500]) AS C1500, SUM(iuh.[1515]) AS C1515, SUM(iuh.[1530]) AS C1530, SUM(iuh.[1545]) AS C1545,      

    SUM(iuh.[1600]) AS C1600, SUM(iuh.[1615]) AS C1615, SUM(iuh.[1630]) AS C1630, SUM(iuh.[1645]) AS C1645,      

    SUM(iuh.[1700]) AS C1700, SUM(iuh.[1715]) AS C1715, SUM(iuh.[1730]) AS C1730, SUM(iuh.[1745]) AS C1745,      

    SUM(iuh.[1800]) AS C1800, SUM(iuh.[1815]) AS C1815, SUM(iuh.[1830]) AS C1830, SUM(iuh.[1845]) AS C1845,      

    SUM(iuh.[1900]) AS C1900, SUM(iuh.[1915]) AS C1915, SUM(iuh.[1930]) AS C1930, SUM(iuh.[1945]) AS C1945,      

    SUM(iuh.[2000]) AS C2000, SUM(iuh.[2015]) AS C2015, SUM(iuh.[2030]) AS C2030, SUM(iuh.[2045]) AS C2045,      

    SUM(iuh.[2100]) AS C2100, SUM(iuh.[2115]) AS C2115, SUM(iuh.[2130]) AS C2130, SUM(iuh.[2145]) AS C2145,      

    SUM(iuh.[2200]) AS C2200, SUM(iuh.[2215]) AS C2215, SUM(iuh.[2230]) AS C2230, SUM(iuh.[2245]) AS C2245,      

    SUM(iuh.[2300]) AS C2300, SUM(iuh.[2315]) AS C2315, SUM(iuh.[2330]) AS C2330, SUM(iuh.[2345]) AS C2345,      

    SUM(iuh.[2359]) AS C2359, SUM(iuh.[Int98]) AS Int98, SUM(iuh.[Int99]) AS Int99, SUM(iuh.[Int100]) AS Int100 
	 From (

  Select  Dense_Rank() OVER(partition by AccountNumber,UtilityCode,Date
    order by TimeStampInsert desc) as rowNumber,*

   from #temp2) iuh where iuh.rowNumber=1

	 GROUP BY iuh.UtilityCode, iuh.AccountNumber, iuh.Date      

    ORDER BY iuh.UtilityCode, iuh.AccountNumber, iuh.Date DESC   

    END   

 /*49364 PPL Parser Issue - PPL Utility Provids both format data 15 minute interval as well   

 as 60 minute interval to over come the issue we have changed this as 60 Minutes interval data */  

 ELSE If(@UtilityCode = 'PPL')   

  BEGIN  

  WITH CTE
     AS (SELECT ea.UtilityCode, ea.AccountNumber, this.*, ROW_NUMBER() OVER (ORDER BY this.date) AS rn
	 FROM IdrUsageHorizontal this WITH (NOLOCK)    

     INNER JOIN EdiAccount ea WITH (NOLOCK) ON this.EdiAccountId = ea.ID    

    WHERE     

     ea.UtilityCode = @UtilityCode  --AND this.TransactionSetPurposeCode = 52    

   AND  ea.AccountNumber = @AccountNumber AND     

     this.UnitOfMeasurement IN ('KH')    )

   SELECT this.UtilityCode, this.AccountNumber, this.Date,  NULL AS C0,  
 

     SUM(ISNULL(this.[15],0) + ISNULL(this.[30],0) + ISNULL(this.[45],0) + ISNULL(this.[100],0))AS C100,  

       

   NULL AS C15, NULL AS C30, NULL AS C45,  

            

   SUM( ISNULL(this.[115],0) + ISNULL(this.[130],0) + ISNULL(this.[145],0)+ISNULL(this.[200],0))AS C200,  

        

   NULL AS C115, NULL AS C130, NULL AS C145,  

        

   SUM(ISNULL(this.[215],0) + ISNULL(this.[230],0) + ISNULL(this.[245],0) + ISNULL(this.[300],0))AS C300,  

          

   NULL AS C215, NULL AS C230, NULL AS C245,   

        

   SUM(ISNULL(this.[315],0) + ISNULL(this.[330],0) + ISNULL(this.[345],0) + ISNULL(this.[400],0))AS C400,  

         

   NULL AS C315, NULL AS C330, NULL AS C345,    

        

   SUM(ISNULL(this.[415],0) + ISNULL (this.[430],0) + ISNULL(this.[445],0) + ISNULL(this.[500],0)) AS C500,   

        

   NULL AS C415, NULL AS C430, NULL AS C445,   

        

   SUM(ISNULL(this.[515],0) + ISNULL (this.[530],0) + ISNULL(this.[545],0) + ISNULL(this.[600],0)) AS C600,   

         

   NULL AS C515, NULL AS C530, NULL AS C545,   

        

   SUM(ISNULL(this.[615],0) + ISNULL (this.[630],0) + ISNULL(this.[645],0) + ISNULL(this.[700],0)) AS C700,   

         

   NULL AS C615, NULL AS C630, NULL AS C645,  

        

   SUM(ISNULL(this.[715],0) + ISNULL (this.[730],0) + ISNULL(this.[745],0) + ISNULL(this.[800],0)) AS C800,   

        

   NULL AS C715, NULL AS C730, NULL AS C745,   

        

   SUM(ISNULL(this.[815],0) + ISNULL (this.[830],0) + ISNULL(this.[845],0) + ISNULL(this.[900],0)) AS C900,   

         

   NULL AS C815, NULL AS C830, NULL AS C845,   

        

   SUM(ISNULL(this.[915],0) + ISNULL (this.[930],0) + ISNULL(this.[945],0) + ISNULL(this.[1000],0)) AS C1000,   

         

   NULL AS C915, NULL AS C930, NULL AS C945,   

        

   SUM(ISNULL(this.[1015],0) + ISNULL (this.[1030],0) + ISNULL(this.[1045],0) + ISNULL(this.[1100],0)) AS C1100,    

        

   NULL AS C1015, NULL AS C1030, NULL AS C1045,    

        

   SUM(ISNULL(this.[1115],0) + ISNULL (this.[1130],0) + ISNULL(this.[1145],0) + ISNULL(this.[1200],0)) AS C1200,   

        

   NULL AS C1115, NULL AS C1130, NULL AS C1145,  

        

   SUM(ISNULL(this.[1215],0) + ISNULL (this.[1230],0) + ISNULL(this.[1245],0) + ISNULL(this.[1300],0)) AS C1300,   

          

   NULL AS C1215, NULL AS C1230, null AS C1245,    

        

   SUM(ISNULL(this.[1315],0) + ISNULL (this.[1330],0) + ISNULL(this.[1345],0) + ISNULL(this.[1400],0)) AS C1400,   

        

   NULL AS C1315, NULL AS C1330, NULL AS C1345,  

        

   SUM(ISNULL(this.[1415],0) + ISNULL (this.[1430],0) + ISNULL(this.[1445],0) + ISNULL(this.[1500],0)) AS C1500,   

          

   NULL AS C1415, NULL AS C1430, NULL AS C1445,  

        

   SUM(ISNULL(this.[1515],0) + ISNULL (this.[1530],0) + ISNULL(this.[1545],0) + ISNULL(this.[1600],0)) AS C1600,     

        

   NULL AS C1515, NULL AS C1530, NULL AS C1545,  

        

   SUM(ISNULL(this.[1615],0) + ISNULL (this.[1630],0) + ISNULL(this.[1645],0) + ISNULL(this.[1700],0)) AS C1700,  

          

   NULL AS C1615, NULL AS C1630, NULL AS C1645,  

        

   SUM(ISNULL(this.[1715],0) + ISNULL (this.[1730],0) + ISNULL(this.[1745],0) + ISNULL(this.[1800],0)) AS C1800,  

          

   NULL AS C1715, NULL AS C1730, NULL AS C1745,  

        

   SUM(ISNULL(this.[1815],0) + ISNULL (this.[1830],0) + ISNULL(this.[1845],0) + ISNULL(this.[1900],0)) AS C1900,  

          

   NULL AS C1815, NULL AS C1830, NULL AS C1845,  

        

   SUM(ISNULL(this.[1915],0) + ISNULL (this.[1930],0) + ISNULL(this.[1945],0) + ISNULL(this.[2000],0)) AS C2000,  

          

   NULL AS C1915, NULL AS C1930, NULL AS C1945,  

        

   SUM(ISNULL(this.[2015],0) + ISNULL (this.[2030],0) + ISNULL(this.[2045],0) + ISNULL(this.[2100],0)) AS C2100,  

          

   NULL AS C2015, NULL AS C2030, NULL AS C2045,    

        

   SUM(ISNULL(this.[2115],0) + ISNULL (this.[2130],0) + ISNULL(this.[2145],0) + ISNULL(this.[2200],0)) AS C2200,  

        

   NULL AS C2115, NULL AS C2130, NULL AS C2145,    

        

   SUM(ISNULL(this.[2215],0) + ISNULL (this.[2230],0) + ISNULL(this.[2245],0) + ISNULL(this.[2300],0)) AS C2300,  

        

   NULL AS C2215, NULL AS C2230, null AS C2245,  

        

   --SUM(ISNULL (this.[2300],0)  + ISNULL(this.[2315],0) + ISNULL(this.[2330],0) + ISNULL(this.[2345],0) + ISNULL(this.[0],0)) AS C2300,  

          

   --NULL AS C0, NULL AS C2315, NULL AS C2330, NULL AS C2345,    

        

   
   
   
  SUM(ISNULL (this.[2315],0)  + ISNULL(this.[2330],0) + ISNULL(this.[2345],0) + ISNULL(prev.[0],0)) AS C2359,  

          

   NULL AS C2315, NULL AS C2330, NULL AS C2345, 

   SUM(this.[Int98]) AS Int98, SUM(this.[Int99]) AS Int99, SUM(this.[Int100]) AS Int100  


         



         

    FROM CTE this WITH (NOLOCK)    

     LEFT JOIN CTE prev WITH (NOLOCK) ON this.rn =  prev.rn - 1  

	

         GROUP BY this.UtilityCode, this.AccountNumber, this.Date   
		 order by this.date desc  

      

  END  

         
    ELSE    --If Utility code is CSP or OPH then below query run  

   BEGIN       

		IF OBJECT_ID('tempdb..#temp1') IS NOT NULL 

   DROP TABLE #temp1 

          

    SELECT 

    --iuh.id,

    ea.UtilityCode, ea.AccountNumber,iuh.Date, iuh.[0] ,iuh.[15]  , iuh.[30], iuh.[45],         

    iuh.[100]  , iuh.[115] , iuh.[130]  , iuh.[145], iuh.[200]  , iuh.[215] , iuh.[230]  , iuh.[245]  ,         

    iuh.[300]  , iuh.[315] , iuh.[330]  , iuh.[345], iuh.[400]  , iuh.[415] , iuh.[430]  , iuh.[445]  ,         

    iuh.[500]  , iuh.[515] , iuh.[530]  , iuh.[545], iuh.[600]  , iuh.[615] , iuh.[630]  , iuh.[645]  ,         

    iuh.[700]  , iuh.[715] , iuh.[730]  , iuh.[745]  ,  iuh.[800]  , iuh.[815] , iuh.[830]  , iuh.[845]  ,         

    iuh.[900]  , iuh.[915] , iuh.[930]  , iuh.[945]  ,  iuh.[1000] , iuh.[1015], iuh.[1030]  , iuh.[1045] ,         

    iuh.[1100] , iuh.[1115], iuh.[1130]  , iuh.[1145] , iuh.[1200] , iuh.[1215], iuh.[1230]  ,iuh.[1245] ,       

    iuh.[1300] , iuh.[1315], iuh.[1330] ,iuh.[1345] ,   iuh.[1400] , iuh.[1415], iuh.[1430] ,iuh.[1445] ,         

    iuh.[1500] , iuh.[1515],iuh.[1530] ,iuh.[1545] ,    iuh.[1600] , iuh.[1615],iuh.[1630] ,iuh.[1645] ,         

    iuh.[1700] , iuh.[1715],iuh.[1730],iuh.[1745] ,     iuh.[1800] , iuh.[1815],iuh.[1830] ,iuh.[1845],         

    iuh.[1900] , iuh.[1915],iuh.[1930],iuh.[1945] ,     iuh.[2000] , iuh.[2015],iuh.[2030] ,iuh.[2045],         

    iuh.[2100] , iuh.[2115],iuh.[2130] ,iuh.[2145],    iuh.[2200] , iuh.[2215],iuh.[2230] ,iuh.[2245],         

    iuh.[2300] , iuh.[2315] ,iuh.[2330] ,iuh.[2345],   iuh.[2359] , iuh.[Int98] ,iuh.[Int99] ,iuh.[Int100] ,iuh.MeterNumber       

    into #temp1  FROM IdrUsageHorizontal iuh WITH(NOLOCK)         

    INNER JOIN EdiAccount ea WITH(NOLOCK) ON iuh.EdiAccountId = ea.ID         

    WHERE          

      ea.UtilityCode = @UtilityCode
	 -- MOdify iuh.TransactionSetPurposeCode =52 to iuh.TransactionSetPurposeCode ='52'  
    AND iuh.TransactionSetPurposeCode ='52'       

       AND ea.AccountNumber = @AccountNumber

       AND iuh.UnitOfMeasurement IN ('KH')        

  

   

 

  Select iuh.UtilityCode, iuh.AccountNumber, iuh.Date,      

    SUM(iuh.[0]) AS C0, SUM(iuh.[15]) AS C15, SUM(iuh.[30]) AS C30, SUM(iuh.[45]) AS C45,      

    SUM(iuh.[100]) AS C100, SUM(iuh.[115]) AS C115, SUM(iuh.[130]) AS C130, SUM(iuh.[145]) AS C145,      

    SUM(iuh.[200]) AS C200, SUM(iuh.[215]) AS C215, SUM(iuh.[230]) AS C230, SUM(iuh.[245]) AS C245,      

    SUM(iuh.[300]) AS C300, SUM(iuh.[315]) AS C315, SUM(iuh.[330]) AS C330, SUM(iuh.[345]) AS C345,      

    SUM(iuh.[400]) AS C400, SUM(iuh.[415]) AS C415, SUM(iuh.[430]) AS C430, SUM(iuh.[445]) AS C445,      

    SUM(iuh.[500]) AS C500, SUM(iuh.[515]) AS C515, SUM(iuh.[530]) AS C530, SUM(iuh.[545]) AS C545,      

    SUM(iuh.[600]) AS C600, SUM(iuh.[615]) AS C615, SUM(iuh.[630]) AS C630, SUM(iuh.[645]) AS C645,      

    SUM(iuh.[700]) AS C700, SUM(iuh.[715]) AS C715, SUM(iuh.[730]) AS C730, SUM(iuh.[745]) AS C745,      

    SUM(iuh.[800]) AS C800, SUM(iuh.[815]) AS C815, SUM(iuh.[830]) AS C830, SUM(iuh.[845]) AS C845,      

    SUM(iuh.[900]) AS C900, SUM(iuh.[915]) AS C915, SUM(iuh.[930]) AS C930, SUM(iuh.[945]) AS C945,      

    SUM(iuh.[1000]) AS C1000, SUM(iuh.[1015]) AS C1015, SUM(iuh.[1030]) AS C1030, SUM(iuh.[1045]) AS C1045,      

    SUM(iuh.[1100]) AS C1100, SUM(iuh.[1115]) AS C1115, SUM(iuh.[1130]) AS C1130, SUM(iuh.[1145]) AS C1145,      

    SUM(iuh.[1200]) AS C1200, SUM(iuh.[1215]) AS C1215, SUM(iuh.[1230]) AS C1230, SUM(iuh.[1245]) AS C1245,      

    SUM(iuh.[1300]) AS C1300, SUM(iuh.[1315]) AS C1315, SUM(iuh.[1330]) AS C1330, SUM(iuh.[1345]) AS C1345,      

    SUM(iuh.[1400]) AS C1400, SUM(iuh.[1415]) AS C1415, SUM(iuh.[1430]) AS C1430, SUM(iuh.[1445]) AS C1445,      

    SUM(iuh.[1500]) AS C1500, SUM(iuh.[1515]) AS C1515, SUM(iuh.[1530]) AS C1530, SUM(iuh.[1545]) AS C1545,      

    SUM(iuh.[1600]) AS C1600, SUM(iuh.[1615]) AS C1615, SUM(iuh.[1630]) AS C1630, SUM(iuh.[1645]) AS C1645,      

    SUM(iuh.[1700]) AS C1700, SUM(iuh.[1715]) AS C1715, SUM(iuh.[1730]) AS C1730, SUM(iuh.[1745]) AS C1745,      

    SUM(iuh.[1800]) AS C1800, SUM(iuh.[1815]) AS C1815, SUM(iuh.[1830]) AS C1830, SUM(iuh.[1845]) AS C1845,      

    SUM(iuh.[1900]) AS C1900, SUM(iuh.[1915]) AS C1915, SUM(iuh.[1930]) AS C1930, SUM(iuh.[1945]) AS C1945,      

    SUM(iuh.[2000]) AS C2000, SUM(iuh.[2015]) AS C2015, SUM(iuh.[2030]) AS C2030, SUM(iuh.[2045]) AS C2045,      

    SUM(iuh.[2100]) AS C2100, SUM(iuh.[2115]) AS C2115, SUM(iuh.[2130]) AS C2130, SUM(iuh.[2145]) AS C2145,      

    SUM(iuh.[2200]) AS C2200, SUM(iuh.[2215]) AS C2215, SUM(iuh.[2230]) AS C2230, SUM(iuh.[2245]) AS C2245,      

    SUM(iuh.[2300]) AS C2300, SUM(iuh.[2315]) AS C2315, SUM(iuh.[2330]) AS C2330, SUM(iuh.[2345]) AS C2345,      

    SUM(iuh.[2359]) AS C2359, SUM(iuh.[Int98]) AS Int98, SUM(iuh.[Int99]) AS Int99, SUM(iuh.[Int100]) AS Int100
	

    

  From (

  Select  ROW_NUMBER() OVER(partition by AccountNumber,UtilityCode,Date,[0],[15],[30],[45],[100] 

  order by AccountNumber) as rowNumber,*

   from #temp1) iuh where iuh.rowNumber=1

	GROUP BY iuh.UtilityCode, iuh.AccountNumber, iuh.Date    

    ORDER BY iuh.UtilityCode, iuh.AccountNumber, iuh.Date DESC    

  END         

END   

SET NOCOUNT OFF; 

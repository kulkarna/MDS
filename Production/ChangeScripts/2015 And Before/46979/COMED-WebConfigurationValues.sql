  USE lp_transactions
  GO
  
  update [WebConfigurationValues]
  set ConfigurationValue = REPLACE(configurationValue,'ctl00$SPWebPartManager1$g_f9e92af4_f7e3_49c0_8ce2_ea5dd25edaa3$ctl00$RequestOption','ctl00$SPWebPartManager1$g_1bb6dc86_55ab_4ea9_a4db_4747922a8202$ctl00$RequestOption')
  where UtilityCode = 'COMED' and configurationType =4
    and WebPageReference='HomePageData2'
  
  GO  
     update [WebConfigurationValues]
  set ConfigurationValue = REPLACE(configurationValue,'ctl00$SPWebPartManager1$g_f9e92af4_f7e3_49c0_8ce2_ea5dd25edaa3$ctl00$AccountNumber','ctl00$SPWebPartManager1$g_1bb6dc86_55ab_4ea9_a4db_4747922a8202$ctl00$AccountNumber')
  where UtilityCode = 'COMED' and configurationType =4
    and WebPageReference='HomePageData3'

  
    
        


SELECT 'INSERT INTO LibertyPower.dbo.SalesChannelDeviceAssignment (ChannelID, DeviceID, IsActive) VALUES(' + 
      CAST([PartnerID] as varchar(15)) +
      ', ''' + CAST([DeviceID] as varchar(50)) + ''''+
      ', ' + CAST([Enabled] as varchar(1)) + ');'
      
  FROM [GENIE].[dbo].[LK_PartnerAgent] WITH (NOLOCK)
  WHERE Enabled = 1
USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if not exists( select 1 from LibertyPower..ComplaintStatus WITH (NOLOCK) where Name ='ERROR')
	insert into LibertyPower..ComplaintStatus(ComplaintStatusID,Name) values(2,'ERROR')
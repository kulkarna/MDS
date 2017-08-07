/***************************** [dbo].[usp_IDRServiceConfigurationSelect] ********************/
CREATE PROCEDURE [dbo].[usp_IDRServiceConfigurationSelect]                                                                                    
	@UtilityID	varchar(15)

AS
BEGIN

	SELECT	StartDate, StartTime, Frequency, EmailNotification, [Status]
	FROM	IDRServiceConfiguration
	WHERE	UtilityID	= @UtilityID

END                                                                                                                                              

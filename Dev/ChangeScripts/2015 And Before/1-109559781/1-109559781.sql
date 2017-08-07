/* Inserting required dispositions for Retention Queue dropdown. */
use Lp_common
insert into [dbo].[common_views] 
	([process_id],[seq],[option_id],[return_value],[active])
VALUES
	('REASON CODE', 22065 ,'Wrong Telephone number', '3010' ,1)

insert into [dbo].[common_views] 
	([process_id],[seq],[option_id],[return_value],[active])
VALUES
	('REASON CODE', 22066 ,'Disconnected Telephone number', '3020' ,1)


/* Inserting matching rows in call_status table. */
use Lp_Enrollment
INSERT INTO [dbo].[call_status] VALUES ('3010','L','',0,0)
INSERT INTO [dbo].[call_status] VALUES ('3020','L','',0,0)
USE LibertyPower

select * from ManagerRoot                                                                                                 
select * from FileManager

INSERT	INTO FileManager
VALUES	('true', 'MtM Data Uploads',GETDATE(),0)

INSERT	INTO ManagerRoot
VALUES	(16, 'E:\MtM\WsoFiles\Archive\', 1,GETDATE(),0)



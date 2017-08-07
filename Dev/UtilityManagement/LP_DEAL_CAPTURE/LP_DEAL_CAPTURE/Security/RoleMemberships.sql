EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\rdeigsler';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'NT AUTHORITY\NETWORK SERVICE';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\webadmin';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\lpapplications_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\SQL_Rep_Ser_RW_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'mguevara';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\SvcSSISdmzctr';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'mtm';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\jforero';


GO
EXECUTE sp_addrolemember @rolename = N'db_accessadmin', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_accessadmin', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_securityadmin', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_securityadmin', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_ddladmin', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_ddladmin', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_ddladmin', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'svc_sql';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'LIBERTYPOWER\sqlagent_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'invoicing';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'readonly';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQLProdSupportRO';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'readonly_msoffice';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'dmaia';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Reporting_ReadOn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Rep_Ser_Read_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'SQL_Rep_Ser_Read_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'SQL_Rep_Ser_RW_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Rep_Ser_RW_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'sqllinkedserver_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'libertypower\pperez';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\dmoretti';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ReadOnly_Access_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ReadOnly_Excel_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\sscott';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LnkSrvFrmSQL9Txn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\jmarsh';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\clima';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'libertypower\lrosenblum';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\SQL_Rep_Ser_RW_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LnkSrvFrmSQL9Txn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatareader', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatareader', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'chrisruby';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'BUILTIN\Administrators';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\SQLProdSupportRO';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'readonly_msoffice';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\dmoretti';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'ReadOnly_Access_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'ReadOnly_Excel_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\sscott';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\jmarsh';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\clima';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'libertypower\lrosenblum';


use lp_transactions

GO

update lp_transactions..WebConfigurationValues
set ConfigurationValue='https://login.ameren.com/nidp/app/login'
where UtilityCode='AMEREN'
and WebPageReference='LoginPage'

GO
update lp_transactions..WebConfigurationValues
set ConfigurationValue='Ecom_User_ID=LibertyPowerH&Ecom_Password=Florida&id=eCustomer'
where UtilityCode='AMEREN'
and WebPageReference='LoginPageData'


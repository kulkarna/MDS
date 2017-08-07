
$Enroll = New-WebServiceProxy -Uri http://lpcnocws4/EnrollmentWebServices/LPSingleEnrollmentAccount.asmx?wsdl
$Enroll.SendingAccAsync()

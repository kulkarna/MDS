USE LIBERTYPOWER 
GO
If Exists(Select * from UtilityPaymentTerms ut with (nolock) Join Utility U with (nolock) on
 U.ID=ut.UtilityId where u.UtilityCode in ('NSTAR-BOS','NSTAR-CAMB','NSTAR-COMM'))
    UPDATE UtilityPaymentTerms set ARTerms=58 where UtilityId in  
    (Select u.id from Utility u with (nolock) where u.UtilityCode in ('NSTAR-BOS','NSTAR-CAMB','NSTAR-COMM'))
If Exists(Select * from Utility with (nolock) where UtilityCode in ('NSTAR-BOS','NSTAR-CAMB','NSTAR-COMM'))
    UPDATE Utility set AutoApproval=1, PorOption='YES' where UtilityCode in ('NSTAR-BOS','NSTAR-CAMB','NSTAR-COMM')
    
--Select * from libertypower..Utility where UtilityCode like '%NSTAR%'

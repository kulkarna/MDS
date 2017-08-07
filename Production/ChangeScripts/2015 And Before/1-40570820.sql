begin tran
update libertypower..WorkflowTaskLogic
set workflowtaskid = workflowtaskidrequired
from libertypower..workflowtasklogic wtl
join libertypower..workflowpathlogic wpl on wtl.workflowtaskid = wpl.workflowtaskid
where 1 = 1
and wpl.workflowtaskid in (35,
41,
53,
96,
106,
132,
140,
155,
162)


update libertypower..WorkflowTaskLogic
set workflowtaskid = 71
where workflowtaskid in (69)

update libertypower..WorkflowTaskLogic
set workflowtaskid = 46
where workflowtaskid in (44)

commit
use OnlineEnrollment
go
begin 
begin tran 
update LegalContent set Content = 'I understand that I may have a certain number of days, based on my customer class
    and the state in which the account is located, to cancel the agreement without penalty
    according to the chart below.
    <p>
    </p>
    <style>
        .rescissionTable
        {
            border: 1px solid #CCC;
            border-radius: 5px;
        }
        .RescissionPeriodChartHeader
        {
            font-size: 25px;
            background-color: #DDD;
        }
        .centerAlign
        {
            text-align: center;
        }
        .rescissionTable tr
        {
        }
        .rescissionTable td
        {
            width: 150px;
            padding: 10px;
            border: 1px solid #CCC;
        }
        .rescissionTable th
        {
            border: 1px solid #CCC;
            background-color: #CCC;
            height: 35px;
            text-align:center;
        }
    </style>
    <table class="rescissionTable" id="rescissionChartTable" cellspacing="0">
        <tr>
            <td class="noBorder">
            </td>
            <td colspan="4" class="centerAlign RescissionPeriodChartHeader">
                Rescission Period
            </td>
        </tr>
        <tr>
            <th>
                Customer Class
            </th>
            <th>
                IL
            </th>
            <th>
                PA
            </th>
            <th>
                NY
            </th>
            <th>
                OH
            </th>
        </tr>
        <tr>
            <td>
                Residential
            </td>
            <td>
                Any time before the enrollment is submitted to the utility, or within 10 calendar
                days after the utility processes the enrollment request
            </td>
            <td>
                3 business days
            </td>
            <td>
                3 business days
            </td>
            <td>
                Within seven calendar days following a confirmation notice from the electric utility
            </td>
        </tr>
        <tr>
            <td>
                Commercial
            </td>
            <td>
                Any time before the enrollment is submitted to the utility, or within 10 calendar
                days after the utility processes the enrollment request
            </td>
            <td>
                3 business days
            </td>
            <td>
                No Rescission Period
            </td>
            <td>
                Within seven calendar days following a confirmation notice from the electric utility
            </td>
        </tr>
    </table>'
     where LegalContentId = 14 
--rollback
commit
end
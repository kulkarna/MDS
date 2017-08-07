
IE4 = (document.all);
NS4 = (document.layers);

if (NS4) document.captureEvents(Event.KEYPRESS);
document.onkeypress = doKey;

var isEnterKeyDisabled = true;

function doKey(e) 
{
    key = (NS4) ? e.which : event.keyCode;

    if((key == 13) && isEnterKeyDisabled)
    {
		return !(window.event && window.event.keyCode == 13);
    }
}


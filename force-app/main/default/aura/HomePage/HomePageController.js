({
    myAction : function(component, event, helper) {
        console.log('Main Fun Home');
    },


    gotoDashboard: function(component,event){
        console.log('gotoDashboard called');

        var evt = $A.get('e.force:navigateToComponent');
        console.log('evt-->'+ evt);
        evt.setParams({
            componentDef : "c:Dashboard",
            componentAttributes: {
                contactId : '21132423sdfe23'
            }
        });
    }



})
({
    doInit : function(component, event, helper) {
        component.set('v.columns',[
            {label : 'Business Goal',
             fieldName : 'Subject',
             type : 'picklist'},
            {label : 'Target Date',
             fieldName : 'ActivityDate',
             type:"date",
             typeAttributes:{
                 weekday: "long",
                 year: "numeric",
                 month: "long",
                 day: "2-digit"
             }},
            {label : 'Status',
             fieldName : 'Status',
             type : 'picklist'},
            {label : 'Description',
             fieldName : 'Description',
             type : 'text',
             wrapText: true}
        ])
    },
    getSelectedTask : function(component,event,helper){
        var selectedTasks = event.getParam('selectedRows');
        component.set('v.selectedTasks',selectedTasks[0])
    },
    updateSorting : function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sordDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection)
    }
})
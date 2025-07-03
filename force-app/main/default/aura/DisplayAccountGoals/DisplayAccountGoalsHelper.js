({
	sortData : function(cmp, fieldName, sortDirection) {
        var fname = fieldName;
		var data = cmp.get("v.taskList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.taskList",data);
	},
    sortBy: function(field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a,b) {
            return a = key(a), b = key(b), reverse *((a > b) - (b > a));
        }
    }
})
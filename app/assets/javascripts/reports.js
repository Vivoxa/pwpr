function checkAll() {
    var $my_check = document.getElementById('selectAll')
    if ($my_check.checked) {
        $(':checkbox').each(function () {
            this.checked = true;
        });
        $my_check.checked = true;
    } else {
        $(':checkbox').each(function () {
            this.checked = false;
        });
        $my_check.checked = false
    }
}

function yearChanged(year) {
    $.ajax({
        url: 'reports/report_data',
        data: {
            report: document.getElementById('report').value,
            year: year.value
        }
    });
}
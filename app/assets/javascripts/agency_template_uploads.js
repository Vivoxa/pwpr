function selectedYearChanged(year) {
    $.ajax({

        url: "previous_upload_for_year",
        data: {
            year: year.value
        }
    });
}
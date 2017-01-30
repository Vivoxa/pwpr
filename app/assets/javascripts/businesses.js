function subsidiaryCo(subtype) {
    $.ajax({
        url: 'businesses/scheme_businesses',
        data: {
            scheme_id: document.getElementById('business_scheme_id').value,
            company_subtype: subtype.selectedOptions[0].innerText
        }
    });
}
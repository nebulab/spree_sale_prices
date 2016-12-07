//= require jquery-ui-timepicker-addon

handle_datetime_picker_fields = function() {
  $('.datetimepicker').datetimepicker({
    dateFormat: Spree.translations.date_picker,
    timeFormat: "hh:mm tt",
    dayNames: Spree.translations.abbr_day_names,
    dayNamesMin: Spree.translations.abbr_day_names,
    firstDay: Spree.translations.first_day,
    monthNames: Spree.translations.month_names,
    prevText: Spree.translations.previous,
    nextText: Spree.translations.next,
    showOn: "focus",
    oneLine: true
  });
}

$(document).ready(function() {
  handle_datetime_picker_fields();
});

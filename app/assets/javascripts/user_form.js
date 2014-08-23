$(function () {
  $('.form-group.user_company_name').toggle($('#user_is_company').checked);
  $('.form-group.user_company_info').toggle($('#user_is_company').checked);

  $('#user_is_company').change(function () {
     $('.form-group.user_company_name').toggle(this.checked);
     $('.form-group.user_company_info').toggle(this.checked);
  }).change(); //ensure visible state matches initially
});

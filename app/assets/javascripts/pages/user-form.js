PhaxMachine.pages['user-form'] = {
    render: function() {
        $('#addUserEmail').on('click', function() {
            var emailInputs = $('#userEmailList input[type=email]');
            var nextIdx = emailInputs.length;
            var newInput = emailInputs.first().clone();
            newInput.attr('id', 'user_user_emails_attributes_' + nextIdx + '_email');
            newInput.attr('name', 'user[user_emails_attributes][' + nextIdx + '][email]');
            newInput.attr('value', '');
            newInput.val('');
            $('#userEmailList').append(newInput);
        });
    }
}
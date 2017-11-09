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

            // Super ugly, but it's 2 AM and this needs to go out.
            var inputGroup = $('<div class="input-group"></div>')
            var hiddenFieldHtml = '<input class="destroy-field" type="hidden" value="false" name="user[user_emails_attributes][' + nextIdx + '][_destroy]" id="user_user_emails_attributes_' + nextIdx + '__destroy">';
            var inputGroupBtn = $('<span class="input-group-btn">' + hiddenFieldHtml + '<a class="btn btn-secondary btn-remove-email" ><i class="glyphicon glyphicon-trash"></i></a></span>');
            inputGroup.append(newInput);
            inputGroup.append(inputGroupBtn);

            $('#userEmailList').append(inputGroup);
        });

        $(document).on('click', '.btn-remove-email', function() {
            var inputGroup = $(this).closest('.input-group');
            inputGroup.find('input[type="email"]').val('pending@deletion.com')
            inputGroup.find('.destroy-field').val(true)
            inputGroup.hide();
        });
    }
}
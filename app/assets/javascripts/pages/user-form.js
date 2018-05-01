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

        $('#addUserFaxNumber').on('click', function() {
            var faxNumberInputs = $('#userFaxNumberList input[type=tel]');
            var nextFaxIdx = faxNumberInputs.length;
            var newFaxInput = faxNumberInputs.first().clone();
            newFaxInput.attr('id', 'user_user_fax_numbers_attributes_' + nextFaxIdx + '_fax_number');
            newFaxInput.attr('name', 'user[user_fax_numbers_attributes][' + nextFaxIdx + '][fax_number]');
            newFaxInput.attr('value', '');
            newFaxInput.val('');

            // Super ugly, but this time Matt copy-pasted what's above
            var inputFaxGroup = $('<div class="input-group"></div>')
            var hiddenFaxFieldHtml = '<input class="destroy-field" type="hidden" value="false" name="user[user_fax_numbers_attributes][' + nextFaxIdx + '][_destroy]" id="user_user_fax_numbers_attributes_' + nextFaxIdx + '__destroy">';
            var inputFaxGroupBtn = $('<span class="input-group-btn">' + hiddenFaxFieldHtml + '<a class="btn btn-secondary btn-remove-tel" ><i class="glyphicon glyphicon-trash"></i></a></span>');
            inputFaxGroup.append(newFaxInput);
            inputFaxGroup.append(inputFaxGroupBtn);

            $('#userFaxNumberList').append(inputFaxGroup);
        });

        // Matt again, these two functions could probably use the same class and work but again
        // I'm ignorant of Vue and don't want to mess anything up
        $(document).on('click', '.btn-remove-email', function() {
            var inputGroup = $(this).closest('.input-group');
            inputGroup.find('input[type="email"]').val('pending@deletion.com')
            inputGroup.find('.destroy-field').val(true)
            inputGroup.hide();
        });
        
        $(document).on('click', '.btn-remove-tel', function() {
            var inputFaxGroup = $(this).closest('.input-group');
            inputFaxGroup.find('input[type="tel"]').val('12223334444')
            inputFaxGroup.find('.destroy-field').val(true)
            inputFaxGroup.hide();
        });
    }
}
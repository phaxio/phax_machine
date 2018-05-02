PhaxMachine.pages['user-form'] = {
    render: function() {
    		ensureNoBlankRadioButtons();

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

            // Super ugly, but this time Matt copy-pasted what's above b/c he doesn't know Vue.js and didn't want to accidentally break anything
            var inputFaxGroup = $('<div class="input-group"></div>')
            var inputRadioButton = $('<div class="radio"><input class="radio-btn" type="radio" value="false" name="user[user_fax_numbers_attributes][' + nextFaxIdx + '][primary_number]"></div>')
            var hiddenFaxFieldHtml = '<input class="destroy-field" type="hidden" value="false" name="user[user_fax_numbers_attributes][' + nextFaxIdx + '][_destroy]" id="user_user_fax_numbers_attributes_' + nextFaxIdx + '__destroy">';
            var inputFaxGroupBtn = $('<span class="input-group-btn">' + hiddenFaxFieldHtml + '<a class="btn btn-secondary btn-remove-tel" ><i class="glyphicon glyphicon-trash"></i></a></span>');
            inputFaxGroup.append(inputRadioButton);
            inputFaxGroup.append(newFaxInput);
            inputFaxGroup.append(inputFaxGroupBtn);
            $('#userFaxNumberList').append(inputFaxGroup);
        });

        $(document).on('click', '.btn-remove-email', function() {
            var inputGroup = $(this).closest('.input-group');
            var inputId = inputGroup.find('input[type="email"]').attr('id');
            // Added this regexp so that it doesn't find duplicates of 'pending@deletion.com' Looks for any integer
            // 0th index of match object is the actual match
            var inputGroupIdx = inputId.match(/[\d]/);
            inputGroup.find('input[type="email"]').val('pending@deletion.com' + inputGroupIdx[0]);
            inputGroup.find('.destroy-field').val(true);
            inputGroup.hide();
        });
        
        $(document).on('click', '.btn-remove-tel', function() {
            var inputFaxGroup = $(this).closest('.input-group');
	          inputFaxGroup.find('input[type="tel"]').val('12223334444');
	          inputFaxGroup.find('.destroy-field').val(true);
	          inputFaxGroup.find('.radio-btn').prop('value', false);
        		inputFaxGroup.find('.radio-btn').prop('checked', false);
	          inputFaxGroup.hide();
        		ensureNoBlankRadioButtons();
        });

        $(document).on('click', '.radio-btn', function() {
        		ensureNoBlankRadioButtons();
        		var radioButtonValue = $(this).prop('value');
        		var allRadioButtons = $('.radio-btn');
        		if (radioButtonValue) {
        				allRadioButtons.each(function() {
        						if ($(this).prop('value') && $(this).attr('id') === $(event.target).attr('id')) {
        							return;
        						} else if ($(this).prop('value') && $(this).attr('id') !== $(event.target).attr('id')) {
        								$(this).prop('value', false);
        								$(this).prop('checked', false);
        						} else {
        								$(this).prop('value', false);
        								$(this).prop('checked', false);
        						}
        				})
        		}
        });
    }
}

function ensureNoBlankRadioButtons() {
  var allRadioButtons = $('.radio-btn');
	if (radioButtonIsChecked(allRadioButtons)) {
		$('#submit-button').removeClass('disabled');
		$('#submit-button').prop('disabled', false);
	} else {
		$('#submit-button').addClass('disabled');
		$('#submit-button').prop('disabled', true);
		createUserAlert("danger", "Please select a primary number before continuing");
	}
}

function radioButtonIsChecked(allRadioButtons) {
	var isChecked = false;
	allRadioButtons.each(function() {
		if ($(this).prop('checked') === true) {
			isChecked = true;
		}
	});
	return isChecked;
}

function createUserAlert(type, message) {
	var alert = $("<div class='alert alert-dismissable alert-" + type + "'></div>")
	var closeAlertButton = $(
		'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+ '<span aria-hidden="true">&times;</span>'
		+ '</button>'
	)
	alert.append(closeAlertButton)
	alert.append(message)
	$("form").prepend(alert)
}
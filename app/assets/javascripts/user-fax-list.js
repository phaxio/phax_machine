function formatMoney(valueInCents) {
  var valueString = String(valueInCents);
  while (valueString.length < 3) {
    valueString = "0" + valueString;
  }
  var valueChars = valueString.split("");
  valueChars.splice(-2, 0, ".");
  return "$" + valueChars.join("");
}

function capitalize(string) {
  chars = string.split('');
  chars[0] = chars[0].toUpperCase();
  return chars.join('');
}

document.addEventListener('DOMContentLoaded', function() {
  function getUserFaxes() {
    var userJsonPath = '/users/' + userId + '.json';
    $.getJSON(userJsonPath)
      .done(updateUserFaxList)
      .fail(retryGetUserFaxes);
  }

  function retryGetUserFaxes() {
    console.error("Something went wrong getting user fax data. Waiting 5s and trying again.");
    setTimeout(getUserFaxes, 5000);
  }

  function updateUserFaxList(faxDataResponse) {
    if (faxDataResponse.success) {
      userFaxList.loading = false;
      userFaxList.empty = faxDataResponse.data.length == 0
      userFaxList.faxes = faxDataResponse.data
    }
    else {
      retryGetUserFaxes();
    }
  }

  if ($('#userFaxList').length > 0) {
    var userFaxList = new Vue({
      el: '#userFaxList',
      data: {
        loading: true,
        empty: false,
        faxes: []
      },
      methods: {
        faxCost: function(fax) {
          return formatMoney(fax.cost);
        },
        faxDirection: function(fax) {
          return capitalize(fax.direction);
        },
        faxStatus: function(fax) {
         var statusMap = {
            building:       ['Building',        'info'   ],
            pendingbatch:   ['Batching',        'info'   ],
            queued:         ['Queued',          'info'   ],
            inprogress:     ['In Progress',     'info'   ],
            ringing:        ['Ringing',         'info'   ],
            callactive:     ['Call Active',     'info'   ],
            success:        ['Success',         'success'],
            partialsuccess: ['Partial Success', 'warning'],
            willretry:      ['Will Retry',      'warning'],
            failure:        ['Failure',         'danger' ]
          };

          var statusText = statusMap[fax.status][0];
          var statusClass = statusMap[fax.status][1];

          return "<span class='text-" + statusClass + "'>" + statusText + "</span>";
        },
        faxType: function(fax) {
          if (fax.isTest) {
            return 'Test';
          }
          else {
            return 'Live';
          }
        }
      }
    });

    var userId = $('#userFaxList').data('user-id');

    getUserFaxes();
  }
});

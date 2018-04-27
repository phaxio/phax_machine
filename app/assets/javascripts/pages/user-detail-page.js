PhaxMachine.pages['user-detail-page'] = {
  data: {
    userId: null,
  },

  userFaxList: null,

  render: function(){
    this.data.userId = this.getUserFaxListElement().dataset.userId;
    if (this.getUserFaxListElement() !== null){
      this.userFaxList = new Vue({
        el: '#userFaxList',
        data: {
          loading: true,
          empty: false,
          totalSent: 'N/A',
          totalReceived: 'N/A',
          faxes: []
        },
        methods: {
          faxCost: function(fax) {
            return PhaxMachine.Utils.formatMoney(fax.cost);
          },
          faxDirection: function(fax) {
            return PhaxMachine.Utils.capitalize(fax.direction);
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
    };
    this.getUserFaxes();
  },

  userDataPath: function(){
    return '/users/' + this.data.userId + '.json';
  },

  getUserFaxListElement: function(){
    return document.getElementById('userFaxList');
  },

  getUserFaxes: function(){
    $.getJSON(this.userDataPath())
      .done(this.updateUserFaxList())
      .fail(this.retryGetUserFaxes)
  },

  updateUserFaxList: function(){
    return function(faxDataResponse){
      if (faxDataResponse.success){
        this.userFaxList.totalSent = faxDataResponse.totals.sent;
        this.userFaxList.totalReceived = faxDataResponse.totals.received;
        this.userFaxList.loading = false;
        this.userFaxList.empty = faxDataResponse.data.length == 0;
        this.userFaxList.faxes = faxDataResponse.data;
      }
      else{
        this.retryGetUserFaxes();
      }
    }.bind(this);
  },

  retryGetUserFaxes: function(){
    console.error("Something went wrong getting user fax data. Waiting 1s and trying again.");
    setTimeout(this.getUserFaxes, 1000);
  }
}

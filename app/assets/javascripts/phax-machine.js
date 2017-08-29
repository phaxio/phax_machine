PhaxMachine = {
  pages: [],
  render: function(){
    var pageName = document.getElementsByTagName('body')[0].dataset.page;
    var page = PhaxMachine.pages[pageName];
    if (page != null){
      page.render();
    }
  }
};

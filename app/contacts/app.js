class ContactsApp {
  constructor(options) {
    this.region = options.region;
  }

  showContactList() {
    App.trigger('loading:start')
    App.trigerr('app:contacts:started');

    new ContactCollection().fetch({
      success: (collection) => {
        this.showList(collection);
        App.trigger('loading:stop');
      },
      fail: (collection, response) => {
        App.trigger('loading:stop');
        App.trigger('server:error', response);
      }
    })
  }

  showNewContactForm() {
    App.trigger('app:contacts:new:started');
    this.showEditor(new Contact());
  }

  showContactEditorById(contactId){
    App.trigger('loading:start');
    App.trigger('app:contacts:started');

    new Contact({id: contactId}).fetch({
      success: (model) => {
        this.showEditor(model);
        App.trigger('loading:stop');
      },
      fail: (collection, response) => {
        App.trigger('loading:stop');
        App.trigger('server:error', respone);
      }
    })
  }

  showContactById(contactId) {
    App.trigger('loading:start');
    App.trigger('app:contacts:started');

    new Contact({id: contactId}).fetch({
      success: (model) => {
        this.showViewer(model);
        App.trigger('loading:stop');
      },
      fail: (collection, response) => {
        App.trigger('loading:stop');
        App.trigger('server:error', response);
      }
    })
  }

  showList(contacts) {
    var contactList = this.startController(ContactList);
    contactList.showList(contacts);
  }

  showEditor(contact) {
    var contactEditor = this.startController(ContactEditor);
    contactEditor.showEditor(contact);
  }

  showViewer(contact) {
    var contactViewer = this.startController(ContactViewer);
    contactViewer.showContart(contact);
  }

  startController(Controller) {
    if (this.currentController &&
        this.currentController instanceof Controller) {
      return this.currentController;
    }

    if (this.currentController &&
        this.currentController.destroy) {
      return this.currentController.destroy();
    }

    this.currentController = new Controller({
      region: this.region
    });

    return this.currentController;
  }
}


























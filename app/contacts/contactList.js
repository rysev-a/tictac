class ContactList {
  constructor(options) {
    this.region = options.region;
    _.extend(this, Backbone.Events);
  }
  showList(contacts) {
    var layout = ContactListLayout();
    var actionBar = new ContactListActionBar();
    var contactList = new ContactListView({collection: contacts});

    this.region.show(layout);
    layout.getRegion('actions').show(actionBar);
    layout.getRegion('list').show(contactList);

    this.listenTo(contactList, 'item:contact:delete',
      this.deleteContact);
  }

  createContact() {
    App.router.navigate('contacts/new', true);
  }

  deleteContact(view, contact) {
    let message = 'The contact will be deleted';
    App.askConfirmation(message, (isConfirm) => {
      if (isConfirm) {
        contact.destroy({
          success() {
            App.notifySuccess('Contact was deleted');
          },
          error() {
            App.notifyError('Ooops... Something went wrong');
          }
        })
      }
    });
  }
  destroy() {
    this.region.remove();
    this.stopListening();
  }
}

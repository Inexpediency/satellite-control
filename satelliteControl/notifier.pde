class Notifier extends EventListener {
  Client client;
  
  Notifier(Client client) {
    this.client = client;
  }
  
  void sendUpdate(String data) {
     this.client.write(data);
  }
}

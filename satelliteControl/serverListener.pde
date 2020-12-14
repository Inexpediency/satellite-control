class ServerListener extends EventListener {
  private Client server;
  
  ServerListener(Client server) {
    this.server = server;
  }
  
  void sendUpdate(String data) {
    this.server.write(data);
  }
}

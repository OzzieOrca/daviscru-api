part of server;

String generateCSRFToken(String sessionId, String appSecret){
  var sha256 = new SHA256();
  sha256.add(sessionId.codeUnits);
  sha256.add(new Random().nextInt(4294967296).toString().codeUnits);
  sha256.add(appSecret.codeUnits);
  var digest = sha256.close();
  return CryptoUtils.bytesToHex(digest);
}
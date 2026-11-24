import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

/// 摘要算法；保留常见互操作算法，不提供 MD2/MD4 等旧算法。
enum AxcDigest {
  /// MD5，仅用于兼容和非安全校验。
  md5,

  /// SHA-1，仅用于兼容和非安全校验。
  sha1,

  /// SHA-256。
  sha256,

  /// SHA-384。
  sha384,

  /// SHA-512。
  sha512;

  crypto.Hash get _hash => switch (this) {
        md5 => crypto.md5,
        sha1 => crypto.sha1,
        sha256 => crypto.sha256,
        sha384 => crypto.sha384,
        sha512 => crypto.sha512,
      };
}

/// 二进制数据命名空间；接收 Uint8List，不改变其内容。
extension type AxcDataSpace(Uint8List base) {
  /// UTF-8 解码，非法字节返回 null。
  String? get string {
    try {
      return utf8.decode(base);
    } on FormatException {
      return null;
    }
  }

  /// Base64 编码。
  String get base64Str => base64.encode(base);

  /// 小写十六进制字符串。
  String get hexString =>
      base.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  /// 返回字节拷贝。
  Uint8List byteArray() => Uint8List.fromList(base);

  /// 返回摘要字节。
  Uint8List hashData(AxcDigest algorithm) =>
      Uint8List.fromList(algorithm._hash.convert(base).bytes);

  /// 返回小写十六进制摘要。
  String hashStr(AxcDigest algorithm) =>
      algorithm._hash.convert(base).toString();

  /// 返回 Base64 摘要。
  String hashBase64(AxcDigest algorithm) => base64.encode(hashData(algorithm));

  /// 使用给定原始字节密钥计算 HMAC，不对密钥进行额外编码。
  Uint8List hmacData(AxcDigest algorithm, {required List<int> key}) =>
      Uint8List.fromList(crypto.Hmac(algorithm._hash, key).convert(base).bytes);

  /// 返回小写十六进制 HMAC。
  String hmacStr(AxcDigest algorithm, {required List<int> key}) =>
      AxcDataSpace(hmacData(algorithm, key: key)).hexString;
}

/// Uint8List 的专用入口，比 List<int> 的入口更具体。
extension AxcDataNamespace on Uint8List {
  /// 数据命名空间；需要列表能力时显式使用 AxcListSpace<int>。
  AxcDataSpace get axc => AxcDataSpace(this);
}

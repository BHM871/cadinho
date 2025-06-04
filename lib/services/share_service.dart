import 'package:share_plus/share_plus.dart';

class ShareService {

  const ShareService();

  Future<bool> share(String content) async {
    ShareParams params = ShareParams();

    ShareResult result = await SharePlus.instance.share(params);

    return result.status == ShareResultStatus.success;
  }

}
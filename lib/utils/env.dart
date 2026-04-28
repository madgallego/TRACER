import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'assets/.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_API_KEY', obfuscate: true)
  static final String supabaseKey = _Env.supabaseKey;
  @EnviedField(varName: 'DOC_AI_KEY', obfuscate: true)
  static final String docAiKey = _Env.docAiKey;
  @EnviedField(varName: 'DOC_AI_ENDPOINT_URL', obfuscate: true)
  static final String docAiEndpointUrl = _Env.docAiEndpointUrl;
}

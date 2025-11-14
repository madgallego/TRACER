import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../assets/.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_API_KEY', obfuscate: true)
  static final String supabaseKey = _Env.supabaseKey;
}

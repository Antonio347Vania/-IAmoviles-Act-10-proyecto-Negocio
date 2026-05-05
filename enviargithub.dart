import 'dart:io';

void main() async {
  print('==================================================');
  print('  🚀 Asistente Interactivo para Enviar a GitHub');
  print('==================================================\n');

  // 1. Pedir el enlace del repositorio
  stdout.write('🔗 Introduce el enlace del nuevo repositorio de GitHub\n(ej. https://github.com/usuario/repo.git): ');
  String? repoLink = stdin.readLineSync();
  
  if (repoLink == null || repoLink.trim().isEmpty) {
    print('❌ Error: El enlace del repositorio no puede estar vacío.');
    return;
  }
  repoLink = repoLink.trim();

  // 2. Pedir mensaje de commit
  stdout.write('\n📝 Introduce el mensaje del commit: ');
  String? commitMessage = stdin.readLineSync();
  
  if (commitMessage == null || commitMessage.trim().isEmpty) {
    commitMessage = 'Initial commit';
    print('⚠️ Mensaje vacío. Se usará el mensaje por defecto: "$commitMessage"');
  } else {
    commitMessage = commitMessage.trim();
  }

  // 3. Pedir el nombre de la rama
  stdout.write('\n🌿 Introduce el nombre de la rama (presiona Enter para usar "main" por defecto): ');
  String? branchNameInput = stdin.readLineSync();
  String branchName = 'main'; // Valor por defecto
  
  if (branchNameInput != null && branchNameInput.trim().isNotEmpty) {
    branchName = branchNameInput.trim();
  }

  // Resumen
  print('\n--------------------------------------------------');
  print('📋 Resumen de configuración:');
  print('--------------------------------------------------');
  print('Repositorio: $repoLink');
  print('Mensaje de commit: "$commitMessage"');
  print('Rama: $branchName');
  print('--------------------------------------------------\n');

  stdout.write('¿Deseas continuar con estos datos? (s/n): ');
  String? confirm = stdin.readLineSync();
  if (confirm?.toLowerCase() != 's') {
    print('❌ Operación cancelada por el usuario.');
    return;
  }

  print('\n⚙️ Ejecutando comandos de Git...\n');

  // Iniciar git si no está iniciado
  await _runGitCommand(['init'], 'Inicializando git (git init)...');

  // Agregar archivos
  await _runGitCommand(['add', '.'], 'Agregando archivos (git add .)...');

  // Crear commit
  await _runGitCommand(['commit', '-m', commitMessage], 'Creando commit (git commit)...');

  // Renombrar/establecer rama
  await _runGitCommand(['branch', '-M', branchName], 'Estableciendo la rama principal a $branchName...');

  // Validar y configurar el remote 'origin'
  var remoteCheck = await Process.run('git', ['remote', 'get-url', 'origin']);
  if (remoteCheck.exitCode == 0) {
    print('> El remote "origin" ya existe. Actualizando la URL...');
    await _runGitCommand(['remote', 'set-url', 'origin', repoLink], 'Actualizando remote origin...');
  } else {
    await _runGitCommand(['remote', 'add', 'origin', repoLink], 'Agregando remote origin...');
  }

  // Subir cambios (push)
  await _runGitCommand(['push', '-u', 'origin', branchName], 'Subiendo al repositorio (git push)...', allowFailure: true);

  print('\n✅ ¡Proceso completado exitosamente!');
}

/// Función auxiliar para ejecutar comandos de Git de forma organizada
Future<void> _runGitCommand(List<String> args, String stepDescription, {bool allowFailure = false}) async {
  print('⏳ $stepDescription');
  var result = await Process.run('git', args);
  
  if (result.stdout.toString().trim().isNotEmpty) {
    print('   ${result.stdout.toString().trim().replaceAll('\n', '\n   ')}');
  }
  
  if (result.exitCode != 0) {
    print('   ⚠️ Advertencia o Error (código ${result.exitCode}):\n   ${result.stderr.toString().trim().replaceAll('\n', '\n   ')}');
    if (!allowFailure) {
      print('\n❌ Se detuvo el proceso debido a un error crítico.');
      exit(result.exitCode);
    }
  }
}

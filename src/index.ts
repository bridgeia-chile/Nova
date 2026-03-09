// src/index.ts - Punto de entrada principal de Nova
// Inspired by OpenClaw's architecture

import { NovaCore, getCoreInstance } from './core/mod';
import { NovaGateway } from './gateway/mod';
import { CLIChannel } from './channels/cli';

/**
 * Nova - Personal AI Assistant
 *
 * Punto de entrada principal del asistente virtual.
 * Este archivo inicializa todos los componentes y sistemas.
 */

async function main() {
  console.log('🚀 Starting Nova AI Assistant...');
  console.log('=================================');

  try {
    // 1. Inicializar el núcleo
    const core = getCoreInstance({
      modelProvider: 'openai',
      memorySystem: null,
      contextEngine: null,
      pluginManager: null
    });
    await core.initialize();

    // 2. Inicializar el gateway
    const gateway = new NovaGateway({ port: 18789 });
    await gateway.start();

    // 3. Inicializar canales
    const cliChannel = new CLIChannel(gateway);

    // 4. Modo interactivo (por ahora solo CLI)
    cliChannel.startInteractiveMode();

    console.log('✅ Nova is ready!');
  } catch (error) {
    console.error('❌ Failed to start Nova:', error);
    process.exit(1);
  }
}

// Iniciar Nova
if (require.main === module) {
  main();
}

export { NovaCore, NovaGateway, CLIChannel };
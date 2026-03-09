// src/channels/cli.ts - Canal CLI para Nova
// Inspired by OpenClaw's CLI interface

import { NovaGateway } from '../gateway/mod';

/**
 * CLI Channel for Nova
 *
 * Este canal permite interactuar con Nova a través de la línea de comandos.
 * Similar al enfoque de OpenClaw pero simplificado.
 */

export class CLIChannel {
  private gateway: NovaGateway;

  constructor(gateway: NovaGateway) {
    this.gateway = gateway;
    this.gateway.registerChannel('cli', this.handleMessage.bind(this));
  }

  /**
   * Maneja mensajes entrantes desde la CLI
   */
  async handleMessage(message: string): Promise<string> {
    console.log(`[CLI] Received: ${message}`);

    // Enviar al gateway para procesamiento
    await this.gateway.routeMessage({
      channel: 'cli',
      message: message,
      timestamp: new Date().toISOString()
    });

    return 'Message processed';
  }

  /**
   * Inicia el modo interactivo CLI
   */
  startInteractiveMode(): void {
    console.log('Nova CLI - Interactive Mode');
    console.log('Type your messages below (Ctrl+C to exit):');

    // TODO: Implementar modo interactivo con readline
  }

  /**
   * Procesa un comando directo
   */
  async processCommand(command: string): Promise<string> {
    return this.handleMessage(command);
  }
}

// Exportar instancia
export const cliChannel = new CLIChannel(new NovaGateway({ port: 18789 }));
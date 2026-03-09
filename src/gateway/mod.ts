// src/gateway/mod.ts - Gateway/Control Plane de Nova
// Inspired by OpenClaw's gateway system

/**
 * Nova Gateway Module
 *
 * Este módulo actúa como el plano de control central que:
 * - Coordina la comunicación entre componentes
 * - Maneja conexiones entrantes y salientes
 * - Proporciona API REST y WebSocket
 * - Gestiona autenticación y autorización
 */

export interface GatewayOptions {
  port: number;
  host?: string;
  enableWebsocket?: boolean;
}

export class NovaGateway {
  private options: GatewayOptions;

  constructor(options: GatewayOptions) {
    this.options = {
      port: 18789, // Puerto por defecto (similar a OpenClaw)
      ...options
    };
  }

  /**
   * Inicia el servidor gateway
   */
  async start(): Promise<void> {
    console.log(`Starting Nova Gateway on port ${this.options.port}`);
    // TODO: Implementar servidor HTTP/WebSocket
  }

  /**
   * Registra un canal de comunicación
   */
  registerChannel(channelType: string, handler: any): void {
    console.log(`Registering channel: ${channelType}`);
    // TODO: Implementar registro de canales
  }

  /**
   * Enruta un mensaje al componente apropiado
   */
  async routeMessage(message: any): Promise<void> {
    console.log('Routing message:', message);
    // TODO: Implementar lógica de enrutamiento
  }
}

// Exportar instancia singleton
export const gateway = new NovaGateway({ port: 18789 });
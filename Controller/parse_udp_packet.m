function [trolley_cmd, hoist_cmd, system_on, twistlock, sway_ctrl, emergency, emgy_ack] = parse_udp_packet(data)
% parse_udp_packet  Desempaqueta el datagrama de 13 bytes enviado por controller_reader.py
%
% Entrada:
%   data  : uint8(1x13) — bytes crudos del bloque UDP Receive
%
% Salidas (todas double):
%   trolley_cmd  [-4.0 .. +4.0] m/s   consigna velocidad carro
%   hoist_cmd    [-1.5 .. +1.5] m/s   consigna velocidad izaje
%   system_on    0/1   Sistema ON/OFF
%   twistlock    0/1   0=Abierto 1=Cerrado
%   sway_ctrl    0/1   Control de balanceo ON/OFF
%   emergency    0/1   Emergencia activa
%   emgy_ack     0/1   ACK de emergencia global
%
% Formato del paquete Python: struct.pack('!ffBBBBB', ...)
%   Big-endian: bytes 1-4 float32, 5-8 float32, 9-13 uint8
% -----------------------------------------------------------------------

% Valores por defecto (paquete malformado o vacío)
trolley_cmd = 0;
hoist_cmd   = 0;
system_on   = 0;
twistlock   = 0;
sway_ctrl   = 0;
emergency   = 0;
emgy_ack    = 0;

if numel(data) < 13
    return
end

raw = uint8(data(:)');   % forzar fila 1x13

% ── Floats big-endian → invertir bytes antes de typecast ──────────────
%    Python '!' = big-endian; x86/MATLAB = little-endian
trolley_cmd = double(typecast(raw(4:-1:1), 'single'));
hoist_cmd   = double(typecast(raw(8:-1:5), 'single'));

% ── Flags uint8 (un byte cada uno) ────────────────────────────────────
system_on = double(raw(9));
twistlock = double(raw(10));
sway_ctrl = double(raw(11));
emergency = double(raw(12));
emgy_ack  = double(raw(13));

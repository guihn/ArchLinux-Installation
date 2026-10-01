-- Exemplo de configuração Lua modular do Hyprland.
-- Documentação de configuração:
-- https://wiki.hypr.land/Configuring/Start/

-- Este exemplo configura parte das opções disponíveis.
-- A wiki oficial documenta o conjunto completo de opções.

-- A configuração está dividida em módulos.
-- Um módulo separado pode ser carregado como no exemplo comentado:
-- require("myColors")

----------------------
---- IMPORTAÇÃO DE MÓDULOS ----
----------------------

require ("monitors")
require ("programs")
require ("autostart")
require ("environmentvariables")
require ("permissions")
require ("lookandfeel")
require ("miscellaneous")
require ("input")
require ("keybinds")
require ("windowsandworkspaces")

# smartcontracts
README para entrega final del módulo 3

Contrato en etherscan: https://sepolia.etherscan.io/address/0x791da29a1472e5bde01d90a23ac511519e185494 

Se consideraron los siguientes patrones de diseño:

Ownable: Patrón utilizado para establecer control sobre funciones críticas mediante un propietario. En este contrato se estableció la variable owner para este control y mediante requiere se valida si la dirección apropiada en las funciones que necesitan comprobar si el dueño del NFT efectivamente está solicitando que un token se pueda comprar o no, o se pueda transferir o no.

Reentrancy Guard: Para evitar ataques de reentrancy se siguió el patrón de Patrón de Chequeo-Efectos-Interacción. Para esto, toda función se estructuró de la siguiente manera dependiendo del contexto:
• Chequeo: Primero, verifica todas las condiciones necesarias o convalidaciones de variables mediante requiere.
• Efectos: Luego, actualiza el estado del contrato dependiendo del contexto.
• Interacción: Finalmente, realiza interacciones con otros contratos o transferencias

Se decidió no usar el patrón Factory Pattern mediante la creación de los NFTs en el mismo contrato para no crear otro contrato hijo adicional. 

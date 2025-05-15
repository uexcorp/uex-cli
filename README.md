# uex-cli
The UEX 2.0 Command Line Interface offers an alternative interaction mode with the UEX website software, enabling quicker and distinct access to certain information.

## Installation

    // via installer
    $ curl -sSL https://raw.githubusercontent.com/uexcorp/uex-cli/main/install.sh | sudo bash 
    $ uex   

or:  

    // download the script file  
    $ curl -o uex.sh https://raw.githubusercontent.com/uexcorp/uex-cli/main/uex-cli.sh  
    $ sh uex.sh

## Basic commands

> [!IMPORTANT]  
> Commands marked with an asterisk (*) are available only when the secret key is set.  
> Use `set key <value>` to set the secret key.

| Command | Description                |
| ------- | -------------------------- |
| aels*   | api events list            |
| als*    | api applications list      |
| cls     | commodities list           |
| cp      | commodities prices         |
| drk*    | datarunners ranking list   |
| fset*   | set fleet vehicle          |
| help    | this help                  |
| ils     | items list                 |
| me*     | about you                  |
| online  | users connected            |
| rls     | resources list             |
| sls     | supporters list            |
| tdb*    | trade log: buy             |
| tdbal*  | trade log: balance         |
| tdls*   | trade log: list            |
| tdrm*   | trade log: remove item     |
| tds*    | trade log: sell            |
| tdwipe* | trade log: wipe all trades |
| tls*    | terminals list             |
| vls     | vehicles list              |
| wallet* | wallet balance             |

## Questions? Ideas? Bugs?

[UEX Discord](http://discord.gg/Kf2GZCBgpx)
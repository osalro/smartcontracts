// SPDX-License-Identifier: MIT
//https://github.com/fsobrado/eth/blob/main/NFTMarketplace.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    // ID de incremento para cada minteo de NFTs
    uint256 private _nextTokenId = 1;
    
    // Struct para representar cada NFT a la venta
    struct NFT {
        uint256 tokenId;
        address owner;
        uint256 price;
        bool isForSale;
        bool isForTransfer;
    }
    
    // mapeo del tokenId para cada NFT
    mapping(uint256 => NFT) public nftItems;
    
    // Evento cuando se crea un nuevo NFT
    event NFTCreated(uint256 indexed tokenId, address owner, uint256 price);
    
    // Evento cuando se compra un NFT
    event NFTBought(uint256 indexed tokenId, address buyer, uint256 price);

    // Evento cuando se transfiere un NFT
    event NFTTransferred(uint256 indexed tokenId, address newOwner);
    
    //constructor para inicializar el tipo ERC721
    constructor() ERC721("NFT Market Place", "NFTMP") {}

    // funcion para crear un nuevo NFT
    function createNFT(uint256 price) public {
        require(price > 0, "El precio debe ser mayor a 0");

        uint256 newItemId = _nextTokenId;

        // se incrementa el id para el siguiente NFT
        _nextTokenId++;     

        // Mint NFT
        _mint(msg.sender, newItemId);

        // agregar el NFT al market place
        nftItems[newItemId] = NFT({
            tokenId: newItemId,
            owner: msg.sender,
            price: price,
            isForSale: true,
            isForTransfer: true
        });
        //emitir mensaje de creacion
        emit NFTCreated(newItemId, msg.sender, price);           
    }

    // funcion para comprar NFT
    function buyNFT(uint256 tokenId) public payable {        
        require(nftItems[tokenId].isForSale, "Este NFT no esta a la venta");
        require(msg.value >= nftItems[tokenId].price, "fondos insuficientes para comprar este NFT");

        address previousOwner = nftItems[tokenId].owner; //guarda el duenno anterior
        
        // actualiza el NFT con el nuevo duenno y le quita lo vendible
        nftItems[tokenId].owner = msg.sender;
        nftItems[tokenId].isForSale = false;

         // transfiere el duenno
        _transfer(previousOwner, msg.sender, tokenId);

        // transfiere los fondos al duenno anterior
        payable(previousOwner).transfer(msg.value);

        emit NFTBought(tokenId, msg.sender, nftItems[tokenId].price);
    }

    function transferNFT(uint256 tokenId) public {        
        require(nftItems[tokenId].isForTransfer, "Este NFT no es transferible");        

        address previousOwner = nftItems[tokenId].owner; //guarda el duenno anterior  
        
        // actualiza el NFT con el nuevo duenno y le quita lo vendible
        nftItems[tokenId].owner = msg.sender;
        nftItems[tokenId].isForSale = false;

        // transfiere el duenno
        _transfer(previousOwner, msg.sender, tokenId);        

        emit NFTTransferred(tokenId, msg.sender);
    }

    // funcion para poder poner un NFT en venta con un precio determinado
    function turnOnNFTForSale(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Solamente el duenno puede poner este NFT en venta");
        require(price > 0, "El precio debe ser mayor a cero");        
        nftItems[tokenId].isForSale = true;
        nftItems[tokenId].price = price;
    }

    // funcion para poder desactivar la posible venta de un NFT
    function turnOffNFTForSale(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Solamente el duenno puede desactivar la venta de este NFT");
        nftItems[tokenId].isForSale = false;
    }

    // funcion para poder poner un NFT en transferencia
    function turnOnNFTForTransfer(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Solamente el duenno puede poner este NFT en venta");      
        nftItems[tokenId].isForTransfer = true;
    }

     // funcion para poder desactivar la posible transferencia de un NFT
    function turnOffNFTForTransfer(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Solamente el duenno puede desactivar la transferencia de este NFT");
        nftItems[tokenId].isForTransfer = false;
    }
}
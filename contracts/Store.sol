// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

contract Store {

    // add events for product add and purchase
    // add is_unavailable for Product
    
    address public storeOwner;
    string public storeName;

    struct Product {
        string productUUID;
        uint256 price;
        string ipfsHash;
    }

    mapping (string => Product) products;

    modifier onlyOwner {
      require(msg.sender == storeOwner);
      _;
   }

    constructor (address _ownerAddress, string memory _storeName) {
        storeOwner = _ownerAddress;
        storeName = _storeName;
    }

    function add_product(string memory _productUUID, uint256 _price, string memory _ipfsHash) onlyOwner public {
        products[_ipfsHash] = Product(_productUUID, _price, _ipfsHash);
    }

    function product_by_ipfs_hash(string memory _ipfsHash) public view returns (string memory, uint256, string memory) {
        Product memory product = products[_ipfsHash];
        return (product.productUUID, product.price, product.ipfsHash);
    }

    function purchase_product_by_ipfs_hash(string memory _ipfsHash) payable public {
        Product memory product = products[_ipfsHash];
        require(msg.value >= product.price);
        (bool sent, bytes memory data) = storeOwner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
